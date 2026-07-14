package com.example.studentmanagement.controller;

import com.example.studentmanagement.entity.ResponseResult;
import com.example.studentmanagement.entity.Student;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.repository.StudentRepository;
import com.example.studentmanagement.service.UserService;
import com.example.studentmanagement.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserService userService;
    
    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private JwtUtils jwtUtils;

    // 登录
    @PostMapping("/login")
    public ResponseResult<Map<String, Object>> login(@RequestBody LoginRequest loginRequest) {
        try {
            // 使用AuthenticationManager进行真正的密码验证
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginRequest.getUsername(),
                            loginRequest.getPassword()
                    )
            );

            // 验证成功，从认证信息中获取用户名
            String username = authentication.getName();
            
            // 从数据库获取完整用户信息
            User user = userService.findByUsername(username);
            if (user == null) {
                return ResponseResult.error(400, "用户名或密码错误");
            }

            // 将认证信息存储到SecurityContext中
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // 生成真实的JWT Token
            String token = jwtUtils.generateToken(user.getUsername(), user.getRole());
            
            // 获取用户信息，对于学生，从Student表获取email和phone
            String email = user.getEmail();
            String phone = user.getPhone();
            
            // 如果是学生用户，从Student表获取email和phone
            if ("ROLE_STUDENT".equals(user.getRole())) {
                Student student = studentRepository.findByStudentId(user.getUsername());
                if (student != null) {
                    email = student.getEmail();
                    phone = student.getPhone();
                }
            }

            // 构建响应数据
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("token", token);
            
            // 构建userInfo，根据角色添加不同的字段
            Map<String, Object> userInfoMap = new HashMap<>();
            userInfoMap.put("username", user.getUsername());
            userInfoMap.put("role", user.getRole());
            userInfoMap.put("name", user.getName());
            userInfoMap.put("email", email);
            userInfoMap.put("phone", phone);
            
            // 如果是学生用户，添加性别信息
            if ("ROLE_STUDENT".equals(user.getRole())) {
                Student student = studentRepository.findByStudentId(user.getUsername());
                if (student != null && student.getGender() != null) {
                    userInfoMap.put("gender", student.getGender());
                }
            } else if ("ROLE_TEACHER".equals(user.getRole())) {
                // 为教师用户添加性别信息
                if (user.getGender() != null) {
                    userInfoMap.put("gender", user.getGender());
                }
            }
            
            responseData.put("userInfo", userInfoMap);

            return ResponseResult.success("登录成功", responseData);
        } catch (BadCredentialsException e) {
            // 密码错误异常
            return ResponseResult.error(400, "用户名或密码错误");
        } catch (Exception e) {
            // 捕获其他异常
            return ResponseResult.error(500, "登录失败，请稍后重试");
        }
    }

    // 登出
    @PostMapping("/logout")
    public ResponseResult<String> logout() {
        // 清除SecurityContext
        SecurityContextHolder.clearContext();
        return ResponseResult.success("登出成功");
    }

    // 获取当前用户信息
    @GetMapping("/me")
    public ResponseResult<Map<String, Object>> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        // 检查是否是匿名用户
        if (authentication.getPrincipal() instanceof String && "anonymousUser".equals(authentication.getPrincipal())) {
            return ResponseResult.error(401, "用户未登录");
        }
        
        String username;
        // 处理principal可能是字符串或UserDetails类型的情况
        if (authentication.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            username = userDetails.getUsername();
        } else if (authentication.getPrincipal() instanceof String) {
            username = (String) authentication.getPrincipal();
        } else {
            return ResponseResult.error(401, "用户未登录");
        }

        User user = userService.findByUsername(username);
        
        if (user == null) {
            return ResponseResult.error(404, "用户不存在");
        }
        
        // 获取用户信息，对于学生，从Student表获取email和phone
        String email = user.getEmail();
        String phone = user.getPhone();
        
        // 如果是学生用户，从Student表获取email和phone
        if ("ROLE_STUDENT".equals(user.getRole())) {
            Student student = studentRepository.findByStudentId(user.getUsername());
            if (student != null) {
                email = student.getEmail();
                phone = student.getPhone();
            }
        }

        // 构建userInfo，根据角色添加不同的字段
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("username", user.getUsername());
        userInfo.put("role", user.getRole());
        userInfo.put("name", user.getName());
        userInfo.put("email", email);
        userInfo.put("phone", phone);
        
        // 如果是学生用户，添加性别信息
        if ("ROLE_STUDENT".equals(user.getRole())) {
            Student student = studentRepository.findByStudentId(user.getUsername());
            if (student != null && student.getGender() != null) {
                userInfo.put("gender", student.getGender());
            }
        } else if ("ROLE_TEACHER".equals(user.getRole())) {
            // 为教师用户添加性别信息
            if (user.getGender() != null) {
                userInfo.put("gender", user.getGender());
            }
        }

        return ResponseResult.success(userInfo);
    }

    // 刷新Token
    @PostMapping("/refresh")
    public ResponseResult<Map<String, String>> refreshToken() {
        try {
            // 获取当前认证信息
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated()) {
                return ResponseResult.error(401, "用户未登录");
            }
            
            // 获取当前用户名
            String username;
            String role = "ROLE_USER"; // 默认角色
            
            // 处理principal可能是字符串或UserDetails类型的情况
            if (authentication.getPrincipal() instanceof UserDetails) {
                UserDetails userDetails = (UserDetails) authentication.getPrincipal();
                username = userDetails.getUsername();
                // 从用户信息中获取角色
                if (!userDetails.getAuthorities().isEmpty()) {
                    role = userDetails.getAuthorities().iterator().next().getAuthority();
                }
            } else if (authentication.getPrincipal() instanceof String) {
                username = (String) authentication.getPrincipal();
                // 从数据库获取用户角色
                User user = userService.findByUsername(username);
                if (user != null) {
                    role = user.getRole();
                }
            } else {
                return ResponseResult.error(401, "用户未登录");
            }
            
            // 生成新的JWT Token
            String newToken = jwtUtils.generateToken(username, role);
            return ResponseResult.success("Token刷新成功", Map.of("token", newToken));
        } catch (Exception e) {
            return ResponseResult.error(500, "Token刷新失败：" + e.getMessage());
        }
    }
    
    // 登录请求参数类
    public static class LoginRequest {
        private String username;
        private String password;
        private boolean remember;

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public boolean isRemember() {
            return remember;
        }

        public void setRemember(boolean remember) {
            this.remember = remember;
        }
    }
}
