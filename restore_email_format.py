import mysql.connector
from pypinyin import lazy_pinyin, Style

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

# 获取新生成的学生（student_id >= 20230051）
cursor.execute("SELECT id, student_id, name, email FROM sys_student WHERE student_id >= 20230051")
students = cursor.fetchall()

print(f"找到 {len(students)} 名新生成的学生")

# 更新邮箱计数器
updated_count = 0

for student in students:
    student_id = student[1]
    name = student[2]
    
    # 使用pypinyin生成姓名全拼
    pinyin = lazy_pinyin(name, style=Style.NORMAL)
    email_prefix = ''.join(pinyin)
    
    # 生成标准邮箱格式：姓名全拼@example.com
    new_email = f"{email_prefix}@example.com"
    
    # 更新学生表中的邮箱
    cursor.execute(
        "UPDATE sys_student SET email = %s WHERE student_id = %s",
        (new_email, student_id)
    )
    
    # 更新用户表中的邮箱
    cursor.execute(
        "UPDATE sys_user SET email = %s WHERE user_name = %s",
        (new_email, student_id)
    )
    
    updated_count += 1
    
    # 每10条提交一次
    if updated_count % 10 == 0:
        db.commit()
        print(f"已更新 {updated_count} 名学生的邮箱")

# 提交剩余的更新
db.commit()

# 验证更新结果
cursor.execute(
    "SELECT student_id, name, email FROM sys_student WHERE student_id >= 20230051 LIMIT 10"
)
updated_students = cursor.fetchall()

print("\n=== 更新后的学生邮箱示例 ===")
for student in updated_students:
    print(f"学号: {student[0]}, 姓名: {student[1]}, 邮箱: {student[2]}")

# 关闭数据库连接
cursor.close()
db.close()

print(f"\n=== 更新完成 ===")
print(f"成功更新了 {updated_count} 名学生的邮箱")
print(f"所有学生的邮箱格式已统一为：姓名全拼@example.com")