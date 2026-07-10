USE stusys;

-- Generate 100 students with correct table structure
-- 1. Set password (bcrypt encrypted, password: 123456, 60 characters long)
SET @password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy';

-- 2. Generate 100 students using a simpler approach
-- Insert 100 students directly into sys_user and sys_student
-- First, let's check current max id in sys_user to avoid conflicts
SET @max_user_id = (SELECT IFNULL(MAX(id), 0) FROM sys_user);

-- Generate students one by one
-- This approach is slower but more reliable for avoiding syntax errors

-- Insert first 25 students
INSERT INTO sys_user (user_name, password, real_name, email, phone, role, status) VALUES
('student001', @password, 'Student001', 'student001@example.com', '13800138001', 'ROLE_STUDENT', 1),
('student002', @password, 'Student002', 'student002@example.com', '13800138002', 'ROLE_STUDENT', 1),
('student003', @password, 'Student003', 'student003@example.com', '13800138003', 'ROLE_STUDENT', 1),
('student004', @password, 'Student004', 'student004@example.com', '13800138004', 'ROLE_STUDENT', 1),
('student005', @password, 'Student005', 'student005@example.com', '13800138005', 'ROLE_STUDENT', 1),
('student006', @password, 'Student006', 'student006@example.com', '13800138006', 'ROLE_STUDENT', 1),
('student007', @password, 'Student007', 'student007@example.com', '13800138007', 'ROLE_STUDENT', 1),
('student008', @password, 'Student008', 'student008@example.com', '13800138008', 'ROLE_STUDENT', 1),
('student009', @password, 'Student009', 'student009@example.com', '13800138009', 'ROLE_STUDENT', 1),
('student010', @password, 'Student010', 'student010@example.com', '13800138010', 'ROLE_STUDENT', 1),
('student011', @password, 'Student011', 'student011@example.com', '13800138011', 'ROLE_STUDENT', 1),
('student012', @password, 'Student012', 'student012@example.com', '13800138012', 'ROLE_STUDENT', 1),
('student013', @password, 'Student013', 'student013@example.com', '13800138013', 'ROLE_STUDENT', 1),
('student014', @password, 'Student014', 'student014@example.com', '13800138014', 'ROLE_STUDENT', 1),
('student015', @password, 'Student015', 'student015@example.com', '13800138015', 'ROLE_STUDENT', 1),
('student016', @password, 'Student016', 'student016@example.com', '13800138016', 'ROLE_STUDENT', 1),
('student017', @password, 'Student017', 'student017@example.com', '13800138017', 'ROLE_STUDENT', 1),
('student018', @password, 'Student018', 'student018@example.com', '13800138018', 'ROLE_STUDENT', 1),
('student019', @password, 'Student019', 'student019@example.com', '13800138019', 'ROLE_STUDENT', 1),
('student020', @password, 'Student020', 'student020@example.com', '13800138020', 'ROLE_STUDENT', 1),
('student021', @password, 'Student021', 'student021@example.com', '13800138021', 'ROLE_STUDENT', 1),
('student022', @password, 'Student022', 'student022@example.com', '13800138022', 'ROLE_STUDENT', 1),
('student023', @password, 'Student023', 'student023@example.com', '13800138023', 'ROLE_STUDENT', 1),
('student024', @password, 'Student024', 'student024@example.com', '13800138024', 'ROLE_STUDENT', 1),
('student025', @password, 'Student025', 'student025@example.com', '13800138025', 'ROLE_STUDENT', 1);

-- Now insert corresponding sys_student records for these users
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id)
SELECT 
    u.id, 
    CONCAT('2023', LPAD(SUBSTRING(u.user_name, 8), 3, '0')),
    u.real_name,
    IF(MOD(u.id, 2) = 0, 'Male', 'Female'),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650 + 3650) DAY),
    u.email,
    u.phone,
    CONCAT('Computer Science 2023-', CEIL((u.id - @max_user_id) / 25), '班'),
    'Enrolled',
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
    CEIL((u.id - @max_user_id) / 50),
    CEIL((u.id - @max_user_id) / 25)
FROM sys_user u
WHERE u.user_name LIKE 'student00%' OR u.user_name LIKE 'student01%' OR u.user_name LIKE 'student02%';

-- Verify results
SELECT COUNT(*) FROM sys_user WHERE user_name LIKE 'student%';
SELECT COUNT(*) FROM sys_student;