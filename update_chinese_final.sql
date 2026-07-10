USE stusys;

-- 1. 更新学院名称和描述为中文
UPDATE sys_college SET 
    college_name = '计算机学院',
    description = '计算机科学与技术学院'
WHERE college_name LIKE '%Computer Science%';

UPDATE sys_college SET 
    college_name = '电子工程学院',
    description = '电子工程学院'
WHERE college_name LIKE '%Electronic Engineering%';

UPDATE sys_college SET 
    college_name = '外国语学院',
    description = '外国语学院'
WHERE college_name LIKE '%Foreign Languages%';

UPDATE sys_college SET 
    college_name = '管理学院',
    description = '管理学院'
WHERE college_name LIKE '%Management%';

UPDATE sys_college SET 
    college_name = '数学学院',
    description = '数学学院'
WHERE college_name LIKE '%Mathematics%';

-- 2. 更新专业名称和描述为中文
UPDATE sys_major SET 
    major_name = '计算机科学与技术',
    description = '计算机科学与技术专业'
WHERE major_name = 'Computer Science';

UPDATE sys_major SET 
    major_name = '软件工程',
    description = '软件工程专业'
WHERE major_name = 'Software Engineering';

UPDATE sys_major SET 
    major_name = '电子信息工程',
    description = '电子信息工程专业'
WHERE major_name = 'Electronic Information Engineering';

UPDATE sys_major SET 
    major_name = '通信工程',
    description = '通信工程专业'
WHERE major_name = 'Communication Engineering';

UPDATE sys_major SET 
    major_name = '工商管理',
    description = '工商管理专业'
WHERE major_name = 'Business Administration';

UPDATE sys_major SET 
    major_name = '会计学',
    description = '会计学专业'
WHERE major_name = 'Accounting';

UPDATE sys_major SET 
    major_name = '英语',
    description = '英语专业'
WHERE major_name = 'English';

UPDATE sys_major SET 
    major_name = '日语',
    description = '日语专业'
WHERE major_name = 'Japanese';

UPDATE sys_major SET 
    major_name = '数学与应用数学',
    description = '数学与应用数学专业'
WHERE major_name = 'Mathematics';

UPDATE sys_major SET 
    major_name = '统计学',
    description = '统计学专业'
WHERE major_name = 'Statistics';

-- 3. 更新老师姓名为中文
UPDATE sys_user SET 
    real_name = '张老师'
WHERE user_name = 'teacher01';

UPDATE sys_user SET 
    real_name = '李老师'
WHERE user_name = 'teacher02';

UPDATE sys_user SET 
    real_name = '王老师'
WHERE user_name = 'teacher03';

UPDATE sys_user SET 
    real_name = '刘老师'
WHERE user_name = 'teacher04';

UPDATE sys_user SET 
    real_name = '陈老师'
WHERE user_name = 'teacher05';

UPDATE sys_user SET 
    real_name = '杨老师'
WHERE user_name = 'teacher06';

UPDATE sys_user SET 
    real_name = '赵老师'
WHERE user_name = 'teacher07';

UPDATE sys_user SET 
    real_name = '周老师'
WHERE user_name = 'teacher08';

UPDATE sys_user SET 
    real_name = '吴老师'
WHERE user_name = 'teacher09';

UPDATE sys_user SET 
    real_name = '郑老师'
WHERE user_name = 'teacher10';

-- 4. 更新学生姓名为中文
UPDATE sys_user SET 
    real_name = CONCAT('学生', SUBSTRING(user_name, 8))
WHERE role = 'ROLE_STUDENT';

-- 5. 更新课程信息为中文
UPDATE sys_course SET 
    course_name = '高等数学',
    description = '高等数学课程',
    semester = '2023-2024学年第一学期'
WHERE course_code = 'MATH101';

UPDATE sys_course SET 
    course_name = '大学英语',
    description = '大学英语课程',
    semester = '2023-2024学年第一学期'
WHERE course_code = 'ENG101';

UPDATE sys_course SET 
    course_name = '计算机基础',
    description = '计算机基础课程',
    semester = '2023-2024学年第一学期'
WHERE course_code = 'CS101';

UPDATE sys_course SET 
    course_name = '线性代数',
    description = '线性代数课程',
    semester = '2023-2024学年第二学期'
WHERE course_code = 'MATH201';

UPDATE sys_course SET 
    course_name = '数据结构',
    description = '数据结构课程',
    semester = '2023-2024学年第二学期'
WHERE course_code = 'CS201';

UPDATE sys_course SET 
    course_name = '操作系统',
    description = '操作系统课程',
    semester = '2024-2025学年第一学期'
WHERE course_code = 'CS301';

UPDATE sys_course SET 
    course_name = '数据库原理',
    description = '数据库原理课程',
    semester = '2024-2025学年第一学期'
WHERE course_code = 'CS302';

UPDATE sys_course SET 
    course_name = '计算机网络',
    description = '计算机网络课程',
    semester = '2024-2025学年第二学期'
WHERE course_code = 'CS303';

-- 6. 更新学生信息为中文
UPDATE sys_student SET 
    gender = '男'
WHERE gender = 'Male';

UPDATE sys_student SET 
    gender = '女'
WHERE gender = 'Female';

UPDATE sys_student SET 
    status = '在读'
WHERE status = 'Enrolled';

UPDATE sys_student SET 
    class_name = CONCAT('2023级', SUBSTRING(class_name, 7, 1), '班')
WHERE class_name LIKE 'Class%';

-- 7. 更新选课状态为中文
UPDATE sys_selection SET 
    status = '已选'
WHERE status = 'Selected';

-- 8. 更新成绩表学期为中文
UPDATE sys_grade SET 
    semester = '2023-2024学年第一学期'
WHERE semester = '2023-2024 Semester 1';

UPDATE sys_grade SET 
    semester = '2023-2024学年第二学期'
WHERE semester = '2023-2024 Semester 2';

UPDATE sys_grade SET 
    semester = '2024-2025学年第一学期'
WHERE semester = '2024-2025 Semester 1';

UPDATE sys_grade SET 
    semester = '2024-2025学年第二学期'
WHERE semester = '2024-2025 Semester 2';
