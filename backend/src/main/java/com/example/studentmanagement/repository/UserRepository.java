package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // 根据用户名查找用户
    User findByUsername(String username);
    
    // 检查用户名是否存在
    boolean existsByUsername(String username);
    
    // 根据角色查找用户
    List<User> findByRole(String role);
    
    // 根据工号查找用户
    User findByEmployeeId(String employeeId);
    
    // 检查工号是否存在
    boolean existsByEmployeeId(String employeeId);
    
    // 根据用户名列表批量查询用户
    List<User> findByUsernameIn(List<String> usernames);
}