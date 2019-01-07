#!/usr/bin/env python

# encoding: utf-8
'''
@author: ch
@file: page_content.py
@time: 2017/12/15 11:17
@desc:
'''
import os


def page_content_me(page_name):
    path = os.path.dirname(__file__)
    path = os.path.split(path)
    path = path[0] + '\\static\\pages\\' + page_name
    data = open(path, encoding="utf-8")
    page_content = data.read()
    data.close()
    return page_content