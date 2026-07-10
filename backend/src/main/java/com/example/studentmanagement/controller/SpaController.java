package com.example.studentmanagement.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SpaController {

    // 处理所有前端路由请求，返回index.html
    @GetMapping(value = {
        "/login",
        "/students",
        "/students/add",
        "/students/edit/{id}",
        "/students/detail/{id}",
        "/courses",
        "/courses/add",
        "/courses/edit/{id}",
        "/scores",
        "/scores/add",
        "/scores/edit/{id}",
        "/scores/analysis",
        "/users",
        "/users/add",
        "/users/edit/{id}",
        "/attendance",
        "/attendance/add",
        "/attendance/edit/{id}",
        "/attendance/statistics",
        "/notifications",
        "/settings"
    })
    public String spaFallback() {
        return "forward:/index.html";
    }
}
