USE stusys;

-- Create simple student records for missing users
-- This will create basic sys_student records for all users with role=ROLE_STUDENT
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id)
SELECT 
    u.id, 
    CONCAT('2023', LPAD(SUBSTRING(u.user_name, 8), 3, '0')),
    u.real_name,
    'Male',
    u.email,
    u.phone,
    'Computer Science 2023-1班',
    'Enrolled',
    1,
    1
FROM sys_user u
LEFT JOIN sys_student s ON u.id = s.user_id
WHERE u.role = 'ROLE_STUDENT' AND s.id IS NULL;

-- Verify results
SELECT COUNT(*) FROM sys_user WHERE role = 'ROLE_STUDENT';
SELECT COUNT(*) FROM sys_student;