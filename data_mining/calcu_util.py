#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : calcu_util.py
# @Author: CH
# @Date  : 2018/5/14
# @Desc  : 算法工具类
import numpy as np
from sklearn import metrics
import pickle as pickle
from data_mining.common import model_savepath  # 固化模型存放路径


# Multinomial Naive Bayes Classifier
def naive_bayes_classifier():  # 朴素贝叶斯算法
    from sklearn.naive_bayes import MultinomialNB
    model = MultinomialNB(alpha=0.01)
    # model.fit(train_x, train_y)
    return model


# KNN Classifier
def knn_classifier():  # KNN（K最邻近算法）算法
    from sklearn.neighbors import KNeighborsClassifier
    model = KNeighborsClassifier()
    # model.fit(train_x, train_y)
    return model


# Logistic Regression Classifier
def logistic_regression_classifier():  # 逻辑回归算法
    from sklearn.linear_model import LogisticRegression
    model = LogisticRegression(penalty='l2')
    # model.fit(train_x, train_y)
    return model


# Random Forest Classifier
# os.chdir(model_savepath)
# result = 'car_evaluation_RF_V0.1_sp_normal_1.model'
# model_rf = ''#pickle.load(open(result, 'rb'))

def random_forest_classifier():  # 随机森林算法
    from sklearn.ensemble import RandomForestClassifier
    model = RandomForestClassifier(n_estimators=8)
    # model.fit(train_x, train_y)
    return model


# Decision Tree Classifier
def decision_tree_classifier():  # 决策树算法
    from sklearn import tree
    model = tree.DecisionTreeClassifier()
    # model.fit(train_x, train_y)
    return model


# GBDT(Gradient Boosting Decision Tree) Classifier
def gradient_boosting_classifier():  # 梯度提升决策树算法
    from sklearn.ensemble import GradientBoostingClassifier
    model = GradientBoostingClassifier(n_estimators=200)
    # model.fit(train_x, train_y)
    return model


# SVM Classifier
def svm_classifier():  # 支持向量机SVM算法
    from sklearn.svm import SVC
    model = SVC(kernel='rbf', probability=True)
    # model.fit(train_x, train_y)
    return model


# SVM Classifier using cross validation
def svm_cross_validation(train_x, train_y):  # SVM 交叉验证算法
    from sklearn.model_selection import GridSearchCV
    from sklearn.svm import SVC
    model = SVC(kernel='rbf', probability=True)
    param_grid = {'C': [1e-3, 1e-2, 1e-1, 1, 10, 100, 1000], 'gamma': [0.001, 0.0001]}
    grid_search = GridSearchCV(model, param_grid, n_jobs=1, verbose=1)
    grid_search.fit(train_x, train_y)
    best_parameters = grid_search.best_estimator_.get_params()
    for para, val in list(best_parameters.items()):
        print(para, val)
    model = SVC(kernel='rbf', C=best_parameters['C'], gamma=best_parameters['gamma'], probability=True)
    # model.fit(train_x, train_y)
    return model


def read_data(df1, cns_ft, cns_y):
    N_all = df1.shape[0]
    N_train = int(np.ceil(N_all * 0.8))
    myperm = np.random.permutation(N_all)
    idx_train = myperm[0:N_train]
    idx_test = myperm[N_train:]

    df_train = df1.iloc[idx_train, :]

    df_test = df1.iloc[idx_test, :]

    # cns_ft = f_arr # ['car_models_id', 'manufacture_date', 'odo']
    # cns_y = p_arr # ['sale_price_normal']

    x_test = df_test.loc[:, cns_ft].values
    y_test = df_test.loc[:, cns_y].values

    x_train = df_train.loc[:, cns_ft].values
    y_train = df_train.loc[:, cns_y].values

    y_train = np.array(y_train)
    y_train = np.asarray(y_train, dtype=np.string_)

    y_test = np.array(y_test)
    y_test = np.asarray(y_test, dtype="|S6")

    train_x = x_train
    train_y = y_train
    test_x = x_test
    test_y = y_test

    return train_x, train_y, test_x, test_y


def selectcal_culation(cu_name, df1, cns_ft, cns_y):
    import time
    t = time.time()
    model_name = str(round(t * 1000))
    model_save_file = model_savepath + model_name + '.model'
    model_save = {}

    classifiers = {'RF': random_forest_classifier,
                   'NB': naive_bayes_classifier,
                   'KNN': knn_classifier,
                   'LR': logistic_regression_classifier,
                   'DT': decision_tree_classifier,
                   'SVM': svm_classifier,
                   'GBDT': gradient_boosting_classifier
                   }

    print(df1.dtypes)
    train_x, train_y, test_x, test_y = read_data(df1, cns_ft, cns_y)
    rf = classifiers[cu_name]() # (train_x, train_y)
    rf.fit(train_x, train_y)

    predict = rf.predict(test_x)

    if model_save_file != None:
        model_save[cu_name] = rf

    accuracy = metrics.accuracy_score(test_y, predict)
    print('accuracy: %.2f%%' % (100 * accuracy))

    if model_save_file != None:
        f = open(model_save_file, 'wb')
        pickle.dump(rf, f, protocol=2)  # dump the object to a file HIGHEST_PROTOCOL
        f.close()

    return model_name, 100 * accuracy


def select_method_classify(cu_name):
    classifiers = {'RF': random_forest_classifier,
                   'NB': naive_bayes_classifier,
                   'KNN': knn_classifier,
                   'LR': logistic_regression_classifier,
                   'DT': decision_tree_classifier,
                   'SVM': svm_classifier,
                   'GBDT': gradient_boosting_classifier
                   }

    rf = classifiers[cu_name]()
    return rf