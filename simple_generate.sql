USE stusys;

-- Simple script to generate students
-- This script will generate students by inserting them one by one
-- It uses a simple loop structure that works directly in MySQL

-- Drop the temporary table if it exists
DROP TABLE IF EXISTS temp_students;

-- Create a temporary table to store student IDs
CREATE TABLE temp_students (
    id INT PRIMARY KEY AUTO_INCREMENT
);

-- Insert 100 rows into the temporary table
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);
INSERT INTO temp_students VALUES (NULL);

-- Now insert students into sys_student table
INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id)
SELECT 
    16 + t.id AS user_id,
    CONCAT('2023', LPAD(t.id, 3, '0')) AS student_id,
    CONCAT('Student', LPAD(t.id, 3, '0')) AS name,
    'Male' AS gender,
    CONCAT('student', LPAD(t.id, 3, '0'), '@example.com') AS email,
    CONCAT('13800138', LPAD(t.id, 3, '0')) AS phone,
    'Computer Science 2023-1班' AS class_name,
    '在读' AS status,
    1 AS college_id,
    1 AS major_id
FROM temp_students t
WHERE t.id <= 100
  AND NOT EXISTS (SELECT 1 FROM sys_student s WHERE s.student_id = CONCAT('2023', LPAD(t.id, 3, '0')));

-- Verify the results
SELECT COUNT(*) FROM sys_student;

-- Clean up the temporary table
DROP TABLE temp_students;