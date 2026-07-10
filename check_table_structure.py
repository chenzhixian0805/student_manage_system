import mysql.connector

# 连接数据库
cnx = mysql.connector.connect(
    host='localhost',
    user='root',
    password='123456',
    database='stusys'
)

# 创建游标
cursor = cnx.cursor()

# 查询sys_student表结构
print('sys_student表结构：')
cursor.execute('DESCRIBE sys_student')
for row in cursor.fetchall():
    print(row)

# 查询sys_user表结构
print('\nsys_user表结构：')
cursor.execute('DESCRIBE sys_user')
for row in cursor.fetchall():
    print(row)

# 查询sys_student表中的status字段的实际值
print('\nsys_student表中status字段的实际值：')
cursor.execute('SELECT DISTINCT status FROM sys_student LIMIT 10')
for row in cursor.fetchall():
    print(row)

# 关闭游标和连接
cursor.close()
cnx.close()
