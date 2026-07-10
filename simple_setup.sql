USE stusys;

-- 创建学院表
CREATE TABLE sys_college (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    college_name VARCHAR(100) NOT NULL,
    description TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建专业表
CREATE TABLE sys_major (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    major_name VARCHAR(100) NOT NULL,
    college_id BIGINT NOT NULL,
    description TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (college_id) REFERENCES sys_college(id)
);

-- 创建班级表
CREATE TABLE sys_class (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(50) NOT NULL,
    major_id BIGINT NOT NULL,
    grade INT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (major_id) REFERENCES sys_major(id)
);

-- 创建用户表
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(60) NOT NULL,
    role VARCHAR(50) NOT NULL,
    real_name VARCHAR(50) NOT NULL,
    status INT DEFAULT 1,
    email VARCHAR(100),
    phone VARCHAR(20),
    employee_id VARCHAR(20) UNIQUE,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建教师表
CREATE TABLE sys_teacher (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    teacher_no VARCHAR(20) NOT NULL UNIQUE,
    gender VARCHAR(10),
    birth_date DATE,
    title VARCHAR(50),
    department VARCHAR(100),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES sys_user(id)
);

-- 创建学生表
CREATE TABLE sys_student (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    birth_date DATE,
    email VARCHAR(100),
    phone VARCHAR(20),
    class_id BIGINT,
    status VARCHAR(20) DEFAULT '在读',
    admission_date DATE,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES sys_user(id),
    FOREIGN KEY (class_id) REFERENCES sys_class(id)
);

-- 创建课程表
CREATE TABLE sys_course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(50) UNIQUE,
    name VARCHAR(100),
    credit INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    teacher_id BIGINT NOT NULL,
    description TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES sys_teacher(id)
);

-- 创建选课表
CREATE TABLE sys_selection (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    selection_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Selected',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES sys_student(id),
    FOREIGN KEY (course_id) REFERENCES sys_course(id),
    UNIQUE KEY unique_selection (student_id, course_id)
);

-- 创建成绩表
CREATE TABLE sys_grade (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    score DOUBLE NOT NULL,
    gpa DOUBLE,
    semester VARCHAR(20) NOT NULL,
    exam_datetime DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES sys_student(id),
    FOREIGN KEY (course_id) REFERENCES sys_course(id),
    UNIQUE KEY unique_grade (student_id, course_id, semester)
);
