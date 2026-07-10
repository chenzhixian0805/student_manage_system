import mysql.connector
import bcrypt

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

print("开始将密码从明文转换为BCrypt加密格式...")

# 查询所有密码为明文"password123"的用户
cursor.execute("SELECT id, user_name, role FROM sys_user WHERE password = 'password123'")
users = cursor.fetchall()

print(f"找到 {len(users)} 个用户需要更新密码格式")

# 加密每个用户的密码
for user in users:
    user_id = user[0]
    user_name = user[1]
    role = user[2]
    
    # 生成BCrypt加密密码
    password = "password123"
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt(10)).decode('utf-8')
    
    # 更新用户密码
    cursor.execute("UPDATE sys_user SET password = %s WHERE id = %s", (hashed_password, user_id))
    
    print(f"已将用户 {user_name} ({role}) 的密码转换为BCrypt格式")

# 提交更改
db.commit()

# 验证修改结果
print("\n验证修改结果：")
cursor.execute("SELECT user_name, role, LEFT(password, 20) as password_prefix FROM sys_user ORDER BY role")
result = cursor.fetchall()

for row in result[:20]:  # 只显示前20条
    print(f"user_name: {row[0]}, role: {row[1]}, password: {row[2]}...")

# 关闭数据库连接
cursor.close()
db.close()

print("\n所有用户密码已成功转换为BCrypt加密格式！")