-- Add remaining student records from user_id 21 onwards
USE stusys;

-- Batch 1: user_id 21-40
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(21, '2023017', 'Student017', 'Male', '2005-01-01', 'student017@example.com', '13800138017', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(22, '2023018', 'Student018', 'Female', '2005-02-01', 'student018@example.com', '13800138018', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(23, '2023019', 'Student019', 'Male', '2005-03-01', 'student019@example.com', '13800138019', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(24, '2023020', 'Student020', 'Female', '2005-04-01', 'student020@example.com', '13800138020', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(25, '2023021', 'Student021', 'Male', '2005-05-01', 'student021@example.com', '13800138021', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(26, '2023022', 'Student022', 'Female', '2005-06-01', 'student022@example.com', '13800138022', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(27, '2023023', 'Student023', 'Male', '2005-07-01', 'student023@example.com', '13800138023', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(28, '2023024', 'Student024', 'Female', '2005-08-01', 'student024@example.com', '13800138024', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(29, '2023025', 'Student025', 'Male', '2005-09-01', 'student025@example.com', '13800138025', 'NE23-1', 'Enrolled', '2023-09-01', 1, 3),
(30, '2023026', 'Student026', 'Female', '2005-10-01', 'student026@example.com', '13800138026', 'NE23-1', 'Enrolled', '2023-09-01', 1, 3),
(31, '2023027', 'Student027', 'Male', '2005-11-01', 'student027@example.com', '13800138027', 'NE23-2', 'Enrolled', '2023-09-01', 1, 3),
(32, '2023028', 'Student028', 'Female', '2005-12-01', 'student028@example.com', '13800138028', 'NE23-2', 'Enrolled', '2023-09-01', 1, 3),
(33, '2023029', 'Student029', 'Male', '2006-01-01', 'student029@example.com', '13800138029', 'EE23-1', 'Enrolled', '2023-09-01', 2, 4),
(34, '2023030', 'Student030', 'Female', '2006-02-01', 'student030@example.com', '13800138030', 'EE23-1', 'Enrolled', '2023-09-01', 2, 4),
(35, '2023031', 'Student031', 'Male', '2006-03-01', 'student031@example.com', '13800138031', 'EE23-2', 'Enrolled', '2023-09-01', 2, 4),
(36, '2023032', 'Student032', 'Female', '2006-04-01', 'student032@example.com', '13800138032', 'EE23-2', 'Enrolled', '2023-09-01', 2, 4),
(37, '2023033', 'Student033', 'Male', '2006-05-01', 'student033@example.com', '13800138033', 'CE23-1', 'Enrolled', '2023-09-01', 2, 5),
(38, '2023034', 'Student034', 'Female', '2006-06-01', 'student034@example.com', '13800138034', 'CE23-1', 'Enrolled', '2023-09-01', 2, 5),
(39, '2023035', 'Student035', 'Male', '2006-07-01', 'student035@example.com', '13800138035', 'CE23-2', 'Enrolled', '2023-09-01', 2, 5),
(40, '2023036', 'Student036', 'Female', '2006-08-01', 'student036@example.com', '13800138036', 'CE23-2', 'Enrolled', '2023-09-01', 2, 5);

-- Check current count
SELECT COUNT(*) FROM sys_student;