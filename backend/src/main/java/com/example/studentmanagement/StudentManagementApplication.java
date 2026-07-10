package com.example.studentmanagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class StudentManagementApplication {

    public static void main(String[] args) {
        // 注册关闭钩子，捕获JVM关闭事件
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("\n=== 应用程序正在关闭... ===");
            System.out.println("关闭原因: JVM关闭钩子被触发");
            System.out.println("当前时间: " + new java.util.Date());
            System.out.println("=== 应用程序关闭完成 ===");
        }, "ShutdownHook"));

        System.out.println("=== 正在启动学生管理系统... ===");
        System.out.println("启动时间: " + new java.util.Date());

        // 启动Spring Boot应用程序
        ConfigurableApplicationContext context = SpringApplication.run(StudentManagementApplication.class, args);

        System.out.println("=== 学生管理系统启动完成 ===");
        System.out.println("应用程序上下文ID: " + context.getId());
        System.out.println("应用程序显示名称: " + context.getDisplayName());
        System.out.println("应用程序启动时间: " + context.getStartupDate());
        System.out.println("应用程序是否活跃: " + context.isActive());
        System.out.println("应用程序配置: " + context.getEnvironment().getActiveProfiles());
        System.out.println("Tomcat端口: " + context.getEnvironment().getProperty("server.port"));
    }

}
