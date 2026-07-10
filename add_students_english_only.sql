-- English only version, no Chinese characters
USE stusys;

-- Add student records for existing users
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(5, '2023001', 'Liu Hao', 'Male', '2005-01-15', 'student1@example.com', '13800138001', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(6, '2023002', 'Chen Yu', 'Female', '2005-02-20', 'student2@example.com', '13800138002', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1),
(7, '2023003', 'Zhao Yang', 'Male', '2005-03-10', 'student3@example.com', '13800138003', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(8, '2023004', 'Sun Xue', 'Female', '2005-04-05', 'student4@example.com', '13800138004', 'CS23-2', 'Enrolled', '2023-09-01', 1, 1),
(9, '2023005', 'Zhou Ming', 'Male', '2005-05-18', 'student5@example.com', '13800138005', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(10, '2023006', 'Wu Ting', 'Female', '2005-06-22', 'student6@example.com', '13800138006', 'SE23-1', 'Enrolled', '2023-09-01', 1, 2),
(11, '2023007', 'Zhang Ming', 'Male', '2005-07-15', 'student7@example.com', '13800138007', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(12, '2023008', 'Wang Hong', 'Female', '2005-08-30', 'student8@example.com', '13800138008', 'SE23-2', 'Enrolled', '2023-09-01', 1, 2),
(13, '2023009', 'Li Hua', 'Male', '2005-09-12', 'student9@example.com', '13800138009', 'NE23-1', 'Enrolled', '2023-09-01', 1, 3),
(14, '2023010', 'Zhao Qiang', 'Male', '2005-10-25', 'student10@example.com', '13800138010', 'NE23-1', 'Enrolled', '2023-09-01', 1, 3),
(15, '2023011', 'Sun Jing', 'Female', '2005-11-18', 'student11@example.com', '13800138011', 'NE23-2', 'Enrolled', '2023-09-01', 1, 3),
(16, '2023012', 'Zhou Ming', 'Male', '2005-12-05', 'student12@example.com', '13800138012', 'NE23-2', 'Enrolled', '2023-09-01', 1, 3);

-- Check result
SELECT COUNT(*) FROM sys_student;