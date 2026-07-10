package com.example.studentmanagement.service;

import com.example.studentmanagement.entity.User;
import java.util.List;

public interface UserService {
    // 根据用户名查找用户
    User findByUsername(String username);
    
    // 保存用户
    User saveUser(User user);
    
    // 删除用户
    void deleteUser(Long id);
    
    // 检查用户名是否存在
    boolean existsByUsername(String username);
    
    // 根据角色查找用户
    List<User> findUsersByRole(String role);
    
    // 根据工号查找用户
    User findByEmployeeId(String employeeId);
    
    // 检查工号是否存在
    boolean existsByEmployeeId(String employeeId);
    
    // 获取所有用户
    List<User> getAllUsers();
    
    // 根据ID查找用户
    User findById(Long id);
    
    // 更新所有用户的密码
    void updateAllUsersPassword(String password);
    
    // 重置单个用户密码
    void resetPassword(Long id, String password);
    
    // 根据用户名列表批量查询用户
    List<User> findUsersByUsernames(List<String> usernames);
    
    // 批量保存用户
    void batchSaveUsers(List<User> users);
}