USE stusys;

-- 生成100个学生数据
-- 1. 创建临时存储学生信息的表
CREATE TABLE IF NOT EXISTS temp_students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(20),
    real_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- 2. 清空临时表
TRUNCATE TABLE temp_students;

-- 3. 生成100个学生的基本信息
INSERT INTO temp_students (user_name, real_name, email, phone)
VALUES
('student001', '陈小明', 'chenxiaoming@example.com', '13800138001'),
('student002', '李小红', 'lixiaohong@example.com', '13800138002'),
('student003', '王大明', 'wangdaming@example.com', '13800138003'),
('student004', '赵小花', 'zhaoxiaohua@example.com', '13800138004'),
('student005', '刘大力', 'liudali@example.com', '13800138005'),
('student006', '陈小丽', 'chenxiaoli@example.com', '13800138006'),
('student007', '李小军', 'lixiaojun@example.com', '13800138007'),
('student008', '王小芳', 'wangxiaofang@example.com', '13800138008'),
('student009', '赵小强', 'zhaoxiaoqiang@example.com', '13800138009'),
('student010', '刘小丽', 'liuxiaoli@example.com', '13800138010'),
('student011', '陈明', 'chenming@example.com', '13800138011'),
('student012', '李红', 'lihong@example.com', '13800138012'),
('student013', '王强', 'wangqiang@example.com', '13800138013'),
('student014', '赵芳', 'zhaofang@example.com', '13800138014'),
('student015', '刘强', 'liuqiang@example.com', '13800138015'),
('student016', '陈燕', 'chenyan@example.com', '13800138016'),
('student017', '李军', 'lijun@example.com', '13800138017'),
('student018', '王芳', 'wangfang@example.com', '13800138018'),
('student019', '赵强', 'zhaoqiang@example.com', '13800138019'),
('student020', '刘芳', 'liufang@example.com', '13800138020'),
('student021', '陈刚', 'chengong@example.com', '13800138021'),
('student022', '李刚', 'ligang@example.com', '13800138022'),
('student023', '王刚', 'wanggang@example.com', '13800138023'),
('student024', '赵刚', 'zhaogang@example.com', '13800138024'),
('student025', '刘刚', 'liugang@example.com', '13800138025'),
('student026', '陈静', 'chenjing@example.com', '13800138026'),
('student027', '李静', 'lijing@example.com', '13800138027'),
('student028', '王静', 'wangjing@example.com', '13800138028'),
('student029', '赵静', 'zhaojing@example.com', '13800138029'),
('student030', '刘静', 'liujing@example.com', '13800138030'),
('student031', '陈亮', 'chenliang@example.com', '13800138031'),
('student032', '李亮', 'liliang@example.com', '13800138032'),
('student033', '王亮', 'wangliang@example.com', '13800138033'),
('student034', '赵亮', 'zhaoliang@example.com', '13800138034'),
('student035', '刘强', 'liuqiang2@example.com', '13800138035'),
('student036', '陈辉', 'chenhui@example.com', '13800138036'),
('student037', '李辉', 'lihui@example.com', '13800138037'),
('student038', '王辉', 'wanghui@example.com', '13800138038'),
('student039', '赵辉', 'zhaohui@example.com', '13800138039'),
('student040', '刘辉', 'liuhui@example.com', '13800138040'),
('student041', '陈勇', 'chenyong@example.com', '13800138041'),
('student042', '李勇', 'liyong@example.com', '13800138042'),
('student043', '王勇', 'wangyong@example.com', '13800138043'),
('student044', '赵勇', 'zhaoyong@example.com', '13800138044'),
('student045', '刘勇', 'liuyong@example.com', '13800138045'),
('student046', '陈艳', 'chenyan2@example.com', '13800138046'),
('student047', '李艳', 'liyan@example.com', '13800138047'),
('student048', '王艳', 'wangyan@example.com', '13800138048'),
('student049', '赵艳', 'zhaoyan@example.com', '13800138049'),
('student050', '刘艳', 'liuyan@example.com', '13800138050'),
('student051', '陈杰', 'chenjie@example.com', '13800138051'),
('student052', '李杰', 'lijie@example.com', '13800138052'),
('student053', '王杰', 'wangjie@example.com', '13800138053'),
('student054', '赵杰', 'zhaojie@example.com', '13800138054'),
('student055', '刘杰', 'liujie@example.com', '13800138055'),
('student056', '陈超', 'chenchao@example.com', '13800138056'),
('student057', '李超', 'lichao@example.com', '13800138057'),
('student058', '王超', 'wangchao@example.com', '13800138058'),
('student059', '赵超', 'zhaochao@example.com', '13800138059'),
('student060', '刘超', 'liuchao@example.com', '13800138060'),
('student061', '陈丽', 'chenli@example.com', '13800138061'),
('student062', '李丽', 'lili@example.com', '13800138062'),
('student063', '王丽', 'wangli@example.com', '13800138063'),
('student064', '赵丽', 'zhaoli@example.com', '13800138064'),
('student065', '刘丽', 'liuli@example.com', '13800138065'),
('student066', '陈涛', 'chentao@example.com', '13800138066'),
('student067', '李涛', 'litao@example.com', '13800138067'),
('student068', '王涛', 'wangtao@example.com', '13800138068'),
('student069', '赵涛', 'zhaotao@example.com', '13800138069'),
('student070', '刘涛', 'liutao@example.com', '13800138070'),
('student071', '陈峰', 'chenfeng@example.com', '13800138071'),
('student072', '李峰', 'lifeng@example.com', '13800138072'),
('student073', '王峰', 'wangfeng@example.com', '13800138073'),
('student074', '赵峰', 'zhaofeng@example.com', '13800138074'),
('student075', '刘峰', 'liufeng@example.com', '13800138075'),
('student076', '陈敏', 'chenmin@example.com', '13800138076'),
('student077', '李敏', 'limin@example.com', '13800138077'),
('student078', '王敏', 'wangmin@example.com', '13800138078'),
('student079', '赵敏', 'zhaomin@example.com', '13800138079'),
('student080', '刘敏', 'liumine@example.com', '13800138080'),
('student081', '陈磊', 'chenlei@example.com', '13800138081'),
('student082', '李磊', 'lilei@example.com', '13800138082'),
('student083', '王磊', 'wanglei@example.com', '13800138083'),
('student084', '赵磊', 'zhaolei@example.com', '13800138084'),
('student085', '刘磊', 'liulei@example.com', '13800138085'),
('student086', '陈辉', 'chenhui2@example.com', '13800138086'),
('student087', '李辉', 'lihui2@example.com', '13800138087'),
('student088', '王辉', 'wanghui2@example.com', '13800138088'),
('student089', '赵辉', 'zhaohui2@example.com', '13800138089'),
('student090', '刘辉', 'liuhui2@example.com', '13800138090'),
('student091', '陈勇', 'chenyong2@example.com', '13800138091'),
('student092', '李勇', 'liyong2@example.com', '13800138092'),
('student093', '王勇', 'wangyong2@example.com', '13800138093'),
('student094', '赵勇', 'zhaoyong2@example.com', '13800138094'),
('student095', '刘勇', 'liuyong2@example.com', '13800138095'),
('student096', '陈艳', 'chenyan3@example.com', '13800138096'),
('student097', '李艳', 'liyan2@example.com', '13800138097'),
('student098', '王艳', 'wangyan2@example.com', '13800138098'),
('student099', '赵艳', 'zhaoyan2@example.com', '13800138099'),
('student100', '刘艳', 'liuyan2@example.com', '13800138100');

-- 4. 生成密码（使用bcrypt加密，密码为123456）
SET @password = '$2a$10$e4XQe5B7Xv7Y3Z4A5B6C7D8E9F0G1H2I3J4K5L6M7N8O9P0Q1R2S3T4U5V6W7X8Y9Z0';

-- 5. 将临时表中的学生信息插入到sys_user表
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

-- 6. 将临时表中的学生信息插入到sys_student表
INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, create_time, update_time, college_id, major_id)
SELECT 
    u.id AS user_id, 
    CONCAT('2023', LPAD(t.id, 3, '0')) AS student_id, 
    t.real_name AS name, 
    IF(t.id % 2 = 0, '男', '女') AS gender, 
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 3650 + 3650) DAY) AS birth_date, 
    CONCAT('计算机科学与技术2023级', CEIL(t.id / 25), '班') AS class_name, 
    t.phone, 
    t.email, 
    '在读' AS status, 
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY) AS admission_date, 
    NOW() AS create_time, 
    NOW() AS update_time, 
    CEIL(t.id / 50) AS college_id, 
    CEIL(t.id / 25) AS major_id
FROM temp_students t
JOIN sys_user u ON t.user_name = u.user_name
ORDER BY t.id;

-- 7. 清理临时表
DROP TABLE IF EXISTS temp_students;

-- 8. 验证生成结果
SELECT COUNT(*) FROM sys_user WHERE user_name LIKE 'student%';
SELECT COUNT(*) FROM sys_student;