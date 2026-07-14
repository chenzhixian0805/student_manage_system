package com.example.studentmanagement.controller;

import com.example.studentmanagement.entity.ResponseResult;
import com.example.studentmanagement.entity.Teacher;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.repository.TeacherRepository;
import com.example.studentmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/teachers")
public class TeacherController {

    @Autowired
    private UserService userService;

    @Autowired
    private TeacherRepository teacherRepository;

    // 获取所有教师
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    public ResponseResult<List<User>> getAllTeachers(Principal principal) {
        List<User> teachers;
        if (principal == null) {
            // 未登录用户无权限查看教师列表
            return ResponseResult.error(403, "无权限查看教师列表");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        // 检查用户是否存在
        if (currentUser == null) {
            return ResponseResult.error(404, "用户不存在");
        }
        
        if ("ROLE_ADMIN".equals(currentUser.getRole())) {
            // 管理员可以查看所有教师
            teachers = userService.findUsersByRole("ROLE_TEACHER");
        } else if ("ROLE_TEACHER".equals(currentUser.getRole())) {
            // 教师只能查看自己
            teachers = new ArrayList<>();
            teachers.add(currentUser);
        } else {
            // 其他角色无权限查看教师列表
            return ResponseResult.error(403, "无权限查看教师列表");
        }
        return ResponseResult.success(teachers);
    }

    // 根据ID获取教师
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    public ResponseResult<User> getTeacherById(@PathVariable Long id, Principal principal) {
        if (principal == null) {
            // 未登录用户无权限查看教师信息
            return ResponseResult.error(403, "无权限查看教师信息");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        // 检查用户是否存在
        if (currentUser == null) {
            return ResponseResult.error(404, "用户不存在");
        }
        
        User teacher = userService.findById(id);
        if (teacher == null || !"ROLE_TEACHER".equals(teacher.getRole())) {
            return ResponseResult.error(404, "Teacher not found");
        }
        
        // 检查权限：只有管理员或教师本人可以查看教师信息
        if (!"ROLE_ADMIN".equals(currentUser.getRole()) && !currentUser.getId().equals(teacher.getId())) {
            return ResponseResult.error(403, "无权限查看该教师信息");
        }
        
        return ResponseResult.success(teacher);
    }

    // 创建教师
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseResult<User> createTeacher(@RequestBody User teacher, Principal principal) {
        if (principal == null) {
            // 未登录用户无权限创建教师
            return ResponseResult.error(403, "无权限创建教师");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        // 只有管理员可以创建教师
        if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
            return ResponseResult.error(403, "无权限创建教师");
        }
        
        // 设置角色为教师
        teacher.setRole("ROLE_TEACHER");
        // 默认状态为启用
        if (teacher.getStatus() == null) {
            teacher.setStatus(1);
        }
        // 确保username不为空
        if (teacher.getUsername() == null || teacher.getUsername().isEmpty()) {
            return ResponseResult.error(400, "用户名不能为空");
        }
        // 确保password不为空
        if (teacher.getPassword() == null || teacher.getPassword().isEmpty()) {
            return ResponseResult.error(400, "密码不能为空");
        }
        // 确保name不为空
        if (teacher.getName() == null || teacher.getName().isEmpty()) {
            return ResponseResult.error(400, "姓名不能为空");
        }
        User savedTeacher = userService.saveUser(teacher);
        
        // 同时保存到sys_teacher表
        Teacher teacherInfo = new Teacher();
        teacherInfo.setName(savedTeacher.getName());
        teacherInfo.setGender(savedTeacher.getGender());
        teacherInfo.setPhone(savedTeacher.getPhone());
        teacherInfo.setEmail(savedTeacher.getEmail());
        teacherInfo.setTeacherId(savedTeacher.getEmployeeId());
        teacherInfo.setStatus(savedTeacher.getStatus() == 1 ? "正常" : "禁用");
        teacherInfo.setUserId(savedTeacher.getId());
        teacherRepository.save(teacherInfo);
        
        return ResponseResult.success("教师创建成功", savedTeacher);
    }

    // 更新教师
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','TEACHER')")
    public ResponseResult<User> updateTeacher(@PathVariable Long id, @RequestBody User teacher, Principal principal) {
        if (principal == null) {
            // 未登录用户无权限更新教师信息
            return ResponseResult.error(403, "无权限更新教师信息");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        User existingTeacher = userService.findById(id);
        if (existingTeacher == null || !"ROLE_TEACHER".equals(existingTeacher.getRole())) {
            return ResponseResult.error(404, "Teacher not found");
        }
        
        // 检查权限：只有管理员或教师本人可以更新教师信息
        if (!"ROLE_ADMIN".equals(currentUser.getRole()) && !currentUser.getId().equals(existingTeacher.getId())) {
            return ResponseResult.error(403, "无权限更新该教师信息");
        }
        
        // 确保角色保持为教师
        teacher.setRole("ROLE_TEACHER");
        teacher.setId(id);
        User updatedTeacher = userService.saveUser(teacher);
        
        // 同时更新sys_teacher表
        Teacher teacherInfo = teacherRepository.findByUserId(id);
        if (teacherInfo == null) {
            teacherInfo = new Teacher();
            teacherInfo.setTeacherId(updatedTeacher.getEmployeeId());
            teacherInfo.setUserId(id);
        }
        teacherInfo.setName(updatedTeacher.getName());
        teacherInfo.setGender(updatedTeacher.getGender());
        teacherInfo.setPhone(updatedTeacher.getPhone());
        teacherInfo.setEmail(updatedTeacher.getEmail());
        teacherInfo.setStatus(updatedTeacher.getStatus() == 1 ? "正常" : "禁用");
        teacherRepository.save(teacherInfo);
        
        return ResponseResult.success("教师更新成功", updatedTeacher);
    }

    // 删除教师
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseResult<String> deleteTeacher(@PathVariable Long id, Principal principal) {
        if (principal == null) {
            // 未登录用户无权限删除教师
            return ResponseResult.error(403, "无权限删除教师");
        }
        
        // 获取当前登录用户
        String username = principal.getName();
        User currentUser = userService.findByUsername(username);
        
        // 只有管理员可以删除教师
        if (!"ROLE_ADMIN".equals(currentUser.getRole())) {
            return ResponseResult.error(403, "无权限删除教师");
        }
        
        User existingTeacher = userService.findById(id);
        if (existingTeacher == null || !"ROLE_TEACHER".equals(existingTeacher.getRole())) {
            return ResponseResult.error(404, "Teacher not found");
        }
        
        // 先删除sys_teacher表中的记录
        teacherRepository.deleteByUserId(id);
        
        // 再删除sys_user表中的记录
        userService.deleteUser(id);
        
        return ResponseResult.success("教师删除成功");
    }

    // 检查工号是否存在
    @GetMapping("/check-employee-id")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseResult<Boolean> checkEmployeeId(@RequestParam String employeeId) {
        boolean exists = userService.existsByEmployeeId(employeeId);
        return ResponseResult.success(exists);
    }
}