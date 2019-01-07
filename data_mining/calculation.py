#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : calculation.py
# @Author: CH
# @Date  : 2018/5/10
# @Desc  : 算法模块类
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import HttpResponse

from data_mining import conn

@csrf_exempt
def dict_calc(request):
    cursor = conn.cursor()
    cursor.execute("select code, name from tb_data_calculation")
    res_data = []
    for row in cursor.fetchall():
        res_data.append({'label': row[1], 'value': row[0]})

    return HttpResponse(json.dumps(res_data, ensure_ascii=False), content_type="application/json;charset=utf-8")




# RandomForestRegressor
# def naive_bayes_classifier(train_x, train_y):  # 随机深林算法
#     from sklearn.naive_bayes import MultinomialNB
#     model = MultinomialNB(alpha=0.01)
#     model.fit(train_x, train_y)
#     return model


# Multinomial Naive Bayes Classifier
def naive_bayes_classifier(train_x, train_y):  # 朴素贝叶斯算法
    from sklearn.naive_bayes import MultinomialNB
    model = MultinomialNB(alpha=0.01)
    model.fit(train_x, train_y)
    return model


# KNN Classifier
def knn_classifier(train_x, train_y):  # KNN（K最邻近算法）算法
    from sklearn.neighbors import KNeighborsClassifier
    model = KNeighborsClassifier()
    model.fit(train_x, train_y)
    return model


# Logistic Regression Classifier
def logistic_regression_classifier(train_x, train_y):  # 逻辑回归算法
    from sklearn.linear_model import LogisticRegression
    model = LogisticRegression(penalty='l2')
    model.fit(train_x, train_y)
    return model


# Random Forest Classifier
# os.chdir(model_savepath)
# result = 'car_evaluation_RF_V0.1_sp_normal_1.model'
model_rf = ''#pickle.load(open(result, 'rb'))

def random_forest_classifier(train_x, train_y):  # 随机森林算法

    model = model_rf
    # model = RandomForestClassifier(n_estimators=8)
    # model.fit(train_x, train_y)
    return model


# Decision Tree Classifier
def decision_tree_classifier(train_x, train_y):  # 决策树算法
    from sklearn import tree
    model = tree.DecisionTreeClassifier()
    model.fit(train_x, train_y)
    return model


# GBDT(Gradient Boosting Decision Tree) Classifier
def gradient_boosting_classifier(train_x, train_y):  # 梯度提升决策树算法
    from sklearn.ensemble import GradientBoostingClassifier
    model = GradientBoostingClassifier(n_estimators=200)
    model.fit(train_x, train_y)
    return model


# SVM Classifier
def svm_classifier(train_x, train_y):  # 支持向量机SVM算法
    from sklearn.svm import SVC
    model = SVC(kernel='rbf', probability=True)
    model.fit(train_x, train_y)
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
    model.fit(train_x, train_y)
    return model