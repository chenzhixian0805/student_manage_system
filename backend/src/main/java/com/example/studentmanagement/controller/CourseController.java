package com.example.studentmanagement.controller;

import com.example.studentmanagement.entity.Course;
import com.example.studentmanagement.entity.ResponseResult;
import com.example.studentmanagement.entity.Selection;
import com.example.studentmanagement.entity.Student;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.repository.SelectionRepository;
import com.example.studentmanagement.repository.StudentRepository;
import com.example.studentmanagement.service.CourseService;
import com.example.studentmanagement.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/courses")
public class CourseController {

    private static final Logger logger = LoggerFactory.getLogger(CourseController.class);

    @Autowired
    private CourseService courseService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private SelectionRepository selectionRepository;
    
    @Autowired
    private StudentRepository studentRepository;

    // 获取所有课程
    @GetMapping
    public ResponseResult<List<Course>> getAllCourses(Principal principal) {
        List<Course> courses;
        
        if (principal == null) {
            // 未登录，返回空列表
            courses = List.of();
            logger.info("getAllCourses() - 未登录用户，返回空列表");
        } else {
            // 获取当前登录用户
            String username = principal.getName();
            logger.info("getAllCourses() - 登录用户: {}", username);
            User currentUser = userService.findByUsername(username);
            
            if (currentUser == null) {
                // 用户不存在，返回空列表
                courses = List.of();
                logger.info("getAllCourses() - 用户不存在，返回空列表");
            } else {
                logger.info("getAllCourses() - 用户角色: {}", currentUser.getRole());
                if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                    // 管理员可以查看所有课程
                    courses = courseService.getAllCourses();
                    logger.info("getAllCourses() - 管理员角色，返回 {} 个课程", courses.size());
                } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己的课程
                    courses = courseService.getCoursesByTeacherId(currentUser.getId());
                    logger.info("getAllCourses() - 教师角色，返回 {} 个课程", courses.size());
                } else {
                    // 学生可以查看所有课程，但在详情页会检查权限
                    courses = courseService.getAllCourses();
                    logger.info("getAllCourses() - 学生角色，返回 {} 个课程", courses.size());
                }
            }
        }
        
        return ResponseResult.success(courses);
    }
    
    // 获取课程总数
    @GetMapping("/count")
    public ResponseResult<Long> getCourseCount(Principal principal) {
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
                // 管理员可以查看所有课程总数
                count = courseService.countTotalCourses();
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能查看自己课程的总数
                count = courseService.countCoursesByTeacherId(currentUser.getId());
            } else {
                // 学生可以查看所有课程总数
                count = courseService.countTotalCourses();
            }
        }
        return ResponseResult.success(count);
    }

    // 根据ID获取课程
    @GetMapping("/{id}")
    public ResponseResult<Course> getCourseById(@PathVariable Long id, Principal principal) {
        Course course = courseService.getCourseById(id);
        if (course == null) {
            return ResponseResult.error(404, "Course not found");
        }
        
        // 检查权限
        if (principal != null) {
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser != null) {
                if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己的课程
                    if (!currentUser.getId().equals(course.getTeacherId())) {
                        return ResponseResult.error(403, "无权限查看该课程");
                    }
                } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                    // 学生只能查看自己已经选择的课程
                    Student student = studentRepository.findByStudentId(username);
                    if (student == null) {
                        return ResponseResult.error(403, "无权限查看该课程");
                    }
                    // 检查学生是否已选该课程
                    List<Selection> selections = selectionRepository.findByStudent_Id(student.getId());
                    boolean hasSelected = selections.stream()
                            .anyMatch(selection -> selection.getCourseId().equals(course.getId()));
                    if (!hasSelected) {
                        return ResponseResult.error(403, "无权限查看该课程");
                    }
                }
            }
        }
        
        return ResponseResult.success(course);
    }

    // 根据课程代码获取课程
    @GetMapping("/by-course-code/{courseCode}")
    public ResponseResult<Course> getCourseByCourseCode(@PathVariable String courseCode, Principal principal) {
        Course course = courseService.getCourseByCourseCode(courseCode);
        if (course == null) {
            return ResponseResult.error(404, "Course not found");
        }
        
        // 检查权限
        if (principal != null) {
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            
            if (currentUser != null) {
                if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                    // 教师只能查看自己的课程
                    if (!currentUser.getId().equals(course.getTeacherId())) {
                        return ResponseResult.error(403, "无权限查看该课程");
                    }
                } else if ("ROLE_STUDENT".equals(currentUser.getRole())) {
                    // 学生只能查看自己已经选择的课程
                    Student student = studentRepository.findByStudentId(username);
                    if (student == null) {
                        return ResponseResult.error(403, "无权限查看该课程");
                    }
                    // 检查学生是否已选该课程
                    List<Selection> selections = selectionRepository.findByStudent_Id(student.getId());
                    boolean hasSelected = selections.stream()
                            .anyMatch(selection -> selection.getCourseId().equals(course.getId()));
                    if (!hasSelected) {
                        return ResponseResult.error(403, "无权限查看该课程");
                    }
                }
            }
        }
        
        return ResponseResult.success(course);
    }

    // 创建课程
    @PostMapping
    public ResponseResult<Course> createCourse(@RequestBody Course course, Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        if (currentUser == null) {
            return ResponseResult.error(401, "用户不存在");
        }
        
        // 只有管理员可以创建课程
        if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
            return ResponseResult.error(403, "无权限创建课程");
        }
        
        Course savedCourse = courseService.saveCourse(course);
        return ResponseResult.success("Course created successfully", savedCourse);
    }

    // 更新课程
    @PutMapping("/{id}")
    public ResponseResult<Course> updateCourse(@PathVariable Long id, @RequestBody Course course, Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        if (currentUser == null) {
            return ResponseResult.error(401, "用户不存在");
        }
        
        // 检查课程是否存在
        Course existingCourse = courseService.getCourseById(id);
        if (existingCourse == null) {
            return ResponseResult.error(404, "Course not found");
        }
        
        // 检查权限
        if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
            // 非管理员只能更新自己的课程
            if (!currentUser.getId().equals(existingCourse.getTeacherId())) {
                return ResponseResult.error(403, "无权限更新该课程");
            }
        }
        
        // 确保不修改courseId
        course.setCourseId(existingCourse.getCourseId());
        
        course.setId(id);
        Course updatedCourse = courseService.saveCourse(course);
        return ResponseResult.success("Course updated successfully", updatedCourse);
    }

    // 删除课程
    @DeleteMapping("/{id}")
    @Transactional
    public ResponseResult<String> deleteCourse(@PathVariable Long id, Principal principal) {
        if (principal == null) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        if (currentUser == null) {
            return ResponseResult.error(401, "用户不存在");
        }
        
        // 检查课程是否存在
        Course course = courseService.getCourseById(id);
        if (course == null) {
            return ResponseResult.error(404, "Course not found");
        }
        
        // 检查权限
        if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
            // 非管理员只能删除自己的课程
            if (!currentUser.getId().equals(course.getTeacherId())) {
                return ResponseResult.error(403, "无权限删除该课程");
            }
        }
        
        courseService.deleteCourse(id);
        return ResponseResult.success("Course deleted successfully");
    }

    // 搜索课程
    @GetMapping("/search")
    public ResponseResult<List<Course>> searchCourses(@RequestParam(required = false) String keyword, 
                                                     @RequestParam(required = false) String courseType, 
                                                     Principal principal) {
        List<Course> courses;
        if (principal == null) {
            // 未登录，返回空列表
            courses = List.of();
        } else {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            if (currentUser == null) {
                // 用户不存在，返回空列表
                courses = List.of();
            } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以搜索所有课程
                courses = courseService.searchCourses(keyword, courseType);
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能搜索自己的课程
                courses = courseService.getCoursesByTeacherId(currentUser.getId());
                // 如果有搜索条件，过滤结果
                if (keyword != null && !keyword.isEmpty()) {
                    courses = courses.stream()
                        .filter(course -> course.getName().contains(keyword) || course.getCourseId().contains(keyword))
                        .toList();
                }
            } else {
                // 学生可以搜索所有课程，但在详情页会检查权限
                courses = courseService.searchCourses(keyword, courseType);
            }
        }
        return ResponseResult.success(courses);
    }

    // 根据学期获取课程
    @GetMapping("/by-semester/{semester}")
    public ResponseResult<List<Course>> getCoursesBySemester(@PathVariable String semester, 
                                                           Principal principal) {
        List<Course> courses;
        if (principal == null) {
            // 未登录，返回空列表
            courses = List.of();
        } else {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            if (currentUser == null) {
                // 用户不存在，返回空列表
                courses = List.of();
            } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以查看所有学期的课程
                courses = courseService.getCoursesBySemester(semester);
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能查看自己课程中该学期的课程
                courses = courseService.getCoursesByTeacherId(currentUser.getId())
                    .stream()
                    .filter(course -> semester.equals(course.getSemester()))
                    .toList();
            } else {
                // 学生可以查看所有课程，但在详情页会检查权限
                courses = courseService.getCoursesBySemester(semester);
            }
        }
        return ResponseResult.success(courses);
    }

    // 根据教师获取课程
    @GetMapping("/by-teacher/{teacher}")
    public ResponseResult<List<Course>> getCoursesByTeacher(@PathVariable String teacher, 
                                                         Principal principal) {
        List<Course> courses;
        if (principal == null) {
            // 未登录，返回空列表
            courses = List.of();
        } else {
            // 获取当前登录用户
            String username = principal.getName();
            User currentUser = userService.findByUsername(username);
            if (currentUser == null) {
                // 用户不存在，返回空列表
                courses = List.of();
            } else if ("ROLE_ADMIN".equals(currentUser.getRole())) {
                // 管理员可以查看所有教师的课程
                courses = courseService.getCoursesByTeacher(teacher);
            } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                // 教师只能查看自己的课程
                courses = courseService.getCoursesByTeacherId(currentUser.getId());
            } else {
                // 学生可以查看所有课程，但在详情页会检查权限
                courses = courseService.getCoursesByTeacher(teacher);
            }
        }
        return ResponseResult.success(courses);
    }
}
