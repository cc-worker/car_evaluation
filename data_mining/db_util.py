#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @File  : db_util.py
# @Author: CH
# @Date  : 2018/5/17
# @Desc  : 数据库通用类


# 数据分页
def pagenation_common(conn, table, dict_data):  # table, limit, page

    cursor = conn.cursor()
    sql = "SELECT * FROM %s WHERE 1 = 1" % (table)
    sql_total = "SELECT count(*) FROM %s WHERE 1 = 1" % (table)
    # 查询
    limit = 10
    page = 1
    index = 'id'
    if dict_data:
        for d, x in dict_data.items():
            if dict_data.has_key(d):
                if d == 'index':
                    if dict_data[d] != '':
                        index = dict_data[d]
                    else:
                        index = 'id'
                elif d == 'limit':
                    limit = int(dict_data[d])
                elif d == 'page':
                    page = int(dict_data[d])
                else:
                    if dict_data[d] != '':
                        sql = sql + " and " + d + " like '%" + dict_data[d] + "%'"
                        sql_total = sql_total + " and " + d + " like '%" + dict_data[d] + "%'"
                    else:
                        pass
    else:
        index = 'id'

    sql = sql + " ORDER BY " + index + " desc limit %s OFFSET %s " % (limit, (page - 1) * limit)

    cursor.execute(sql)
    rawData = cursor.fetchall()
    col_names = [desc[0] for desc in cursor.description]
    list = []
    for row in rawData:
        objDict = {}
        # 把每一行的数据遍历出来放到Dict中
        for index, value in enumerate(row):
            objDict[col_names[index]] = value
        list.append(objDict)
    # 获取数据总量 total
    cursor.execute(sql_total)
    total = cursor.fetchone()
    total = total[0]
    cursor.close()
    return {'data': list, 'total': total}


# 数据的增、改(return: (id 、 data))
def saveorupdate(conn, table, dict_data):
    id = ''
    cursor = conn.cursor()
    if dict_data['id'] == '' or dict_data['id'] is None:  # 新增
        del dict_data['id']
        cols = ', '.join(dict_data.keys())
        data_value = dict_data.values()
        qmarks = ', '.join(['%s'] * len(dict_data))
        sql = "INSERT INTO %s (%s) VALUES (%s) RETURNING id" % (table, cols, qmarks)
        try:
            cursor.execute(sql, data_value)
            item = cursor.fetchone()
            id = item[0]
            conn.commit()
        except Exception:
            print('err')
    else:
        id = dict_data['id']
        value = ''
        for key in dict_data:
            if key == 'id':
                pass
            else:
                if type(dict_data[key]) == int:
                    value = key + '=' + str(dict_data[key]) + ',' + value
                else:
                    value = key + " ='" + str(dict_data[key]) + "'," + value
        sql = "UPDATE %s set %s WHERE  id=%s" % (table, value[:-1], id)
        try:
            cursor.execute(sql)
            conn.commit()
        except Exception:
            print('err')

    dict_data['id'] = id
    data = {'id': id, 'data': dict_data}
    cursor.close()
    return data


# 根据ID删除对应数据行
def delete(conn, table, ids):
    idarr = ids.split(",")
    cursor = conn.cursor()
    try:
        for id in idarr:
            sql = "delete from %s where id =%s" % (table, int(id))
            cursor.execute(sql)
            conn.commit()
    except:
        print('delete err')

    cursor.close()
    return len(idarr)
