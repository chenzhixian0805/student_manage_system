-- 简单版本的学生添加脚本
USE stusys;

-- 只添加一条学生记录测试
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES
(217, '2023017', 'Test Student', 'Male', '2005-01-15', 'test@example.com', '13800138001', 'CS23-1', 'Enrolled', '2023-09-01', 1, 1);

-- 检查结果
SELECT COUNT(*) FROM sys_student;