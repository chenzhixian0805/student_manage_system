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

print("开始更新学生的身份证号和生日日期...")

# 查询所有学生
cursor.execute("SELECT id, student_id, gender FROM sys_student")
students = cursor.fetchall()

# 生成随机日期的函数（在指定年份范围内）
def generate_birth_date(start_year, end_year):
    # 随机选择年份
    year = random.randint(start_year, end_year)
    # 随机选择月份
    month = random.randint(1, 12)
    # 根据月份选择天数
    if month in [4, 6, 9, 11]:
        day = random.randint(1, 30)
    elif month == 2:
        # 检查是否为闰年
        if (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0):
            day = random.randint(1, 29)
        else:
            day = random.randint(1, 28)
    else:
        day = random.randint(1, 31)
    # 格式化为日期对象
    return datetime(year, month, day)

# 生成身份证号的函数
def generate_id_card(birth_date, gender):
    # 1. 前6位：地区代码（固定为110101代表北京东城区）
    area_code = "110101"
    
    # 2. 中间8位：出生日期
    birth_str = birth_date.strftime("%Y%m%d")
    
    # 3. 第15-17位：顺序码（随机3位数，奇数为男，偶数为女）
    # 性别码：奇数为男，偶数为女
    if gender == '男':
        # 奇数
        sequence_code = str(random.randint(1, 999)).zfill(3)
        # 确保最后一位是奇数
        if int(sequence_code[-1]) % 2 == 0:
            sequence_code = sequence_code[:-1] + str(int(sequence_code[-1]) + 1 if sequence_code[-1] != '8' else '9')
    else:
        # 偶数
        sequence_code = str(random.randint(1, 999)).zfill(3)
        # 确保最后一位是偶数
        if int(sequence_code[-1]) % 2 == 1:
            sequence_code = sequence_code[:-1] + str(int(sequence_code[-1]) + 1 if sequence_code[-1] != '9' else '0')
    
    # 4. 第18位：校验码（这里简化处理，使用随机数字或X）
    check_digit = random.choice([str(i) for i in range(10)] + ['X'])
    
    # 组合身份证号
    id_card = f"{area_code}{birth_str}{sequence_code}{check_digit}"
    return id_card

# 更新每个学生的身份证号和生日日期
for student in students:
    student_db_id = student[0]
    student_id = student[1]
    gender = student[2]
    
    # 生成符合2023年入学年龄的生日（出生年份2003-2005年）
    birth_date = generate_birth_date(2003, 2005)
    
    # 生成身份证号
    id_card = generate_id_card(birth_date, gender)
    
    # 更新学生表
    update_query = """UPDATE sys_student 
                     SET id_card = %s, birth_date = %s 
                     WHERE id = %s"""
    cursor.execute(update_query, (id_card, birth_date, student_db_id))
    
    print(f"学生 {student_id} 的身份证号已更新为 {id_card}，生日日期已更新为 {birth_date.strftime('%Y-%m-%d')}")

# 提交更改
db.commit()

# 验证修改结果
print("\n验证修改结果：")
verify_query = """SELECT student_id, name, id_card, birth_date 
                  FROM sys_student 
                  LIMIT 10"""
cursor.execute(verify_query)
result = cursor.fetchall()

for row in result:
    student_id = row[0]
    name = row[1]
    id_card = row[2]
    birth_date = row[3]
    # 从身份证号中提取出生日期
    id_card_birth = f"{id_card[6:10]}-{id_card[10:12]}-{id_card[12:14]}"
    print(f"学生 {student_id} {name}: 身份证号={id_card}, 身份证出生日期={id_card_birth}, 生日字段={birth_date}")

# 关闭数据库连接
cursor.close()
db.close()

print("\n所有学生的身份证号和生日日期已成功更新！")