# PowerShell script to generate 100 students
$mysqlUser = "root"
$mysqlPass = "czx040805"
$mysqlDb = "stusys"

# Calculate how many more students we need
$currentCount = (mysql -u $mysqlUser -p$mysqlPass -D $mysqlDb -e "SELECT COUNT(*) FROM sys_student;")[-1].Trim()
$needed = 100 - [int]$currentCount

if ($needed -le 0) {
    Write-Host "Already have $currentCount students, no need to generate more."
    exit
}

Write-Host "Need to generate $needed more students."

# Generate the remaining students
for ($i = 1; $i -le $needed; $i++) {
    $studentNumber = [int]$currentCount + $i
    $userId = 16 + $studentNumber
    $studentId = "2023{0:D3}" -f $studentNumber
    $userName = "student{0:D3}" -f $studentNumber
    $name = "Student{0:D3}" -f $studentNumber
    $email = "{0}@example.com" -f $userName
    $phone = "13800138{0:D3}" -f $studentNumber
    
    Write-Host "Generating student $userName with ID $studentId..."
    
    $sql = "INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES ($userId, '$studentId', '$name', 'Male', '$email', '$phone', 'Computer Science 2023-1班', 'Enrolled', 1, 1);"
    
    mysql -u $mysqlUser -p$mysqlPass -D $mysqlDb -e $sql
}

Write-Host "Done!"
Write-Host "Final student count:"
mysql -u $mysqlUser -p$mysqlPass -D $mysqlDb -e "SELECT COUNT(*) FROM sys_student;"