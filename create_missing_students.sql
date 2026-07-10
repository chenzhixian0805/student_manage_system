USE stusys;

-- Create student records for all student users that don't have one
-- This will create sys_student records for all users with role=ROLE_STUDENT
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id)
SELECT 
    u.id, 
    CONCAT('2023', LPAD(SUBSTRING(u.user_name, 8), 3, '0')),
    u.real_name,
    IF(MOD(u.id, 2) = 0, 'Male', 'Female'),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650 + 3650) DAY),
    u.email,
    u.phone,
    CONCAT('Computer Science 2023-', CEIL((u.id - (SELECT IFNULL(MIN(id), 0) FROM sys_user WHERE role='ROLE_STUDENT')) / 25), '班'),
    'Enrolled',
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
    CEIL((u.id - (SELECT IFNULL(MIN(id), 0) FROM sys_user WHERE role='ROLE_STUDENT')) / 50),
    CEIL((u.id - (SELECT IFNULL(MIN(id), 0) FROM sys_user WHERE role='ROLE_STUDENT')) / 25)
FROM sys_user u
LEFT JOIN sys_student s ON u.id = s.user_id
WHERE u.role = 'ROLE_STUDENT' AND s.id IS NULL;

-- Verify results
SELECT COUNT(*) FROM sys_user WHERE role = 'ROLE_STUDENT';
SELECT COUNT(*) FROM sys_student;