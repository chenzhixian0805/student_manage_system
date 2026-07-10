-- 创建学生管理系统数据库
-- CREATE DATABASE stusys;
USE stusys;

-- 1. 创建学院表
CREATE TABLE IF NOT EXISTS sys_college (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    college_name VARCHAR(100) NOT NULL COMMENT '学院名称',
    description TEXT COMMENT '学院描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 创建专业表
CREATE TABLE IF NOT EXISTS sys_major (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    major_name VARCHAR(100) NOT NULL COMMENT '专业名称',
    college_id BIGINT NOT NULL COMMENT '所属学院ID',
    description TEXT COMMENT '专业描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (college_id) REFERENCES sys_college(id)
);

-- 3. 创建班级表
CREATE TABLE IF NOT EXISTS sys_class (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(50) NOT NULL COMMENT '班级名称',
    major_id BIGINT NOT NULL COMMENT '所属专业ID',
    grade INT NOT NULL COMMENT '年级',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (major_id) REFERENCES sys_major(id)
);

-- 4. 创建用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(60) NOT NULL COMMENT '密码',
    role VARCHAR(50) NOT NULL COMMENT '角色：ROLE_ADMIN, ROLE_TEACHER, ROLE_STUDENT',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    status INT DEFAULT 1 COMMENT '状态：0-禁用, 1-启用',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    employee_id VARCHAR(20) UNIQUE COMMENT '工号/学号',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. 创建教师表
CREATE TABLE IF NOT EXISTS sys_teacher (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE COMMENT '关联用户ID',
    teacher_no VARCHAR(20) NOT NULL UNIQUE COMMENT '教师编号',
    gender VARCHAR(10) COMMENT '性别',
    birth_date DATE COMMENT '出生日期',
    title VARCHAR(50) COMMENT '职称',
    department VARCHAR(100) COMMENT '所在部门',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES sys_user(id)
);

-- 6. 创建学生表
CREATE TABLE IF NOT EXISTS sys_student (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE COMMENT '关联用户ID',
    student_id VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) COMMENT '性别',
    birth_date DATE COMMENT '出生日期',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    class_id BIGINT COMMENT '班级ID',
    status VARCHAR(20) DEFAULT '在读' COMMENT '状态：在读, 休学, 毕业',
    admission_date DATE COMMENT '入学日期',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES sys_user(id),
    FOREIGN KEY (class_id) REFERENCES sys_class(id)
);

-- 7. 创建课程表
CREATE TABLE IF NOT EXISTS sys_course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE COMMENT '课程代码',
    course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
    course_id VARCHAR(50) UNIQUE COMMENT '课程标识',
    name VARCHAR(100) COMMENT '课程名称（冗余）',
    credit INT NOT NULL COMMENT '学分',
    semester VARCHAR(20) NOT NULL COMMENT '学期',
    teacher_id BIGINT NOT NULL COMMENT '授课教师ID',
    description TEXT COMMENT '课程描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES sys_teacher(id)
);

-- 8. 创建选课表
CREATE TABLE IF NOT EXISTS sys_selection (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT NOT NULL COMMENT '学生ID',
    course_id BIGINT NOT NULL COMMENT '课程ID',
    selection_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
    status VARCHAR(20) DEFAULT 'Selected' COMMENT '状态：Selected, Dropped',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES sys_student(id),
    FOREIGN KEY (course_id) REFERENCES sys_course(id),
    UNIQUE KEY unique_selection (student_id, course_id)
);

-- 9. 创建成绩表
CREATE TABLE IF NOT EXISTS sys_grade (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT NOT NULL COMMENT '学生ID',
    course_id BIGINT NOT NULL COMMENT '课程ID',
    score DOUBLE NOT NULL COMMENT '分数',
    gpa DOUBLE COMMENT '绩点',
    semester VARCHAR(20) NOT NULL COMMENT '学期',
    exam_datetime DATETIME COMMENT '考试时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES sys_student(id),
    FOREIGN KEY (course_id) REFERENCES sys_course(id),
    UNIQUE KEY unique_grade (student_id, course_id, semester)
);

-- 填充基础数据

-- 1. 填充学院数据
INSERT INTO sys_college (college_name, description) VALUES
('计算机学院', '计算机科学与技术相关专业学院'),
('电子工程学院', '电子信息工程相关专业学院'),
('经济管理学院', '经济学与管理学相关专业学院'),
('外国语学院', '外语相关专业学院');

-- 2. 填充专业数据
INSERT INTO sys_major (major_name, college_id, description) VALUES
('计算机科学与技术', 1, '计算机科学与技术专业，培养计算机相关技术人才'),
('软件工程', 1, '软件工程专业，培养软件开发与管理人才'),
('电子信息工程', 2, '电子信息工程专业，培养电子信息相关技术人才'),
('通信工程', 2, '通信工程专业，培养通信技术人才'),
('会计学', 3, '会计学专业，培养会计与财务人才'),
('市场营销', 3, '市场营销专业，培养市场营销人才'),
('英语', 4, '英语专业，培养英语语言与文学人才'),
('日语', 4, '日语专业，培养日语语言与文学人才');

-- 3. 填充班级数据
INSERT INTO sys_class (class_name, major_id, grade) VALUES
('计科2021-1班', 1, 2021),
('计科2021-2班', 1, 2021),
('软件2021-1班', 2, 2021),
('电子2021-1班', 3, 2021),
('通信2021-1班', 4, 2021),
('会计2021-1班', 5, 2021),
('营销2021-1班', 6, 2021),
('英语2021-1班', 7, 2021),
('日语2021-1班', 8, 2021);

-- 4. 填充用户数据（管理员、教师、学生）
-- 密码统一使用：password123（加密后的值）
INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone, employee_id) VALUES
('admin', '$2a$10$e4Y5V5Z6W7X8U9T0S1R2Q', 'ROLE_ADMIN', '管理员', 1, 'admin@example.com', '13800138000', 'ADM001'),
('liwei', '$2a$10$a1B2c3D4e5F6g7H8i9J0K', 'ROLE_TEACHER', '李伟', 1, 'liwei@example.com', '13800138001', 'TEA001'),
('zhangying', '$2a$10$L1M2n3O4p5Q6r7S8t9U0V', 'ROLE_TEACHER', '张颖', 1, 'zhangying@example.com', '13800138002', 'TEA002'),
('wanghong', '$2a$10$W1X2y3Z4A5B6C7D8E9F0G', 'ROLE_TEACHER', '王宏', 1, 'wanghong@example.com', '13800138003', 'TEA003'),
('sunyan', '$2a$10$H1I2J3K4L5M6N7O8P9Q0R', 'ROLE_STUDENT', '孙燕', 1, 'sunyan@example.com', '13800138004', '20210001'),
('zhanglei', '$2a$10$S1T2U3V4W5X6Y7Z8A9B0C', 'ROLE_STUDENT', '张磊', 1, 'zhanglei@example.com', '13800138005', '20210002'),
('chenfang', '$2a$10$D1E2F3G4H5I6J7K8L9M0N', 'ROLE_STUDENT', '陈芳', 1, 'chenfang@example.com', '13800138006', '20210003'),
('litao', '$2a$10$O1P2Q3R4S5T6U7V8W9X0Y', 'ROLE_STUDENT', '李涛', 1, 'litao@example.com', '13800138007', '20210004'),
('zhoujun', '$2a$10$Z1A2B3C4D5E6F7G8H9I0J', 'ROLE_STUDENT', '周俊', 1, 'zhoujun@example.com', '13800138008', '20210005'),
('wumei', '$2a$10$K1L2M3N4O5P6Q7R8S9T0U', 'ROLE_STUDENT', '吴梅', 1, 'wumei@example.com', '13800138009', '20210006'),
('gaoyuan', '$2a$10$A1B2C3D4E5F6G7H8I9J0K', 'ROLE_STUDENT', '高远', 1, 'gaoyuan@example.com', '13800138010', '20210007'),
('xujing', '$2a$10$B1C2D3E4F5G6H7I8J9K0L', 'ROLE_STUDENT', '徐静', 1, 'xujing@example.com', '13800138011', '20210008'),
('maohui', '$2a$10$C1D2E3F4G5H6I7J8K9L0M', 'ROLE_STUDENT', '毛辉', 1, 'maohui@example.com', '13800138012', '20210009'),
('dingli', '$2a$10$D1E2F3G4H5I6J7K8L9M0N', 'ROLE_STUDENT', '丁丽', 1, 'dingli@example.com', '13800138013', '20210010');

-- 5. 填充教师数据
INSERT INTO sys_teacher (user_id, teacher_no, gender, birth_date, title, department) VALUES
(2, 'TEA001', '男', '1985-03-15', '副教授', '计算机学院'),
(3, 'TEA002', '女', '1988-07-20', '讲师', '电子工程学院'),
(4, 'TEA003', '男', '1979-12-10', '教授', '经济管理学院');

-- 6. 填充学生数据
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_id, status, admission_date) VALUES
(5, '20210001', '孙燕', '女', '2003-01-15', 'sunyan@example.com', '13800138004', 1, '在读', '2021-09-01'),
(6, '20210002', '张磊', '男', '2003-02-20', 'zhanglei@example.com', '13800138005', 1, '在读', '2021-09-01'),
(7, '20210003', '陈芳', '女', '2003-03-10', 'chenfang@example.com', '13800138006', 2, '在读', '2021-09-01'),
(8, '20210004', '李涛', '男', '2003-04-05', 'litao@example.com', '13800138007', 2, '在读', '2021-09-01'),
(9, '20210005', '周俊', '男', '2003-05-12', 'zhoujun@example.com', '13800138008', 3, '在读', '2021-09-01'),
(10, '20210006', '吴梅', '女', '2003-06-08', 'wumei@example.com', '13800138009', 3, '在读', '2021-09-01'),
(11, '20210007', '高远', '男', '2003-07-22', 'gaoyuan@example.com', '13800138010', 4, '在读', '2021-09-01'),
(12, '20210008', '徐静', '女', '2003-08-18', 'xujing@example.com', '13800138011', 4, '在读', '2021-09-01'),
(13, '20210009', '毛辉', '男', '2003-09-30', 'maohui@example.com', '13800138012', 5, '在读', '2021-09-01'),
(14, '20210010', '丁丽', '女', '2003-10-15', 'dingli@example.com', '13800138013', 5, '在读', '2021-09-01');

-- 7. 填充课程数据
INSERT INTO sys_course (course_code, course_name, course_id, name, credit, semester, teacher_id, description) VALUES
('CS101', '计算机导论', 'CS101', '计算机导论', 3, '2023-2024-1', 1, '计算机科学的入门课程，介绍计算机基础知识和原理'),
('CS102', '高等数学', 'CS102', '高等数学', 4, '2023-2024-1', 1, '高等数学基础课程，包括微积分、线性代数等'),
('CS201', '数据结构', 'CS201', '数据结构', 4, '2023-2024-2', 1, '数据结构与算法分析，介绍常见数据结构和算法'),
('CS202', '操作系统', 'CS202', '操作系统', 4, '2023-2024-2', 1, '操作系统原理与实现，介绍操作系统核心概念'),
('EE101', '电路分析', 'EE101', '电路分析', 4, '2023-2024-1', 2, '电路分析基础，介绍电路基本原理和分析方法'),
('EE102', '模拟电子技术', 'EE102', '模拟电子技术', 4, '2023-2024-2', 2, '模拟电子技术基础，介绍模拟电路设计和分析'),
('MG101', '管理学原理', 'MG101', '管理学原理', 3, '2023-2024-1', 3, '管理学基本原理，介绍管理理论和实践'),
('MG102', '微观经济学', 'MG102', '微观经济学', 3, '2023-2024-1', 3, '微观经济学基础，介绍市场经济基本原理');

-- 8. 填充选课数据
INSERT INTO sys_selection (student_id, course_id, selection_time, status) VALUES
(1, 1, '2023-08-20 10:00:00', 'Selected'),
(1, 2, '2023-08-20 10:05:00', 'Selected'),
(2, 1, '2023-08-20 10:10:00', 'Selected'),
(2, 2, '2023-08-20 10:15:00', 'Selected'),
(3, 3, '2023-08-20 10:20:00', 'Selected'),
(3, 4, '2023-08-20 10:25:00', 'Selected'),
(4, 3, '2023-08-20 10:30:00', 'Selected'),
(4, 4, '2023-08-20 10:35:00', 'Selected'),
(5, 1, '2023-08-20 10:40:00', 'Selected'),
(5, 5, '2023-08-20 10:45:00', 'Selected'),
(6, 2, '2023-08-20 10:50:00', 'Selected'),
(6, 6, '2023-08-20 10:55:00', 'Selected'),
(7, 7, '2023-08-20 11:00:00', 'Selected'),
(7, 8, '2023-08-20 11:05:00', 'Selected'),
(8, 7, '2023-08-20 11:10:00', 'Selected'),
(8, 8, '2023-08-20 11:15:00', 'Selected');

-- 9. 填充成绩数据
INSERT INTO sys_grade (student_id, course_id, score, gpa, semester, exam_datetime) VALUES
(1, 1, 92.5, 3.7, '2023-2024-1', '2024-01-15 09:00:00'),
(1, 2, 88.0, 3.3, '2023-2024-1', '2024-01-16 14:00:00'),
(2, 1, 95.0, 4.0, '2023-2024-1', '2024-01-15 09:00:00'),
(2, 2, 91.0, 3.7, '2023-2024-1', '2024-01-16 14:00:00'),
(3, 3, 85.0, 3.0, '2023-2024-2', '2024-06-20 09:00:00'),
(3, 4, 89.0, 3.3, '2023-2024-2', '2024-06-21 14:00:00'),
(4, 3, 93.0, 3.7, '2023-2024-2', '2024-06-20 09:00:00'),
(4, 4, 90.0, 3.7, '2023-2024-2', '2024-06-21 14:00:00'),
(5, 1, 86.0, 3.0, '2023-2024-1', '2024-01-15 09:00:00'),
(5, 5, 84.0, 3.0, '2023-2024-1', '2024-01-17 09:00:00'),
(6, 2, 87.0, 3.0, '2023-2024-1', '2024-01-16 14:00:00'),
(6, 6, 82.0, 2.7, '2023-2024-2', '2024-06-22 09:00:00'),
(7, 7, 94.0, 3.7, '2023-2024-1', '2024-01-18 14:00:00'),
(7, 8, 91.0, 3.7, '2023-2024-1', '2024-01-19 09:00:00'),
(8, 7, 88.0, 3.3, '2023-2024-1', '2024-01-18 14:00:00'),
(8, 8, 85.0, 3.0, '2023-2024-1', '2024-01-19 09:00:00');
