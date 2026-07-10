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

# 查询所有学生用户
cursor.execute("SELECT id, user_name, employee_id FROM sys_user WHERE role = 'ROLE_STUDENT'")
students = cursor.fetchall()

print(f"正在将 {len(students)} 名学生的user_name统一为employee_id...")

for student in students:
    user_id = student[0]
    current_user_name = student[1]
    employee_id = student[2]
    
    # 如果user_name已经与employee_id相同，则跳过
    if current_user_name == employee_id:
        continue
    
    # 更新用户表中的user_name
    user_sql = "UPDATE sys_user SET user_name = %s WHERE id = %s"
    cursor.execute(user_sql, (employee_id, user_id))
    
    print(f"已将用户 {current_user_name} 的user_name更新为 {employee_id}")

# 提交更改
db.commit()

# 验证修改结果
cursor.execute("SELECT COUNT(*) FROM sys_user WHERE role = 'ROLE_STUDENT' AND user_name != employee_id")
invalid_count = cursor.fetchone()[0]
print(f"\n统一完成！不符合格式的用户数量：{invalid_count}")

# 关闭数据库连接
cursor.close()
db.close()