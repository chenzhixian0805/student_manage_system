USE stusys;

-- 1. 重新创建学院表并插入中文数据
TRUNCATE TABLE sys_college;
INSERT INTO sys_college (college_name, description, create_time, update_time)
VALUES 
('计算机学院', '计算机科学与技术学院', NOW(), NOW()),
('电子工程学院', '电子工程学院', NOW(), NOW()),
('外国语学院', '外国语学院', NOW(), NOW()),
('管理学院', '管理学院', NOW(), NOW()),
('数学学院', '数学学院', NOW(), NOW());

-- 2. 重新创建专业表并插入中文数据
TRUNCATE TABLE sys_major;
INSERT INTO sys_major (major_name, college_id, description, create_time, update_time)
VALUES 
('计算机科学与技术', 1, '计算机科学与技术专业', NOW(), NOW()),
('软件工程', 1, '软件工程专业', NOW(), NOW()),
('电子信息工程', 2, '电子信息工程专业', NOW(), NOW()),
('通信工程', 2, '通信工程专业', NOW(), NOW()),
('工商管理', 3, '工商管理专业', NOW(), NOW()),
('会计学', 3, '会计学专业', NOW(), NOW()),
('英语', 4, '英语专业', NOW(), NOW()),
('日语', 4, '日语专业', NOW(), NOW()),
('数学与应用数学', 5, '数学与应用数学专业', NOW(), NOW()),
('统计学', 5, '统计学专业', NOW(), NOW());

-- 3. 更新老师姓名为中文
UPDATE sys_user SET 
    real_name = CASE user_name
        WHEN 'teacher01' THEN '张老师'
        WHEN 'teacher02' THEN '李老师'
        WHEN 'teacher03' THEN '王老师'
        WHEN 'teacher04' THEN '刘老师'
        WHEN 'teacher05' THEN '陈老师'
        WHEN 'teacher06' THEN '杨老师'
        WHEN 'teacher07' THEN '赵老师'
        WHEN 'teacher08' THEN '周老师'
        WHEN 'teacher09' THEN '吴老师'
        WHEN 'teacher10' THEN '郑老师'
        ELSE real_name
    END
WHERE role = 'ROLE_TEACHER';

-- 4. 更新学生姓名为中文
UPDATE sys_user SET 
    real_name = CONCAT('学生', SUBSTRING(user_name, 8))
WHERE role = 'ROLE_STUDENT';

-- 5. 更新课程为中文
UPDATE sys_course SET 
    course_name = CASE course_code
        WHEN 'MATH101' THEN '高等数学'
        WHEN 'ENG101' THEN '大学英语'
        WHEN 'CS101' THEN '计算机基础'
        WHEN 'MATH201' THEN '线性代数'
        WHEN 'CS201' THEN '数据结构'
        WHEN 'CS301' THEN '操作系统'
        WHEN 'CS302' THEN '数据库原理'
        WHEN 'CS303' THEN '计算机网络'
        ELSE course_name
    END,
    description = CASE course_code
        WHEN 'MATH101' THEN '高等数学课程'
        WHEN 'ENG101' THEN '大学英语课程'
        WHEN 'CS101' THEN '计算机基础课程'
        WHEN 'MATH201' THEN '线性代数课程'
        WHEN 'CS201' THEN '数据结构课程'
        WHEN 'CS301' THEN '操作系统课程'
        WHEN 'CS302' THEN '数据库原理课程'
        WHEN 'CS303' THEN '计算机网络课程'
        ELSE description
    END,
    semester = CASE 
        WHEN semester LIKE '%Semester 1' THEN CONCAT(SUBSTRING(semester, 1, 9), '学年第一学期')
        WHEN semester LIKE '%Semester 2' THEN CONCAT(SUBSTRING(semester, 1, 9), '学年第二学期')
        ELSE semester
    END;

-- 6. 更新学生信息为中文
UPDATE sys_student SET 
    gender = CASE gender
        WHEN 'Male' THEN '男'
        WHEN 'Female' THEN '女'
        ELSE gender
    END,
    status = '在读',
    class_name = CONCAT('2023级', (SUBSTRING(class_name, 7, 1)), '班')
WHERE class_name LIKE 'Class %';

-- 7. 更新选课状态为中文
UPDATE sys_selection SET 
    status = '已选';

-- 8. 更新成绩表学期为中文
UPDATE sys_grade SET 
    semester = CASE 
        WHEN semester LIKE '%Semester 1' THEN CONCAT(SUBSTRING(semester, 1, 9), '学年第一学期')
        WHEN semester LIKE '%Semester 2' THEN CONCAT(SUBSTRING(semester, 1, 9), '学年第二学期')
        ELSE semester
    END;
