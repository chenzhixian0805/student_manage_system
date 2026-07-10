import mysql.connector
import random
from datetime import datetime

# 数据库连接配置
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'czx040805',
    'database': 'stusys'
}

# 连接数据库
cnx = mysql.connector.connect(**db_config)
cursor = cnx.cursor()

# 先获取当前最大的student_id和user_id
cursor.execute("SELECT MAX(CAST(student_id AS UNSIGNED)) FROM sys_student")
max_student_id = cursor.fetchone()[0]
if max_student_id is None:
    max_student_id = 20230000
else:
    max_student_id = int(max_student_id)

cursor.execute("SELECT MAX(id) FROM sys_user")
max_user_id = cursor.fetchone()[0]
if max_user_id is None:
    max_user_id = 61
else:
    max_user_id = int(max_user_id)

# 需要添加的学生数量
target_count = 200
current_count = 50  # 已知当前有50名学生
students_to_add = target_count - current_count

# 班级ID和专业ID映射
class_info = {
    1: (1, '计算机科学与技术1班'),
    2: (1, '计算机科学与技术2班'),
    3: (2, '软件工程1班'),
    4: (2, '软件工程2班'),
    5: (3, '电子信息工程1班'),
    6: (4, '通信工程1班'),
    7: (5, '工商管理1班'),
    8: (6, '会计学1班'),
    9: (7, '英语1班'),
    10: (8, '日语1班'),
    11: (9, '数学与应用数学1班'),
    12: (10, '统计学1班')
}

# 姓名列表
first_names = ['张', '李', '王', '刘', '陈', '杨', '赵', '黄', '周', '吴']
last_names = ['明', '华', '强', '芳', '磊', '娜', '敏', '静', '丽', '秀']

# 开始添加学生
for i in range(students_to_add):
    student_id = max_student_id + 1 + i
    user_id = max_user_id + 1 + i
    
    # 确定班级
    class_id = (i % 12) + 1
    major_id, class_name = class_info[class_id]
    
    # 生成姓名（三字名，确保唯一）
    while True:
        first_name = random.choice(first_names)
        middle_name = random.choice(last_names)
        last_name = random.choice(last_names)
        full_name = f"{first_name}{middle_name}{last_name}"
        # 检查姓名是否已存在
        cursor.execute("SELECT COUNT(*) FROM sys_student WHERE name = %s", (full_name,))
        if cursor.fetchone()[0] == 0:
            break
    
    # 生成其他信息
    gender = '男' if i % 2 == 0 else '女'
    phone = f"138{random.randint(0, 99999999):08d}"
    
    # 生成邮箱（基于三字名拼音，确保唯一）
    from pypinyin import pinyin, Style
    pinyin_list = pinyin(full_name, style=Style.NORMAL)
    pinyin_full = ''.join([item[0] for item in pinyin_list])
    base_email = f"{pinyin_full}@example.com"
    email = base_email
    suffix = 1
    while True:
        cursor.execute("SELECT COUNT(*) FROM sys_student WHERE email = %s", (email,))
        if cursor.fetchone()[0] == 0:
            cursor.execute("SELECT COUNT(*) FROM sys_user WHERE email = %s", (email,))
            if cursor.fetchone()[0] == 0:
                break
        email = f"{pinyin_full}{suffix}@example.com"
        suffix += 1
    
    # 插入用户
    employee_id = f"S{student_id}"
    user_sql = "INSERT INTO sys_user (id, user_name, password, role, status, create_time, update_time, real_name, phone, email, employee_id) VALUES (%s, %s, %s, 'ROLE_STUDENT', 1, NOW(), NOW(), %s, %s, %s, %s)"
    cursor.execute(user_sql, (user_id, employee_id, 'password123', full_name, phone, email, employee_id))
    
    # 插入学生
    student_sql = "INSERT INTO sys_student (student_id, name, gender, phone, email, class_name, status, major_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, '在读', %s, %s)"
    cursor.execute(student_sql, (str(student_id), full_name, gender, phone, email, class_name, major_id, user_id))

# 提交事务
cnx.commit()

# 关闭连接
cursor.close()
cnx.close()

print(f"成功添加了{students_to_add}名学生，学生总数达到200名。")