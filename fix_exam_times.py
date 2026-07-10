import mysql.connector
from datetime import datetime, timedelta
import random

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

# 学期对应的期末周日期范围
# 第一学期：1月上旬
# 第二学期：6月下旬-7月上旬
semester_date_ranges = {
    '2023-2024学年第一学期': {
        'start': datetime(2024, 1, 7),
        'end': datetime(2024, 1, 13)
    },
    '2023-2024学年第二学期': {
        'start': datetime(2024, 6, 24),
        'end': datetime(2024, 6, 30)
    },
    '2024-2025学年第一学期': {
        'start': datetime(2025, 1, 6),
        'end': datetime(2025, 1, 12)
    },
    '2024-2025学年第二学期': {
        'start': datetime(2025, 6, 23),
        'end': datetime(2025, 6, 29)
    }
}

# 考试时间段（2小时）
exam_time_slots = [
    (8, 30),  # 8:30-10:30
    (14, 30)  # 14:30-16:30
]

# 获取所有成绩记录
cursor.execute("SELECT id, semester, exam_datetime FROM sys_grade")
grades = cursor.fetchall()

print(f"找到 {len(grades)} 条成绩记录，开始修复考试时间")

# 更新考试时间
updated_count = 0
for grade in grades:
    grade_id = grade[0]
    semester = grade[1]
    current_exam_time = grade[2]
    
    # 获取对应学期的期末周日期范围
    if semester in semester_date_ranges:
        date_range = semester_date_ranges[semester]
        
        # 生成随机的期末周日期
        delta_days = (date_range['end'] - date_range['start']).days
        random_days = random.randint(0, delta_days)
        exam_date = date_range['start'] + timedelta(days=random_days)
        
        # 选择随机的考试时间段
        hour, minute = random.choice(exam_time_slots)
        
        # 创建新的考试时间
        exam_datetime = exam_date.replace(hour=hour, minute=minute, second=0, microsecond=0)
        
        # 更新数据库
        cursor.execute(
            "UPDATE sys_grade SET exam_datetime = %s WHERE id = %s",
            (exam_datetime, grade_id)
        )
        
        updated_count += 1
        
        # 每100条提交一次
        if updated_count % 100 == 0:
            db.commit()
            print(f"已更新 {updated_count} 条成绩记录的考试时间")

# 提交剩余更新
db.commit()

# 验证结果
cursor.execute("SELECT id, semester, exam_datetime FROM sys_grade LIMIT 5")
result = cursor.fetchall()

print("\n=== 修复结果示例 ===")
for row in result:
    print(f"成绩ID: {row[0]}, 学期: {row[1]}, 考试时间: {row[2]}")

# 关闭数据库连接
cursor.close()
db.close()

print(f"\n=== 修复完成 ===")
print(f"成功更新了 {updated_count} 条成绩记录的考试时间")
print(f"考试时间已与学期对应，均为期末周，时长为2小时")