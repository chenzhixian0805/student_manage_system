import mysql.connector

# 数据库连接配置
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'czx040805',
    'database': 'stusys'
}

# 连接数据库
db = mysql.connector.connect(**db_config)
cursor = db.cursor()

print("按照管理员、教师、学生的顺序，同一角色内按employee_id从小到大排列：")

# 查询并按照指定顺序排序
query = """SELECT id, user_name, role, employee_id, real_name 
           FROM sys_user 
           ORDER BY 
               CASE role 
                   WHEN 'ROLE_ADMIN' THEN 1 
                   WHEN 'ROLE_TEACHER' THEN 2 
                   WHEN 'ROLE_STUDENT' THEN 3 
                   ELSE 4 
               END, 
               employee_id ASC"""

cursor.execute(query)
result = cursor.fetchall()

# 打印结果
for row in result:
    print(f"id: {row[0]}, user_name: {row[1]}, role: {row[2]}, employee_id: {row[3]}, real_name: {row[4]}")

# 关闭数据库连接
cursor.close()
db.close()

print("\n排序完成！")