-- 扩充学生人数到200人
-- 当前已有50名学生，需要新增150名学生

-- 1. 生成学生ID序列（从20230051开始）
-- 2. 为每个班级分配约12-13名学生
-- 3. 为每个学生创建用户账号

DELIMITER //

CREATE PROCEDURE ExpandStudents()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE student_id INT DEFAULT 20230051;
    DECLARE user_id INT DEFAULT 62;
    DECLARE class_id INT;
    DECLARE major_id INT;
    
    -- 班级ID列表，按照班级顺序分配学生
    DECLARE class_ids INT[] DEFAULT [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    DECLARE class_index INT DEFAULT 1;
    
    -- 姓名列表，用于生成随机姓名
    DECLARE first_names VARCHAR(20)[] DEFAULT ['张', '李', '王', '刘', '陈', '杨', '赵', '黄', '周', '吴'];
    DECLARE last_names VARCHAR(20)[] DEFAULT ['明', '华', '强', '芳', '磊', '娜', '伟', '敏', '静', '丽', '涛', '辉', '燕', '超', '秀'];
    
    -- 性别列表
    DECLARE genders VARCHAR(10)[] DEFAULT ['男', '女'];
    
    -- 循环生成150名学生
    WHILE i < 150 DO
        -- 计算当前班级ID（循环分配）
        SET class_id = class_ids[class_index];
        
        -- 根据班级ID获取专业ID
        SELECT major_id INTO major_id FROM sys_class WHERE id = class_id;
        
        -- 生成随机姓名
        SET @first_name = first_names[FLOOR(RAND() * 10) + 1];
        SET @last_name = last_names[FLOOR(RAND() * 15) + 1];
        SET @full_name = CONCAT(@first_name, @last_name);
        
        -- 生成随机性别
        SET @gender = genders[FLOOR(RAND() * 2) + 1];
        
        -- 生成随机手机号（138开头）
        SET @phone = CONCAT('138', LPAD(FLOOR(RAND() * 100000000), 8, '0'));
        
        -- 生成邮箱
        SET @email = CONCAT('student', student_id, '@example.com');
        
        -- 生成身份证号（模拟）
        SET @id_card = CONCAT('110101', FLOOR(2000 + RAND() * 5), LPAD(FLOOR(1 + RAND() * 12), 2, '0'), LPAD(FLOOR(1 + RAND() * 28), 2, '0'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
        
        -- 1. 插入用户表
        INSERT INTO sys_user (create_time, update_time, real_name, password, phone, email, employee_id, role, status, user_name) 
        VALUES (NOW(), NOW(), @full_name, 'password123', @phone, @email, CONCAT('S', student_id), 'ROLE_STUDENT', 1, student_id);
        
        -- 2. 插入学生表
        INSERT INTO sys_student (create_time, update_time, student_id, name, gender, class_name, status, major_id, user_id, id_card, phone, email) 
        VALUES (NOW(), NOW(), student_id, @full_name, @gender, (SELECT class_name FROM sys_class WHERE id = class_id), '在读', major_id, user_id, @id_card, @phone, @email);
        
        -- 递增计数器
        SET i = i + 1;
        SET student_id = student_id + 1;
        SET user_id = user_id + 1;
        
        -- 更新班级索引（循环12个班级）
        SET class_index = class_index + 1;
        IF class_index > 12 THEN
            SET class_index = 1;
        END IF;
    END WHILE;
END //

DELIMITER ;

-- 执行存储过程
CALL ExpandStudents();

-- 查看结果
SELECT COUNT(*) as total_students FROM sys_student;
SELECT class_name, COUNT(*) as count FROM sys_student GROUP BY class_name ORDER BY class_name;

-- 删除存储过程
DROP PROCEDURE ExpandStudents;