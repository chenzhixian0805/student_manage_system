package com.example.studentmanagement.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置静态资源处理
        // Spring Boot默认会优先处理控制器请求，然后才会处理静态资源
        // 所以API请求会被控制器处理，而不会被静态资源处理器处理
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }
}