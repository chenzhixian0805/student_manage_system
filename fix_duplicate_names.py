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

# 查询所有重名的学生姓名及数量
cursor.execute("SELECT name, COUNT(*) as count FROM sys_student GROUP BY name HAVING COUNT(*) > 1")
duplicate_names = cursor.fetchall()

print(f"找到 {len(duplicate_names)} 组重名学生，正在处理...")

# 名字列表
name_chars = ['明', '华', '强', '芳', '磊', '娜', '伟', '敏', '静', '丽', '涛', '辉', '燕', '超', '秀', '军', '刚', '勇', '艳', '杰']

for name_info in duplicate_names:
    duplicate_name = name_info[0]
    count = name_info[1]
    
    print(f"处理重名：{duplicate_name}（共 {count} 人）")
    
    # 查询所有使用该姓名的学生
    cursor.execute("SELECT student_id, name FROM sys_student WHERE name = %s", (duplicate_name,))
    students = cursor.fetchall()
    
    # 保留第一个学生的姓名不变，修改其他学生的姓名
    for i in range(1, len(students)):
        student = students[i]
        student_id = student[0]
        current_name = student[1]
        
        # 生成新姓名（替换中间字为不同的随机字）
        new_middle_char = random.choice(name_chars)
        # 确保新名字与原名字不同
        while new_middle_char == current_name[1]:
            new_middle_char = random.choice(name_chars)
        
        new_name = f"{current_name[0]}{new_middle_char}{current_name[2]}"
        
        # 确保新名字不与其他学生重名
        while True:
            cursor.execute("SELECT COUNT(*) FROM sys_student WHERE name = %s", (new_name,))
            if cursor.fetchone()[0] == 0:
                break
            # 如果新名字已存在，重新生成
            new_middle_char = random.choice(name_chars)
            new_name = f"{current_name[0]}{new_middle_char}{current_name[2]}"
        
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
cursor.execute("SELECT name, COUNT(*) as count FROM sys_student GROUP BY name HAVING COUNT(*) > 1")
remaining_duplicates = cursor.fetchall()
print(f"\n处理完成！剩余重名学生组数：{len(remaining_duplicates)}")

# 关闭数据库连接
cursor.close()
db.close()