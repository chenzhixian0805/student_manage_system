-- 创建存储过程生成100个学生数据
USE stusys;
DELIMITER //
CREATE PROCEDURE generate_100_students()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE user_id INT DEFAULT 17;
    DECLARE student_id INT DEFAULT 2023001;
    DECLARE college_id INT;
    DECLARE major_id INT;
    DECLARE class_name VARCHAR(100);
    
    -- 密码哈希值（bcrypt加密，密码为123456）
    DECLARE password_hash VARCHAR(60) DEFAULT '$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6';
    
    WHILE i < 100 DO
        -- 计算学院ID（1-6）
        SET college_id = (i % 6) + 1;
        
        -- 计算专业ID（1-12，每个学院2个专业）
        SET major_id = ((i % 6) * 2) + (i % 2) + 1;
        
        -- 根据专业ID确定班级名称
        CASE major_id
            WHEN 1 THEN SET class_name = '计算机科学与技术2301';
            WHEN 2 THEN SET class_name = '软件工程2301';
            WHEN 3 THEN SET class_name = '数学与应用数学2301';
            WHEN 4 THEN SET class_name = '信息与计算科学2301';
            WHEN 5 THEN SET class_name = '电子信息工程2301';
            WHEN 6 THEN SET class_name = '通信工程2301';
            WHEN 7 THEN SET class_name = '机械工程2301';
            WHEN 8 THEN SET class_name = '机械设计制造及其自动化2301';
            WHEN 9 THEN SET class_name = '财务管理2301';
            WHEN 10 THEN SET class_name = '工商管理2301';
            WHEN 11 THEN SET class_name = '英语2301';
            WHEN 12 THEN SET class_name = '日语2301';
        END CASE;
        
        -- 插入用户记录
        INSERT INTO stusys.sys_user (user_name, password, real_name, role, status, email, phone)
        VALUES (student_id, password_hash, CONCAT('Student_', i), 'ROLE_STUDENT', 1, CONCAT('student', i, '@example.com'), CONCAT('13800138', LPAD(i + 100, 3, '0')));
        
        -- 插入学生记录
        INSERT INTO stusys.sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, major_id, college_id)
        VALUES (user_id, student_id, CONCAT('Student_', i), IF(i % 2 = 0, '男', '女'), DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 3650) DAY), class_name, CONCAT('13800138', LPAD(i + 100, 3, '0')), CONCAT('student', i, '@example.com'), '在读', '2023-09-01', major_id, college_id);
        
        SET i = i + 1;
        SET user_id = user_id + 1;
        SET student_id = student_id + 1;
    END WHILE;
END //
DELIMITER ;

-- 执行存储过程
begin;
CALL stusys.generate_100_students();
commit;

-- 删除存储过程
drop procedure stusys.generate_100_students;