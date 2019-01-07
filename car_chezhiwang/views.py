# coding=UTF-8


from django.shortcuts import render
from car_chezhiwang.models import Chezhiwang
from django.core.serializers.json import json
from django.http import HttpResponse
from django.core import serializers
from django.db.models import Sum
import simplejson
import math
import numpy as np
from django.views.decorators.csrf import csrf_exempt
import os
from car_chezhiwang.page_content import page_content_me

import simplejson
from django.conf import settings


# Create your views here.

def index(request):
    select_brand = Chezhiwang.objects.values("brand").distinct();
    #     print(select_brand)

    select_class_data = Chezhiwang.objects.raw(
        "SELECT id,group_concat(car_class SEPARATOR ',') as car_class FROM chezhiwang")
    select_class_data = select_class_data[0].car_class
    #     print(select_class_data)
    if (select_class_data[:-1] is None):
        select_class = select_class_data.split(',')
        select_class = list(set(select_class))
    elif (select_class_data[:-1] == ','):
        select_class = select_class_data[:-1].split(',')
        select_class = list(set(select_class))
    else:
        select_class = select_class_data.split(',')
        select_class = list(set(select_class))
    select_class = list(set(select_class))

    #     print(select_class)
    select_lj_data = Chezhiwang.objects.raw(
        "SELECT id,group_concat(typical_fault SEPARATOR ',') as listdata FROM chezhiwang")
    dataStr = select_lj_data[0].listdata
    if (dataStr[:-1] is None):
        list_dic = dataStr.split(',')
        list_dic = list(set(list_dic))
    elif (dataStr[:-1] == ','):
        list_dic = dataStr[:-1].split(',')
        list_dic = list(set(list_dic))
    else:
        list_dic = dataStr.split(',')
        list_dic = list(set(list_dic))

    list_dis_data = []
    for e in list_dic:
        tmp = e.strip()
        list_dis_data.append(tmp)
    select_lj = list(set(list_dis_data))

    result_info = Chezhiwang.objects.all()
    return render(request, "pages/index.html",
                  {"content": result_info, "select_class": select_class, "select_lj": select_lj,
                   "select_brand": select_brand})  # 返回界面


@csrf_exempt
def dataindex(request):
    car_brand = request.POST.get("car_brand", "")  # Jeep
    car_class = request.POST.get("car_class", "")  # 自由光
    key_words = request.POST.get("lj_key", "")  # 发动机'

    # 总故障量
    all_count = Chezhiwang.objects.filter(brand='Jeep').count()
    # 发动机故障数量
    fdj_count = Chezhiwang.objects.filter(typical_fault__contains=key_words).count()
    # 发动机投诉率
    c = fdj_count / all_count

    fdj_repair_data = Chezhiwang.objects.raw("SELECT id, SUM(repair_num) as repair_count FROM chezhiwang "
                                             "WHERE typical_fault LIKE '%%" + key_words + "%%' and car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    # 发动机故障数据量
    fdj_repair_count = fdj_repair_data[0].repair_count

    all_repair_data = Chezhiwang.objects.raw(
        "SELECT id, SUM(repair_num) as repair_count FROM chezhiwang WHERE brand = '" + car_brand + "'")
    # 总故障量
    all_repair_count = all_repair_data[0].repair_count

    # 发动机故障频繁度
    print(fdj_repair_count)
    print(all_repair_count)
    if (fdj_repair_count is None):
        f = 0
    else:
        f = fdj_repair_count / all_repair_count

    # 安全事件发生的可能性
    # 1、安全隐患 p
    p_data = Chezhiwang.objects.raw("SELECT id, SUM(safety_num) as safety_count FROM chezhiwang "
                                    "WHERE typical_fault LIKE '%%" + key_words + "%%' and car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    p_all_data = Chezhiwang.objects.raw(
        "SELECT id, SUM(safety_num) as safety_count FROM chezhiwang WHERE brand = '" + car_brand + "'")

    if (p_data[0].safety_count is None):
        p = 0
    else:
        p = p_data[0].safety_count / p_all_data[0].safety_count

    # 2、伤亡信息 r / v
    r_data = Chezhiwang.objects.raw("SELECT id, SUM(injury_num) as injury_count FROM chezhiwang "
                                    "WHERE typical_fault LIKE '%%" + key_words + "%%' and car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    r_count = r_data[0].injury_count
    v = 0
    if (r_count is None):
        r_count = 0

    if (r_count <= 3):
        v = ((1 - math.e ** (float(-r_count))) + (1 - math.e ** (float(-p)))) / 2
    else:
        v = 1
    print("产品伤亡严重率：")
    print(v)

    # 危害可能性 h
    if (v == 1):
        h = 1
    else:
        h = math.sqrt(float(f) ** 2 + float(v) ** 2)
    print("不同系列的产品质量危害可能性：")
    print(h)

    # 零部件风险指数
    if (h == 1):
        r_s = 1
    else:
        r_s = math.sqrt(float(c) ** 2 + float(h) ** 2)
    print(key_words + "零部件风险指数：")
    print(r_s)

    list_data = Chezhiwang.objects.raw(
        "SELECT id,group_concat(typical_fault SEPARATOR ',') as listdata FROM chezhiwang where car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    print("******************************************************")

    # dataStr = list_data[0].listdata
    # list_dic = dataStr[:-1].split(',')
    # list_dic = list(set(list_dic))
    dataStr = list_data[0].listdata
    print(dataStr)
    if (dataStr[:-1] is None):
        list_dic = dataStr.split(',')
        list_dic = list(set(list_dic))
    elif (dataStr[:-1] == ','):
        list_dic = dataStr[:-1].split(',')
        list_dic = list(set(list_dic))
    else:
        list_dic = dataStr.split(',')
        list_dic = list(set(list_dic))
    list_dis_data = []
    for e in list_dic:
        tmp = e.strip()
        list_dis_data.append(tmp)
    # print(list_dis_data)  [v,h,r_s]
    list_dis_data = list(set(list_dis_data))

    num_r_s = 0
    # 零部件个数
    lj_count = list_dis_data.__sizeof__()
    # 零部件权重
    j = 0
    lj_weigth = [0.2, 0.05, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05]
    for e in list_dis_data:
        r_s_tmp = getData(e, car_class, car_brand)
        r_s_tmp = r_s_tmp * lj_weigth[j]
        j = j + 1
        num_r_s = num_r_s + r_s_tmp
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    print(list_dis_data)
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

    # 产品风险指数
    r_cp = num_r_s / lj_count
    print("总的零部件风险概率")
    print(r_cp)

    result_info = {"injury": v, "harm": h, "risk": r_s, 'cp_risk': r_cp, "tousu": c}

    return HttpResponse(simplejson.dumps(result_info), content_type="application/json; charset=utf-8")


def getData(key_words, car_class, car_brand):
    # 总故障量
    all_count = Chezhiwang.objects.filter(brand='Jeep').count()
    # 发动机故障数量
    fdj_count = Chezhiwang.objects.filter(typical_fault__contains='发动机').count()
    # 发动机投诉率
    c = fdj_count / all_count

    fdj_repair_data = Chezhiwang.objects.raw("SELECT id, SUM(repair_num) as repair_count FROM chezhiwang "
                                             "WHERE typical_fault LIKE '%%" + key_words + "%%' and car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    # 发动机故障数据量
    fdj_repair_count = fdj_repair_data[0].repair_count

    all_repair_data = Chezhiwang.objects.raw(
        "SELECT id, SUM(repair_num) as repair_count FROM chezhiwang WHERE brand = '" + car_brand + "'")
    # 总故障量
    all_repair_count = all_repair_data[0].repair_count

    # 发动机故障频繁度
    if (fdj_repair_count is None):
        f = 0
    else:
        f = fdj_repair_count / all_repair_count

    # 安全事件发生的可能性
    # 1、安全隐患 p
    p_data = Chezhiwang.objects.raw("SELECT id, SUM(safety_num) as safety_count FROM chezhiwang "
                                    "WHERE typical_fault LIKE '%%" + key_words + "%%' and car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    p_all_data = Chezhiwang.objects.raw(
        "SELECT id, SUM(safety_num) as safety_count FROM chezhiwang WHERE brand = '" + car_brand + "'")

    if (p_data[0].safety_count is None):
        p = 0
    else:
        p = p_data[0].safety_count / p_all_data[0].safety_count

    # 2、伤亡信息 r / v
    r_data = Chezhiwang.objects.raw("SELECT id, SUM(injury_num) as injury_count FROM chezhiwang "
                                    "WHERE typical_fault LIKE '%%" + key_words + "%%' and car_class = '" + car_class + "' and brand = '" + car_brand + "'")
    r_count = r_data[0].injury_count
    v = 0
    if (r_count is None):
        r_count = 0

    if (r_count <= 3):
        v = ((1 - math.e ** (float(-r_count))) + (1 - math.e ** (float(-p)))) / 2
    else:
        v = 1
    print("产品伤亡严重率：")
    print(v)

    # 危害可能性 h
    if (v == 1):
        h = 1
    else:
        h = math.sqrt(float(f) ** 2 + float(v) ** 2)
    print("不同系列的产品质量危害可能性：")
    print(h)

    # 零部件风险指数
    if (h == 1):
        r_s = 1
    else:
        r_s = math.sqrt(float(c) ** 2 + float(h) ** 2)
    print(key_words + "零部件风险指数：")
    print(r_s)

    return r_s


@csrf_exempt
def risk_page(request):
    select_brand = Chezhiwang.objects.values("brand").distinct();
    select_brand = list(select_brand)
    print(select_brand)

    select_class_data = Chezhiwang.objects.raw(
        "SELECT id,group_concat(car_class SEPARATOR ',') as car_class FROM chezhiwang")
    select_class_data = select_class_data[0].car_class
    print(select_class_data)
    if (select_class_data[:-1] is None):
        select_class = select_class_data.split(',')
        select_class = list(set(select_class))
    elif (select_class_data[:-1] == ','):
        select_class = select_class_data[:-1].split(',')
        select_class = list(set(select_class))
    else:
        select_class = select_class_data.split(',')
        select_class = list(set(select_class))
    select_class = list(set(select_class))

    print(select_class)
    select_lj_data = Chezhiwang.objects.raw(
        "SELECT id,group_concat(typical_fault SEPARATOR ',') as listdata FROM chezhiwang")
    dataStr = select_lj_data[0].listdata
    if (dataStr[:-1] is None):
        list_dic = dataStr.split(',')
        list_dic = list(set(list_dic))
    elif (dataStr[:-1] == ','):
        list_dic = dataStr[:-1].split(',')
        list_dic = list(set(list_dic))
    else:
        list_dic = dataStr.split(',')
        list_dic = list(set(list_dic))

    list_dis_data = []
    for e in list_dic:
        tmp = e.strip()
        list_dis_data.append(tmp)
    select_lj = list(set(list_dis_data))

    result = {"select_class": select_class, "select_lj": select_lj, "select_brand": select_brand}

    print(result)
    return HttpResponse(json.dumps(result), content_type="application/json;charset=utf-8")


from sklearn.externals import joblib


# import matplotlib.pyplot as plt
# from pandas import Series
# 超重
@csrf_exempt
def car_overweight_index(request):
    day_array = []
    for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]:
        day_array.append([i])

    my_model = joblib.load(sys.path[0] + '/static//pkl/car_info_RF_V0.1.pkl')
    day_result = my_model.predict(day_array)

    #     plt.figure(facecolor='white',figsize=(12,5))
    #     plt.plot(Series([1,2,3,4,5,6,7,8,9,10,11,12]), Series(day_result), label='predict')
    # #     Series(day_result).plot(color='red', label='predict')
    #     plt.title('car_overweight')
    #     plt.show()
    result = {"result": str(day_result)}
    return HttpResponse(json.dumps(result), content_type="application/json;charset=utf-8")


@csrf_exempt
def car_overweight_page(request):
    #     analyze_type = request.POST.get("analyze_type")
    month_sle = request.POST.get("month_sle")
    day_sle = request.POST.get("day_sle")

    day_array = []
    day_result = []
    if (month_sle and day_sle):
        my_model = joblib.load(sys.path[
                                   0] + '/static/pkl/car_info_RF_V0.2.pkl')  # 'D:/develop/pycharm/car_evaluation/static/pkl/car_info_RF_V0.2.pkl')
        day_array.append([month_sle, day_sle])
    else:
        my_model = joblib.load(sys.path[0] + '/static/pkl/car_info_RF_V0.1.pkl')
        day_array.append([month_sle])

    if (day_array):
        day_result = my_model.predict(day_array)
    result = {"result": str(day_result)}
    return HttpResponse(json.dumps(result), content_type="application/json;charset=utf-8")


import jieba
import sys

# jieba.load_userdict('D:/develop/pycharm/car_evaluation/static/data/wordDict.txt')
jieba.load_userdict(sys.path[0] + '/static/data/wordDict.txt')


# 对列表进行分词并用空格连接
def segmentWord(cont):
    c = []
    for i in cont:
        a = list(jieba.cut(i))
        b = " ".join(a)
        c.append(b)
    return c


@csrf_exempt
def files_ana_page(request):
    files_ana = request.POST.get("files_ana")

    files_ana_arr = []
    files_ana_result = []
    if (files_ana):
        url = sys.path[0] + '/static/pkl/files_ana_V0.1.pkl'.replace('\\', '/')
        my_model = joblib.load(url)
        files_ana_arr.append(" ".join(jieba.cut(files_ana)))

    if (files_ana_arr):
        import json
        print(files_ana_arr)
        print(files_ana_arr)

        files_ana_result = my_model.predict(files_ana_arr)

        print(files_ana_result)
        print(files_ana_result)
        # s_unicode = files_ana_result
        # files_ana_result = s_unicode.encode('unicode-escape').decode('string_escape')
        # print(files_ana_result[0])
        # print(files_ana_result[0])

    # result = {"result": str(files_ana_result).replace('u', '').replace('\'', '').replace('[', '').replace(']', '')}
    return HttpResponse(json.dumps(files_ana_result[0],ensure_ascii=False), content_type="application/json;charset=utf-8")
    # return HttpResponse(files_ana_result[0], content_type="application/json; charset=utf-8")


import pymysql


@csrf_exempt
def files_conn_page(request):
    type = request.POST.get("type")
    ku_name = request.POST.get("ku_name")
    ip_name = request.POST.get("ip_name")
    user_name = request.POST.get("user_name")
    pwd_name = request.POST.get("pwd_name")
    table_name = request.POST.get("table_name")

    try:
        conn = pymysql.connect(host=ip_name, port=3306, user=user_name, passwd=pwd_name, charset='UTF8', db=ku_name)
        cur = conn.cursor()
        result = '连接成功'
    except:
        result = '连接失败'
    else:
        if (type == u'2'):
            sql = 'select id,detail from ' + table_name
            ret = cur.execute(sql)
            data = cur.fetchall()
            files_ana_arr = []
            for row in data:
                files_ana_arr.append(" ".join(jieba.cut(row[1])))
            url = sys.path[0] + '/static/pkl/files_ana_V0.1.pkl'.replace('\\', '/')
            my_model = joblib.load(url)


            if (files_ana_arr):
                files_ana_result = my_model.predict(files_ana_arr)
                for index, predict in enumerate(files_ana_result):
                    # sql = 'update ' + table_name + ' set custom_type=' + predict + ' where id=' + str(data[index][0])
                    sql = "update "+ table_name +" set custom_type='"+ predict +"' where id="+ str(data[index][0]) +""
                    print(sql)
                    cur.execute(sql)
                conn.commit()
                result = '分类成功,更新%d条数据' % (ret)
    finally:
        cur.close()
        conn.close()

    result = {"result": str(result)}
    return HttpResponse(json.dumps(result), content_type="applica   tion/json;charset=utf-8")


import car_chezhiwang.utils.FP_tree as fp


@csrf_exempt
def association_ana_page(request):
    ret = upload_file(request)
    if (ret['status'] != True):
        return HttpResponse(json.dumps({"result": '上传文件失败！！'}), content_type="application/json;charset=utf-8")
    dataSet = fp.loadSimpDat(ret['data'])[0]
    minSup = request.POST.get("num")
    freqItems = fp.fpGrowth(dataSet, int(minSup))
    res = []
    for item in freqItems:
        if len(item) != 1:
            res.append(fp.u_to_utf8(item))

    result = {"result": res, "count": fp.loadSimpDat(ret['data'])[1]}
    return HttpResponse(json.dumps(result), content_type="application/json;charset=utf-8")


def upload_file(request):
    if request.method == 'POST':
        ret = {'status': False, 'data': None, 'error': None}
        try:
            uf = request.FILES.get('uploadFile')
            if not uf:
                return None
            import sys
            newpath = os.path.abspath(sys.path[0]).replace('\\', '/') + '/static/data'
            if not os.path.isdir(newpath):
                os.makedirs(newpath)
            f = open(os.path.join(newpath, uf.name).replace('\\', '/'), 'wb')
            for chunk in uf.chunks(chunk_size=1024):
                f.write(chunk)
            ret['status'] = True
            ret['data'] = os.path.join(newpath, uf.name)
        except Exception as e:
            ret['error'] = e
        finally:
            if (f):
                f.close()
            return ret


@csrf_exempt
def test_list(request):
    data = {"data": [{"appclass": 1, "id": 933, "keywordid": 478, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 932, "keywordid": 477, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 931, "keywordid": 476, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 930, "keywordid": 475, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 929, "keywordid": 474, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 928, "keywordid": 473, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 927, "keywordid": 472, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 926, "keywordid": 471, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 925, "keywordid": 470, "keywordname": "你好1", "stop": 0},
              {"appclass": 1, "id": 924, "keywordid": 469, "keywordname": "你好1", "stop": 0}], "total": 10}
    return HttpResponse(json.dumps(data), content_type="application/json;charset=utf-8")

# @csrf_exempt# 根据请求页面的名称返回对应页面的html
# def page_content(request):
#     page_name_data = request.POST.get("page_name", "")
#     print(page_name_data)
#     contenttmp = page_content_me(page_name_data)
#     result = {"content": contenttmp}
#     return HttpResponse(simplejson.dumps(result), content_type="application/json;charset=utf-8")
