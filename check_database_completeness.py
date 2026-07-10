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

print("开始全面检查数据库完整性和关联性...")

# 1. 检查所有表的唯一约束
print("\n1. 检查所有表的唯一约束：")
table_query = """SELECT table_name, column_name, constraint_name 
                 FROM information_schema.key_column_usage 
                 WHERE table_schema = 'stusys' AND constraint_name LIKE 'UNIQ%' OR constraint_name LIKE 'UK%'"""
cursor.execute(table_query)
unique_constraints = cursor.fetchall()

for constraint in unique_constraints:
    table_name = constraint[0]
    column_name = constraint[1]
    constraint_name = constraint[2]
    
    # 检查唯一约束是否有冲突
    conflict_query = f"""
        SELECT {column_name}, COUNT(*) as count 
        FROM {table_name} 
        GROUP BY {column_name} 
        HAVING COUNT(*) > 1
    """
    cursor.execute(conflict_query)
    conflicts = cursor.fetchall()
    
    if conflicts:
        print(f"  ✗ {table_name}.{column_name} ({constraint_name}) 存在 {len(conflicts)} 个重复值")
        for conflict in conflicts[:3]:  # 只显示前3个
            print(f"    重复值: {conflict[0]}, 出现次数: {conflict[1]}")
        if len(conflicts) > 3:
            print(f"    ... 还有 {len(conflicts) - 3} 个重复值")
    else:
        print(f"  ✓ {table_name}.{column_name} ({constraint_name}) 唯一约束有效")

# 2. 检查所有表的非空约束
print("\n2. 检查所有表的非空约束：")
not_null_query = """SELECT table_name, column_name 
                   FROM information_schema.columns 
                   WHERE table_schema = 'stusys' AND is_nullable = 'NO'"""
cursor.execute(not_null_query)
not_null_columns = cursor.fetchall()

for column in not_null_columns:
    table_name = column[0]
    column_name = column[1]
    
    # 跳过自增主键，因为它们不会为NULL
    if column_name == 'id':
        continue
    
    null_check_query = f"""
        SELECT COUNT(*) 
        FROM {table_name} 
        WHERE {column_name} IS NULL OR {column_name} = ''
    """
    cursor.execute(null_check_query)
    null_count = cursor.fetchone()[0]
    
    if null_count > 0:
        print(f"  ✗ {table_name}.{column_name} 存在 {null_count} 个空值")
    else:
        print(f"  ✓ {table_name}.{column_name} 非空约束有效")

# 3. 检查sys_course表的完整性
print("\n3. 检查sys_course表的完整性：")
course_check_query = """
    SELECT c.id, c.name, c.teacher_id, u.id as user_id, u.user_name, u.role 
    FROM sys_course c 
    LEFT JOIN sys_user u ON c.teacher_id = u.id 
    WHERE u.id IS NULL OR u.role != 'ROLE_TEACHER'
"""
cursor.execute(course_check_query)
course_issues = cursor.fetchall()

if course_issues:
    print(f"  ✗ sys_course表存在 {len(course_issues)} 个无效的teacher_id引用")
    for issue in course_issues[:3]:
        print(f"    课程ID: {issue[0]}, 课程名称: {issue[1]}, 无效teacher_id: {issue[2]}")
    if len(course_issues) > 3:
        print(f"    ... 还有 {len(course_issues) - 3} 个无效引用")
else:
    print("  ✓ sys_course表的teacher_id引用都有效")

# 4. 检查sys_selection表的完整性
print("\n4. 检查sys_selection表的完整性：")
selection_check_query = """
    SELECT COUNT(*) 
    FROM sys_selection 
    WHERE student_id NOT IN (SELECT id FROM sys_student) OR course_id NOT IN (SELECT id FROM sys_course)
"""
cursor.execute(selection_check_query)
selection_issues = cursor.fetchone()[0]

if selection_issues > 0:
    print(f"  ✗ sys_selection表存在 {selection_issues} 个无效的外键引用")
else:
    print("  ✓ sys_selection表的外键引用都有效")

# 5. 检查sys_grade表的完整性
print("\n5. 检查sys_grade表的完整性：")
grade_check_query = """
    SELECT COUNT(*) 
    FROM sys_grade 
    WHERE student_id NOT IN (SELECT id FROM sys_student) OR course_id NOT IN (SELECT id FROM sys_course)
"""
cursor.execute(grade_check_query)
grade_issues = cursor.fetchone()[0]

if grade_issues > 0:
    print(f"  ✗ sys_grade表存在 {grade_issues} 个无效的外键引用")
else:
    print("  ✓ sys_grade表的外键引用都有效")

# 6. 检查sys_teacher表的完整性
print("\n6. 检查sys_teacher表的完整性：")
teacher_check_query = """
    SELECT COUNT(*) 
    FROM sys_teacher t 
    LEFT JOIN sys_user u ON t.user_id = u.id 
    WHERE u.id IS NULL OR u.role != 'ROLE_TEACHER'
"""
cursor.execute(teacher_check_query)
teacher_issues = cursor.fetchone()[0]

if teacher_issues > 0:
    print(f"  ✗ sys_teacher表存在 {teacher_issues} 个无效的user_id引用")
else:
    print("  ✓ sys_teacher表的user_id引用都有效")

# 7. 检查sys_student表的完整性
print("\n7. 检查sys_student表的完整性：")
student_check_query = """
    SELECT COUNT(*) 
    FROM sys_student s 
    LEFT JOIN sys_user u ON s.user_id = u.id 
    WHERE u.id IS NULL OR u.role != 'ROLE_STUDENT'
"""
cursor.execute(student_check_query)
student_issues = cursor.fetchone()[0]

if student_issues > 0:
    print(f"  ✗ sys_student表存在 {student_issues} 个无效的user_id引用")
else:
    print("  ✓ sys_student表的user_id引用都有效")

# 8. 检查sys_major表的完整性
print("\n8. 检查sys_major表的完整性：")
major_check_query = """
    SELECT COUNT(*) 
    FROM sys_major 
    WHERE college_id NOT IN (SELECT id FROM sys_college)
"""
cursor.execute(major_check_query)
major_issues = cursor.fetchone()[0]

if major_issues > 0:
    print(f"  ✗ sys_major表存在 {major_issues} 个无效的college_id引用")
else:
    print("  ✓ sys_major表的college_id引用都有效")

# 关闭数据库连接
cursor.close()
db.close()

print("\n" + "="*50)
print("数据库全面检查完成！")
print("="*50)