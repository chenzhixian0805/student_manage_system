import mysql.connector
import random
from datetime import datetime, timedelta

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

# 地址码列表（前6位）
address_codes = [
    '110101', '110102', '110103', '110104', '110105', '110106',  # 北京
    '310101', '310102', '310103', '310104', '310105', '310106',  # 上海
    '440101', '440103', '440104', '440105', '440106', '440111',  # 广州
    '440301', '440303', '440304', '440305', '440306', '440307'   # 深圳
]

# 计算身份证校验码
def calculate_check_digit(id_17):
    """根据前17位计算第18位校验码"""
    weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
    check_codes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2']
    
    sum = 0
    for i in range(17):
        sum += int(id_17[i]) * weights[i]
    
    return check_codes[sum % 11]

# 生成随机出生日期（2000-2005年之间）
def generate_birth_date():
    start_date = datetime(2000, 1, 1)
    end_date = datetime(2005, 12, 31)
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

# 生成身份证号码
def generate_id_card(gender):
    # 随机选择地址码
    address_code = random.choice(address_codes)
    
    # 生成随机出生日期
    birth_date = generate_birth_date()
    birth_date_str = birth_date.strftime('%Y%m%d')
    
    # 生成顺序码（3位数字），其中第3位根据性别决定奇偶
    # 男：奇数，女：偶数
    seq = random.randint(0, 99)
    if gender == '男':
        # 确保最后一位是奇数
        seq = seq * 10 + (random.randint(0, 4) * 2 + 1)
    else:
        # 确保最后一位是偶数
        seq = seq * 10 + (random.randint(0, 4) * 2)
    seq_str = f"{seq:03d}"
    
    # 拼接前17位
    id_17 = address_code + birth_date_str + seq_str
    
    # 计算校验码
    check_digit = calculate_check_digit(id_17)
    
    return id_17 + check_digit

# 获取所有学生信息
cursor.execute("SELECT id, name, gender FROM sys_student")
students = cursor.fetchall()

print(f"找到 {len(students)} 名学生，开始生成身份证号码")

# 更新学生身份证号码
updated_count = 0
for student in students:
    student_id = student[0]
    name = student[1]
    gender = student[2]
    
    # 生成身份证号码
    id_card = generate_id_card(gender)
    
    # 更新数据库
    cursor.execute(
        "UPDATE sys_student SET id_card = %s WHERE id = %s",
        (id_card, student_id)
    )
    
    updated_count += 1
    
    # 每10条提交一次
    if updated_count % 10 == 0:
        db.commit()
        print(f"已生成 {updated_count} 个身份证号码")

# 提交剩余更新
db.commit()

# 验证结果
cursor.execute("SELECT student_id, name, gender, id_card FROM sys_student LIMIT 5")
result = cursor.fetchall()

print("\n=== 生成结果示例 ===")
for row in result:
    print(f"学号: {row[0]}, 姓名: {row[1]}, 性别: {row[2]}, 身份证: {row[3]}")

# 关闭数据库连接
cursor.close()
db.close()

print(f"\n=== 生成完成 ===")
print(f"成功为 {updated_count} 名学生生成了身份证号码")