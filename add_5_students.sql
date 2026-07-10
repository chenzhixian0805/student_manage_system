USE stusys;

-- 先添加用户记录
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student017', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'student', '王浩然', 1, 'wanghaoran@example.com', '13800138017');

INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student018', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'student', '李雨桐', 1, 'liyutong@example.com', '13800138018');

INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student019', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'student', '张博宇', 1, 'zhangboyu@example.com', '13800138019');

INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student020', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'student', '刘思琪', 1, 'liusq@example.com', '13800138020');

INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student021', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'student', '陈俊杰', 1, 'chenjj@example.com', '13800138021');

-- 然后添加对应的学生记录
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES 
(217, '2023017', '王浩然', '男', 'wanghaoran@example.com', '13800138017', '计算机科学与技术23-1', '在读', 1, 1),
(218, '2023018', '李雨桐', '女', 'liyutong@example.com', '13800138018', '计算机科学与技术23-1', '在读', 1, 1),
(219, '2023019', '张博宇', '男', 'zhangboyu@example.com', '13800138019', '计算机科学与技术23-2', '在读', 1, 1),
(220, '2023020', '刘思琪', '女', 'liusq@example.com', '13800138020', '计算机科学与技术23-2', '在读', 1, 1),
(221, '2023021', '陈俊杰', '男', 'chenjj@example.com', '13800138021', '软件工程23-1', '在读', 1, 2);

-- 检查学生数量
SELECT COUNT(*) FROM sys_student;