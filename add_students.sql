USE stusys;

-- Add 5 students at a time
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (35, '2023019', 'Student019', 'Male', 'student019@example.com', '13800138019', 'Computer Science 2023-1班', '在读', 1, 1);
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (36, '2023020', 'Student020', 'Male', 'student020@example.com', '13800138020', 'Computer Science 2023-1班', '在读', 1, 1);
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (37, '2023021', 'Student021', 'Male', 'student021@example.com', '13800138021', 'Computer Science 2023-1班', '在读', 1, 1);
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (38, '2023022', 'Student022', 'Male', 'student022@example.com', '13800138022', 'Computer Science 2023-1班', '在读', 1, 1);
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (39, '2023023', 'Student023', 'Male', 'student023@example.com', '13800138023', 'Computer Science 2023-1班', '在读', 1, 1);

SELECT COUNT(*) FROM sys_student;