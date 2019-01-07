#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : main.py
# @Author: CH
# @Date  : 2018/5/9
# @Desc  : 数据建模类
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
import json
import pymysql

from data_mining import calculation
from data_mining import model_build
from data_mining import model_manage

@csrf_exempt
def mysql_info(request):
    data = request.POST
    try:
        conn = pymysql.connect(
            host=data['data[db_ip]'],  # 如果是服务器，则输公网ip
            user=data['data[db_name]'],  # 当时设置的数据超级管理员账户
            passwd=data['data[db_pw]'],  # 当时设置的管理员密码
            port=int(data['data[db_port]']),  # MySQL数据的端口为3306，注意:切记这里不要写引号''
        )
    except:
        return HttpResponse(json.dumps('err', ensure_ascii=False), content_type="application/json;charset=utf-8")

    level = 0
    sql = ''
    if data['level'] == '':
        level = 0
        sql = "show databases"
    elif data['level'] == '0':
        level = 1
        sql = "select table_name from information_schema.tables where table_schema='%s'"%(data['database'])
    else:
        level = 2
        sql = "select COLUMN_NAME from information_schema.COLUMNS where table_name = '%s' AND table_schema = '%s'"%(data['curr_label'], data['database'])

    cursor = conn.cursor()
    cursor.execute(sql)
    data_db = cursor.fetchall()  # 获取所有的数据
    i = 0
    res_data = []
    for db in data_db:
        res_item = {}
        res_item['label'] = db[0]
        if level < 2:
            res_item['children'] = []
        else:
            pass
        res_item['value'] = {'value': i, 'label': db[0]}
        res_item['level'] = level
        i = i + 1
        res_data.append(res_item)
    cursor.close()
    conn.close()
    return HttpResponse(json.dumps(res_data, ensure_ascii=False), content_type="application/json;charset=utf-8")

