package com.example.studentmanagement.controller;

import com.example.studentmanagement.entity.Grade;
import com.example.studentmanagement.entity.GradeAnalysisResult;
import com.example.studentmanagement.entity.ResponseResult;
import com.example.studentmanagement.entity.Student;
import com.example.studentmanagement.entity.Course;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.repository.StudentRepository;
import com.example.studentmanagement.repository.CourseRepository;
import com.example.studentmanagement.repository.SelectionRepository;
import com.example.studentmanagement.service.GradeService;
import com.example.studentmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/grades")
public class GradeController {

    @Autowired
    private GradeService gradeService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private CourseRepository courseRepository;
    
    @Autowired
    private SelectionRepository selectionRepository;

    private Map<String, Object> toGradeMap(Grade grade) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", grade.getId());
        map.put("score", grade.getScore());
        map.put("gpa", grade.getGpa());
        map.put("semester", grade.getSemester());
        map.put("creditGpa", grade.getCreditGpa());
        map.put("examDateTime", grade.getExamDateTime() != null
                ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(grade.getExamDateTime())
                : null);

        Student student = grade.getStudent();
        if (student != null) {
            Map<String, Object> studentMap = new HashMap<>();
            studentMap.put("id", student.getId());
            studentMap.put("studentId", student.getStudentId());
            studentMap.put("name", student.getName());
            studentMap.put("className", student.getClassName());
            studentMap.put("gender", student.getGender());
            map.put("student", studentMap);
        } else {
            Map<String, Object> studentMap = new HashMap<>();
            studentMap.put("id", grade.getStudentId());
            studentMap.put("studentId", "");
            studentMap.put("name", "");
            studentMap.put("className", "");
            map.put("student", studentMap);
        }

        Course course = grade.getCourse();
        if (course != null) {
            Map<String, Object> courseMap = new HashMap<>();
            courseMap.put("id", course.getId());
            courseMap.put("courseId", course.getCourseId());
            courseMap.put("name", course.getName());
            courseMap.put("credit", course.getCredit());
            map.put("course", courseMap);
        } else {
            Map<String, Object> courseMap = new HashMap<>();
            courseMap.put("id", grade.getCourseId());
            courseMap.put("courseId", "");
            courseMap.put("name", "");
            map.put("course", courseMap);
        }

        return map;
    }

    private List<Map<String, Object>> toGradeMapList(List<Grade> grades) {
        if (grades == null) return new ArrayList<>();
        return grades.stream().map(this::toGradeMap).toList();
    }

    // 获取所有成绩 - 支持分页
    @GetMapping
    public ResponseResult<Map<String, Object>> getAllGrades(
            Principal principal, 
            @RequestParam(defaultValue = "0") int page, 
            @RequestParam(defaultValue = "20") int size) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 设置默认分页参数
            if (page < 0) page = 0;
            if (size < 1) size = 10;
            if (size > 100) size = 100; // 限制最大每页条数
            
            // 初始化默认响应值
            response.put("content", List.of());
            response.put("totalElements", 0);
            response.put("totalPages", 0);
            response.put("currentPage", page);
            response.put("pageSize", size);
            
            // 获取当前登录用户
            String username = principal != null ? principal.getName() : null;
            User currentUser = username != null ? userService.findByUsername(username) : null;
            
            if (currentUser == null) {
                // 如果用户未登录或不存在，返回错误
                return ResponseResult.error(401, "用户未登录");
            }
            
            // 根据用户角色返回对应成绩
            if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以查看所有成绩
                Page<Grade> gradePage = gradeService.getAllGrades(page, size);
                response.put("content", toGradeMapList(gradePage.getContent()));
                response.put("totalElements", gradePage.getTotalElements());
                response.put("totalPages", gradePage.getTotalPages());
                response.put("currentPage", gradePage.getNumber());
                response.put("pageSize", gradePage.getSize());
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能查看自己课程的成绩 - 暂不支持分页
                List<Grade> grades = gradeService.getGradesByTeacherId(currentUser.getId());
                List<Map<String, Object>> filteredGrades = grades != null ? grades.stream()
                    .filter(grade -> grade.getCourse() != null)
                    .map(this::toGradeMap)
                    .toList() : List.of();
                response.put("content", filteredGrades);
                response.put("totalElements", filteredGrades.size());
                response.put("totalPages", 1);
                response.put("currentPage", 0);
                response.put("pageSize", filteredGrades.size());
            } else {
                // 学生可以查看自己的成绩 - 暂不支持分页
                List<Grade> grades = gradeService.getGradesByStudentNumber(currentUser.getUsername());
                List<Map<String, Object>> filteredGrades = grades != null ? grades.stream()
                    .filter(grade -> grade.getCourse() != null)
                    .map(this::toGradeMap)
                    .toList() : List.of();
                response.put("content", filteredGrades);
                response.put("totalElements", filteredGrades.size());
                response.put("totalPages", 1);
                response.put("currentPage", 0);
                response.put("pageSize", filteredGrades.size());
            }
            
            return ResponseResult.success(response);
        } catch (Exception e) {
            // 记录详细错误日志
            e.printStackTrace();
            // 返回错误响应
            return ResponseResult.error(500, "获取成绩失败: " + e.getMessage());
        }
    }

    // 根据ID获取成绩
    @GetMapping("/{id}")
    public ResponseResult<Map<String, Object>> getGradeById(@PathVariable Long id, Principal principal) {
        Grade grade = gradeService.getGradeById(id);
        if (grade == null) {
            return ResponseResult.error(404, "Grade not found");
        }
        
        if (principal != null) {
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                if (grade.getCourse() == null) {
                    return ResponseResult.error(403, "无权限查看该成绩");
                }
                List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                boolean isTeacherCourse = teacherCourses.stream()
                    .anyMatch(course -> course.getId().equals(grade.getCourse().getId()));
                if (!isTeacherCourse) {
                    return ResponseResult.error(403, "无权限查看该成绩");
                }
            }
        }
        
        return ResponseResult.success(toGradeMap(grade));
    }

    // 用于接收前端传递的成绩数据
    public static class GradeRequest {
        private Long studentId;
        private Long courseId;
        private Double score;
        private Double gpa;
        private String semester;
        private String examDateTime; // 前端发送的是字符串格式，先接收为String类型
        
        // getter和setter方法
        public Long getStudentId() { return studentId; }
        public void setStudentId(Long studentId) { this.studentId = studentId; }
        public Long getCourseId() { return courseId; }
        public void setCourseId(Long courseId) { this.courseId = courseId; }
        public Double getScore() { return score; }
        public void setScore(Double score) { this.score = score; }
        public Double getGpa() { return gpa; }
        public void setGpa(Double gpa) { this.gpa = gpa; }
        public String getSemester() { return semester; }
        public void setSemester(String semester) { this.semester = semester; }
        public String getExamDateTime() { return examDateTime; }
        public void setExamDateTime(String examDateTime) { this.examDateTime = examDateTime; }
    }

    // 创建成绩
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    public ResponseResult<Map<String, Object>> createGrade(@RequestBody GradeRequest gradeRequest) {
        // 根据student_id查询对应的Student对象
        Student student = studentRepository.findById(gradeRequest.getStudentId()).orElse(null);
        if (student == null) {
            return ResponseResult.error(404, "Student not found");
        }
        
        // 根据course_id查询对应的Course对象
        Course course = courseRepository.findById(gradeRequest.getCourseId()).orElse(null);
        if (course == null) {
            return ResponseResult.error(404, "Course not found");
        }
        
        // 检查学生是否已经选了这门课程
        boolean isSelected = selectionRepository.existsByStudentIdAndCourseId(gradeRequest.getStudentId(), gradeRequest.getCourseId());
        if (!isSelected) {
            return ResponseResult.error(400, "学生尚未选这门课程，无法添加成绩");
        }
        
        // 创建Grade对象并设置属性
        Grade grade = new Grade();
        grade.setStudent(student);
        grade.setCourse(course);
        grade.setScore(gradeRequest.getScore());
        grade.setGpa(gradeRequest.getGpa());
        grade.setSemester(gradeRequest.getSemester());
        
        // 转换examDateTime为Date类型
        try {
            if (gradeRequest.getExamDateTime() != null && !gradeRequest.getExamDateTime().isEmpty()) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                java.util.Date examDate = sdf.parse(gradeRequest.getExamDateTime());
                grade.setExamDateTime(examDate);
            }
        } catch (java.text.ParseException e) {
            return ResponseResult.error(400, "Invalid exam datetime format");
        }
        
        // 保存成绩
        Grade savedGrade = gradeService.saveGrade(grade);
        return ResponseResult.success("Grade created successfully", toGradeMap(savedGrade));
    }

    // 更新成绩
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    public ResponseResult<Map<String, Object>> updateGrade(@PathVariable Long id, @RequestBody GradeRequest gradeRequest) {
        // 首先查询要更新的成绩
        Grade grade = gradeService.getGradeById(id);
        if (grade == null) {
            return ResponseResult.error(404, "Grade not found");
        }
        
        // 根据student_id查询对应的Student对象
        Student student = studentRepository.findById(gradeRequest.getStudentId()).orElse(null);
        if (student == null) {
            return ResponseResult.error(404, "Student not found");
        }
        
        // 根据course_id查询对应的Course对象
        Course course = courseRepository.findById(gradeRequest.getCourseId()).orElse(null);
        if (course == null) {
            return ResponseResult.error(404, "Course not found");
        }
        
        // 检查学生是否已经选了这门课程
        boolean isSelected = selectionRepository.existsByStudentIdAndCourseId(gradeRequest.getStudentId(), gradeRequest.getCourseId());
        if (!isSelected) {
            return ResponseResult.error(400, "学生尚未选这门课程，无法更新成绩");
        }
        
        // 更新Grade对象的属性
        grade.setStudent(student);
        grade.setCourse(course);
        grade.setScore(gradeRequest.getScore());
        grade.setGpa(gradeRequest.getGpa());
        grade.setSemester(gradeRequest.getSemester());
        
        // 转换examDateTime为Date类型
        try {
            if (gradeRequest.getExamDateTime() != null && !gradeRequest.getExamDateTime().isEmpty()) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                java.util.Date examDate = sdf.parse(gradeRequest.getExamDateTime());
                grade.setExamDateTime(examDate);
            }
        } catch (java.text.ParseException e) {
            return ResponseResult.error(400, "Invalid exam datetime format");
        }
        
        // 保存更新
        Grade updatedGrade = gradeService.saveGrade(grade);
        return ResponseResult.success("Grade updated successfully", toGradeMap(updatedGrade));
    }

    // 删除成绩
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    public ResponseResult<String> deleteGrade(@PathVariable Long id) {
        gradeService.deleteGrade(id);
        return ResponseResult.success("Grade deleted successfully");
    }

    // 根据学生ID获取成绩
    @GetMapping("/by-student/{studentId}")
    public ResponseResult<List<Map<String, Object>>> getGradesByStudentId(@PathVariable Long studentId, Principal principal) {
        try {
            List<Grade> grades = gradeService.getGradesByStudentId(studentId);
            
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null) {
                    if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                        // 教师只能查看自己课程的成绩
                        List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                        grades = grades.stream()
                            .filter(grade -> grade.getCourse() != null) // 添加null检查
                            .filter(grade -> {
                                Long gradeCourseId = grade.getCourse().getId();
                                return teacherCourses.stream()
                                    .anyMatch(course -> course.getId().equals(gradeCourseId));
                            })
                            .toList();
                    } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                        // 学生只能查看自己的成绩
                        // 首先获取当前学生的ID
                        Student currentStudent = studentRepository.findByStudentId(username);
                        if (currentStudent != null) {
                            // 检查请求的studentId是否与当前学生的ID匹配
                            if (!currentStudent.getId().equals(studentId)) {
                                // 不匹配，返回空列表
                                return ResponseResult.success(List.of());
                            }
                        }
                    }
                }
            }
            
            return ResponseResult.success(toGradeMapList(grades));
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生成绩失败: " + e.getMessage());
        }
    }

    // 根据课程ID获取成绩
    @GetMapping("/by-course/{courseId}")
    public ResponseResult<List<Map<String, Object>>> getGradesByCourseId(@PathVariable Long courseId, Principal principal) {
        try {
            if (principal != null) {
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean isTeacherCourse = teacherCourses.stream()
                        .anyMatch(course -> course.getId().equals(courseId));
                    if (!isTeacherCourse) {
                        return ResponseResult.error(403, "无权限查看该课程的成绩");
                    }
                }
            }
            
            List<Grade> grades = gradeService.getGradesByCourseId(courseId);
            return ResponseResult.success(toGradeMapList(grades));
        } catch (Exception e) {
            return ResponseResult.error(500, "获取课程成绩失败: " + e.getMessage());
        }
    }

    // 根据学期获取成绩
    @GetMapping("/by-semester/{semester}")
    public ResponseResult<List<Map<String, Object>>> getGradesBySemester(@PathVariable String semester, Principal principal) {
        try {
            List<Grade> grades;
            if (principal == null) {
                // 未登录，返回空列表
                grades = List.of();
            } else {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser == null) {
                    // 用户不存在，返回空列表
                    grades = List.of();
                } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                    // 管理员可以查看所有学期的成绩
                    grades = gradeService.getGradesBySemester(semester);
                } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的成绩
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    grades = gradeService.getGradesBySemester(semester).stream()
                        .filter(grade -> grade.getCourse() != null) // 添加null检查
                        .filter(grade -> {
                            Long gradeCourseId = grade.getCourse().getId();
                            return teacherCourses.stream()
                                .anyMatch(course -> course.getId().equals(gradeCourseId));
                        })
                        .toList();
                } else {
                    // 学生只能查看自己的成绩
                    grades = gradeService.getGradesByStudentNumber(username);
                    // 过滤出指定学期的成绩
                    grades = grades.stream()
                        .filter(grade -> semester.equals(grade.getSemester()))
                        .toList();
                }
            }
            
            return ResponseResult.success(toGradeMapList(grades));
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学期成绩失败: " + e.getMessage());
        }
    }

    // 根据学生ID和学期获取成绩
    @GetMapping("/by-student-and-semester/{studentId}/{semester}")
    public ResponseResult<List<Map<String, Object>>> getGradesByStudentIdAndSemester(@PathVariable Long studentId, @PathVariable String semester, Principal principal) {
        try {
            List<Grade> grades;
            if (principal != null) {
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    grades = gradeService.getGradesByStudentIdAndSemester(studentId, semester).stream()
                        .filter(grade -> grade.getCourse() != null)
                        .filter(grade -> {
                            Long gradeCourseId = grade.getCourse().getId();
                            return teacherCourses.stream()
                                .anyMatch(course -> course.getId().equals(gradeCourseId));
                        })
                        .toList();
                } else {
                    grades = gradeService.getGradesByStudentIdAndSemester(studentId, semester);
                }
            } else {
                grades = List.of();
            }
            
            return ResponseResult.success(toGradeMapList(grades));
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生学期成绩失败: " + e.getMessage());
        }
    }

    // 根据课程ID和学期获取成绩
    @GetMapping("/by-course-and-semester/{courseId}/{semester}")
    public ResponseResult<List<Map<String, Object>>> getGradesByCourseIdAndSemester(@PathVariable Long courseId, @PathVariable String semester, Principal principal) {
        try {
            if (principal != null) {
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean isTeacherCourse = teacherCourses.stream()
                        .anyMatch(course -> course.getId().equals(courseId));
                    if (!isTeacherCourse) {
                        return ResponseResult.error(403, "无权限查看该课程的成绩");
                    }
                }
            }
            
            List<Grade> grades = gradeService.getGradesByCourseIdAndSemester(courseId, semester);
            return ResponseResult.success(toGradeMapList(grades));
        } catch (Exception e) {
            return ResponseResult.error(500, "获取课程学期成绩失败: " + e.getMessage());
        }
    }

    // 获取课程平均分
    @GetMapping("/statistics/average/{courseId}")
    public ResponseResult<Double> getCourseAverageScore(@PathVariable Long courseId, Principal principal) {
        try {
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的成绩统计
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean isTeacherCourse = teacherCourses.stream()
                        .anyMatch(course -> course.getId().equals(courseId));
                    if (!isTeacherCourse) {
                        return ResponseResult.error(403, "无权限查看该课程的成绩统计");
                    }
                }
            }
            
            Double average = gradeService.calculateCourseAverageScore(courseId);
            return ResponseResult.success(average);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取课程平均分失败: " + e.getMessage());
        }
    }

    // 获取课程及格率
    @GetMapping("/statistics/pass-rate/{courseId}")
    public ResponseResult<Double> getCoursePassRate(@PathVariable Long courseId, Principal principal) {
        try {
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的成绩统计
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean isTeacherCourse = teacherCourses.stream()
                        .anyMatch(course -> course.getId().equals(courseId));
                    if (!isTeacherCourse) {
                        return ResponseResult.error(403, "无权限查看该课程的成绩统计");
                    }
                }
            }
            
            Double passRate = gradeService.calculateCoursePassRate(courseId);
            return ResponseResult.success(passRate);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取课程及格率失败: " + e.getMessage());
        }
    }

    // 获取课程优秀率
    @GetMapping("/statistics/excellent-rate/{courseId}")
    public ResponseResult<Double> getCourseExcellentRate(@PathVariable Long courseId, Principal principal) {
        try {
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的成绩统计
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean isTeacherCourse = teacherCourses.stream()
                        .anyMatch(course -> course.getId().equals(courseId));
                    if (!isTeacherCourse) {
                        return ResponseResult.error(403, "无权限查看该课程的成绩统计");
                    }
                }
            }
            
            Double excellentRate = gradeService.calculateCourseExcellentRate(courseId);
            return ResponseResult.success(excellentRate);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取课程优秀率失败: " + e.getMessage());
        }
    }
    
    // 获取成绩记录总数
    @GetMapping("/count")
    public ResponseResult<Long> getGradeCount(Principal principal) {
        try {
            long count;
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的成绩记录总数
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    count = gradeService.countGradesByCourses(teacherCourses);
                } else {
                    // 管理员可以查看所有成绩记录总数
                    count = gradeService.countTotalGrades();
                }
            } else {
                // 未登录，返回0
                count = 0;
            }
            
            return ResponseResult.success(count);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取成绩记录总数失败: " + e.getMessage());
        }
    }
    
    // 获取整体平均成绩
    @GetMapping("/statistics/average")
    public ResponseResult<Double> getOverallAverageScore(Principal principal) {
        Double average;
        if (principal != null) {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能查看自己课程的整体平均成绩
                List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                average = gradeService.calculateAverageScoreByCourses(teacherCourses);
            } else if (currentUser != null && "ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以查看所有成绩的整体平均成绩
                average = gradeService.calculateOverallAverageScore();
            } else {
                // 学生只能查看自己的整体平均成绩
                average = gradeService.calculateStudentAverageScore(currentUser.getId());
            }
        } else {
            // 未登录，返回0
            average = 0.0;
        }
        return ResponseResult.success(average);
    }
    
    // 获取学生GPA
    @GetMapping("/statistics/gpa/{studentId}")
    public ResponseResult<Double> getStudentGPA(@PathVariable Long studentId, Principal principal) {
        try {
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的学生GPA
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean hasAccess = gradeService.getGradesByStudentId(studentId).stream()
                        .filter(grade -> grade.getCourse() != null) // 添加null检查
                        .anyMatch(grade -> {
                            Long gradeCourseId = grade.getCourse().getId();
                            return teacherCourses.stream()
                                .anyMatch(course -> course.getId().equals(gradeCourseId));
                        });
                    if (!hasAccess) {
                        return ResponseResult.error(403, "无权限查看该学生的GPA");
                    }
                }
            }
            
            Double gpa = gradeService.calculateStudentGPA(studentId);
            return ResponseResult.success(gpa);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生GPA失败: " + e.getMessage());
        }
    }
    
    // 根据学生ID和课程ID获取成绩
    @GetMapping("/by-student-and-course/{studentId}/{courseId}")
    public ResponseResult<Grade> getGradeByStudentIdAndCourseId(@PathVariable Long studentId, @PathVariable Long courseId, Principal principal) {
        try {
            if (principal != null) {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的成绩
                    List<Course> teacherCourses = courseRepository.findByTeacher_Id(currentUser.getId());
                    boolean isTeacherCourse = teacherCourses.stream()
                        .anyMatch(course -> course.getId().equals(courseId));
                    if (!isTeacherCourse) {
                        return ResponseResult.error(403, "无权限查看该课程的成绩");
                    }
                }
            }
            
            Grade grade = gradeService.getGradeByStudentIdAndCourseId(studentId, courseId);
            return ResponseResult.success(toGradeMap(grade));
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生课程成绩失败: " + e.getMessage());
        }
    }
    
    // 获取成绩分布
    @GetMapping("/statistics/distribution")
    public ResponseResult<List<Long>> getScoreDistribution(Principal principal) {
        try {
            // 获取当前登录用户
            if (principal == null) {
                // 未登录用户，返回无权限
                return ResponseResult.error(403, "无权限获取成绩分布");
            }
            
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            List<Long> distribution;
            if (currentUser != null && "ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以获取所有成绩的分布
                distribution = gradeService.getScoreDistribution();
            } else if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能获取自己课程的成绩分布
                distribution = gradeService.getScoreDistributionByTeacherId(currentUser.getId());
            } else {
                // 学生不应该调用这个接口
                return ResponseResult.error(403, "无权限获取成绩分布");
            }
            
            return ResponseResult.success(distribution);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取成绩分布失败: " + e.getMessage());
        }
    }
    
    // 获取成绩分析结果
    @GetMapping("/statistics/analysis")
    public ResponseResult<GradeAnalysisResult> getGradeAnalysis(
            @RequestParam(required = false) Long course_id,
            @RequestParam(required = false) String semester) {
        try {
            GradeAnalysisResult result = gradeService.getGradeAnalysis(course_id, semester);
            return ResponseResult.success(result);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取成绩分析结果失败: " + e.getMessage());
        }
    }
    
    // 搜索成绩
    @GetMapping("/search")
    public ResponseResult<List<Map<String, Object>>> searchGrades(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String courseType,
            @RequestParam(required = false) String semester,
            Principal principal) {
        try {
            List<Grade> grades;
            
            // 获取当前登录用户
            String username = principal != null ? principal.getName() : null;
            User currentUser = username != null ? userService.findByUsername(username) : null;
            
            if (currentUser == null) {
                // 如果用户未登录或不存在，返回错误
                return ResponseResult.error(401, "用户未登录");
            }
            
            // 根据用户角色搜索成绩
            if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以搜索所有成绩
                grades = gradeService.getAllGrades();
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能搜索自己课程的成绩
                grades = gradeService.getGradesByTeacherId(currentUser.getId());
            } else {
                // 学生只能搜索自己的成绩
                grades = gradeService.getGradesByStudentNumber(currentUser.getUsername());
            }
            
            // 过滤成绩
            if (keyword != null && !keyword.isEmpty()) {
                grades = grades.stream()
                    .filter(grade -> {
                        // 按学生ID或姓名过滤
                        boolean matchesStudent = grade.getStudent() != null && 
                            (grade.getStudent().getStudentId().contains(keyword) || 
                             grade.getStudent().getName().contains(keyword));
                        // 按课程ID或名称过滤
                        boolean matchesCourse = grade.getCourse() != null && 
                            (grade.getCourse().getCourseId().contains(keyword) || 
                             grade.getCourse().getName().contains(keyword));
                        return matchesStudent || matchesCourse;
                    })
                    .toList();
            }
            
            // 按学期过滤
            if (semester != null && !semester.isEmpty()) {
                grades = grades.stream()
                    .filter(grade -> semester.equals(grade.getSemester()))
                    .toList();
            }
            
            return ResponseResult.success(toGradeMapList(grades));
        } catch (Exception e) {
            return ResponseResult.error(500, "搜索成绩失败: " + e.getMessage());
        }
    }
}
