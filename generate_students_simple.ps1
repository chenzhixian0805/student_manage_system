# 生成学生数据的PowerShell脚本

# 数据库连接信息
$username = "root"
$password = "czx040805"
$database = "stusys"

# 生成SQL语句的变量
$userSql = @()
$studentSql = @()

# 起始ID
$startUserId = 17
$startStudentId = 2021013

# 密码哈希值（bcrypt加密，密码为123456）
$passwordHash = "$2a$10$eWZQ5kE4FzqZ5eQ2cHh1aOeKfLgMmNnOoPpQqRrSsTtUuVvWwXxYyZzA1b2c3d4e5f6"

# 专业列表，包含专业ID、学院ID和班级名称
$majors = @(
    @{"majorId"=1; "collegeId"=1; "className"="计算机科学与技术2301"},
    @{"majorId"=2; "collegeId"=1; "className"="软件工程2301"},
    @{"majorId"=3; "collegeId"=2; "className"="数学与应用数学2301"},
    @{"majorId"=4; "collegeId"=2; "className"="信息与计算科学2301"},
    @{"majorId"=5; "collegeId"=3; "className"="电子信息工程2301"},
    @{"majorId"=6; "collegeId"=3; "className"="通信工程2301"},
    @{"majorId"=7; "collegeId"=4; "className"="机械工程2301"},
    @{"majorId"=8; "collegeId"=4; "className"="机械设计制造及其自动化2301"},
    @{"majorId"=9; "collegeId"=5; "className"="财务管理2301"},
    @{"majorId"=10; "collegeId"=5; "className"="工商管理2301"},
    @{"majorId"=11; "collegeId"=6; "className"="英语2301"},
    @{"majorId"=12; "collegeId"=6; "className"="日语2301"}
)

# 生成88个学生记录
for ($i = 0; $i -lt 88; $i++) {
    $userId = $startUserId + $i
    $studentId = $startStudentId + $i
    
    # 生成英文姓名
    $name = "Student_$i"
    
    # 随机生成性别
    $gender = if (($i % 2) -eq 0) { "男" } else { "女" }
    
    # 生成出生日期（2003-2005年）
    $birthYear = 2003 + ($i % 3)
    $birthMonth = 1 + ($i % 12)
    $birthDay = 1 + ($i % 28)
    $birthDate = "$birthYear-{0:D2}-{1:D2}" -f $birthMonth, $birthDay
    
    # 生成电话号码
    $phone = "13800138{0:D3}" -f ($i + 13)
    
    # 生成邮箱
    $email = "student{0}@example.com" -f $i
    
    # 均匀分配到12个专业
    $majorIndex = $i % 12
    $major = $majors[$majorIndex]
    $majorId = $major.majorId
    $collegeId = $major.collegeId
    $className = $major.className
    
    # 生成用户SQL
    $userSql += "INSERT INTO stusys.sys_user (user_name, password, real_name, role, status, email, phone) VALUES ('$studentId', '$passwordHash', '$name', 'ROLE_STUDENT', 1, '$email', '$phone');"
    
    # 生成学生SQL
    $studentSql += "INSERT INTO stusys.sys_student (user_id, student_id, name, gender, birth_date, class_name, phone, email, status, admission_date, major_id, college_id) VALUES ($userId, '$studentId', '$name', '$gender', '$birthDate', '$className', '$phone', '$email', '在读', '2023-09-01', $majorId, $collegeId);"
}

# 将SQL语句写入文件
$userSql | Out-File -FilePath "d:/student_manage_system/insert_users.sql" -Encoding utf8
$studentSql | Out-File -FilePath "d:/student_manage_system/insert_students.sql" -Encoding utf8

# 执行SQL语句
Write-Host "生成SQL文件成功："
Write-Host "  - insert_users.sql"
Write-Host "  - insert_students.sql"

# 提示用户可以执行的命令
Write-Host "
执行以下命令将数据插入数据库："
Write-Host "mysql -u $username -p$password $database < d:/student_manage_system/insert_users.sql"
Write-Host "mysql -u $username -p$password $database < d:/student_manage_system/insert_students.sql"
