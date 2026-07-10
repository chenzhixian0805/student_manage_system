-- 填充用户表（教师和学生）
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES
('admin', '$2a$10$e4Y5V5Z6W7X8U9T0S1R2Q', 'ROLE_ADMIN', '管理员', 1, 'admin@example.com', '13800138000'),
('teacher1', '$2a$10$a1B2c3D4e5F6g7H8i9J0K', 'ROLE_TEACHER', '张明', 1, 'teacher1@example.com', '13800138001'),
('teacher2', '$2a$10$L1M2n3O4p5Q6r7S8t9U0V', 'ROLE_TEACHER', '李华', 1, 'teacher2@example.com', '13800138002'),
('teacher3', '$2a$10$W1X2y3Z4A5B6C7D8E9F0G', 'ROLE_TEACHER', '王芳', 1, 'teacher3@example.com', '13800138003'),
('student1', '$2a$10$H1I2J3K4L5M6N7O8P9Q0R', 'ROLE_STUDENT', '刘浩', 1, 'student1@example.com', '13800138004'),
('student2', '$2a$10$S1T2U3V4W5X6Y7Z8A9B0C', 'ROLE_STUDENT', '陈雨', 1, 'student2@example.com', '13800138005'),
('student3', '$2a$10$D1E2F3G4H5I6J7K8L9M0N', 'ROLE_STUDENT', '赵阳', 1, 'student3@example.com', '13800138006'),
('student4', '$2a$10$O1P2Q3R4S5T6U7V8W9X0Y', 'ROLE_STUDENT', '孙雪', 1, 'student4@example.com', '13800138007'),
('student5', '$2a$10$Z1A2B3C4D5E6F7G8H9I0J', 'ROLE_STUDENT', '周明', 1, 'student5@example.com', '13800138008'),
('student6', '$2a$10$K1L2M3N4O5P6Q7R8S9T0U', 'ROLE_STUDENT', '吴婷', 1, 'student6@example.com', '13800138009');

-- 填充学生表
INSERT INTO sys_student (student_id, name, gender, birth_date, email, phone, class_name, admission_date, status) VALUES
('2021001', '刘浩', '男', '2003-01-01', 'student1@example.com', '13800138004', '计科2021-1班', '2021-09-01', '在读'),
('2021002', '陈雨', '女', '2003-02-02', 'student2@example.com', '13800138005', '软件2021-2班', '2021-09-01', '在读'),
('2021003', '赵阳', '男', '2003-03-03', 'student3@example.com', '13800138006', '电信2021-1班', '2021-09-01', '在读'),
('2021004', '孙雪', '女', '2003-04-04', 'student4@example.com', '13800138007', '机制2021-1班', '2021-09-01', '在读'),
('2021005', '周明', '男', '2003-05-05', 'student5@example.com', '13800138008', '财管2021-1班', '2021-09-01', '在读'),
('2021006', '吴婷', '女', '2003-06-06', 'student6@example.com', '13800138009', '英语2021-1班', '2021-09-01', '在读');

-- 填充课程表
INSERT INTO sys_course (course_code, course_name, credits, teacher_id, semester, create_time, update_time, description) VALUES
('CS101', '计算机导论', 3, 2, '2023-2024学年第一学期', NOW(), NOW(), '计算机科学的入门课程'),
('CS102', '高等数学', 4, 3, '2023-2024学年第一学期', NOW(), NOW(), '高等数学基础课程'),
('CS201', '数据结构', 4, 2, '2023-2024学年第二学期', NOW(), NOW(), '数据结构与算法'),
('CS202', '操作系统', 4, 4, '2023-2024学年第二学期', NOW(), NOW(), '操作系统原理与实现'),
('EE101', '电路分析', 4, 3, '2023-2024学年第一学期', NOW(), NOW(), '电路分析基础'),
('ME101', '机械原理', 4, 4, '2023-2024学年第一学期', NOW(), NOW(), '机械原理与设计');

-- 填充选课表
INSERT INTO sys_selection (student_id, course_id, selection_time, status, create_time, update_time) VALUES
(1, 1, '2023-08-20 10:00:00', 'Selected', '2023-08-20 10:00:00', '2023-08-20 10:00:00'),
(1, 2, '2023-08-20 10:05:00', 'Selected', '2023-08-20 10:05:00', '2023-08-20 10:05:00'),
(2, 1, '2023-08-20 10:10:00', 'Selected', '2023-08-20 10:10:00', '2023-08-20 10:10:00'),
(2, 3, '2023-08-20 10:15:00', 'Selected', '2023-08-20 10:15:00', '2023-08-20 10:15:00'),
(3, 2, '2023-08-20 10:20:00', 'Selected', '2023-08-20 10:20:00', '2023-08-20 10:20:00'),
(3, 5, '2023-08-20 10:25:00', 'Selected', '2023-08-20 10:25:00', '2023-08-20 10:25:00'),
(4, 6, '2023-08-20 10:30:00', 'Selected', '2023-08-20 10:30:00', '2023-08-20 10:30:00'),
(5, 1, '2023-08-20 10:35:00', 'Selected', '2023-08-20 10:35:00', '2023-08-20 10:35:00'),
(5, 4, '2023-08-20 10:40:00', 'Selected', '2023-08-20 10:40:00', '2023-08-20 10:40:00'),
(6, 2, '2023-08-20 10:45:00', 'Selected', '2023-08-20 10:45:00', '2023-08-20 10:45:00');

-- 填充成绩表
INSERT INTO sys_grade (student_id, course_id, gpa, score, semester, create_time, update_time) VALUES
(1, 1, 4.0, 95, '2023-2024学年第一学期', NOW(), NOW()),
(1, 2, 3.7, 92, '2023-2024学年第一学期', NOW(), NOW()),
(2, 1, 3.3, 88, '2023-2024学年第一学期', NOW(), NOW()),
(2, 3, 3.0, 85, '2023-2024学年第二学期', NOW(), NOW()),
(3, 2, 3.7, 91, '2023-2024学年第一学期', NOW(), NOW()),
(3, 5, 3.3, 87, '2023-2024学年第一学期', NOW(), NOW()),
(4, 6, 3.0, 84, '2023-2024学年第一学期', NOW(), NOW()),
(5, 1, 4.0, 96, '2023-2024学年第一学期', NOW(), NOW()),
(5, 4, 3.7, 93, '2023-2024学年第二学期', NOW(), NOW()),
(6, 2, 3.3, 89, '2023-2024学年第一学期', NOW(), NOW());
