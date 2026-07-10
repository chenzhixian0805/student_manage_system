import mysql.connector
import random
from datetime import datetime
import math

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

# 1. 先查看当前选课记录数和成绩记录数
print("=== 当前系统状态 ===")
cursor.execute("SELECT COUNT(*) FROM sys_selection")
selection_count = cursor.fetchone()[0]
print(f"选课记录数: {selection_count}")

cursor.execute("SELECT COUNT(*) FROM sys_grade")
grade_count = cursor.fetchone()[0]
print(f"成绩记录数: {grade_count}")

# 2. 查看课程学分信息
cursor.execute("SELECT id, credit FROM sys_course")
courses_credits = {course_id: credit for course_id, credit in cursor.fetchall()}
print(f"课程数量: {len(courses_credits)}")

# 3. 查看学生数量
cursor.execute("SELECT COUNT(*) FROM sys_student")
student_count = cursor.fetchone()[0]
print(f"学生数量: {student_count}")

# 4. 正态分布生成成绩函数
def generate_normal_score(mean=75, std_dev=10):
    """生成符合正态分布的成绩，范围在60-100之间"""
    while True:
        score = random.normalvariate(mean, std_dev)
        if 60 <= score <= 100:
            return round(score, 1)

# 5. 计算GPA函数
def calculate_gpa(score):
    """根据分数计算GPA"""
    if score >= 90:
        return 4.0
    elif score >= 85:
        return 3.7
    elif score >= 82:
        return 3.3
    elif score >= 78:
        return 3.0
    elif score >= 75:
        return 2.7
    elif score >= 72:
        return 2.3
    elif score >= 68:
        return 2.0
    elif score >= 64:
        return 1.5
    elif score >= 60:
        return 1.0
    else:
        return 0.0

# 6. 为现有选课记录生成成绩
print("\n=== 为现有选课记录生成成绩 ===")
cursor.execute("SELECT student_id, course_id FROM sys_selection WHERE status = '已选'")
selections = cursor.fetchall()

# 计算需要生成的成绩数量
grades_to_generate = len(selections) - grade_count
print(f"需要为 {grades_to_generate} 条选课记录生成成绩")

# 生成学期列表
semesters = ['2023-2024第一学期', '2023-2024第二学期', '2024-2025第一学期', '2024-2025第二学期']

# 生成考试时间范围
exam_datetimes = [
    datetime(2024, 1, 15, 9, 0),
    datetime(2024, 6, 20, 9, 0),
    datetime(2025, 1, 15, 9, 0),
    datetime(2025, 6, 20, 9, 0)
]

# 为每条选课记录生成成绩
for i, (student_id, course_id) in enumerate(selections):
    # 检查是否已经有成绩
    cursor.execute("SELECT id FROM sys_grade WHERE student_id = %s AND course_id = %s", (student_id, course_id))
    if cursor.fetchone():
        continue
    
    # 生成随机学期和考试时间
    semester = random.choice(semesters)
    exam_datetime = random.choice(exam_datetimes)
    
    # 生成符合正态分布的成绩
    score = generate_normal_score()
    
    # 计算GPA
    gpa = calculate_gpa(score)
    
    # 获取课程学分
    credit = courses_credits.get(course_id, 3.0)
    credit_gpa = gpa * credit
    
    # 插入成绩记录
    grade_sql = """
        INSERT INTO sys_grade (student_id, course_id, score, gpa, credit_gpa, semester, exam_datetime, create_time, update_time)
        VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
    """
    cursor.execute(grade_sql, (student_id, course_id, score, gpa, credit_gpa, semester, exam_datetime))
    
    # 每100条提交一次
    if (i + 1) % 100 == 0:
        db.commit()
        print(f"已生成 {i + 1} 条成绩记录")

# 提交剩余的成绩记录
db.commit()

# 7. 检查是否有学生没有成绩记录
print("\n=== 检查没有成绩记录的学生 ===")
cursor.execute("""
    SELECT s.id 
    FROM sys_student s 
    LEFT JOIN sys_grade g ON s.id = g.student_id 
    WHERE g.id IS NULL
""")
students_without_grades = [student_id[0] for student_id in cursor.fetchall()]
print(f"有 {len(students_without_grades)} 名学生没有成绩记录")

# 8. 为没有成绩的学生生成选课记录和成绩
if students_without_grades:
    print("\n=== 为没有成绩的学生生成选课记录和成绩 ===")
    
    # 获取所有课程ID
    cursor.execute("SELECT id FROM sys_course")
    all_course_ids = [course_id[0] for course_id in cursor.fetchall()]
    
    for i, student_id in enumerate(students_without_grades):
        # 为每个学生随机选择3-5门课程
        num_courses = random.randint(3, 5)
        selected_courses = random.sample(all_course_ids, num_courses)
        
        for course_id in selected_courses:
            # 生成选课记录
            selection_sql = """
                INSERT INTO sys_selection (student_id, course_id, status, selection_time, create_time, update_time)
                VALUES (%s, %s, '已选', NOW(), NOW(), NOW())
            """
            cursor.execute(selection_sql, (student_id, course_id))
            
            # 生成成绩
            semester = random.choice(semesters)
            exam_datetime = random.choice(exam_datetimes)
            score = generate_normal_score()
            gpa = calculate_gpa(score)
            credit = courses_credits.get(course_id, 3.0)
            credit_gpa = gpa * credit
            
            grade_sql = """
                INSERT INTO sys_grade (student_id, course_id, score, gpa, credit_gpa, semester, exam_datetime, create_time, update_time)
                VALUES (%s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
            """
            cursor.execute(grade_sql, (student_id, course_id, score, gpa, credit_gpa, semester, exam_datetime))
        
        # 每10名学生提交一次
        if (i + 1) % 10 == 0:
            db.commit()
            print(f"已处理 {i + 1} 名学生")
    
    # 提交剩余的记录
    db.commit()

# 9. 验证生成结果
print("\n=== 生成结果验证 ===")
cursor.execute("SELECT COUNT(*) FROM sys_grade")
final_grade_count = cursor.fetchone()[0]
print(f"最终成绩记录数: {final_grade_count}")

# 10. 统计成绩分布
print("\n=== 成绩分布统计 ===")
cursor.execute("""
    SELECT 
        CASE 
            WHEN score >= 90 THEN '90-100' 
            WHEN score >= 80 THEN '80-89' 
            WHEN score >= 70 THEN '70-79' 
            WHEN score >= 60 THEN '60-69' 
            ELSE '不及格' 
        END AS score_range,
        COUNT(*) AS count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sys_grade), 2) AS percentage
    FROM sys_grade 
    GROUP BY score_range 
    ORDER BY score_range DESC
""")
score_distribution = cursor.fetchall()
for score_range, count, percentage in score_distribution:
    print(f"{score_range}: {count}人 ({percentage}%)")

# 关闭数据库连接
cursor.close()
db.close()

print("\n=== 成绩生成完成 ===")