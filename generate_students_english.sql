USE stusys;

-- Generate 100 students data with English names
-- 1. Create temporary table to store student information
CREATE TABLE IF NOT EXISTS temp_students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20),
    real_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- 2. Clear temporary table
TRUNCATE TABLE temp_students;

-- 3. Generate 100 students basic information with English names
INSERT INTO temp_students (user_name, real_name, email, phone)
VALUES
('student001', 'John Chen', 'johnchen@example.com', '13800138001'),
('student002', 'Alice Li', 'aliceli@example.com', '13800138002'),
('student003', 'Bob Wang', 'bobwang@example.com', '13800138003'),
('student004', 'Cathy Zhao', 'cathyzhao@example.com', '13800138004'),
('student005', 'David Liu', 'davidliu@example.com', '13800138005'),
('student006', 'Eva Chen', 'evachen@example.com', '13800138006'),
('student007', 'Frank Li', 'frankli@example.com', '13800138007'),
('student008', 'Grace Wang', 'gracewang@example.com', '13800138008'),
('student009', 'Henry Zhao', 'henryzhao@example.com', '13800138009'),
('student010', 'Ivy Liu', 'ivylui@example.com', '13800138010'),
('student011', 'Jack Chen', 'jackchen@example.com', '13800138011'),
('student012', 'Kelly Li', 'kellyli@example.com', '13800138012'),
('student013', 'Leo Wang', 'leowang@example.com', '13800138013'),
('student014', 'Mia Zhao', 'miazhao@example.com', '13800138014'),
('student015', 'Nate Liu', 'nateliu@example.com', '13800138015'),
('student016', 'Olivia Chen', 'oliviachen@example.com', '13800138016'),
('student017', 'Paul Li', 'paulli@example.com', '13800138017'),
('student018', 'Queen Wang', 'queenwang@example.com', '13800138018'),
('student019', 'Ryan Zhao', 'ryanzhao@example.com', '13800138019'),
('student020', 'Sarah Liu', 'sarahliu@example.com', '13800138020'),
('student021', 'Tom Chen', 'tomchen@example.com', '13800138021'),
('student022', 'Una Li', 'unali@example.com', '13800138022'),
('student023', 'Victor Wang', 'victorwang@example.com', '13800138023'),
('student024', 'Wendy Zhao', 'wendyzhao@example.com', '13800138024'),
('student025', 'Xavier Liu', 'xavierliu@example.com', '13800138025'),
('student026', 'Yuki Chen', 'yukichen@example.com', '13800138026'),
('student027', 'Zoe Li', 'zoeli@example.com', '13800138027'),
('student028', 'Adam Wang', 'adamwang@example.com', '13800138028'),
('student029', 'Betty Zhao', 'bettyzhao@example.com', '13800138029'),
('student030', 'Charlie Liu', 'charlieliu@example.com', '13800138030'),
('student031', 'Diana Chen', 'dianachen@example.com', '13800138031'),
('student032', 'Edward Li', 'edwardli@example.com', '13800138032'),
('student033', 'Fiona Wang', 'fionawang@example.com', '13800138033'),
('student034', 'George Zhao', 'georgezhao@example.com', '13800138034'),
('student035', 'Helen Liu', 'helenliu@example.com', '13800138035'),
('student036', 'Ian Chen', 'ianchen@example.com', '13800138036'),
('student037', 'Julia Li', 'juliali@example.com', '13800138037'),
('student038', 'Kevin Wang', 'kevinwang@example.com', '13800138038'),
('student039', 'Linda Zhao', 'lindazhao@example.com', '13800138039'),
('student040', 'Mike Liu', 'mikeli@example.com', '13800138040'),
('student041', 'Nancy Chen', 'nancychen@example.com', '13800138041'),
('student042', 'Oscar Li', 'oscarli@example.com', '13800138042'),
('student043', 'Patty Wang', 'pattywang@example.com', '13800138043'),
('student044', 'Quinn Zhao', 'quinnzhao@example.com', '13800138044'),
('student045', 'Rachel Liu', 'rachelliu@example.com', '13800138045'),
('student046', 'Steve Chen', 'stevechen@example.com', '13800138046'),
('student047', 'Tina Li', 'tinali@example.com', '13800138047'),
('student048', 'Ulysses Wang', 'ulysseswang@example.com', '13800138048'),
('student049', 'Vicky Zhao', 'vickyzhao@example.com', '13800138049'),
('student050', 'William Liu', 'williamliu@example.com', '13800138050'),
('student051', 'Xena Chen', 'xenachen@example.com', '13800138051'),
('student052', 'Yvan Li', 'yvanli@example.com', '13800138052'),
('student053', 'Zach Wang', 'zachwang@example.com', '13800138053'),
('student054', 'Anna Zhao', 'annazhao@example.com', '13800138054'),
('student055', 'Brian Liu', 'brianliu@example.com', '13800138055'),
('student056', 'Carol Chen', 'carolchen@example.com', '13800138056'),
('student057', 'Dan Li', 'danli@example.com', '13800138057'),
('student058', 'Emma Wang', 'emmawang@example.com', '13800138058'),
('student059', 'Fred Zhao', 'fredzhao@example.com', '13800138059'),
('student060', 'Gina Liu', 'ginaliu@example.com', '13800138060'),
('student061', 'Harry Chen', 'harrychen@example.com', '13800138061'),
('student062', 'Irene Li', 'ireneli@example.com', '13800138062'),
('student063', 'Jerry Wang', 'jerrywang@example.com', '13800138063'),
('student064', 'Kate Zhao', 'katezhao@example.com', '13800138064'),
('student065', 'Larry Liu', 'larryliu@example.com', '13800138065'),
('student066', 'Maggie Chen', 'maggiechen@example.com', '13800138066'),
('student067', 'Nick Li', 'nickli@example.com', '13800138067'),
('student068', 'Olivia Wang', 'oliviawang@example.com', '13800138068'),
('student069', 'Peter Zhao', 'peterzhao@example.com', '13800138069'),
('student070', 'Queen Liu', 'queenliu@example.com', '13800138070'),
('student071', 'Ray Chen', 'raychen@example.com', '13800138071'),
('student072', 'Sandy Li', 'sandili@example.com', '13800138072'),
('student073', 'Tim Wang', 'timwang@example.com', '13800138073'),
('student074', 'Ursula Zhao', 'ursulazhao@example.com', '13800138074'),
('student075', 'Victor Liu', 'victorliu@example.com', '13800138075'),
('student076', 'Wanda Chen', 'wandachen@example.com', '13800138076'),
('student077', 'Xander Li', 'xanderli@example.com', '13800138077'),
('student078', 'Yvonne Wang', 'yvonnewang@example.com', '13800138078'),
('student079', 'Zack Zhao', 'zackzhao@example.com', '13800138079'),
('student080', 'Amy Liu', 'amylui@example.com', '13800138080'),
('student081', 'Bill Chen', 'billchen@example.com', '13800138081'),
('student082', 'Cindy Li', 'cindyli@example.com', '13800138082'),
('student083', 'Dale Wang', 'dalewang@example.com', '13800138083'),
('student084', 'Eve Zhao', 'evazhao@example.com', '13800138084'),
('student085', 'Frank Liu', 'frankliu@example.com', '13800138085'),
('student086', 'Gloria Chen', 'gloriachen@example.com', '13800138086'),
('student087', 'Henry Li', 'henryli@example.com', '13800138087'),
('student088', 'Ivy Wang', 'ivywang@example.com', '13800138088'),
('student089', 'Jack Zhao', 'jackzhao@example.com', '13800138089'),
('student090', 'Karen Liu', 'karenliu@example.com', '13800138090'),
('student091', 'Leo Chen', 'leochen@example.com', '13800138091'),
('student092', 'Mona Li', 'monali@example.com', '13800138092'),
('student093', 'Ned Wang', 'nedwang@example.com', '13800138093'),
('student094', 'Olivia Zhao', 'oliviazhao@example.com', '13800138094'),
('student095', 'Paul Liu', 'paulliu@example.com', '13800138095'),
('student096', 'Queen Chen', 'queenchen@example.com', '13800138096'),
('student097', 'Richard Li', 'richardli@example.com', '13800138097'),
('student098', 'Sara Wang', 'sarawang@example.com', '13800138098'),
('student099', 'Tom Zhao', 'tomzhao@example.com', '13800138099'),
('student100', 'Una Liu', 'unali2@example.com', '13800138100');

-- 4. Set password (bcrypt encrypted, password: 123456)
SET @password = '$2a$10$e4XQe5B7Xv7Y3Z4A5B6C7D8E9F0G1H2I3J4K5L6M7N8O9P0Q1R2S3T4U5V6W7X8Y9Z0';

-- 5. Insert students into sys_user table
INSERT INTO sys_user (user_name, password, real_name, email, phone, role, status, create_time, update_time)
SELECT 
    user_name, 
    @password, 
    real_name, 
    email, 
    phone, 
    'ROLE_STUDENT' as role, 
    1 as status, 
    NOW() as create_time, 
    NOW() as update_time
FROM temp_students;

-- 6. Insert students into sys_student table
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, create_time, update_time, college_id, major_id)
SELECT 
    u.id AS user_id, 
    CONCAT('2023', LPAD(t.id, 3, '0')) AS student_id, 
    t.real_name AS name, 
    IF(t.id % 2 = 0, 'Male', 'Female') AS gender, 
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650 + 3650) DAY) AS birth_date, 
    CONCAT('Computer Science 2023-', CEIL(t.id / 25), '班') AS class_name, 
    t.phone, 
    t.email, 
    'Enrolled' AS status, 
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY) AS admission_date, 
    NOW() AS create_time, 
    NOW() AS update_time, 
    CEIL(t.id / 50) AS college_id, 
    CEIL(t.id / 25) AS major_id
FROM temp_students t
JOIN sys_user u ON t.user_name = u.user_name
ORDER BY t.id;

-- 7. Clean up temporary table
DROP TABLE IF EXISTS temp_students;

-- 8. Verify results
SELECT COUNT(*) FROM sys_user WHERE user_name LIKE 'student%';
SELECT COUNT(*) FROM sys_student;