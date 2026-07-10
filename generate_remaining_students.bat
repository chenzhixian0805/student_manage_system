@echo off
setlocal enabledelayedexpansion

set MYSQL_USER=root
set MYSQL_PASS=czx040805
set MYSQL_DB=stusys

REM Generate students from 14 to 100
for /l %%i in (14,1,100) do (
    set /a user_id=16+%%i
    set "student_id=2023000%%i"
    set "student_id=!student_id:~-6!"
    set "user_name=student000%%i"
    set "user_name=!user_name:~-7!"
    
    echo Generating student !user_name! with ID !student_id!...
    
    mysql -u %MYSQL_USER% -p%MYSQL_PASS% -D %MYSQL_DB% -e "INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (!user_id!, '!student_id!', 'Student!student_id:~-3!', 'Male', '!user_name!@example.com', '13800138!student_id:~-3!', 'Computer Science 2023-1班', 'Enrolled', 1, 1);"
)

echo Done!
mysql -u %MYSQL_USER% -p%MYSQL_PASS% -D %MYSQL_DB% -e "SELECT COUNT(*) FROM sys_student;"