USE stusys;

-- 新增84个学生用户和对应的学生记录
-- 注意：角色必须是ROLE_STUDENT，不是student
-- 注意：sys_student表需要birth_date和admission_date字段

-- 用户记录从id=217开始
-- 学生ID从2023017开始

-- 批次1：计算机科学与技术23-1班
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student017', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'ROLE_STUDENT', '王浩然', 1, 'wanghaoran@example.com', '13800138017');

INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES 
(217, '2023017', '王浩然', '男', '2005-01-15', 'wanghaoran@example.com', '13800138017', '计算机科学与技术23-1', '在读', '2023-09-01', 1, 1);

-- 批次2：计算机科学与技术23-1班
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student018', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'ROLE_STUDENT', '李雨桐', 1, 'liyutong@example.com', '13800138018');

INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES 
(218, '2023018', '李雨桐', '女', '2005-02-20', 'liyutong@example.com', '13800138018', '计算机科学与技术23-1', '在读', '2023-09-01', 1, 1);

-- 批次3：计算机科学与技术23-2班
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student019', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'ROLE_STUDENT', '张博宇', 1, 'zhangboyu@example.com', '13800138019');

INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES 
(219, '2023019', '张博宇', '男', '2005-03-10', 'zhangboyu@example.com', '13800138019', '计算机科学与技术23-2', '在读', '2023-09-01', 1, 1);

-- 批次4：计算机科学与技术23-2班
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student020', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'ROLE_STUDENT', '刘思琪', 1, 'liusq@example.com', '13800138020');

INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES 
(220, '2023020', '刘思琪', '女', '2005-04-05', 'liusq@example.com', '13800138020', '计算机科学与技术23-2', '在读', '2023-09-01', 1, 1);

-- 批次5：软件工程23-1班
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES 
('student021', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'ROLE_STUDENT', '陈俊杰', 1, 'chenjj@example.com', '13800138021');

INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES 
(221, '2023021', '陈俊杰', '男', '2005-05-18', 'chenjj@example.com', '13800138021', '软件工程23-1', '在读', '2023-09-01', 1, 2);

-- 检查当前学生数量
SELECT COUNT(*) FROM sys_student;