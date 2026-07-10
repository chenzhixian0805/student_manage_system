# PowerShell脚本：批量添加84个学生，使总数达到100个

$mysqlUser = "root"
$mysqlPass = "czx040805"
$dbName = "stusys"

# 获取当前最大用户ID
$maxUserId = mysql -u $mysqlUser -p$mysqlPass -e "USE $dbName; SELECT MAX(id) FROM sys_user;" | Select-Object -Skip 2 | ForEach-Object { $_.Trim() }
$currentUserId = [int]$maxUserId + 1
$currentStudentId = 17  # 从2023017开始

# 姓氏和名字列表（用于生成真实姓名）
$lastNames = @("王", "李", "张", "刘", "陈", "杨", "赵", "黄", "周", "吴",
               "徐", "孙", "胡", "朱", "高", "林", "何", "郭", "马", "罗",
               "梁", "宋", "郑", "谢", "韩", "唐", "冯", "于", "董", "萧")

$maleFirstNames = @("浩然", "博宇", "俊杰", "宇航", "思源", "宇轩", "浩然", "嘉豪", "思远", "雨泽",
                    "智轩", "子涵", "文博", "明轩", "子墨", "雨辰", "浩宇", "子轩", "俊杰", "文博")

$femaleFirstNames = @("雨桐", "思琪", "一诺", "欣怡", "雨萌", "梦瑶", "思涵", "欣悦", "雨涵", "雨彤",
                      "一诺", "语桐", "可欣", "语涵", "梓涵", "雨萱", "雨琪", "思妍", "欣妍", "语馨")

# 学院和专业映射
$collegeMajorMap = @{
    1 = @(1, 2, 3)    # 计算机学院：计算机科学与技术、软件工程、网络工程
    2 = @(4, 5, 6)    # 电子信息学院：电子信息工程、通信工程、自动化
    3 = @(7, 8)       # 机械工程学院：机械工程、土木工程
    4 = @(9, 10)      # 化工学院：化学工程、生物工程
    5 = @(11, 12, 13) # 经济管理学院：经济管理、市场营销、会计学
    6 = @(14)         # 法学院：法学
    7 = @(15, 16)     # 外国语学院：英语、汉语言文学
}

# 班级列表
$classNames = @(
    "计算机科学与技术23-1", "计算机科学与技术23-2",
    "软件工程23-1", "软件工程23-2",
    "网络工程23-1", "网络工程23-2",
    "电子信息工程23-1", "电子信息工程23-2",
    "通信工程23-1", "通信工程23-2",
    "自动化23-1", "自动化23-2",
    "机械工程23-1", "机械工程23-2",
    "土木工程23-1", "土木工程23-2",
    "化学工程23-1", "化学工程23-2",
    "生物工程23-1", "生物工程23-2",
    "经济管理23-1", "经济管理23-2",
    "市场营销23-1", "市场营销23-2",
    "会计学23-1", "会计学23-2",
    "法学23-1", "法学23-2",
    "英语23-1", "英语23-2",
    "汉语言文学23-1", "汉语言文学23-2"
)

# 密码（统一使用相同的密码，bcrypt加密）
$password = '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW'

# 循环添加84个学生
for ($i = 0; $i -lt 84; $i++) {
    # 生成随机性别
    $gender = if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) { "男" } else { "女" }
    
    # 生成真实姓名
    $lastName = $lastNames[(Get-Random -Minimum 0 -Maximum $lastNames.Length)]
    if ($gender -eq "男") {
        $firstName = $maleFirstNames[(Get-Random -Minimum 0 -Maximum $maleFirstNames.Length)]
    } else {
        $firstName = $femaleFirstNames[(Get-Random -Minimum 0 -Maximum $femaleFirstNames.Length)]
    }
    $realName = $lastName + $firstName
    
    # 生成用户名
    $userName = "student{0:D3}" -f ($currentStudentId)
    
    # 生成学生ID
    $studentId = "2023{0:D3}" -f ($currentStudentId)
    
    # 随机选择学院和专业
    $collegeId = (Get-Random -Minimum 1 -Maximum 8)
    $majorList = $collegeMajorMap[$collegeId]
    $majorId = $majorList[(Get-Random -Minimum 0 -Maximum $majorList.Length)]
    
    # 随机选择班级
    $className = $classNames[(Get-Random -Minimum 0 -Maximum $classNames.Length)]
    
    # 生成邮箱和电话
    $email = "{0}@example.com" -f ($userName)
    $phone = "13800138{0:D3}" -f ($currentStudentId)
    
    # 生成出生日期（2004-2006年）
    $birthYear = Get-Random -Minimum 2004 -Maximum 2007
    $birthMonth = Get-Random -Minimum 1 -Maximum 13
    $birthDay = Get-Random -Minimum 1 -Maximum 29
    $birthDate = "{0}-{1:D2}-{2:D2}" -f ($birthYear, $birthMonth, $birthDay)
    
    # 入学日期固定为2023-09-01
    $admissionDate = "2023-09-01"
    
    Write-Host "正在添加学生：$realName ($userName)，用户ID：$currentUserId，学生ID：$studentId"
    
    # 添加用户记录
    $userSql = "INSERT INTO sys_user (user_name, password, role, real_name, status, email, phone) VALUES ('$userName', '$password', 'ROLE_STUDENT', '$realName', 1, '$email', '$phone');"
    mysql -u $mysqlUser -p$mysqlPass -e "USE $dbName; $userSql"
    
    # 添加学生记录
    $studentSql = "INSERT INTO sys_student (user_id, student_id, name, gender, birth_date, email, phone, class_name, status, admission_date, college_id, major_id) VALUES ($currentUserId, '$studentId', '$realName', '$gender', '$birthDate', '$email', '$phone', '$className', '在读', '$admissionDate', $collegeId, $majorId);"
    mysql -u $mysqlUser -p$mysqlPass -e "USE $dbName; $studentSql"
    
    # 更新计数器
    $currentUserId++
    $currentStudentId++
}

# 检查最终学生数量
Write-Host "\n添加完成！正在检查最终学生数量..."
mysql -u $mysqlUser -p$mysqlPass -e "USE $dbName; SELECT COUNT(*) FROM sys_student;"