-- 更新教师用户的user_name为teacher_id
UPDATE sys_user u 
JOIN sys_teacher t ON u.id = t.user_id 
SET u.user_name = t.teacher_id 
WHERE u.role = 'ROLE_TEACHER';

-- 更新学生用户的user_name为student_id
UPDATE sys_user u 
JOIN sys_student s ON u.id = s.user_id 
SET u.user_name = s.student_id 
WHERE u.role = 'ROLE_STUDENT';

-- 验证更新结果
SELECT u.id, u.user_name, u.role, t.teacher_id, s.student_id 
FROM sys_user u 
LEFT JOIN sys_teacher t ON u.id = t.user_id 
LEFT JOIN sys_student s ON u.id = s.user_id 
ORDER BY u.id;