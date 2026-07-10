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

print("检查数据库外键约束的数据关联性...")

# 获取所有外键约束
foreign_keys_query = """SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME 
                       FROM information_schema.KEY_COLUMN_USAGE 
                       WHERE TABLE_SCHEMA = 'stusys' AND REFERENCED_TABLE_NAME IS NOT NULL"""

cursor.execute(foreign_keys_query)
foreign_keys = cursor.fetchall()

# 检查每个外键约束
errors_found = 0

for fk in foreign_keys:
    table_name = fk[0]
    column_name = fk[1]
    referenced_table = fk[2]
    referenced_column = fk[3]
    
    print(f"\n检查 {table_name}.{column_name} -> {referenced_table}.{referenced_column}:")
    
    # 检查是否有无效的外键引用
    check_query = f"""
        SELECT {column_name}
        FROM {table_name}
        WHERE {column_name} NOT IN (SELECT {referenced_column} FROM {referenced_table}) OR {column_name} IS NULL
    """
    
    cursor.execute(check_query)
    invalid_references = cursor.fetchall()
    
    if invalid_references:
        print(f"  发现 {len(invalid_references)} 个无效引用")
        # 只显示前10个无效引用
        for ref in invalid_references[:10]:
            print(f"    无效值: {ref[0]}")
        if len(invalid_references) > 10:
            print(f"    ... 还有 {len(invalid_references) - 10} 个无效引用")
        errors_found += 1
    else:
        print(f"  ✓ 所有引用都有效")

# 检查其他可能的关联性问题
print("\n检查 sys_grade 表的 student_id 和 course_id 组合是否有效:")
grade_check_query = """
    SELECT COUNT(*) 
    FROM sys_grade g 
    LEFT JOIN sys_student s ON g.student_id = s.id 
    LEFT JOIN sys_course c ON g.course_id = c.id 
    WHERE s.id IS NULL OR c.id IS NULL
"""
cursor.execute(grade_check_query)
invalid_grades = cursor.fetchone()[0]
if invalid_grades > 0:
    print(f"  发现 {invalid_grades} 个无效的成绩记录")
    errors_found += 1
else:
    print(f"  ✓ 所有成绩记录都有效")

print("\n检查 sys_selection 表的 student_id 和 course_id 组合是否有效:")
selection_check_query = """
    SELECT COUNT(*) 
    FROM sys_selection s 
    LEFT JOIN sys_student stu ON s.student_id = stu.id 
    LEFT JOIN sys_course c ON s.course_id = c.id 
    WHERE stu.id IS NULL OR c.id IS NULL
"""
cursor.execute(selection_check_query)
invalid_selections = cursor.fetchone()[0]
if invalid_selections > 0:
    print(f"  发现 {invalid_selections} 个无效的选课记录")
    errors_found += 1
else:
    print(f"  ✓ 所有选课记录都有效")

# 关闭数据库连接
cursor.close()
db.close()

# 输出检查结果
print("\n" + "="*50)
if errors_found == 0:
    print("✓ 数据库关联性检查通过，所有外键引用都有效")
else:
    print(f"✗ 数据库关联性检查发现 {errors_found} 个问题，请检查上面的详细信息")
print("="*50)