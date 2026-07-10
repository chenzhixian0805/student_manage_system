import mysql.connector

# 连接数据库
db = mysql.connector.connect(
    host='localhost',
    user='root',
    password='123456',
    database='stusys'
)

cursor = db.cursor()

print("开始同步教师数据...")

# 1. 查看sys_user表中的教师数据
print("\n1. sys_user表中的教师数据：")
cursor.execute("SELECT id, employee_id, real_name, email, phone FROM sys_user WHERE role = 'ROLE_TEACHER' ORDER BY employee_id")
teachers_in_user = cursor.fetchall()
for teacher in teachers_in_user:
    print(f"ID: {teacher[0]}, 工号: {teacher[1]}, 姓名: {teacher[2]}, 邮箱: {teacher[3]}, 电话: {teacher[4]}")

# 2. 查看sys_teacher表中的数据
print("\n2. sys_teacher表中的数据：")
cursor.execute("SELECT id, user_id, teacher_id, name, email, phone FROM sys_teacher ORDER BY teacher_id")
teachers_in_teacher = cursor.fetchall()
for teacher in teachers_in_teacher:
    print(f"ID: {teacher[0]}, user_id: {teacher[1]}, 工号: {teacher[2]}, 姓名: {teacher[3]}, 邮箱: {teacher[4]}, 电话: {teacher[5]}")

# 3. 同步逻辑：将sys_user中的教师同步到sys_teacher，确保数据一致
print("\n3. 开始同步教师数据...")

# 先创建一个映射，key是employee_id，value是教师信息
user_teachers_map = {}
for teacher in teachers_in_user:
    user_teachers_map[teacher[1]] = {
        'user_id': teacher[0],
        'employee_id': teacher[1],
        'name': teacher[2],
        'email': teacher[3],
        'phone': teacher[4]
    }

# 再创建sys_teacher中已有的employee_id集合
existing_teacher_ids = set()
for teacher in teachers_in_teacher:
    existing_teacher_ids.add(teacher[2])

# 同步数据：添加缺失的教师，更新已存在的教师数据
sync_count = 0
update_count = 0
for employee_id, teacher_info in user_teachers_map.items():
    if employee_id in existing_teacher_ids:
        # 更新已存在的教师数据
        update_query = """UPDATE sys_teacher SET 
                        user_id = %s, 
                        name = %s, 
                        email = %s, 
                        phone = %s 
                        WHERE teacher_id = %s"""
        update_values = (
            teacher_info['user_id'],
            teacher_info['name'],
            teacher_info['email'],
            teacher_info['phone'],
            employee_id
        )
        cursor.execute(update_query, update_values)
        update_count += 1
    else:
        # 添加新的教师
        # 先查询sys_teacher表中最大的id，确保id递增
        cursor.execute("SELECT IFNULL(MAX(id), 0) FROM sys_teacher")
        max_id = cursor.fetchone()[0] + 1
        
        # 查询学院和专业信息，使用默认值
        college_id = 1
        major_id = 1
        
        insert_query = """INSERT INTO sys_teacher (
                        id, user_id, college_id, major_id, teacher_id, name, gender, birth_date, 
                        phone, email, title, entry_date, status, created_at, updated_at
                        ) VALUES (
                        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW()
                        )"""
        insert_values = (
            max_id,
            teacher_info['user_id'],
            college_id,
            major_id,
            employee_id,
            teacher_info['name'],
            '男',  # 默认性别
            '1980-01-01',  # 默认生日
            teacher_info['phone'],
            teacher_info['email'],
            '讲师',  # 默认职称
            '2020-01-01',  # 默认入职日期
            '正常'  # 默认状态
        )
        cursor.execute(insert_query, insert_values)
        sync_count += 1

# 提交事务
db.commit()

# 4. 验证同步结果
print(f"\n4. 同步完成：")
print(f"   - 新增教师：{sync_count} 名")
print(f"   - 更新教师：{update_count} 名")

# 5. 查看同步后的sys_teacher表数据
print("\n5. 同步后的sys_teacher表数据：")
cursor.execute("SELECT id, user_id, teacher_id, name, email, phone FROM sys_teacher ORDER BY teacher_id")
updated_teachers = cursor.fetchall()
for teacher in updated_teachers:
    print(f"ID: {teacher[0]}, user_id: {teacher[1]}, 工号: {teacher[2]}, 姓名: {teacher[3]}, 邮箱: {teacher[4]}, 电话: {teacher[5]}")

# 6. 验证sys_teacher中的所有teacher_id都能在sys_user中找到
print("\n6. 验证教师关联完整性：")
validation_query = "SELECT t.teacher_id, t.name, u.real_name FROM sys_teacher t LEFT JOIN sys_user u ON t.teacher_id = u.employee_id ORDER BY t.teacher_id"
cursor.execute(validation_query)
validation_results = cursor.fetchall()
all_valid = True
for result in validation_results:
    if result[2] is None:
        print(f"   ✗ 错误：sys_teacher中工号 {result[0]} ({result[1]}) 在sys_user中不存在")
        all_valid = False
    else:
        print(f"   ✓ 正确：sys_teacher中工号 {result[0]} ({result[1]}) 与sys_user中 {result[2]} 匹配")

if all_valid:
    print("\n✓ 所有教师数据已同步完成，数据一致！")
else:
    print("\n✗ 存在数据不一致，请检查！")

# 关闭连接
cursor.close()
db.close()

print("\n教师数据同步脚本执行完成！")
