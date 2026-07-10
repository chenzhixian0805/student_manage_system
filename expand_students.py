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
db = mysql.connector.connect(**db_config)
cursor = db.cursor()

# 先查看当前学生总数
cursor.execute("SELECT COUNT(*) FROM sys_student")
current_count = cursor.fetchone()[0]
print(f"当前学生总数: {current_count}")

# 需要新增的学生数量
target_total = 200
students_to_add = target_total - current_count
print(f"需要新增学生数量: {students_to_add}")

if students_to_add <= 0:
    print("学生数量已经达到或超过目标值")
    exit()

# 姓名前缀和后缀
first_names = ['张', '李', '王', '刘', '陈', '杨', '赵', '黄', '周', '吴']
last_names = ['明', '华', '强', '芳', '磊', '娜', '伟', '敏', '静', '丽', '涛', '辉', '燕', '超', '秀']
genders = ['男', '女']

# 获取班级列表
cursor.execute("SELECT id, major_id, class_name FROM sys_class ORDER BY id")
classes = cursor.fetchall()
class_count = len(classes)

# 获取当前最大的student_id和user_id
cursor.execute("SELECT MAX(student_id) FROM sys_student")
max_student_id = cursor.fetchone()[0]
if max_student_id is None:
    max_student_id = 20230000

cursor.execute("SELECT MAX(id) FROM sys_user")
max_user_id = cursor.fetchone()[0]
if max_user_id is None:
    max_user_id = 0

print(f"当前最大student_id: {max_student_id}")
print(f"当前最大user_id: {max_user_id}")

# 开始生成学生数据
for i in range(students_to_add):
    # 计算班级索引（循环分配）
    class_index = i % class_count
    class_id, major_id, class_name = classes[class_index]
    
    # 生成学生ID
    student_id = max_student_id + 1 + i
    user_id = max_user_id + 1 + i
    
    # 生成随机姓名（三字名，确保唯一）
    while True:
        first_name = random.choice(first_names)
        middle_name = random.choice(last_names)
        last_name = random.choice(last_names)
        full_name = f"{first_name}{middle_name}{last_name}"
        # 检查姓名是否已存在
        cursor.execute("SELECT COUNT(*) FROM sys_student WHERE name = %s", (full_name,))
        if cursor.fetchone()[0] == 0:
            break
    
    # 生成随机性别
    gender = random.choice(genders)
    
    # 生成随机手机号
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
    
    # 生成身份证号（模拟）
    year = random.randint(2000, 2005)
    month = random.randint(1, 12)
    day = random.randint(1, 28)
    id_card_suffix = random.randint(0, 9999)
    id_card = f"110101{year}{month:02d}{day:02d}{id_card_suffix:04d}"
    
    # 生成当前时间
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # 插入用户表
    employee_id = f"S{student_id}"
    user_sql = """INSERT INTO sys_user 
                (create_time, update_time, real_name, password, phone, email, employee_id, role, status, user_name) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    user_data = (
        now, now, full_name, 'password123', phone, email, employee_id, 
        'ROLE_STUDENT', 1, employee_id
    )
    cursor.execute(user_sql, user_data)
    
    # 插入学生表
    student_sql = """INSERT INTO sys_student 
                   (create_time, update_time, student_id, name, gender, class_name, status, major_id, user_id, id_card, phone, email) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    student_data = (
        now, now, str(student_id), full_name, gender, class_name, '在读', 
        major_id, user_id, id_card, phone, email
    )
    cursor.execute(student_sql, student_data)
    
    # 每10条提交一次
    if (i + 1) % 10 == 0:
        db.commit()
        print(f"已添加 {i + 1} 名学生")

# 最后提交剩余的更改
db.commit()

# 查看最终结果
cursor.execute("SELECT COUNT(*) FROM sys_student")
final_count = cursor.fetchone()[0]
print(f"最终学生总数: {final_count}")

# 查看每个班级的学生数量
print("\n每个班级的学生数量:")
cursor.execute("SELECT class_name, COUNT(*) as count FROM sys_student GROUP BY class_name ORDER BY class_name")
class_counts = cursor.fetchall()
for class_name, count in class_counts:
    print(f"{class_name}: {count} 人")

# 关闭数据库连接
cursor.close()
db.close()

print("\n学生数据扩充完成")