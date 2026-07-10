import mysql.connector
from pypinyin import pinyin, Style

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

# 查询所有学生
cursor.execute("SELECT student_id, name FROM sys_student")
students = cursor.fetchall()

print(f"正在更新 {len(students)} 名学生的邮箱地址...")

for student in students:
    student_id = student[0]
    name = student[1]
    
    # 将中文姓名转换为拼音全拼
    pinyin_list = pinyin(name, style=Style.NORMAL)
    # 合并拼音列表为字符串
    pinyin_full = ''.join([item[0] for item in pinyin_list])
    
    # 生成基础邮箱
    base_email = f"{pinyin_full}@example.com"
    email = base_email
    
    # 检查邮箱是否已存在，如果存在则添加数字后缀
    suffix = 1
    while True:
        cursor.execute("SELECT COUNT(*) FROM sys_student WHERE email = %s AND student_id != %s", (email, student_id))
        if cursor.fetchone()[0] == 0:
            # 同时检查用户表中的邮箱是否已存在
            cursor.execute("SELECT COUNT(*) FROM sys_user WHERE email = %s AND user_name != %s", (email, student_id))
            if cursor.fetchone()[0] == 0:
                break
        # 如果邮箱已存在，添加数字后缀
        email = f"{pinyin_full}{suffix}@example.com"
        suffix += 1
    
    # 更新学生表中的邮箱
    student_sql = "UPDATE sys_student SET email = %s WHERE student_id = %s"
    cursor.execute(student_sql, (email, student_id))
    
    # 更新用户表中的邮箱
    user_sql = "UPDATE sys_user SET email = %s WHERE user_name = %s"
    cursor.execute(user_sql, (email, student_id))
    
    print(f"已将 {student_id} {name} 的邮箱更新为 {email}")

# 提交更改
db.commit()

# 验证修改结果（检查是否还有重复邮箱）
cursor.execute("SELECT email, COUNT(*) as count FROM sys_student GROUP BY email HAVING COUNT(*) > 1")
duplicate_emails = cursor.fetchall()
if len(duplicate_emails) > 0:
    print(f"\n警告：仍存在 {len(duplicate_emails)} 组重复邮箱")
    for email_info in duplicate_emails:
        print(f"  {email_info[0]}: {email_info[1]} 人")
else:
    print(f"\n所有学生邮箱已更新完成，且邮箱地址唯一")

# 关闭数据库连接
cursor.close()
db.close()