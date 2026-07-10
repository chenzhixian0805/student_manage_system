-- Add 40 students from user_id 69 to 108 (total 100 students)
USE stusys;

-- Current student count: 60, need 40 more to reach 100

-- Batch 1: user_id 69-87, using valid major IDs 1-12
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(69, '2023062', 'Student062', 'Female', '2005-06-03', 'student062@example.com', '13800138062', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7),
(70, '2023063', 'Student063', 'Male', '2005-07-03', 'student063@example.com', '13800138063', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(71, '2023064', 'Student064', 'Female', '2005-08-03', 'student064@example.com', '13800138064', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(72, '2023065', 'Student065', 'Male', '2005-09-03', 'student065@example.com', '13800138065', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(73, '2023066', 'Student066', 'Female', '2005-10-03', 'student066@example.com', '13800138066', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(74, '2023067', 'Student067', 'Male', '2005-11-03', 'student067@example.com', '13800138067', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(75, '2023068', 'Student068', 'Female', '2005-12-03', 'student068@example.com', '13800138068', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(76, '2023069', 'Student069', 'Male', '2006-01-03', 'student069@example.com', '13800138069', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11),
(77, '2023070', 'Student070', 'Female', '2006-02-03', 'student070@example.com', '13800138070', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11),
(78, '2023071', 'Student071', 'Male', '2006-03-03', 'student071@example.com', '13800138071', 'ENG23-2', 'Enrolled', '2023-09-01', 6, 11),
(79, '2023072', 'Student072', 'Female', '2006-04-03', 'student072@example.com', '13800138072', 'ENG23-2', 'Enrolled', '2023-09-01', 6, 11),
(80, '2023073', 'Student073', 'Male', '2006-05-03', 'student073@example.com', '13800138073', 'JPN23-1', 'Enrolled', '2023-09-01', 6, 12),
(81, '2023074', 'Student074', 'Female', '2006-06-03', 'student074@example.com', '13800138074', 'JPN23-1', 'Enrolled', '2023-09-01', 6, 12),
(82, '2023075', 'Student075', 'Male', '2006-07-03', 'student075@example.com', '13800138075', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(83, '2023076', 'Student076', 'Female', '2006-08-03', 'student076@example.com', '13800138076', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(84, '2023077', 'Student077', 'Male', '2005-01-04', 'student077@example.com', '13800138077', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(85, '2023078', 'Student078', 'Female', '2005-02-04', 'student078@example.com', '13800138078', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(86, '2023079', 'Student079', 'Male', '2005-03-04', 'student079@example.com', '13800138079', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(87, '2023080', 'Student080', 'Female', '2005-04-04', 'student080@example.com', '13800138080', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2);

-- Batch 2: user_id 88-106, using valid major IDs 2-12
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(88, '2023081', 'Student081', 'Male', '2005-05-04', 'student081@example.com', '13800138081', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(89, '2023082', 'Student082', 'Female', '2005-06-04', 'student082@example.com', '13800138082', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(90, '2023083', 'Student083', 'Male', '2005-07-04', 'student083@example.com', '13800138083', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(91, '2023084', 'Student084', 'Female', '2005-08-04', 'student084@example.com', '13800138084', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(92, '2023085', 'Student085', 'Male', '2005-09-04', 'student085@example.com', '13800138085', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(93, '2023086', 'Student086', 'Female', '2005-10-04', 'student086@example.com', '13800138086', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(94, '2023087', 'Student087', 'Male', '2005-11-04', 'student087@example.com', '13800138087', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(95, '2023088', 'Student088', 'Female', '2005-12-04', 'student088@example.com', '13800138088', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(96, '2023089', 'Student089', 'Male', '2006-01-04', 'student089@example.com', '13800138089', 'EE23-2', 'Enrolled', '2023-09-01', 3, 6),
(97, '2023090', 'Student090', 'Female', '2006-02-04', 'student090@example.com', '13800138090', 'EE23-2', 'Enrolled', '2023-09-01', 3, 6),
(98, '2023091', 'Student091', 'Male', '2006-03-04', 'student091@example.com', '13800138091', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7),
(99, '2023092', 'Student092', 'Female', '2006-04-04', 'student092@example.com', '13800138092', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7),
(100, '2023093', 'Student093', 'Male', '2006-05-04', 'student093@example.com', '13800138093', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(101, '2023094', 'Student094', 'Female', '2006-06-04', 'student094@example.com', '13800138094', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(102, '2023095', 'Student095', 'Male', '2006-07-04', 'student095@example.com', '13800138095', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(103, '2023096', 'Student096', 'Female', '2006-08-04', 'student096@example.com', '13800138096', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(104, '2023097', 'Student097', 'Male', '2005-01-05', 'student097@example.com', '13800138097', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(105, '2023098', 'Student098', 'Female', '2005-02-05', 'student098@example.com', '13800138098', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(106, '2023099', 'Student099', 'Male', '2005-03-05', 'student099@example.com', '13800138099', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11),
(107, '2023100', 'Student100', 'Female', '2005-04-05', 'student100@example.com', '13800138100', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11);

-- Check final count
SELECT COUNT(*) FROM sys_student;