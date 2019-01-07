#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : model_manage.py
# @Author: CH
# @Date  : 2018/5/17
# @Desc  : 模型管理类

from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
import json, os
from data_mining import conn, curr_path
from data_mining import db_util
import pickle
import numpy


@csrf_exempt
def model_list(request):
    data = request.POST
    print(data)
    dict = {}
    for i, v in data.items():
        print(i, v)
        dict[i] = v
    return HttpResponse(json.dumps(db_util.pagenation_common(conn, 'tb_data_model', dict), ensure_ascii=False),
                        content_type="application/json;charset=utf-8")


from sklearn.externals import joblib
import jieba

@csrf_exempt
def model_use(request):
    data = request.POST
    if int(data['model_type']) == 1:
        print(data['feature_value'])
        files_ana_arr = []
        files_ana_result = []
        if (data['feature_value']):
            url = curr_path + '\\static\\pkl\\' + data['model_name'] + '.pkl'
            my_model = joblib.load(url)
            files_ana_arr.append(" ".join(jieba.cut(data['feature_value'])))
        if (files_ana_arr):
            pre_value = my_model.predict(files_ana_arr)
            # pre_value= pre_value[0]
    else:
        curr_rfc = pickle.load(open(curr_path + '\\static\\data\\' + data['model_name'] + '.model', 'rb'))
        predict_request = [int(i) for i in data['feature_value'].split(',') if i]
        predict_request = numpy.array(predict_request).reshape((1, -1))
        y_hat = curr_rfc.predict(predict_request)
        pre_value = [y_hat[0]]

    print(pre_value)

    return HttpResponse(json.dumps(','.join(pre_value),ensure_ascii=False), content_type="application/json;charset=utf-8")
