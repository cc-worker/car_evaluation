#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : __init__.py.py
# @Author: CH
# @Date  : 2018/5/9
# @Desc  :
import pymysql
import sys

conn = pymysql.Connect(
    host='127.0.0.1',
    port=3306,
    user='root',
    passwd='111111',
    db='car_evaluation',
    charset='utf8'
)

curr_path = sys.path[1]