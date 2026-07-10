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

print("开始按照管理员、教师、学生的顺序，同一角色内按employee_id从小到大重新排序用户...")

# 1. 查询当前所有用户，按照指定顺序排序
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
users = cursor.fetchall()

# 2. 关闭外键检查
cursor.execute("SET foreign_key_checks = 0")

# 3. 创建临时表存储新的id映射
temp_table_query = """CREATE TEMPORARY TABLE IF NOT EXISTS temp_user_order (
                           old_id INT,
                           new_id INT
                       )"""
cursor.execute(temp_table_query)

# 4. 生成新的id映射
new_id = 1
for user in users:
    old_id = user[0]
    cursor.execute("INSERT INTO temp_user_order (old_id, new_id) VALUES (%s, %s)", (old_id, new_id))
    new_id += 1

# 5. 将原表的id更新为新的id
# 首先将所有用户id更新为较大的值，避免冲突
max_new_id = new_id - 1
cursor.execute("UPDATE sys_user SET id = id + %s", (max_new_id + 100,))

# 然后将每个用户id更新为新的id
cursor.execute("SELECT old_id, new_id FROM temp_user_order")
id_mappings = cursor.fetchall()

for mapping in id_mappings:
    old_id = mapping[0] + max_new_id + 100  # 已更新的临时id
    new_id = mapping[1]
    cursor.execute("UPDATE sys_user SET id = %s WHERE id = %s", (new_id, old_id))

# 6. 清理临时表
cursor.execute("DROP TEMPORARY TABLE IF EXISTS temp_user_order")

# 7. 恢复外键检查
cursor.execute("SET foreign_key_checks = 1")

# 提交更改
db.commit()

# 验证修改结果
print("\n验证修改结果：")
verify_query = """SELECT id, user_name, role, employee_id, real_name 
                  FROM sys_user 
                  ORDER BY id ASC"""
cursor.execute(verify_query)
result = cursor.fetchall()

# 打印前20条结果
print("前20条用户数据：")
for row in result[:20]:
    print(f"id: {row[0]}, user_name: {row[1]}, role: {row[2]}, employee_id: {row[3]}, real_name: {row[4]}")

# 关闭数据库连接
cursor.close()
db.close()

print("\n用户重新排序完成！")