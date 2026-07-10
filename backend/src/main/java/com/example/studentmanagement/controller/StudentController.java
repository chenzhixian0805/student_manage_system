package com.example.studentmanagement.controller;

import com.example.studentmanagement.entity.ResponseResult;
import com.example.studentmanagement.entity.Student;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.service.StudentService;
import com.example.studentmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {

    @Autowired
    private StudentService studentService;
    
    @Autowired
    private UserService userService;

    // 获取所有学生
    @GetMapping
    public ResponseResult<List<Student>> getAllStudents(Principal principal) {
        try {
            List<Student> students;
            
            if (principal == null) {
                // 未登录，返回空列表
                students = List.of();
            } else {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                
                // 检查是否有管理员权限
                boolean isAdmin = false;
                if (currentUser != null && "ROLE_ADMIN".equals(currentUser.getRole())) {
                    isAdmin = true;
                } else {
                    // 检查SecurityContext中的权限
                    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
                    if (authentication != null && authentication.getAuthorities().stream()
                            .anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuthority()))) {
                        isAdmin = true;
                    }
                }
                
                if (isAdmin) {
                    // 管理员可以查看所有学生
                    students = studentService.getAllStudents();
                } else if (currentUser != null && "ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的学生
                    students = studentService.getStudentsByTeacherId(currentUser.getId());
                } else if (currentUser != null && "ROLE_STUDENT".equals(currentUser.getRole())) {
                    // 学生只能查看自己
                    Student student = studentService.getStudentByStudentId(username);
                    students = student != null ? List.of(student) : List.of();
                } else {
                    // 其他角色返回空列表
                    students = List.of();
                }
            }
            return ResponseResult.success(students);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生列表失败: " + e.getMessage());
        }
    }

    // 根据学号获取学生
    @GetMapping("/by-student-id/{studentId}")
    public ResponseResult<Student> getStudentByStudentId(@PathVariable String studentId, Principal principal) {
        try {
            Student student = studentService.getStudentByStudentId(studentId);
            if (student == null) {
                return ResponseResult.error(404, "Student not found");
            }
            
            if (principal == null) {
                // 未登录，直接返回学生信息
                return ResponseResult.success(student);
            }
            
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                // 用户不存在，直接返回学生信息
                return ResponseResult.success(student);
            }
            
            // 检查权限：管理员可以查看所有学生，教师只能查看自己课程的学生，学生只能查看自己
            if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                return ResponseResult.success(student);
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 检查该学生是否在教师的课程中
                List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                // 使用学生ID进行比较，而不是对象引用
                boolean isStudentInTeacherCourses = teacherStudents.stream()
                    .anyMatch(ts -> ts.getStudentId().equals(student.getStudentId()));
                if (isStudentInTeacherCourses) {
                    return ResponseResult.success(student);
                } else {
                    return ResponseResult.error(403, "无权限查看该学生");
                }
            } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                // 学生只能查看自己
                if (student.getStudentId().equals(username)) {
                    return ResponseResult.success(student);
                } else {
                    return ResponseResult.error(403, "无权限查看该学生");
                }
            } else {
                // 其他角色直接返回学生信息
                return ResponseResult.success(student);
            }
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生详情失败: " + e.getMessage());
        }
    }

    // 获取学生总数
    @GetMapping("/count")
    public ResponseResult<Long> getStudentCount(Principal principal) {
        try {
            long count;
            
            if (principal == null) {
                // 未登录，返回0
                count = 0;
            } else {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                
                if (currentUser == null) {
                    // 用户不存在，返回0
                    count = 0;
                } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                    // 管理员可以查看所有学生总数
                    count = studentService.countTotalStudents();
                } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己课程的学生总数
                    List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                    count = teacherStudents.size();
                } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                    // 学生只能查看自己
                    count = 1;
                } else {
                    // 其他角色返回0
                    count = 0;
                }
            }
            return ResponseResult.success(count);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生总数失败: " + e.getMessage());
        }
    }

    // 获取学生状态统计
    @GetMapping("/status-statistics")
    public ResponseResult<List<Object[]>> getStatusStatistics(Principal principal) {
        try {
            List<Object[]> statistics;
            
            if (principal == null) {
                // 未登录，返回所有学生状态统计
                statistics = studentService.countStudentsByStatus();
            } else {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                
                if (currentUser == null) {
                    // 用户不存在，返回所有学生状态统计
                    statistics = studentService.countStudentsByStatus();
                } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                    // 管理员可以获取所有学生状态统计
                    statistics = studentService.countStudentsByStatus();
                } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能获取自己课程的学生状态统计
                    List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                    // 手动统计状态
                    long enrolledCount = teacherStudents.stream().filter(s -> "在读".equals(s.getStatus())).count();
                    long suspendedCount = teacherStudents.stream().filter(s -> "休学".equals(s.getStatus())).count();
                    long droppedCount = teacherStudents.stream().filter(s -> "退学".equals(s.getStatus())).count();
                    long graduatedCount = teacherStudents.stream().filter(s -> "毕业".equals(s.getStatus())).count();
                    statistics = List.of(
                        new Object[]{"在读", enrolledCount},
                        new Object[]{"休学", suspendedCount},
                        new Object[]{"退学", droppedCount},
                        new Object[]{"毕业", graduatedCount}
                    );
                } else {
                    // 其他角色返回所有学生状态统计
                    statistics = studentService.countStudentsByStatus();
                }
            }
            return ResponseResult.success(statistics);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生状态统计失败: " + e.getMessage());
        }
    }
    
    // 获取学生性别统计
    @GetMapping("/gender-statistics")
    public ResponseResult<List<Object[]>> getGenderStatistics(Principal principal) {
        try {
            List<Object[]> statistics;
            
            if (principal == null) {
                // 未登录，返回所有学生性别统计
                statistics = studentService.countStudentsByGender();
            } else {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                
                if (currentUser == null) {
                    // 用户不存在，返回所有学生性别统计
                    statistics = studentService.countStudentsByGender();
                } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                    // 管理员可以获取所有学生性别统计
                    statistics = studentService.countStudentsByGender();
                } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能获取自己课程的学生性别统计
                    List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                    // 手动统计性别
                    long maleCount = teacherStudents.stream().filter(s -> "男".equals(s.getGender())).count();
                    long femaleCount = teacherStudents.stream().filter(s -> "女".equals(s.getGender())).count();
                    statistics = List.of(
                        new Object[]{"男", maleCount},
                        new Object[]{"女", femaleCount}
                    );
                } else {
                    // 其他角色返回所有学生性别统计
                    statistics = studentService.countStudentsByGender();
                }
            }
            return ResponseResult.success(statistics);
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生性别统计失败: " + e.getMessage());
        }
    }

    // 搜索学生
    @GetMapping("/search")
    public ResponseResult<List<Student>> searchStudents(@RequestParam(required = false) String keyword, 
                                                       @RequestParam(required = false) String className, 
                                                       Principal principal) {
        try {
            List<Student> students;
            
            if (principal == null) {
                // 未登录，返回所有学生或根据条件搜索
                students = studentService.searchStudents(keyword, className);
            } else {
                // 获取当前登录用户
                String username = principal.getName();
                User currentUser = userService.findByUsername(username);
                
                if (currentUser == null) {
                    // 用户不存在，返回所有学生或根据条件搜索
                    students = studentService.searchStudents(keyword, className);
                } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                    // 管理员可以搜索所有学生
                    students = studentService.searchStudents(keyword, className);
                } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能搜索自己课程的学生
                    List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                    // 如果有搜索条件，过滤结果
                    if (keyword != null && !keyword.isEmpty() || className != null && !className.isEmpty()) {
                        students = teacherStudents.stream()
                            .filter(student -> {
                                boolean matchesKeyword = keyword == null || keyword.isEmpty() || 
                                    student.getName().contains(keyword) || 
                                    student.getStudentId().contains(keyword);
                                boolean matchesClassName = className == null || className.isEmpty() || 
                                    student.getClassName().equals(className);
                                return matchesKeyword && matchesClassName;
                            })
                            .toList();
                    } else {
                        students = teacherStudents;
                    }
                } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                    // 学生只能查看自己
                    Student student = studentService.getStudentByStudentId(username);
                    students = student != null ? List.of(student) : List.of();
                } else {
                    // 其他角色返回所有学生或根据条件搜索
                    students = studentService.searchStudents(keyword, className);
                }
            }
            
            return ResponseResult.success(students);
        } catch (Exception e) {
            return ResponseResult.error(500, "搜索学生失败: " + e.getMessage());
        }
    }

    // 根据ID获取学生
    @GetMapping("/{id:[0-9]+}")
    public ResponseResult<Student> getStudentById(@PathVariable Long id, Principal principal) {
        try {
            Student student = studentService.getStudentById(id);
            if (student == null) {
                return ResponseResult.error(404, "Student not found");
            }
            
            if (principal == null) {
                // 未登录，直接返回学生信息
                return ResponseResult.success(student);
            }
            
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                // 用户不存在，直接返回学生信息
                return ResponseResult.success(student);
            }
            
            // 检查权限：管理员可以查看所有学生，教师只能查看自己课程的学生，学生只能查看自己
            if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                return ResponseResult.success(student);
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 检查该学生是否在教师的课程中
                List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                // 使用学生ID进行比较，而不是对象引用
                boolean isStudentInTeacherCourses = teacherStudents.stream()
                    .anyMatch(ts -> ts.getStudentId().equals(student.getStudentId()));
                if (isStudentInTeacherCourses) {
                    return ResponseResult.success(student);
                } else {
                    return ResponseResult.error(403, "无权限查看该学生");
                }
            } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                // 学生只能查看自己
                if (student.getStudentId().equals(username)) {
                    return ResponseResult.success(student);
                } else {
                    return ResponseResult.error(403, "无权限查看该学生");
                }
            } else {
                // 其他角色直接返回学生信息
                return ResponseResult.success(student);
            }
        } catch (Exception e) {
            return ResponseResult.error(500, "获取学生详情失败: " + e.getMessage());
        }
    }

    // 创建学生
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseResult<Student> createStudent(@RequestBody Student student, Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        try {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                return ResponseResult.error(401, "用户不存在");
            }
            
            // 只有管理员可以创建学生
            if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
                return ResponseResult.error(403, "无权限创建学生");
            }
            
            Student savedStudent = studentService.saveStudent(student);
            return ResponseResult.success("Student created successfully", savedStudent);
        } catch (Exception e) {
            return ResponseResult.error(500, "创建学生失败: " + e.getMessage());
        }
    }

    // 更新学生
    @PutMapping("/{id:[0-9]+}")
    public ResponseResult<Student> updateStudent(@PathVariable Long id, @RequestBody Student student, Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        try {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                return ResponseResult.error(401, "用户不存在");
            }
            
            Student existingStudent = studentService.getStudentById(id);
            if (existingStudent == null) {
                return ResponseResult.error(404, "Student not found");
            }
            
            // 检查权限：管理员可以更新所有学生，教师只能更新自己课程的学生，学生只能更新自己
            if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以更新所有学生
                Student updatedStudent = studentService.updateStudent(id, student);
                if (updatedStudent != null) {
                    return ResponseResult.success("Student updated successfully", updatedStudent);
                } else {
                    return ResponseResult.error(404, "Student not found");
                }
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能更新自己课程的学生
                List<Student> teacherStudents = studentService.getStudentsByTeacherId(currentUser.getId());
                // 使用学生ID进行比较，而不是对象引用
                boolean isStudentInTeacherCourses = teacherStudents.stream()
                    .anyMatch(ts -> ts.getStudentId().equals(existingStudent.getStudentId()));
                if (isStudentInTeacherCourses) {
                    Student updatedStudent = studentService.updateStudent(id, student);
                    if (updatedStudent != null) {
                        return ResponseResult.success("Student updated successfully", updatedStudent);
                    } else {
                        return ResponseResult.error(404, "Student not found");
                    }
                } else {
                    return ResponseResult.error(403, "无权限更新该学生");
                }
            } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                // 学生只能更新自己
                if (existingStudent.getStudentId().equals(username)) {
                    Student updatedStudent = studentService.updateStudent(id, student);
                    if (updatedStudent != null) {
                        return ResponseResult.success("Student updated successfully", updatedStudent);
                    } else {
                        return ResponseResult.error(404, "Student not found");
                    }
                } else {
                    return ResponseResult.error(403, "无权限更新该学生");
                }
            } else {
                return ResponseResult.error(403, "无权限更新学生");
            }
        } catch (Exception e) {
            return ResponseResult.error(500, "更新学生失败: " + e.getMessage());
        }
    }

    // 同步学生性别到用户表
    @PostMapping("/sync-gender")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseResult<String> syncStudentGenderToUser(Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        try {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                return ResponseResult.error(401, "用户不存在");
            }
            
            // 只有管理员可以执行此操作
            if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
                return ResponseResult.error(403, "无权限执行此操作");
            }
            
            // 执行同步操作
            studentService.syncStudentGenderToUser();
            return ResponseResult.success("学生性别信息同步到用户表成功");
        } catch (Exception e) {
            return ResponseResult.error(500, "同步学生性别到用户表失败: " + e.getMessage());
        }
    }
    
    // 删除学生
    @DeleteMapping("/{id:[0-9]+}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseResult<String> deleteStudent(@PathVariable Long id, Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        try {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                return ResponseResult.error(401, "用户不存在");
            }
            
            // 只有管理员可以删除学生
            if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
                return ResponseResult.error(403, "无权限删除学生");
            }
            
            studentService.deleteStudent(id);
            return ResponseResult.success("Student deleted successfully");
        } catch (Exception e) {
            return ResponseResult.error(500, "删除学生失败: " + e.getMessage());
        }
    }
}