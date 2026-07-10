USE stusys;

-- Generate 100 students using MySQL loop
-- This script will create a stored procedure to generate students

-- Drop procedure if it exists
DROP PROCEDURE IF EXISTS generate_students;

DELIMITER //
CREATE PROCEDURE generate_students()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total_students INT DEFAULT 100;
    DECLARE current_count INT DEFAULT 0;
    
    -- Get current student count
    SELECT COUNT(*) INTO current_count FROM sys_student;
    
    -- Calculate how many more students we need
    SET total_students = total_students - current_count;
    
    -- Generate the remaining students
    WHILE i <= total_students DO
        -- Calculate values for this student
        SET @student_number = current_count + i;
        SET @user_id = 16 + @student_number;
        SET @student_id = CONCAT('2023', LPAD(@student_number, 3, '0'));
        SET @user_name = CONCAT('student', LPAD(@student_number, 3, '0'));
        SET @name = CONCAT('Student', LPAD(@student_number, 3, '0'));
        SET @email = CONCAT(@user_name, '@example.com');
        SET @phone = CONCAT('13800138', LPAD(@student_number, 3, '0'));
        
        -- Insert student record
        INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id)
        VALUES (@user_id, @student_id, @name, 'Male', @email, @phone, 'Computer Science 2023-1班', '在读', 1, 1);
        
        -- Increment counter
        SET i = i + 1;
    END WHILE;
    
    -- Return total count
    SELECT COUNT(*) FROM sys_student AS total_students;
END //
DELIMITER ;

-- Call the procedure to generate students
CALL generate_students();

-- Drop the procedure
DROP PROCEDURE IF EXISTS generate_students;