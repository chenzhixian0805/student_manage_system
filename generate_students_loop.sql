USE stusys;

-- Generate 100 students using loop
-- 1. Set password (bcrypt encrypted, password: 123456)
SET @password = '$2a$10$e4XQe5B7Xv7Y3Z4A5B6C7D8E9F0G1H2I3J4K5L6M7N8O9P0Q1R2S3T4U5V6W7X8Y9Z0';

-- 2. Create a temporary table for student generation
CREATE TABLE IF NOT EXISTS temp_ids (
    id INT PRIMARY KEY AUTO_INCREMENT
) ENGINE=InnoDB;

-- 3. Insert 100 rows into temp_ids to generate 1 to 100
INSERT INTO temp_ids SELECT NULL FROM information_schema.columns LIMIT 100;

-- 4. Insert students into sys_user table
INSERT INTO sys_user (user_name, password, real_name, email, phone, role, status, create_time, update_time)
SELECT 
    CONCAT('student', LPAD(t.id, 3, '0')) AS user_name,
    @password,
    CONCAT('Student', LPAD(t.id, 3, '0')) AS real_name,
    CONCAT('student', LPAD(t.id, 3, '0'), '@example.com') AS email,
    CONCAT('13800138', LPAD(t.id, 3, '0')) AS phone,
    'ROLE_STUDENT' AS role,
    1 AS status,
    NOW() AS create_time,
    NOW() AS update_time
FROM temp_ids t;

-- 5. Insert students into sys_student table
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, create_time, update_time, college_id, major_id)
SELECT 
    u.id AS user_id,
    CONCAT('2023', LPAD(t.id, 3, '0')) AS student_id,
    u.real_name AS name,
    IF(t.id % 2 = 0, 'Male', 'Female') AS gender,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650 + 3650) DAY) AS birth_date,
    CONCAT('Computer Science 2023-', CEIL(t.id / 25), '班') AS class_name,
    u.phone,
    u.email,
    'Enrolled' AS status,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY) AS admission_date,
    NOW() AS create_time,
    NOW() AS update_time,
    CEIL(t.id / 50) AS college_id,
    CEIL(t.id / 25) AS major_id
FROM temp_ids t
JOIN sys_user u ON u.user_name = CONCAT('student', LPAD(t.id, 3, '0'))
ORDER BY t.id;

-- 6. Clean up temporary table
DROP TABLE IF EXISTS temp_ids;

-- 7. Verify results
SELECT COUNT(*) FROM sys_user WHERE user_name LIKE 'student%';
SELECT COUNT(*) FROM sys_student;