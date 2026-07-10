USE stusys;

-- 2. Add majors if not exists
INSERT IGNORE INTO sys_major (major_name, college_id, create_time, description, update_time)
VALUES 
('Computer Science', 1, NOW(), 'Computer Science Major', NOW()),
('Software Engineering', 1, NOW(), 'Software Engineering Major', NOW()),
('Electronic Information Engineering', 2, NOW(), 'Electronic Information Engineering Major', NOW()),
('Communication Engineering', 2, NOW(), 'Communication Engineering Major', NOW()),
('Business Administration', 3, NOW(), 'Business Administration Major', NOW()),
('Accounting', 3, NOW(), 'Accounting Major', NOW()),
('English', 4, NOW(), 'English Major', NOW()),
('Japanese', 4, NOW(), 'Japanese Major', NOW()),
('Mathematics', 5, NOW(), 'Mathematics Major', NOW()),
('Statistics', 5, NOW(), 'Statistics Major', NOW());

-- 3. Add 10 teachers if not exists
INSERT IGNORE INTO sys_user (user_name, password, real_name, role, status, email, phone, employee_id, create_time, update_time)
VALUES 
('teacher01', 'password123', 'Teacher Zhang', 'ROLE_TEACHER', 1, 'teacher01@example.com', '13800000001', 'T001', NOW(), NOW()),
('teacher02', 'password123', 'Teacher Li', 'ROLE_TEACHER', 1, 'teacher02@example.com', '13800000002', 'T002', NOW(), NOW()),
('teacher03', 'password123', 'Teacher Wang', 'ROLE_TEACHER', 1, 'teacher03@example.com', '13800000003', 'T003', NOW(), NOW()),
('teacher04', 'password123', 'Teacher Liu', 'ROLE_TEACHER', 1, 'teacher04@example.com', '13800000004', 'T004', NOW(), NOW()),
('teacher05', 'password123', 'Teacher Chen', 'ROLE_TEACHER', 1, 'teacher05@example.com', '13800000005', 'T005', NOW(), NOW()),
('teacher06', 'password123', 'Teacher Yang', 'ROLE_TEACHER', 1, 'teacher06@example.com', '13800000006', 'T006', NOW(), NOW()),
('teacher07', 'password123', 'Teacher Zhao', 'ROLE_TEACHER', 1, 'teacher07@example.com', '13800000007', 'T007', NOW(), NOW()),
('teacher08', 'password123', 'Teacher Zhou', 'ROLE_TEACHER', 1, 'teacher08@example.com', '13800000008', 'T008', NOW(), NOW()),
('teacher09', 'password123', 'Teacher Wu', 'ROLE_TEACHER', 1, 'teacher09@example.com', '13800000009', 'T009', NOW(), NOW()),
('teacher10', 'password123', 'Teacher Zheng', 'ROLE_TEACHER', 1, 'teacher10@example.com', '13800000010', 'T010', NOW(), NOW());

-- 4. Add 50 students users if not exists
INSERT IGNORE INTO sys_user (user_name, password, real_name, role, status, email, phone, employee_id, create_time, update_time)
VALUES 
('student01', 'password123', 'Student 1', 'ROLE_STUDENT', 1, 'student1@example.com', '13900000001', NULL, NOW(), NOW()),
('student02', 'password123', 'Student 2', 'ROLE_STUDENT', 1, 'student2@example.com', '13900000002', NULL, NOW(), NOW()),
('student03', 'password123', 'Student 3', 'ROLE_STUDENT', 1, 'student3@example.com', '13900000003', NULL, NOW(), NOW()),
('student04', 'password123', 'Student 4', 'ROLE_STUDENT', 1, 'student4@example.com', '13900000004', NULL, NOW(), NOW()),
('student05', 'password123', 'Student 5', 'ROLE_STUDENT', 1, 'student5@example.com', '13900000005', NULL, NOW(), NOW()),
('student06', 'password123', 'Student 6', 'ROLE_STUDENT', 1, 'student6@example.com', '13900000006', NULL, NOW(), NOW()),
('student07', 'password123', 'Student 7', 'ROLE_STUDENT', 1, 'student7@example.com', '13900000007', NULL, NOW(), NOW()),
('student08', 'password123', 'Student 8', 'ROLE_STUDENT', 1, 'student8@example.com', '13900000008', NULL, NOW(), NOW()),
('student09', 'password123', 'Student 9', 'ROLE_STUDENT', 1, 'student9@example.com', '13900000009', NULL, NOW(), NOW()),
('student10', 'password123', 'Student 10', 'ROLE_STUDENT', 1, 'student10@example.com', '13900000010', NULL, NOW(), NOW()),
('student11', 'password123', 'Student 11', 'ROLE_STUDENT', 1, 'student11@example.com', '13900000011', NULL, NOW(), NOW()),
('student12', 'password123', 'Student 12', 'ROLE_STUDENT', 1, 'student12@example.com', '13900000012', NULL, NOW(), NOW()),
('student13', 'password123', 'Student 13', 'ROLE_STUDENT', 1, 'student13@example.com', '13900000013', NULL, NOW(), NOW()),
('student14', 'password123', 'Student 14', 'ROLE_STUDENT', 1, 'student14@example.com', '13900000014', NULL, NOW(), NOW()),
('student15', 'password123', 'Student 15', 'ROLE_STUDENT', 1, 'student15@example.com', '13900000015', NULL, NOW(), NOW()),
('student16', 'password123', 'Student 16', 'ROLE_STUDENT', 1, 'student16@example.com', '13900000016', NULL, NOW(), NOW()),
('student17', 'password123', 'Student 17', 'ROLE_STUDENT', 1, 'student17@example.com', '13900000017', NULL, NOW(), NOW()),
('student18', 'password123', 'Student 18', 'ROLE_STUDENT', 1, 'student18@example.com', '13900000018', NULL, NOW(), NOW()),
('student19', 'password123', 'Student 19', 'ROLE_STUDENT', 1, 'student19@example.com', '13900000019', NULL, NOW(), NOW()),
('student20', 'password123', 'Student 20', 'ROLE_STUDENT', 1, 'student20@example.com', '13900000020', NULL, NOW(), NOW()),
('student21', 'password123', 'Student 21', 'ROLE_STUDENT', 1, 'student21@example.com', '13900000021', NULL, NOW(), NOW()),
('student22', 'password123', 'Student 22', 'ROLE_STUDENT', 1, 'student22@example.com', '13900000022', NULL, NOW(), NOW()),
('student23', 'password123', 'Student 23', 'ROLE_STUDENT', 1, 'student23@example.com', '13900000023', NULL, NOW(), NOW()),
('student24', 'password123', 'Student 24', 'ROLE_STUDENT', 1, 'student24@example.com', '13900000024', NULL, NOW(), NOW()),
('student25', 'password123', 'Student 25', 'ROLE_STUDENT', 1, 'student25@example.com', '13900000025', NULL, NOW(), NOW()),
('student26', 'password123', 'Student 26', 'ROLE_STUDENT', 1, 'student26@example.com', '13900000026', NULL, NOW(), NOW()),
('student27', 'password123', 'Student 27', 'ROLE_STUDENT', 1, 'student27@example.com', '13900000027', NULL, NOW(), NOW()),
('student28', 'password123', 'Student 28', 'ROLE_STUDENT', 1, 'student28@example.com', '13900000028', NULL, NOW(), NOW()),
('student29', 'password123', 'Student 29', 'ROLE_STUDENT', 1, 'student29@example.com', '13900000029', NULL, NOW(), NOW()),
('student30', 'password123', 'Student 30', 'ROLE_STUDENT', 1, 'student30@example.com', '13900000030', NULL, NOW(), NOW()),
('student31', 'password123', 'Student 31', 'ROLE_STUDENT', 1, 'student31@example.com', '13900000031', NULL, NOW(), NOW()),
('student32', 'password123', 'Student 32', 'ROLE_STUDENT', 1, 'student32@example.com', '13900000032', NULL, NOW(), NOW()),
('student33', 'password123', 'Student 33', 'ROLE_STUDENT', 1, 'student33@example.com', '13900000033', NULL, NOW(), NOW()),
('student34', 'password123', 'Student 34', 'ROLE_STUDENT', 1, 'student34@example.com', '13900000034', NULL, NOW(), NOW()),
('student35', 'password123', 'Student 35', 'ROLE_STUDENT', 1, 'student35@example.com', '13900000035', NULL, NOW(), NOW()),
('student36', 'password123', 'Student 36', 'ROLE_STUDENT', 1, 'student36@example.com', '13900000036', NULL, NOW(), NOW()),
('student37', 'password123', 'Student 37', 'ROLE_STUDENT', 1, 'student37@example.com', '13900000037', NULL, NOW(), NOW()),
('student38', 'password123', 'Student 38', 'ROLE_STUDENT', 1, 'student38@example.com', '13900000038', NULL, NOW(), NOW()),
('student39', 'password123', 'Student 39', 'ROLE_STUDENT', 1, 'student39@example.com', '13900000039', NULL, NOW(), NOW()),
('student40', 'password123', 'Student 40', 'ROLE_STUDENT', 1, 'student40@example.com', '13900000040', NULL, NOW(), NOW()),
('student41', 'password123', 'Student 41', 'ROLE_STUDENT', 1, 'student41@example.com', '13900000041', NULL, NOW(), NOW()),
('student42', 'password123', 'Student 42', 'ROLE_STUDENT', 1, 'student42@example.com', '13900000042', NULL, NOW(), NOW()),
('student43', 'password123', 'Student 43', 'ROLE_STUDENT', 1, 'student43@example.com', '13900000043', NULL, NOW(), NOW()),
('student44', 'password123', 'Student 44', 'ROLE_STUDENT', 1, 'student44@example.com', '13900000044', NULL, NOW(), NOW()),
('student45', 'password123', 'Student 45', 'ROLE_STUDENT', 1, 'student45@example.com', '13900000045', NULL, NOW(), NOW()),
('student46', 'password123', 'Student 46', 'ROLE_STUDENT', 1, 'student46@example.com', '13900000046', NULL, NOW(), NOW()),
('student47', 'password123', 'Student 47', 'ROLE_STUDENT', 1, 'student47@example.com', '13900000047', NULL, NOW(), NOW()),
('student48', 'password123', 'Student 48', 'ROLE_STUDENT', 1, 'student48@example.com', '13900000048', NULL, NOW(), NOW()),
('student49', 'password123', 'Student 49', 'ROLE_STUDENT', 1, 'student49@example.com', '13900000049', NULL, NOW(), NOW()),
('student50', 'password123', 'Student 50', 'ROLE_STUDENT', 1, 'student50@example.com', '13900000050', NULL, NOW(), NOW());

-- 5. Add 8 courses if not exists
INSERT IGNORE INTO sys_course (course_name, course_code, teacher_id, semester, credit, description, create_time, update_time)
VALUES 
('Advanced Mathematics', 'MATH101', 1, '2023-2024 Semester 1', 4, 'Advanced Mathematics Course', NOW(), NOW()),
('College English', 'ENG101', 2, '2023-2024 Semester 1', 3, 'College English Course', NOW(), NOW()),
('Computer Fundamentals', 'CS101', 3, '2023-2024 Semester 1', 3, 'Computer Fundamentals Course', NOW(), NOW()),
('Linear Algebra', 'MATH201', 4, '2023-2024 Semester 2', 3, 'Linear Algebra Course', NOW(), NOW()),
('Data Structures', 'CS201', 5, '2023-2024 Semester 2', 4, 'Data Structures Course', NOW(), NOW()),
('Operating Systems', 'CS301', 6, '2024-2025 Semester 1', 4, 'Operating Systems Course', NOW(), NOW()),
('Database Principles', 'CS302', 7, '2024-2025 Semester 1', 3, 'Database Principles Course', NOW(), NOW()),
('Computer Networks', 'CS303', 8, '2024-2025 Semester 2', 4, 'Computer Networks Course', NOW(), NOW());

-- 6. Add student info for 50 students
INSERT INTO sys_student (student_id, name, gender, birth_date, admission_date, class_name, college_id, major_id, email, phone, status, user_id, create_time, update_time)
SELECT 
    CONCAT('2023', LPAD(seq, 4, '0')),
    u.real_name,
    IF(seq % 2 = 0, 'Male', 'Female'),
    DATE_SUB(NOW(), INTERVAL FLOOR(18 + (RAND() * 3)) YEAR),
    '2023-09-01',
    CONCAT('Class ', (seq % 10) + 1, ', 2023'),
    FLOOR(1 + (RAND() * 5)),
    FLOOR(1 + (RAND() * 10)),
    u.email,
    u.phone,
    'Enrolled',
    u.id,
    NOW(),
    NOW()
FROM (SELECT @seq:=@seq+1 AS seq FROM sys_user LIMIT 50) t
JOIN sys_user u ON u.user_name = CONCAT('student', LPAD(t.seq, 2, '0'))
WHERE NOT EXISTS (SELECT 1 FROM sys_student WHERE user_id = u.id);

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
