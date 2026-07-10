USE stusys;

-- Test simple insert
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (17, '2023001', 'Student001', 'Male', 'student001@example.com', '13800138001', 'Computer Science 2023-1班', 'Enrolled', 1, 1);

SELECT COUNT(*) FROM sys_student;