-- 教师数据同步脚本
-- 将sys_user表中的教师数据同步到sys_teacher表，确保数据一致
USE stusys;

-- 1. 查看当前sys_user表中的教师数据
SELECT id, employee_id, real_name, email, phone 
FROM sys_user 
WHERE role = 'ROLE_TEACHER' 
ORDER BY employee_id;

-- 2. 查看当前sys_teacher表中的数据
SELECT id, user_id, teacher_id, name, email, phone 
FROM sys_teacher 
ORDER BY teacher_id;

-- 3. 开始同步数据
-- 3.1 更新已存在的教师数据，确保与sys_user一致
UPDATE sys_teacher t
JOIN sys_user u ON t.teacher_id = u.employee_id
SET t.user_id = u.id,
    t.name = u.real_name,
    t.email = u.email,
    t.phone = u.phone,
    t.updated_at = NOW()
WHERE u.role = 'ROLE_TEACHER';

-- 3.2 添加缺失的教师数据
-- 先创建一个临时表，用于存储需要添加的教师
CREATE TEMPORARY TABLE temp_teachers_to_add AS
SELECT u.id AS user_id,
       u.employee_id AS teacher_id,
       u.real_name AS name,
       u.email,
       u.phone
FROM sys_user u
LEFT JOIN sys_teacher t ON u.employee_id = t.teacher_id
WHERE u.role = 'ROLE_TEACHER' AND t.teacher_id IS NULL;

-- 查看需要添加的教师
SELECT * FROM temp_teachers_to_add;

-- 计算新教师的id
SELECT IFNULL(MAX(id), 0) AS max_teacher_id FROM sys_teacher;

-- 添加缺失的教师数据，使用变量自增id
SET @max_id = (SELECT IFNULL(MAX(id), 0) FROM sys_teacher);

INSERT INTO sys_teacher (
    id, user_id, college_id, major_id, teacher_id, name, gender, birth_date, 
    phone, email, title, entry_date, status, created_at, updated_at
) 
SELECT 
    (@max_id := @max_id + 1) AS id,
    user_id,
    1 AS college_id, -- 默认学院
    1 AS major_id, -- 默认专业
    teacher_id,
    name,
    '男' AS gender, -- 默认性别
    '1980-01-01' AS birth_date, -- 默认生日
    phone,
    email,
    '讲师' AS title, -- 默认职称
    '2020-01-01' AS entry_date, -- 默认入职日期
    '正常' AS status, -- 默认状态
    NOW() AS created_at,
    NOW() AS updated_at
FROM temp_teachers_to_add;

-- 删除临时表
DROP TEMPORARY TABLE IF EXISTS temp_teachers_to_add;

-- 4. 查看同步后的结果
SELECT t.id, t.user_id, t.teacher_id, t.name, t.email, t.phone,
       u.real_name AS sys_user_name, u.employee_id AS sys_user_employee_id
FROM sys_teacher t
JOIN sys_user u ON t.user_id = u.id
ORDER BY t.teacher_id;

-- 5. 验证完整性：确保sys_teacher中的所有教师都在sys_user中存在
SELECT t.teacher_id, t.name, u.real_name
FROM sys_teacher t
LEFT JOIN sys_user u ON t.teacher_id = u.employee_id
WHERE u.id IS NULL;

-- 6. 优化：确保sys_teacher表有合适的索引
SHOW INDEXES FROM sys_teacher;

-- 7. 清理：删除sys_teacher中不在sys_user中的教师记录
DELETE t FROM sys_teacher t
LEFT JOIN sys_user u ON t.teacher_id = u.employee_id
WHERE u.id IS NULL;

-- 8. 最终验证
SELECT '同步完成' AS status, COUNT(*) AS total_teachers 
FROM sys_teacher;

SELECT 'sys_user中的教师数量' AS status, COUNT(*) AS total_teachers 
FROM sys_user WHERE role = 'ROLE_TEACHER';

SELECT '数据一致' AS status, COUNT(*) AS matched_teachers 
FROM sys_teacher t
JOIN sys_user u ON t.teacher_id = u.employee_id AND u.role = 'ROLE_TEACHER';