#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : common.py
# @Author: CH
# @Date  : 2018/5/11
# @Desc  : 公共方法

import sys

model_savepath = sys.path[1] + "\\static\data\\"

if __name__ == '__main__':

    a = 0;
    b = 1;
    while b < 1000:
        # print('b:'+ str(b))
        # print('a:' + str(a))
        # a = b # 1
        # b = a + b # 1
        a, b = b, a + b

    list = []
    for i in range(100):
        print(i)
        if i == 0 or i == 1:
            list.append(1)
        else:
            list.append(list[i-1] + list[i-2])
    print(list)

    print(list[8])
    #   1,1    1,2    2,3   3,5
    # import pymysql
    # import pandas as pd
    #
    # conn = pymysql.connect(host='192.168.252.200', port=3306, user='root', passwd='root', charset='UTF8',
    #                        db='car_evaluation')
    # data = ['1','2']
    # for i in range(2):
    #     sql = "select count(id) from evaluate_result"
    #     cursor = conn.cursor()
    #     cursor.execute(sql)
    #     print(cursor.fetchone()[0])
    # df1 = pd.read_sql_query(
    #     'select id,car_models_id '
    #     'from evaluate_result limit 9', conn)
    # df2 = pd.read_sql_query(
    #     'select odo,sale_price_normal '
    #     'from evaluate_result limit 9', conn)
    # print(df1)
    # print(df2)
    # df_new = df1.join(df2)
    # print(df_new)
