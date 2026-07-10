USE stusys;

-- 1. 将学院名称从英文改为中文
UPDATE sys_college SET 
    college_name = CASE 
        WHEN college_name = 'College of Computer Science' THEN '计算机学院'
        WHEN college_name = 'College of Electronic Engineering' THEN '电子工程学院'
        WHEN college_name = 'College of Foreign Languages' THEN '外国语学院'
        WHEN college_name = 'College of Management' THEN '管理学院'
        WHEN college_name = 'College of Mathematics' THEN '数学学院'
        ELSE college_name
    END,
    description = CASE 
        WHEN description = 'Computer Science College' THEN '计算机科学与技术学院'
        WHEN description = 'Electronic Engineering College' THEN '电子工程学院'
        WHEN description = 'Foreign Languages College' THEN '外国语学院'
        WHEN description = 'Management College' THEN '管理学院'
        WHEN description = 'Mathematics College' THEN '数学学院'
        ELSE description
    END;

-- 2. 将专业名称从英文改为中文
UPDATE sys_major SET 
    major_name = CASE 
        WHEN major_name = 'Computer Science' THEN '计算机科学与技术'
        WHEN major_name = 'Software Engineering' THEN '软件工程'
        WHEN major_name = 'Electronic Information Engineering' THEN '电子信息工程'
        WHEN major_name = 'Communication Engineering' THEN '通信工程'
        WHEN major_name = 'Business Administration' THEN '工商管理'
        WHEN major_name = 'Accounting' THEN '会计学'
        WHEN major_name = 'English' THEN '英语'
        WHEN major_name = 'Japanese' THEN '日语'
        WHEN major_name = 'Mathematics' THEN '数学与应用数学'
        WHEN major_name = 'Statistics' THEN '统计学'
        ELSE major_name
    END,
    description = CASE 
        WHEN description = 'Computer Science Major' THEN '计算机科学与技术专业'
        WHEN description = 'Software Engineering Major' THEN '软件工程专业'
        WHEN description = 'Electronic Information Engineering Major' THEN '电子信息工程专业'
        WHEN description = 'Communication Engineering Major' THEN '通信工程专业'
        WHEN description = 'Business Administration Major' THEN '工商管理专业'
        WHEN description = 'Accounting Major' THEN '会计学专业'
        WHEN description = 'English Major' THEN '英语专业'
        WHEN description = 'Japanese Major' THEN '日语专业'
        WHEN description = 'Mathematics Major' THEN '数学与应用数学专业'
        WHEN description = 'Statistics Major' THEN '统计学专业'
        ELSE description
    END;

-- 3. 将老师姓名从英文改为中文
UPDATE sys_user SET 
    real_name = CASE 
        WHEN user_name = 'teacher01' THEN '张老师'
        WHEN user_name = 'teacher02' THEN '李老师'
        WHEN user_name = 'teacher03' THEN '王老师'
        WHEN user_name = 'teacher04' THEN '刘老师'
        WHEN user_name = 'teacher05' THEN '陈老师'
        WHEN user_name = 'teacher06' THEN '杨老师'
        WHEN user_name = 'teacher07' THEN '赵老师'
        WHEN user_name = 'teacher08' THEN '周老师'
        WHEN user_name = 'teacher09' THEN '吴老师'
        WHEN user_name = 'teacher10' THEN '郑老师'
        ELSE real_name
    END
WHERE role = 'ROLE_TEACHER';

-- 4. 将学生姓名从英文改为中文
UPDATE sys_user SET 
    real_name = CONCAT('学生', SUBSTRING(user_name, 8))
WHERE role = 'ROLE_STUDENT';

-- 5. 将课程名称从英文改为中文
UPDATE sys_course SET 
    course_name = CASE 
        WHEN course_name = 'Advanced Mathematics' THEN '高等数学'
        WHEN course_name = 'College English' THEN '大学英语'
        WHEN course_name = 'Computer Fundamentals' THEN '计算机基础'
        WHEN course_name = 'Linear Algebra' THEN '线性代数'
        WHEN course_name = 'Data Structures' THEN '数据结构'
        WHEN course_name = 'Operating Systems' THEN '操作系统'
        WHEN course_name = 'Database Principles' THEN '数据库原理'
        WHEN course_name = 'Computer Networks' THEN '计算机网络'
        ELSE course_name
    END,
    description = CASE 
        WHEN description = 'Advanced Mathematics Course' THEN '高等数学课程'
        WHEN description = 'College English Course' THEN '大学英语课程'
        WHEN description = 'Computer Fundamentals Course' THEN '计算机基础课程'
        WHEN description = 'Linear Algebra Course' THEN '线性代数课程'
        WHEN description = 'Data Structures Course' THEN '数据结构课程'
        WHEN description = 'Operating Systems Course' THEN '操作系统课程'
        WHEN description = 'Database Principles Course' THEN '数据库原理课程'
        WHEN description = 'Computer Networks Course' THEN '计算机网络课程'
        ELSE description
    END,
    semester = CASE 
        WHEN semester = '2023-2024 Semester 1' THEN '2023-2024学年第一学期'
        WHEN semester = '2023-2024 Semester 2' THEN '2023-2024学年第二学期'
        WHEN semester = '2024-2025 Semester 1' THEN '2024-2025学年第一学期'
        WHEN semester = '2024-2025 Semester 2' THEN '2024-2025学年第二学期'
        ELSE semester
    END;

-- 6. 将学生信息中的英文改为中文
UPDATE sys_student SET 
    gender = CASE 
        WHEN gender = 'Male' THEN '男'
        WHEN gender = 'Female' THEN '女'
        ELSE gender
    END,
    status = CASE 
        WHEN status = 'Enrolled' THEN '在读'
        ELSE status
    END,
    class_name = CONCAT('2023级', (SUBSTRING(class_name, 7, 1)), '班')
WHERE class_name LIKE 'Class %';

-- 7. 将选课状态从英文改为中文
UPDATE sys_selection SET 
    status = CASE 
        WHEN status = 'Selected' THEN '已选'
        ELSE status
    END;

-- 8. 将成绩表中的学期从英文改为中文
UPDATE sys_grade SET 
    semester = CASE 
        WHEN semester = '2023-2024 Semester 1' THEN '2023-2024学年第一学期'
        WHEN semester = '2023-2024 Semester 2' THEN '2023-2024学年第二学期'
        WHEN semester = '2024-2025 Semester 1' THEN '2024-2025学年第一学期'
        WHEN semester = '2024-2025 Semester 2' THEN '2024-2025学年第二学期'
        ELSE semester
    END;
