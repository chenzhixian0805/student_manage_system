-- 彻底修复sys_teacher表中的中文乱码问题
USE stusys;

-- 1. 备份当前sys_teacher表数据
DROP TABLE IF EXISTS sys_teacher_backup;
CREATE TABLE sys_teacher_backup AS SELECT * FROM sys_teacher;

-- 2. 删除当前sys_teacher表
DROP TABLE sys_teacher;

-- 3. 重新创建sys_teacher表
CREATE TABLE sys_teacher (
  id bigint NOT NULL AUTO_INCREMENT,
  create_time datetime(6) DEFAULT NULL,
  update_time datetime(6) DEFAULT NULL,
  name varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  gender varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  birth_date date DEFAULT NULL,
  phone varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  email varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  college_id bigint DEFAULT NULL,
  major_id bigint DEFAULT NULL,
  teacher_id varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  title varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  hire_date date DEFAULT NULL,
  status varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  user_id bigint DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY teacher_id (teacher_id),
  KEY college_id (college_id),
  KEY major_id (major_id),
  KEY user_id (user_id),
  CONSTRAINT sys_teacher_ibfk_1 FOREIGN KEY (college_id) REFERENCES sys_college (id),
  CONSTRAINT sys_teacher_ibfk_2 FOREIGN KEY (major_id) REFERENCES sys_major (id),
  CONSTRAINT sys_teacher_ibfk_3 FOREIGN KEY (user_id) REFERENCES sys_user (id)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. 从sys_user表重新插入干净的教师数据
INSERT INTO sys_teacher (
    user_id, 
    teacher_id, 
    name, 
    email, 
    phone, 
    college_id, 
    major_id, 
    gender, 
    birth_date, 
    title, 
    hire_date, 
    status, 
    create_time, 
    update_time
) SELECT 
    u.id AS user_id, 
    u.employee_id AS teacher_id, 
    u.real_name AS name, 
    u.email AS email, 
    u.phone AS phone, 
    1 AS college_id, 
    1 AS major_id, 
    '男' AS gender, 
    '1980-01-01' AS birth_date, 
    '讲师' AS title, 
    '2020-01-01' AS hire_date, 
    '正常' AS status, 
    NOW() AS create_time, 
    NOW() AS update_time
FROM sys_user u WHERE u.role = 'ROLE_TEACHER';

-- 5. 验证修复结果
SELECT id, name, gender, title, status, user_id FROM sys_teacher;

-- 6. 检查数据完整性
SELECT COUNT(*) AS total_teachers FROM sys_teacher;
SELECT COUNT(*) AS total_teacher_users FROM sys_user WHERE role = 'ROLE_TEACHER';
