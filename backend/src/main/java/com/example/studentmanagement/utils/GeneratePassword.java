package com.example.studentmanagement.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class GeneratePassword {
    public static void main(String[] args) {
        // 创建BCryptPasswordEncoder实例
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        
        // 要加密的密码
        String rawPassword = "123456";
        
        // 生成加密后的密码
        String encodedPassword = passwordEncoder.encode(rawPassword);
        
        System.out.println("原始密码: " + rawPassword);
        System.out.println("加密后的密码: " + encodedPassword);
    }
}