USE stusys;

-- 1. 修复课程表字段
UPDATE sys_course SET course_code = CONCAT('CS', LPAD(id, 3, '0')) WHERE course_code IS NULL OR course_code = '';
UPDATE sys_course SET credits = 3 WHERE credits IS NULL OR credits = 0;
UPDATE sys_course SET teacher_id = 2 WHERE teacher_id IS NULL OR teacher_id = 0;

-- 2. 修复学生表字段
UPDATE sys_student SET class_name = '计算机科学与技术2023级1班' WHERE class_name IS NULL OR class_name = '';
UPDATE sys_student SET status = '在读' WHERE status IS NULL OR status = '';

-- 3. 清理选课表
TRUNCATE TABLE sys_selection;

-- 4. 创建学生-课程选课关系
INSERT INTO sys_selection (student_id, course_id, selection_time, status, create_time, update_time)
SELECT 
    s.id AS student_id, 
    c.id AS course_id, 
    NOW() AS selection_time, 
    '已选' AS status, 
    NOW() AS create_time, 
    NOW() AS update_time
FROM sys_student s
CROSS JOIN sys_course c
WHERE c.id <= 5
ORDER BY s.id, c.id;

-- 5. 确保每个选课记录都有对应的成绩记录
INSERT INTO sys_grade (student_id, course_id, score, gpa, semester, credit_gpa, exam_datetime, create_time, update_time)
SELECT 
    s.student_id, 
    s.course_id, 
    FLOOR(60 + (RAND() * 40)),
    LEAST(5.0, FLOOR(60 + (RAND() * 40)) * 0.1 - 5.0),
    '2023-2024学年第一学期',
    LEAST(5.0, FLOOR(60 + (RAND() * 40)) * 0.1 - 5.0) * c.credits,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
    NOW(),
    NOW()
FROM sys_selection s
JOIN sys_course c ON s.course_id = c.id
WHERE NOT EXISTS (
    SELECT 1 FROM sys_grade g 
    WHERE g.student_id = s.student_id AND g.course_id = s.course_id
);

-- 6. 修复成绩表中的GPA计算
UPDATE sys_grade g
JOIN sys_course c ON g.course_id = c.id
SET 
    g.gpa = LEAST(5.0, GREATEST(0.0, g.score * 0.1 - 5.0)),
    g.credit_gpa = LEAST(5.0, GREATEST(0.0, g.score * 0.1 - 5.0)) * c.credits;

-- 7. 修复用户表
UPDATE sys_user SET 
    role = IF(role IS NULL OR role = '', 'ROLE_STUDENT', role),
    status = IF(status IS NULL OR status = '', 1, status);

-- 8. 输出修复结果
SELECT 
    (SELECT COUNT(*) FROM sys_course WHERE teacher_id IS NULL OR teacher_id = 0) AS courses_without_teacher,
    (SELECT COUNT(*) FROM sys_course WHERE credits IS NULL OR credits = 0) AS courses_without_credits,
    (SELECT COUNT(*) FROM sys_student WHERE class_name IS NULL OR class_name = '') AS students_without_class,
    (SELECT COUNT(*) FROM sys_selection) AS selection_count,
    (SELECT COUNT(*) FROM sys_grade) AS grade_count;