# PowerShell script to generate 100 students in batches
$mysqlUser = "root"
$mysqlPass = "czx040805"
$mysqlDb = "stusys"

# Calculate how many more students we need
$currentCount = (mysql -u $mysqlUser -p$mysqlPass -D $mysqlDb -e "SELECT COUNT(*) FROM sys_student;")[-1].Trim()
$needed = 100 - [int]$currentCount

Write-Host "Current student count: $currentCount"
Write-Host "Need to generate $needed more students."

if ($needed -le 0) {
    Write-Host "Already have $currentCount students, no need to generate more."
    exit
}

# Generate students in batches of 10
$batchSize = 10
$batches = [math]::Ceiling($needed / $batchSize)

for ($batch = 0; $batch -lt $batches; $batch++) {
    $start = $batch * $batchSize + 1
    $end = [math]::Min(($batch + 1) * $batchSize, $needed)
    
    # Fix variable reference by using string concatenation
    Write-Host "Generating batch " ($batch + 1) " of " $batches ": students " $start " to " $end "..."
    
    # Build the INSERT statements for this batch
    $sql = ""
    for ($i = $start; $i -le $end; $i++) {
        $studentNumber = [int]$currentCount + $i
        $userId = 16 + $studentNumber
        $studentId = "2023{0:D3}" -f $studentNumber
        $userName = "student{0:D3}" -f $studentNumber
        $name = "Student{0:D3}" -f $studentNumber
        $email = "{0}@example.com" -f $userName
        $phone = "13800138{0:D3}" -f $studentNumber
        
        $sql += "INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES ($userId, '$studentId', '$name', 'Male', '$email', '$phone', 'Computer Science 2023-1班', '在读', 1, 1); "
    }
    
    # Append the verification query
    $sql += "SELECT COUNT(*) FROM sys_student;"
    
    # Execute the SQL command
    mysql -u $mysqlUser -p$mysqlPass -D $mysqlDb -e $sql
}

Write-Host "Done! Final student count:"
mysql -u $mysqlUser -p$mysqlPass -D $mysqlDb -e "SELECT COUNT(*) FROM sys_student;"