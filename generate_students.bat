@echo off
setlocal enabledelayedexpansion

set MYSQL_USER=root
set MYSQL_PASS=czx040805
set MYSQL_DB=stusys

:: Get current student count
for /f "skip=3 tokens=1" %%i in ('mysql -u %MYSQL_USER% -p%MYSQL_PASS% -D %MYSQL_DB% -e "SELECT COUNT(*) FROM sys_student;"') do set CURRENT_COUNT=%%i

echo Current student count: %CURRENT_COUNT%

:: Calculate how many more students we need
set TOTAL_STUDENTS=100
set /a NEEDED=%TOTAL_STUDENTS%-%CURRENT_COUNT%

echo Need to generate %NEEDED% more students.

if %NEEDED% leq 0 (
    echo Already have %CURRENT_COUNT% students, no need to generate more.
    exit /b 0
)

:: Generate the remaining students
set /a START_ID=%CURRENT_COUNT%+1
set /a END_ID=%TOTAL_STUDENTS%

for /l %%i in (%START_ID%,1,%END_ID%) do (
    echo Generating student %%i of %END_ID%...
    
    :: Calculate values for this student
    set STUDENT_ID=2023000%%i
    set STUDENT_ID=!STUDENT_ID:~-6!
    set USER_ID=16+%%i
    set USER_NAME=student000%%i
    set USER_NAME=!USER_NAME:~-7!
    set NAME=Student!STUDENT_ID:~-3!
    set EMAIL=!USER_NAME!@example.com
    set PHONE=13800138!STUDENT_ID:~-3!
    
    :: Execute the INSERT statement
    mysql -u %MYSQL_USER% -p%MYSQL_PASS% -D %MYSQL_DB% -e "INSERT INTO sys_student (user_id, student_id, name, gender, email, phone, class_name, status, college_id, major_id) VALUES (%USER_ID%, '!STUDENT_ID!', '!NAME!', 'Male', '!EMAIL!', '!PHONE!', 'Computer Science 2023-1班', '在读', 1, 1);"
)

echo Done!
echo Final student count:
mysql -u %MYSQL_USER% -p%MYSQL_PASS% -D %MYSQL_DB% -e "SELECT COUNT(*) FROM sys_student;"