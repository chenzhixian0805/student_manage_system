-- 扩充学生人数到200人
-- 当前已有50名学生，需要新增150名学生

-- 1. 插入学生数据
-- 2. 为每个学生创建用户账号

-- 先查看当前学生总数
SELECT COUNT(*) as current_total FROM sys_student;

-- 生成学生数据（使用WHILE循环）
SET @i = 0;
SET @student_id = 20230051;
SET @user_id = 62;

-- 重置变量
SET @class_id = 1;
SET @major_id = 1;

-- 开始循环
WHILE @i < 150 DO
    -- 根据班级ID获取专业ID
    SELECT major_id INTO @major_id FROM sys_class WHERE id = @class_id;
    
    -- 生成随机姓名
    SET @first_names = '张,李,王,刘,陈,杨,赵,黄,周,吴';
    SET @last_names = '明,华,强,芳,磊,娜,伟,敏,静,丽,涛,辉,燕,超,秀';
    
    -- 生成随机性别
    SET @gender = IF(RAND() > 0.5, '男', '女');
    
    -- 生成随机手机号
    SET @phone = CONCAT('138', LPAD(FLOOR(RAND() * 100000000), 8, '0'));
    
    -- 生成邮箱
    SET @email = CONCAT('student', @student_id, '@example.com');
    
    -- 生成身份证号（模拟）
    SET @id_card = CONCAT('110101', FLOOR(2000 + RAND() * 5), LPAD(FLOOR(1 + RAND() * 12), 2, '0'), LPAD(FLOOR(1 + RAND() * 28), 2, '0'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- 获取班级名称
    SELECT class_name INTO @class_name FROM sys_class WHERE id = @class_id;
    
    -- 插入用户表
    INSERT INTO sys_user (create_time, update_time, real_name, password, phone, email, employee_id, role, status, user_name) 
    VALUES (NOW(), NOW(), CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(@first_names, ',', FLOOR(1 + RAND() * 10)), ',', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(@last_names, ',', FLOOR(1 + RAND() * 15)), ',', -1)), 'password123', @phone, @email, CONCAT('S', @student_id), 'ROLE_STUDENT', 1, @student_id);
    
    -- 插入学生表
    INSERT INTO sys_student (create_time, update_time, student_id, name, gender, class_name, status, major_id, user_id, id_card, phone, email) 
    VALUES (NOW(), NOW(), @student_id, CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(@first_names, ',', FLOOR(1 + RAND() * 10)), ',', -1), SUBSTRING_INDEX(SUBSTRING_INDEX(@last_names, ',', FLOOR(1 + RAND() * 15)), ',', -1)), @gender, @class_name, '在读', @major_id, @user_id, @id_card, @phone, @email);
    
    -- 递增计数器
    SET @i = @i + 1;
    SET @student_id = @student_id + 1;
    SET @user_id = @user_id + 1;
    
    -- 更新班级ID（循环12个班级）
    SET @class_id = @class_id + 1;
    IF @class_id > 12 THEN
        SET @class_id = 1;
    END IF;
END WHILE;

-- 查看结果
SELECT COUNT(*) as new_total FROM sys_student;
SELECT class_name, COUNT(*) as count FROM sys_student GROUP BY class_name ORDER BY class_name;