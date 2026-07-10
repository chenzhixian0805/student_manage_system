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

print("当前用户手机号码格式：")

# 查询不同角色的手机号码格式
query = """SELECT role, MIN(phone), MAX(phone), COUNT(*) 
           FROM sys_user 
           GROUP BY role 
           ORDER BY role"""

cursor.execute(query)
roles = cursor.fetchall()

for role in roles:
    role_name = role[0]
    min_phone = role[1]
    max_phone = role[2]
    count = role[3]
    print(f"{role_name}: 最小号码={min_phone}, 最大号码={max_phone}, 数量={count}")

# 查看具体的手机号码分布
print("\n具体手机号码格式示例：")
example_query = """SELECT role, phone 
                   FROM sys_user 
                   ORDER BY role, id 
                   LIMIT 15"""

cursor.execute(example_query)
examples = cursor.fetchall()

for example in examples:
    role_name = example[0]
    phone = example[1]
    print(f"{role_name}: {phone}")

# 关闭数据库连接
cursor.close()
db.close()