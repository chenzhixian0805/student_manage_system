USE stusys;

-- Initialize sequence variable
SET @seq:=0;

-- 6. Add student info for 50 students
INSERT INTO sys_student (student_id, name, gender, birth_date, admission_date, class_name, college_id, major_id, email, phone, status, user_id, create_time, update_time)
SELECT 
    CONCAT('2023', LPAD(@seq:=@seq+1, 4, '0')),
    u.real_name,
    IF(@seq % 2 = 0, 'Male', 'Female'),
    DATE_SUB(NOW(), INTERVAL FLOOR(18 + (RAND() * 3)) YEAR),
    '2023-09-01',
    CONCAT('Class ', (@seq % 10) + 1, ', 2023'),
    FLOOR(1 + (RAND() * 5)),
    FLOOR(1 + (RAND() * 10)),
    u.email,
    u.phone,
    'Enrolled',
    u.id,
    NOW(),
    NOW()
FROM sys_user u 
WHERE u.role = 'ROLE_STUDENT'
AND NOT EXISTS (SELECT 1 FROM sys_student WHERE user_id = u.id);

-- 7. Add selection records (50 students * 8 courses = 400 records)
INSERT INTO sys_selection (student_id, course_id, selection_time, status, create_time, update_time)
SELECT 
    s.id AS student_id,
    c.id AS course_id,
    NOW() AS selection_time,
    'Selected' AS status,
    NOW() AS create_time,
    NOW() AS update_time
FROM sys_student s
CROSS JOIN sys_course c
WHERE NOT EXISTS (SELECT 1 FROM sys_selection WHERE student_id = s.id AND course_id = c.id);

-- 8. Add grade records (400 records)
INSERT INTO sys_grade (student_id, course_id, score, gpa, semester, credit_gpa, exam_datetime, create_time, update_time)
SELECT 
    s.student_id,
    s.course_id,
    FLOOR(60 + (RAND() * 40)),
    LEAST(5.0, FLOOR(60 + (RAND() * 40)) * 0.1 - 5.0),
    c.semester,
    LEAST(5.0, FLOOR(60 + (RAND() * 40)) * 0.1 - 5.0) * c.credit,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
    NOW(),
    NOW()
FROM sys_selection s
JOIN sys_course c ON s.course_id = c.id
WHERE NOT EXISTS (SELECT 1 FROM sys_grade WHERE student_id = s.student_id AND course_id = s.course_id);
