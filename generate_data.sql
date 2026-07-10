-- 学生管理系统数据生成脚本
-- 目标：添加学生50人，老师10人，课程8门，成绩400条

USE stusys;

-- 1. 添加学院数据
INSERT INTO sys_college (college_name, create_time, description, update_time)
VALUES 
('计算机学院', NOW(), '计算机学院是学校的重点学院', NOW()),
('电子工程学院', NOW(), '电子工程学院专注于电子技术研究', NOW()),
('管理学院', NOW(), '管理学院培养管理人才', NOW()),
('外国语学院', NOW(), '外国语学院培养外语人才', NOW()),
('数学学院', NOW(), '数学学院专注于数学研究', NOW());

-- 2. 添加专业数据
INSERT INTO sys_major (major_name, college_id, create_time, description, update_time)
VALUES 
('计算机科学与技术', 1, NOW(), '计算机科学与技术专业', NOW()),
('软件工程', 1, NOW(), '软件工程专业', NOW()),
('电子信息工程', 2, NOW(), '电子信息工程专业', NOW()),
('通信工程', 2, NOW(), '通信工程专业', NOW()),
('工商管理', 3, NOW(), '工商管理专业', NOW()),
('会计学', 3, NOW(), '会计学专业', NOW()),
('英语', 4, NOW(), '英语专业', NOW()),
('日语', 4, NOW(), '日语专业', NOW()),
('数学与应用数学', 5, NOW(), '数学与应用数学专业', NOW()),
('统计学', 5, NOW(), '统计学专业', NOW());

-- 3. 添加老师用户数据（10人）
INSERT INTO sys_user (user_name, password, real_name, role, status, email, phone, employee_id, create_time, update_time)
VALUES 
('teacher01', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '张老师', 'ROLE_TEACHER', 1, 'teacher01@example.com', '13800000001', 'T001', NOW(), NOW()),
('teacher02', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '李老师', 'ROLE_TEACHER', 1, 'teacher02@example.com', '13800000002', 'T002', NOW(), NOW()),
('teacher03', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '王老师', 'ROLE_TEACHER', 1, 'teacher03@example.com', '13800000003', 'T003', NOW(), NOW()),
('teacher04', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '刘老师', 'ROLE_TEACHER', 1, 'teacher04@example.com', '13800000004', 'T004', NOW(), NOW()),
('teacher05', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '陈老师', 'ROLE_TEACHER', 1, 'teacher05@example.com', '13800000005', 'T005', NOW(), NOW()),
('teacher06', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '杨老师', 'ROLE_TEACHER', 1, 'teacher06@example.com', '13800000006', 'T006', NOW(), NOW()),
('teacher07', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '赵老师', 'ROLE_TEACHER', 1, 'teacher07@example.com', '13800000007', 'T007', NOW(), NOW()),
('teacher08', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '周老师', 'ROLE_TEACHER', 1, 'teacher08@example.com', '13800000008', 'T008', NOW(), NOW()),
('teacher09', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '吴老师', 'ROLE_TEACHER', 1, 'teacher09@example.com', '13800000009', 'T009', NOW(), NOW()),
('teacher10', '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7', '郑老师', 'ROLE_TEACHER', 1, 'teacher10@example.com', '13800000010', 'T010', NOW(), NOW());

-- 4. 添加学生用户数据（50人）
INSERT INTO sys_user (user_name, password, real_name, role, status, email, phone, employee_id, create_time, update_time)
SELECT 
    CONCAT('student', LPAD(seq, 2, '0')),
    '$2a$10$7vG7eXJ2y5zA8B9C1D2E3F4G5H6I7J8K9L0M1N2O3P4Q5R6S7T8U9V0W1X2Y3Z4A5B6C7',
    CONCAT('学生', seq),
    'ROLE_STUDENT',
    1,
    CONCAT('student', seq, '@example.com'),
    CONCAT('13900000', LPAD(seq, 3, '0')),
    NULL,
    NOW(),
    NOW()
FROM (SELECT @seq:=@seq+1 AS seq FROM sys_user, sys_user b LIMIT 50) t;

-- 5. 添加学生信息（50人）
INSERT INTO sys_student (student_id, name, gender, birth_date, admission_date, class_name, college_id, major_id, email, phone, status, user_id, create_time, update_time)
SELECT 
    CONCAT('2023', LPAD(t.seq, 4, '0')),
    u.real_name,
    IF(t.seq % 2 = 0, '男', '女'),
    DATE_SUB(NOW(), INTERVAL FLOOR(18 + (RAND() * 3)) YEAR),
    '2023-09-01',
    CONCAT('2023级', (t.seq % 10) + 1, '班'),
    FLOOR(1 + (RAND() * 5)),
    FLOOR(1 + (RAND() * 10)),
    u.email,
    u.phone,
    '在读',
    u.id,
    NOW(),
    NOW()
FROM (SELECT @seq:=@seq+1 AS seq FROM sys_user, sys_user b LIMIT 50) t
JOIN sys_user u ON u.user_name = CONCAT('student', LPAD(t.seq, 2, '0'));

-- 6. 添加课程数据（8门）
INSERT INTO sys_course (course_name, course_code, teacher_id, semester, credit, description, create_time, update_time)
VALUES 
('高等数学', 'MATH101', 1, '2023-2024学年第一学期', 4, '高等数学基础课程', NOW(), NOW()),
('大学英语', 'ENG101', 2, '2023-2024学年第一学期', 3, '大学英语基础课程', NOW(), NOW()),
('计算机基础', 'CS101', 3, '2023-2024学年第一学期', 3, '计算机基础课程', NOW(), NOW()),
('线性代数', 'MATH201', 4, '2023-2024学年第二学期', 3, '线性代数课程', NOW(), NOW()),
('数据结构', 'CS201', 5, '2023-2024学年第二学期', 4, '数据结构课程', NOW(), NOW()),
('操作系统', 'CS301', 6, '2024-2025学年第一学期', 4, '操作系统课程', NOW(), NOW()),
('数据库原理', 'CS302', 7, '2024-2025学年第一学期', 3, '数据库原理课程', NOW(), NOW()),
('计算机网络', 'CS303', 8, '2024-2025学年第二学期', 4, '计算机网络课程', NOW(), NOW());

-- 7. 添加选课记录（每个学生选8门课程，共50*8=400条）
INSERT INTO sys_selection (student_id, course_id, selection_time, status, create_time, update_time)
SELECT 
    s.id AS student_id,
    c.id AS course_id,
    NOW() AS selection_time,
    '已选' AS status,
    NOW() AS create_time,
    NOW() AS update_time
FROM sys_student s
CROSS JOIN sys_course c;

-- 8. 添加成绩记录（每个选课记录对应一条成绩，共400条）
INSERT INTO sys_grade (student_id, course_id, score, gpa, semester, credit_gpa, exam_datetime, create_time, update_time)
SELECT 
    s.student_id,
    s.course_id,
    -- 生成60-100之间的随机成绩
    FLOOR(60 + (RAND() * 40)),
    -- 计算GPA (60分=1.0, 每增加1分+0.1, 最高5.0)
    LEAST(5.0, FLOOR(60 + (RAND() * 40)) * 0.1 - 5.0),
    -- 使用课程的学期
    c.semester,
    -- 计算学分绩点 (GPA * 学分)
    LEAST(5.0, FLOOR(60 + (RAND() * 40)) * 0.1 - 5.0) * c.credit,
    -- 生成随机考试时间
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
    NOW(),
    NOW()
FROM sys_selection s
JOIN sys_course c ON s.course_id = c.id;

-- 验证数据生成结果
SELECT 
    (SELECT COUNT(*) FROM sys_student) AS student_count,
    (SELECT COUNT(*) FROM sys_user WHERE role = 'ROLE_TEACHER') AS teacher_count,
    (SELECT COUNT(*) FROM sys_course) AS course_count,
    (SELECT COUNT(*) FROM sys_grade) AS grade_count;
