USE stusys;

-- 插入学生数据，每次插入10个学生，共插入88个学生
-- 第1组：10个学生
INSERT INTO sys_user (user_name, password, real_name, role, status, email, phone) VALUES
('2021013', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_0', 'ROLE_STUDENT', 1, 'student0@example.com', '13800138013'),
('2021014', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_1', 'ROLE_STUDENT', 1, 'student1@example.com', '13800138014'),
('2021015', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_2', 'ROLE_STUDENT', 1, 'student2@example.com', '13800138015'),
('2021016', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_3', 'ROLE_STUDENT', 1, 'student3@example.com', '13800138016'),
('2021017', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_4', 'ROLE_STUDENT', 1, 'student4@example.com', '13800138017'),
('2021018', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_5', 'ROLE_STUDENT', 1, 'student5@example.com', '13800138018'),
('2021019', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_6', 'ROLE_STUDENT', 1, 'student6@example.com', '13800138019'),
('2021020', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_7', 'ROLE_STUDENT', 1, 'student7@example.com', '13800138020'),
('2021021', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_8', 'ROLE_STUDENT', 1, 'student8@example.com', '13800138021'),
('2021022', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_9', 'ROLE_STUDENT', 1, 'student9@example.com', '13800138022');

-- 对应的学生记录
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, major_id, college_id) VALUES
(17, '2021013', 'Student_0', '男', '2003-01-01', '计算机科学与技术2301', '13800138013', 'student0@example.com', '在读', '2023-09-01', 1, 1),
(18, '2021014', 'Student_1', '女', '2003-05-01', '软件工程2301', '13800138014', 'student1@example.com', '在读', '2023-09-01', 2, 1),
(19, '2021015', 'Student_2', '男', '2003-09-01', '数学与应用数学2301', '13800138015', 'student2@example.com', '在读', '2023-09-01', 3, 2),
(20, '2021016', 'Student_3', '女', '2004-01-01', '信息与计算科学2301', '13800138016', 'student3@example.com', '在读', '2023-09-01', 4, 2),
(21, '2021017', 'Student_4', '男', '2004-05-01', '电子信息工程2301', '13800138017', 'student4@example.com', '在读', '2023-09-01', 5, 3),
(22, '2021018', 'Student_5', '女', '2004-09-01', '通信工程2301', '13800138018', 'student5@example.com', '在读', '2023-09-01', 6, 3),
(23, '2021019', 'Student_6', '男', '2005-01-01', '机械工程2301', '13800138019', 'student6@example.com', '在读', '2023-09-01', 7, 4),
(24, '2021020', 'Student_7', '女', '2005-05-01', '机械设计制造及其自动化2301', '13800138020', 'student7@example.com', '在读', '2023-09-01', 8, 4),
(25, '2021021', 'Student_8', '男', '2005-09-01', '财务管理2301', '13800138021', 'student8@example.com', '在读', '2023-09-01', 9, 5),
(26, '2021022', 'Student_9', '女', '2003-02-01', '工商管理2301', '13800138022', 'student9@example.com', '在读', '2023-09-01', 10, 5);

-- 第2组：10个学生
INSERT INTO sys_user (user_name, password, real_name, role, status, email, phone) VALUES
('2021023', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_10', 'ROLE_STUDENT', 1, 'student10@example.com', '13800138023'),
('2021024', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_11', 'ROLE_STUDENT', 1, 'student11@example.com', '13800138024'),
('2021025', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_12', 'ROLE_STUDENT', 1, 'student12@example.com', '13800138025'),
('2021026', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_13', 'ROLE_STUDENT', 1, 'student13@example.com', '13800138026'),
('2021027', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_14', 'ROLE_STUDENT', 1, 'student14@example.com', '13800138027'),
('2021028', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_15', 'ROLE_STUDENT', 1, 'student15@example.com', '13800138028'),
('2021029', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_16', 'ROLE_STUDENT', 1, 'student16@example.com', '13800138029'),
('2021030', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_17', 'ROLE_STUDENT', 1, 'student17@example.com', '13800138030'),
('2021031', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_18', 'ROLE_STUDENT', 1, 'student18@example.com', '13800138031'),
('2021032', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_19', 'ROLE_STUDENT', 1, 'student19@example.com', '13800138032');

-- 对应的学生记录
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, major_id, college_id) VALUES
(27, '2021023', 'Student_10', '男', '2003-06-01', '英语2301', '13800138023', 'student10@example.com', '在读', '2023-09-01', 11, 6),
(28, '2021024', 'Student_11', '女', '2003-10-01', '日语2301', '13800138024', 'student11@example.com', '在读', '2023-09-01', 12, 6),
(29, '2021025', 'Student_12', '男', '2004-02-01', '计算机科学与技术2301', '13800138025', 'student12@example.com', '在读', '2023-09-01', 1, 1),
(30, '2021026', 'Student_13', '女', '2004-06-01', '软件工程2301', '13800138026', 'student13@example.com', '在读', '2023-09-01', 2, 1),
(31, '2021027', 'Student_14', '男', '2004-10-01', '数学与应用数学2301', '13800138027', 'student14@example.com', '在读', '2023-09-01', 3, 2),
(32, '2021028', 'Student_15', '女', '2005-02-01', '信息与计算科学2301', '13800138028', 'student15@example.com', '在读', '2023-09-01', 4, 2),
(33, '2021029', 'Student_16', '男', '2005-06-01', '电子信息工程2301', '13800138029', 'student16@example.com', '在读', '2023-09-01', 5, 3),
(34, '2021030', 'Student_17', '女', '2005-10-01', '通信工程2301', '13800138030', 'student17@example.com', '在读', '2023-09-01', 6, 3),
(35, '2021031', 'Student_18', '男', '2003-03-01', '机械工程2301', '13800138031', 'student18@example.com', '在读', '2023-09-01', 7, 4),
(36, '2021032', 'Student_19', '女', '2003-07-01', '机械设计制造及其自动化2301', '13800138032', 'student19@example.com', '在读', '2023-09-01', 8, 4);

-- 第3组：10个学生
INSERT INTO sys_user (user_name, password, real_name, role, status, email, phone) VALUES
('2021033', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_20', 'ROLE_STUDENT', 1, 'student20@example.com', '13800138033'),
('2021034', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_21', 'ROLE_STUDENT', 1, 'student21@example.com', '13800138034'),
('2021035', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_22', 'ROLE_STUDENT', 1, 'student22@example.com', '13800138035'),
('2021036', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_23', 'ROLE_STUDENT', 1, 'student23@example.com', '13800138036'),
('2021037', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_24', 'ROLE_STUDENT', 1, 'student24@example.com', '13800138037'),
('2021038', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_25', 'ROLE_STUDENT', 1, 'student25@example.com', '13800138038'),
('2021039', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6', 'Student_26', 'ROLE_STUDENT', 1, 'student26@example.com', '13800138039'),
('2021040', '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMm