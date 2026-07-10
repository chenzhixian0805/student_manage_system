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

print("开始将管理员账号移到第一位...")

# 1. 查询当前最大的id值
cursor.execute("SELECT MAX(id) FROM sys_user")
max_id = cursor.fetchone()[0]
print(f"当前最大id: {max_id}")

# 2. 关闭外键检查
print("2. 关闭外键检查")
cursor.execute("SET foreign_key_checks = 0")

# 3. 将现有id=1的用户id修改为临时值（max_id+1）
temp_id = max_id + 1
print(f"3. 将现有id=1的用户id修改为临时值 {temp_id}")
cursor.execute(f"UPDATE sys_user SET id = {temp_id} WHERE id = 1")

# 4. 将管理员账号的id修改为1
print("4. 将管理员账号的id修改为1")
cursor.execute("UPDATE sys_user SET id = 1 WHERE user_name = 'admin'")

# 6. 恢复外键检查
print("6. 恢复外键检查")
cursor.execute("SET foreign_key_checks = 1")

# 提交更改
db.commit()

# 验证修改结果
print("\n验证修改结果：")
cursor.execute("SELECT id, user_name, role, real_name FROM sys_user ORDER BY id LIMIT 5")
result = cursor.fetchall()
for row in result:
    print(f"id: {row[0]}, user_name: {row[1]}, role: {row[2]}, real_name: {row[3]}")

# 关闭数据库连接
cursor.close()
db.close()

print("\n管理员账号已成功移到第一位！")