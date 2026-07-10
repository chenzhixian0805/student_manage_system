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

print(f"正在统一 {len(students)} 名学生的employee_id...")

for student in students:
    user_id = student[0]
    user_name = student[1]
    current_employee_id = student[2]
    
    # 生成统一的employee_id格式：S + 学号
    new_employee_id = f"S{user_name}"
    
    # 如果employee_id已经是正确格式，则跳过
    if current_employee_id == new_employee_id:
        continue
    
    # 更新用户表中的employee_id
    user_sql = "UPDATE sys_user SET employee_id = %s WHERE id = %s"
    cursor.execute(user_sql, (new_employee_id, user_id))
    
    print(f"已将用户 {user_name} 的employee_id从 {current_employee_id} 更新为 {new_employee_id}")

# 提交更改
db.commit()

# 验证修改结果
cursor.execute("SELECT COUNT(*) FROM sys_user WHERE role = 'ROLE_STUDENT' AND employee_id != CONCAT('S', user_name)")
invalid_count = cursor.fetchone()[0]
print(f"\n统一完成！不符合格式的employee_id数量：{invalid_count}")

# 关闭数据库连接
cursor.close()
db.close()