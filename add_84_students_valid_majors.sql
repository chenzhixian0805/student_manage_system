-- Add 84 students with valid major IDs (1-12)
USE stusys;

-- Current student count: 16, need 84 more to reach 100

-- Batch 1: user_id 21-29, using valid major IDs 1-6
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(21, '2023017', 'Student017', 'Male', '2005-01-01', 'student017@example.com', '13800138017', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(22, '2023018', 'Student018', 'Female', '2005-02-01', 'student018@example.com', '13800138018', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(23, '2023019', 'Student019', 'Male', '2005-03-01', 'student019@example.com', '13800138019', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(24, '2023020', 'Student020', 'Female', '2005-04-01', 'student020@example.com', '13800138020', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(25, '2023021', 'Student021', 'Male', '2005-05-01', 'student021@example.com', '13800138021', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(26, '2023022', 'Student022', 'Female', '2005-06-01', 'student022@example.com', '13800138022', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(27, '2023023', 'Student023', 'Male', '2005-07-01', 'student023@example.com', '13800138023', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(28, '2023024', 'Student024', 'Female', '2005-08-01', 'student024@example.com', '13800138024', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(29, '2023025', 'Student025', 'Male', '2005-09-01', 'student025@example.com', '13800138025', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3);

-- Batch 2: user_id 33-41, using valid major IDs 4-9
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(33, '2023026', 'Student026', 'Female', '2005-10-01', 'student026@example.com', '13800138026', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(34, '2023027', 'Student027', 'Male', '2005-11-01', 'student027@example.com', '13800138027', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(35, '2023028', 'Student028', 'Female', '2005-12-01', 'student028@example.com', '13800138028', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(36, '2023029', 'Student029', 'Male', '2006-01-01', 'student029@example.com', '13800138029', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(37, '2023030', 'Student030', 'Female', '2006-02-01', 'student030@example.com', '13800138030', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(38, '2023031', 'Student031', 'Male', '2006-03-01', 'student031@example.com', '13800138031', 'EE23-2', 'Enrolled', '2023-09-01', 3, 6),
(39, '2023032', 'Student032', 'Female', '2006-04-01', 'student032@example.com', '13800138032', 'EE23-2', 'Enrolled', '2023-09-01', 3, 6),
(40, '2023033', 'Student033', 'Male', '2006-05-01', 'student033@example.com', '13800138033', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7),
(41, '2023034', 'Student034', 'Female', '2006-06-01', 'student034@example.com', '13800138034', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7);

-- Batch 3: user_id 42-50, using valid major IDs 8-12
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(42, '2023035', 'Student035', 'Male', '2006-07-01', 'student035@example.com', '13800138035', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(43, '2023036', 'Student036', 'Female', '2006-08-01', 'student036@example.com', '13800138036', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(44, '2023037', 'Student037', 'Male', '2005-01-02', 'student037@example.com', '13800138037', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(45, '2023038', 'Student038', 'Female', '2005-02-02', 'student038@example.com', '13800138038', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(46, '2023039', 'Student039', 'Male', '2005-03-02', 'student039@example.com', '13800138039', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(47, '2023040', 'Student040', 'Female', '2005-04-02', 'student040@example.com', '13800138040', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(48, '2023041', 'Student041', 'Male', '2005-05-02', 'student041@example.com', '13800138041', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11),
(49, '2023042', 'Student042', 'Female', '2005-06-02', 'student042@example.com', '13800138042', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11),
(50, '2023043', 'Student043', 'Male', '2005-07-02', 'student043@example.com', '13800138043', 'JPN23-1', 'Enrolled', '2023-09-01', 6, 12);

-- Batch 4: user_id 51-59, using valid major IDs 1-6
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(51, '2023044', 'Student044', 'Female', '2005-08-02', 'student044@example.com', '13800138044', 'JPN23-1', 'Enrolled', '2023-09-01', 6, 12),
(52, '2023045', 'Student045', 'Male', '2005-09-02', 'student045@example.com', '13800138045', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(53, '2023046', 'Student046', 'Female', '2005-10-02', 'student046@example.com', '13800138046', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(54, '2023047', 'Student047', 'Male', '2005-11-02', 'student047@example.com', '13800138047', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(55, '2023048', 'Student048', 'Female', '2005-12-02', 'student048@example.com', '13800138048', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(56, '2023049', 'Student049', 'Male', '2006-01-02', 'student049@example.com', '13800138049', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(57, '2023050', 'Student050', 'Female', '2006-02-02', 'student050@example.com', '13800138050', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(58, '2023051', 'Student051', 'Male', '2006-03-02', 'student051@example.com', '13800138051', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(59, '2023052', 'Student052', 'Female', '2006-04-02', 'student052@example.com', '13800138052', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2);

-- Batch 5: user_id 60-68, using valid major IDs 3-8
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(60, '2023053', 'Student053', 'Male', '2006-05-02', 'student053@example.com', '13800138053', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(61, '2023054', 'Student054', 'Female', '2006-06-02', 'student054@example.com', '13800138054', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(62, '2023055', 'Student055', 'Male', '2006-07-02', 'student055@example.com', '13800138055', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(63, '2023056', 'Student056', 'Female', '2006-08-02', 'student056@example.com', '13800138056', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(64, '2023057', 'Student057', 'Male', '2005-01-03', 'student057@example.com', '13800138057', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(65, '2023058', 'Student058', 'Female', '2005-02-03', 'student058@example.com', '13800138058', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(66, '2023059', 'Student059', 'Male', '2005-03-03', 'student059@example.com', '13800138059', 'EE23-2', 'Enrolled', '2023-09-01', 3, 6),
(67, '2023060', 'Student060', 'Female', '2005-04-03', 'student060@example.com', '13800138060', 'EE23-2', 'Enrolled', '2023-09-01', 3, 6),
(68, '2023061', 'Student061', 'Male', '2005-05-03', 'student061@example.com', '13800138061', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7);

-- Batch 6: user_id 69-77, using valid major IDs 8-12
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(69, '2023062', 'Student062', 'Female', '2005-06-03', 'student062@example.com', '13800138062', 'ME23-1', 'Enrolled', '2023-09-01', 4, 7),
(70, '2023063', 'Student063', 'Male', '2005-07-03', 'student063@example.com', '13800138063', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(71, '2023064', 'Student064', 'Female', '2005-08-03', 'student064@example.com', '13800138064', 'ME23-2', 'Enrolled', '2023-09-01', 4, 8),
(72, '2023065', 'Student065', 'Male', '2005-09-03', 'student065@example.com', '13800138065', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(73, '2023066', 'Student066', 'Female', '2005-10-03', 'student066@example.com', '13800138066', 'FM23-1', 'Enrolled', '2023-09-01', 5, 9),
(74, '2023067', 'Student067', 'Male', '2005-11-03', 'student067@example.com', '13800138067', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(75, '2023068', 'Student068', 'Female', '2005-12-03', 'student068@example.com', '13800138068', 'FM23-2', 'Enrolled', '2023-09-01', 5, 10),
(76, '2023069', 'Student069', 'Male', '2006-01-03', 'student069@example.com', '13800138069', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11),
(77, '2023070', 'Student070', 'Female', '2006-02-03', 'student070@example.com', '13800138070', 'ENG23-1', 'Enrolled', '2023-09-01', 6, 11);

-- Batch 7: user_id 78-86, using valid major IDs 1-6
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(78, '2023071', 'Student071', 'Male', '2006-03-03', 'student071@example.com', '13800138071', 'ENG23-2', 'Enrolled', '2023-09-01', 6, 11),
(79, '2023072', 'Student072', 'Female', '2006-04-03', 'student072@example.com', '13800138072', 'ENG23-2', 'Enrolled', '2023-09-01', 6, 11),
(80, '2023073', 'Student073', 'Male', '2006-05-03', 'student073@example.com', '13800138073', 'JPN23-1', 'Enrolled', '2023-09-01', 6, 12),
(81, '2023074', 'Student074', 'Female', '2006-06-03', 'student074@example.com', '13800138074', 'JPN23-1', 'Enrolled', '2023-09-01', 6, 12),
(82, '2023075', 'Student075', 'Male', '2006-07-03', 'student075@example.com', '13800138075', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(83, '2023076', 'Student076', 'Female', '2006-08-03', 'student076@example.com', '13800138076', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(84, '2023077', 'Student077', 'Male', '2005-01-04', 'student077@example.com', '13800138077', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(85, '2023078', 'Student078', 'Female', '2005-02-04', 'student078@example.com', '13800138078', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(86, '2023079', 'Student079', 'Male', '2005-03-04', 'student079@example.com', '13800138079', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2);

-- Batch 8: user_id 87-95, using valid major IDs 2-7
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(87, '2023080', 'Student080', 'Female', '2005-04-04', 'student080@example.com', '13800138080', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(88, '2023081', 'Student081', 'Male', '2005-05-04', 'student081@example.com', '13800138081', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(89, '2023082', 'Student082', 'Female', '2005-06-04', 'student082@example.com', '13800138082', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(90, '2023083', 'Student083', 'Male', '2005-07-04', 'student083@example.com', '13800138083', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(91, '2023084', 'Student084', 'Female', '2005-08-04', 'student084@example.com', '13800138084', 'Math23-1', 'Enrolled', '2023-09-01', 2, 3),
(92, '2023085', 'Student085', 'Male', '2005-09-04', 'student085@example.com', '13800138085', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(93, '2023086', 'Student086', 'Female', '2005-10-04', 'student086@example.com', '13800138086', 'Math23-2', 'Enrolled', '2023-09-01', 2, 4),
(94, '2023087', 'Student087', 'Male', '2005-11-04', 'student087@example.com', '13800138087', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5),
(95, '2023088', 'Student088', 'Female', '2005-12-04', 'student088@example.com', '13800138088', 'EE23-1', 'Enrolled', '2023-09-01', 3, 5);

-- Batch 9: user_id 96-107, using valid major IDs 5-12
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
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