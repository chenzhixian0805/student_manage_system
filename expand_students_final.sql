-- 扩充学生人数到200人
-- 当前已有50名学生，需要新增150名学生

DELIMITER //

CREATE PROCEDURE AddStudents()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE student_id INT DEFAULT 20230051;
    DECLARE user_id INT DEFAULT 62;
    DECLARE class_id INT DEFAULT 1;
    DECLARE major_id INT DEFAULT 1;
    DECLARE class_name VARCHAR(50) DEFAULT '';
    
    -- 姓名前缀和后缀列表
    DECLARE first_names VARCHAR(20)[] DEFAULT ['张', '李', '王', '刘', '陈', '杨', '赵', '黄', '周', '吴'];
    DECLARE last_names VARCHAR(20)[] DEFAULT ['明', '华', '强', '芳', '磊', '娜', '伟', '敏', '静', '丽', '涛', '辉', '燕', '超', '秀'];
    
    -- 循环生成150名学生
    WHILE i < 150 DO
        -- 获取班级信息
        SELECT major_id, class_name INTO major_id, class_name FROM sys_class WHERE id = class_id;
        
        -- 生成随机姓名
        SET @first_name = first_names[FLOOR(RAND() * 10) + 1];
        SET @last_name = last_names[FLOOR(RAND() * 15) + 1];
        SET @full_name = CONCAT(@first_name, @last_name);
        
        -- 生成随机性别
        SET @gender = IF(RAND() > 0.5, '男', '女');
        
        -- 生成随机手机号
        SET @phone = CONCAT('138', LPAD(FLOOR(RAND() * 100000000), 8, '0'));
        
        -- 生成邮箱
        SET @email = CONCAT('student', student_id, '@example.com');
        
        -- 生成身份证号（模拟）
        SET @id_card = CONCAT('110101', FLOOR(2000 + RAND() * 5), LPAD(FLOOR(1 + RAND() * 12), 2, '0'), LPAD(FLOOR(1 + RAND() * 28), 2, '0'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
        
        -- 插入用户表
        INSERT INTO sys_user (create_time, update_time, real_name, password, phone, email, employee_id, role, status, user_name) 
        VALUES (NOW(), NOW(), @full_name, 'password123', @phone, @email, CONCAT('S', student_id), 'ROLE_STUDENT', 1, student_id);
        
        -- 插入学生表
        INSERT INTO sys_student (create_time, update_time, student_id, name, gender, class_name, status, major_id, user_id, id_card, phone, email) 
        VALUES (NOW(), NOW(), student_id, @full_name, @gender, class_name, '在读', major_id, user_id, @id_card, @phone, @email);
        
        -- 更新计数器
        SET i = i + 1;
        SET student_id = student_id + 1;
        SET user_id = user_id + 1;
        
        -- 更新班级ID（循环1-12）
        SET class_id = class_id + 1;
        IF class_id > 12 THEN
            SET class_id = 1;
        END IF;
    END WHILE;
END //

DELIMITER ;

-- 执行存储过程
CALL AddStudents();

-- 查看结果
SELECT COUNT(*) as total_students FROM sys_student;
SELECT class_name, COUNT(*) as student_count FROM sys_student GROUP BY class_name ORDER BY class_name;

-- 删除存储过程
DROP PROCEDURE AddStudents;