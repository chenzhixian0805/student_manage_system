-- 教师数据同步脚本：将sys_teacher表的数据完全替换为sys_user表中的教师数据
USE stusys;

-- 1. 首先，确保sys_teacher表中有所有sys_user中的教师记录
-- 使用INSERT IGNORE来避免重复插入
INSERT IGNORE INTO sys_teacher (
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
    1 AS college_id, -- 默认学院
    1 AS major_id, -- 默认专业
    '男' AS gender, -- 默认性别（使用单字）
    '1980-01-01' AS birth_date, -- 默认生日
    '讲师' AS title, -- 默认职称
    '2020-01-01' AS hire_date, -- 默认入职日期
    '正常' AS status, -- 默认状态
    NOW() AS create_time, 
    NOW() AS update_time
FROM sys_user u WHERE u.role = 'ROLE_TEACHER';

-- 2. 然后，更新现有记录，确保数据一致
UPDATE sys_teacher t
JOIN sys_user u ON t.teacher_id = u.employee_id
SET t.user_id = u.id,
    t.name = u.real_name,
    t.email = u.email,
    t.phone = u.phone,
    t.update_time = NOW()
WHERE u.role = 'ROLE_TEACHER';

-- 3. 验证同步结果
SELECT u.id, u.employee_id, u.real_name, u.email, u.phone, 
       t.id AS teacher_id, t.teacher_id AS t_teacher_id, t.name AS t_name, t.email AS t_email, t.phone AS t_phone
FROM sys_user u 
LEFT JOIN sys_teacher t ON u.employee_id = t.teacher_id 
WHERE u.role = 'ROLE_TEACHER' 
ORDER BY u.employee_id;

-- 4. 检查是否所有sys_user表中的教师都已同步到sys_teacher表
SELECT COUNT(*) AS total_teachers_in_user FROM sys_user WHERE role = 'ROLE_TEACHER';
SELECT COUNT(*) AS total_teachers_in_teacher FROM sys_teacher;
