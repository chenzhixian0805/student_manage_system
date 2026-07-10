import mysql.connector
import random

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

# 查询所有两字名的学生（使用CHAR_LENGTH函数获取字符数）
cursor.execute("SELECT student_id, name FROM sys_student WHERE CHAR_LENGTH(name) = 2")
two_char_students = cursor.fetchall()

print(f"找到 {len(two_char_students)} 名两字名学生，正在修改为三字名...")

# 名字列表
name_chars = ['明', '华', '强', '芳', '磊', '娜', '伟', '敏', '静', '丽', '涛', '辉', '燕', '超', '秀']

for student in two_char_students:
    student_id = student[0]
    current_name = student[1]
    
    # 保留原姓氏，在中间插入一个随机字
    new_middle_char = random.choice(name_chars)
    new_name = f"{current_name[0]}{new_middle_char}{current_name[1]}"
    
    # 更新学生表中的姓名
    student_sql = "UPDATE sys_student SET name = %s WHERE student_id = %s"
    cursor.execute(student_sql, (new_name, student_id))
    
    # 更新用户表中的真实姓名
    user_sql = "UPDATE sys_user SET real_name = %s WHERE user_name = %s"
    cursor.execute(user_sql, (new_name, student_id))
    
    print(f"已将 {current_name} 修改为 {new_name}")

# 提交更改
db.commit()

# 验证修改结果
cursor.execute("SELECT COUNT(*) FROM sys_student WHERE CHAR_LENGTH(name) = 2")
remaining_two_char = cursor.fetchone()[0]
print(f"\n修改完成！剩余两字名学生数量：{remaining_two_char}")

# 关闭数据库连接
cursor.close()
db.close()