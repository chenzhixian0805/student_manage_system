package com.example.studentmanagement.filter;

import com.example.studentmanagement.utils.JwtUtils;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtils jwtUtils;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) 
            throws ServletException, IOException {
        
        // 获取Authorization头
        String authHeader = request.getHeader("Authorization");
        String token = null;
        String username = null;
        String role = null;
        
        // 检查Authorization头是否存在且格式正确
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
            try {
                // 解析Token
                username = jwtUtils.extractUsername(token);
                role = jwtUtils.extractRole(token);
            } catch (Exception e) {
                // Token无效，记录日志
                System.err.println("Invalid JWT token: " + e.getMessage());
            }
        }
        
        // 只有当Token有效且用户未认证时，才设置认证信息
        if (username != null && !username.isEmpty() && SecurityContextHolder.getContext().getAuthentication() == null) {
            // 检查Token是否过期
            if (!jwtUtils.isTokenExpired(token)) {
                // 创建权限列表
                List<SimpleGrantedAuthority> authorities = new ArrayList<>();
                authorities.add(new SimpleGrantedAuthority(role));
                
                // 创建认证对象
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        username, null, authorities);
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                
                // 设置认证信息到SecurityContext
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }
        
        // 继续执行过滤器链
        filterChain.doFilter(request, response);
    }
}