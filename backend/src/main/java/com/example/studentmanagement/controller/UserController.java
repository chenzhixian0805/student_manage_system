package com.example.studentmanagement.controller;

import com.example.studentmanagement.entity.ResponseResult;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // 获取所有用户
    @GetMapping
    public ResponseResult<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseResult.success(users);
    }

    // 根据ID获取用户
    @GetMapping("/{id}")
    public ResponseResult<User> getUserById(@PathVariable Long id) {
        User user = userService.findById(id);
        if (user == null) {
            return ResponseResult.error(404, "User not found");
        }
        return ResponseResult.success(user);
    }

    // 创建用户
    @PostMapping
    public ResponseResult<User> createUser(@RequestBody User user) {
        // 默认状态为启用
        if (user.getStatus() == null) {
            user.setStatus(1);
        }
        User savedUser = userService.saveUser(user);
        return ResponseResult.success("用户创建成功", savedUser);
    }

    // 更新用户
    @PutMapping("/{id}")
    public ResponseResult<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        User existingUser = userService.findById(id);
        if (existingUser == null) {
            return ResponseResult.error(404, "User not found");
        }
        user.setId(id);
        User updatedUser = userService.saveUser(user);
        return ResponseResult.success("用户更新成功", updatedUser);
    }

    // 删除用户
    @DeleteMapping("/{id}")
    public ResponseResult<String> deleteUser(@PathVariable Long id) {
        User existingUser = userService.findById(id);
        if (existingUser == null) {
            return ResponseResult.error(404, "User not found");
        }
        userService.deleteUser(id);
        return ResponseResult.success("用户删除成功");
    }

    // 检查用户名是否存在
    @GetMapping("/check-username")
    public ResponseResult<Boolean> checkUsername(@RequestParam String username) {
        boolean exists = userService.existsByUsername(username);
        return ResponseResult.success(exists);
    }

    // 检查工号是否存在
    @GetMapping("/check-employee-id")
    public ResponseResult<Boolean> checkEmployeeId(@RequestParam String employeeId) {
        boolean exists = userService.existsByEmployeeId(employeeId);
        return ResponseResult.success(exists);
    }
    
    // 搜索用户
    @GetMapping("/search")
    public ResponseResult<List<User>> searchUsers(@RequestParam(required = false) String keyword,
                                                @RequestParam(required = false) String role,
                                                @RequestParam(required = false) String status) {
        List<User> users = userService.getAllUsers();
        // 前端进行筛选
        return ResponseResult.success(users);
    }
    
    // 更改用户状态
    @PatchMapping("/{id}/status")
    public ResponseResult<String> changeUserStatus(@PathVariable Long id, @RequestBody User user) {
        User existingUser = userService.findById(id);
        if (existingUser == null) {
            return ResponseResult.error(404, "User not found");
        }
        existingUser.setStatus(user.getStatus());
        userService.saveUser(existingUser);
        return ResponseResult.success("用户状态更新成功");
    }
    
    // 重置用户密码
    @PatchMapping("/{id}/password")
    public ResponseResult<String> resetPassword(@PathVariable Long id, @RequestBody User user) {
        User existingUser = userService.findById(id);
        if (existingUser == null) {
            return ResponseResult.error(404, "User not found");
        }
        userService.resetPassword(id, user.getPassword());
        return ResponseResult.success("密码重置成功");
    }
}
