#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : model_build.py
# @Author: CH
# @Date  : 2018/5/11
# @Desc  : 模型固化类


import pymysql
import pandas
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.naive_bayes import MultinomialNB
import numpy as np
import os
import pickle as p

from data_mining import calcu_util  # 数据处理，算法选择类

from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
import json


@csrf_exempt
def data_manage(request):
    data = request.POST

    message = ''
    # try:
    conn = pymysql.connect(
        host=data['db_info[db_ip]'],  # 如果是服务器，则输公网ip
        user=data['db_info[db_name]'],  # 当时设置的数据超级管理员账户
        passwd=data['db_info[db_pw]'],  # 当时设置的管理员密码
        charset='utf8',  # 不用声明字符集也可以
        port=int(data['db_info[db_port]']),  # MySQL数据的端口为3306，注意:切记这里不要写引号''
    )

    count_arr = []
    cursor = conn.cursor()

    for i in data['data_feature'].split(',') + data['data_predict'].split(','):
        sql_select = "select count(%s) from %s.%s" % (i.split(':')[2], i.split(':')[0], i.split(':')[1])
        cursor.execute(sql_select)
        count_arr.append({'field': i.split(':')[2], 'count': cursor.fetchone()[0]})

    list_df = []
    if min(count_arr)['count'] == 0:
        message = '字段 ' + str(min(count_arr)['field']) + ' 没有对应数据！'
        return HttpResponse(json.dumps(message, ensure_ascii=False), content_type="application/json;charset=utf-8")
    else:
        for i in data['data_feature'].split(',') + data['data_predict'].split(','):
            sql_data = "select %s from %s.%s limit %s" % (
                i.split(':')[2], i.split(':')[0], i.split(':')[1], min(count_arr)['count'])
            df = pandas.read_sql_query(sql_data, conn)
            list_df.append(df)
    df_all = list_df[0]
    for i in range(len(list_df)):
        t = i + 1
        if (t < len(list_df)):
            df_now = list_df[t]
            df_new = df_all.join(df_now)
            df_all = df_new
        else:
            break
    # conn = pymysql.connect(host='192.168.252.200', port=3306, user='root', passwd='root', charset='UTF8',
    #                        db='car_evaluation')
    # df_all = pandas.read_sql_query(
    #     'select id,car_models_id,cast(substr(manufacture_date,1,4) as SIGNED) as manufacture_date ,odo,sale_price_normal '
    #     'from evaluate_result limit 90000', conn)

    type = data['data_type']
    res = ''
    if type == '2':
        res = buildModel_predict(df_all, data['data_feature'].split(','), data['data_predict'].split(','),
                                 data['data_methods'])
    else:
        res = buildModel_classify(df_all, data['data_feature'].split(','), data['data_predict'].split(','),
                                  data['data_methods'])

    print(res)
    if res == 'err':
        return HttpResponse(json.dumps('data_err', ensure_ascii=False),
                            content_type="application/json;charset=utf-8")
    else:
        return HttpResponse(json.dumps(res, ensure_ascii=False),
                            content_type="application/json;charset=utf-8")


# except Exception:
#     print(Exception.args)
#     return HttpResponse(json.dumps('conn_err', ensure_ascii=False), content_type="application/json;charset=utf-8")

# return HttpResponse(json.dumps('success', ensure_ascii=False), content_type="application/json;charset=utf-8")
# conn = pymysql.connect(host='192.168.252.200', port=3306, user='root', passwd='root', charset='UTF8',
# data = ['1', '2']
# for i in range(2):
#     sql = "select count(id) from evaluate_result"
#     cursor = conn.cursor()
#     cursor.execute(sql)
#     print(cursor.fetchone()[0])


def read_data(data_file):
    data = pd.read_csv(data_file)
    train = data[:int(len(data) * 0.9)]
    test = data[int(len(data) * 0.9):]
    train_y = train.label
    train_x = train.drop('label', axis=1)
    test_y = test.label
    test_x = test.drop('label', axis=1)
    return train_x, train_y, test_x, test_y


def buildModel_predict(df, feature, predict, method):
    cns_ft = []
    cns_y = []
    for f in feature:
        cns_ft.append(f.split(':')[2])
    for pre in predict:
        cns_y.append(pre.split(':')[2])

    model_name, accuracy = calcu_util.selectcal_culation(method, df, cns_ft, cns_y)
    list = []
    list.append(model_name)
    list.append(accuracy)
    return list
    # try:
    #     cns_ft = []
    #     cns_y = []
    #     for f in feature:
    #         cns_ft.append(f.split(':')[2])
    #     for pre in predict:
    #         cns_y.append(pre.split(':')[2])
    #
    #     print(df)
    #     model_name, accuracy = calcu_util.selectcal_culation('RF', df, cns_ft, cns_y)
    #     list = []
    #     list.append(model_name)
    #     list.append(accuracy)
    #     return list
    # except Exception:
    #     print(Exception.args)
    #     print("固化模型发生异常！")
    #     return "err"


# 对列表进行分词并用空格连接
import jieba


def segmentWord(cont):
    c = []
    for i in cont:
        a = list(jieba.cut(i))
        b = " ".join(a)
        c.append(b)
    return c


def buildModel_classify(df1, feature, predict, method):
    # try:
    feature_str = feature[0].split(':')[2]
    predict_str = predict[0].split(':')[2]

    from data_mining import curr_path
    jieba.load_userdict(curr_path + '\\static\\data\\wordDict.txt')  # '../data/wordDict.txt')

    N_all = df1.shape[0]

    N_train = int(np.ceil(N_all * 0.8))

    # 读取训练集
    content_train = df1[feature_str]  # 第一列为文本内容，并去除列名
    opinion_train = df1[predict_str]  # 第二列为类别，并去除列名
    print '训练集有 %s 条句子' % len(content_train)
    date = [content_train, opinion_train]

    train = segmentWord(date[0])
    test = date[1]

    X_train_text = train[:N_train]
    X_test_text = train[N_train:]
    Y_train = test[:N_train]
    Y_test = test[N_train:]

    from sklearn.feature_extraction.text import CountVectorizer
    from sklearn.feature_extraction.text import TfidfTransformer
    from sklearn.pipeline import Pipeline

    # 计算权重
    # CountVectorizer 该类会将文本中的词语转换为词频矩阵，矩阵元素a[i][j] 表示j词在i类文本下的词频
    vectorizer = CountVectorizer()
    # TfidfVectorizer该类会统计每个词语的tf-idf权值
    tfidftransformer = TfidfTransformer()
    tfidf = tfidftransformer.fit_transform(vectorizer.fit_transform(X_train_text))  # 先转换成词频矩阵，再计算TFIDF值
    print tfidf.shape

    # 训练和预测一体
    # '''
    # C：C-SVC的惩罚参数C?默认值是1.0
    # C越大，相当于惩罚松弛变量，希望松弛变量接近0，即对误分类的惩罚增大，趋向于对训练集全分对的情况，
    # 这样对训练集测试时准确率很高，但泛化能力弱。C值小，对误分类的惩罚减小，允许容错，将他们当成噪声点，泛化能力较强。
    # '''
    # # Multinomial Naive Bayes Classifier
    # from sklearn.naive_bayes import MultinomialNB
    # clf = MultinomialNB(alpha=0.01)
    # # KNN Classifier
    # from sklearn.neighbors import KNeighborsClassifier
    # knnclf = KNeighborsClassifier()  # default with k=5
    # # SVM Classifier
    # svclf = SVC(kernel='linear', C=0.99)  # default with 'rbf'
    # # Random Forest Classifier
    # from sklearn.ensemble import RandomForestClassifier
    # rfclf = RandomForestClassifier(n_estimators=8)
    # # KMeans Cluster
    # from sklearn.cluster import KMeans
    # kmclf = KMeans(n_clusters=5)
    # # 多层神经网络
    # import sklearn.neural_network as sk_nn
    # sk_nnclf = sk_nn.MLPClassifier(activation='tanh', solver='adam', alpha=0.0001, learning_rate='adaptive',
    #                                learning_rate_init=0.001, max_iter=200)
    print(method)
    rf = calcu_util.select_method_classify(method)
    text_clf = Pipeline([('vect', vectorizer), ('tfidf', tfidftransformer), ('clf', rf)])

    text_clf = text_clf.fit(X_train_text, Y_train)
    predicted = text_clf.predict(X_test_text)
    print '均差', np.mean(predicted == Y_test)

    from sklearn import metrics
    accuracy = metrics.accuracy_score(Y_test, predicted)
    print('accuracy: %.2f%%' % (100 * accuracy))

    from sklearn.externals import joblib
    from data_mining.common import model_savepath
    import time
    t = time.time()
    model_name = str(round(t * 1000))
    joblib.dump(text_clf, curr_path + '\\static\\pkl\\'+ model_name +'.pkl')

    list = []
    list.append(model_name)
    list.append(100 * accuracy)
    return list


# except Exception:
#     return 'err'


@csrf_exempt
def model_save(request):
    data = request.POST
    feature = data['data_feature'].split(','),  #
    predict = data['data_predict'].split(','),  #
    feature_col = ''
    for f in feature[0]:
        info = f.split(':')
        field = info[2]
        feature_col = field + ',' + feature_col
    predict_col = ''
    for p in predict[0]:
        p_info = p.split(':')
        p_field = p_info[2]
        predict_col = p_field + ',' + predict_col

    sql = "insert into tb_data_model(name,file_name,feature,predict,type) values('%s','%s','%s','%s',%s)" % (
        data['new_name'], data['model_name'], feature_col[:-1], predict_col[:-1], int(data['data_type']))

    from data_mining import conn
    cursor = conn.cursor()
    cursor.execute(sql)
    cursor.close()
    conn.commit()
    return HttpResponse(json.dumps('success', ensure_ascii=False),
                        content_type="application/json;charset=utf-8")
