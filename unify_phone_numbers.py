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

print("开始统一所有用户的手机号码格式...")

# 1. 关闭外键检查
cursor.execute("SET foreign_key_checks = 0")

# 2. 统一管理员手机号码为13800000000
admin_phone = "13800000000"
cursor.execute("UPDATE sys_user SET phone = %s WHERE role = 'ROLE_ADMIN'", (admin_phone,))
print(f"管理员手机号码已统一为：{admin_phone}")

# 3. 统一教师手机号码为13800000001-13800000010
# 先按employee_id排序教师用户
teacher_query = """SELECT id, employee_id 
                   FROM sys_user 
                   WHERE role = 'ROLE_TEACHER' 
                   ORDER BY employee_id ASC"""
cursor.execute(teacher_query)
teachers = cursor.fetchall()

for i, teacher in enumerate(teachers):
    teacher_id = teacher[0]
    teacher_phone = f"138000000{str(i+1).zfill(2)}"
    cursor.execute("UPDATE sys_user SET phone = %s WHERE id = %s", (teacher_phone, teacher_id))
    print(f"教师 {teacher[1]} 手机号码已更新为：{teacher_phone}")

# 4. 统一学生手机号码为13800000011-13800000210
# 先按employee_id排序学生用户
student_query = """SELECT id, employee_id 
                   FROM sys_user 
                   WHERE role = 'ROLE_STUDENT' 
                   ORDER BY employee_id ASC"""
cursor.execute(student_query)
students = cursor.fetchall()

for i, student in enumerate(students):
    student_id = student[0]
    student_phone = f"13800000{str(11 + i).zfill(3)}"
    cursor.execute("UPDATE sys_user SET phone = %s WHERE id = %s", (student_phone, student_id))
    print(f"学生 {student[1]} 手机号码已更新为：{student_phone}")

# 5. 恢复外键检查
cursor.execute("SET foreign_key_checks = 1")

# 提交更改
db.commit()

# 验证修改结果
print("\n验证修改结果：")
verify_query = """SELECT role, phone 
                  FROM sys_user 
                  ORDER BY role, id 
                  LIMIT 20"""
cursor.execute(verify_query)
result = cursor.fetchall()

for row in result:
    role_name = row[0]
    phone = row[1]
    print(f"{role_name}: {phone}")

# 关闭数据库连接
cursor.close()
db.close()

print("\n所有用户手机号码已成功统一！")