package com.example.studentmanagement.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Component
public class JwtUtils {

    // 从配置文件读取密钥，必须通过环境变量提供
    @Value("${jwt.secret}")
    private String secretKeyString;
    
    // 从配置文件读取Token有效期，默认24小时
    @Value("${jwt.expiration:86400000}")
    private long expirationTime;
    
    // 从配置文件读取刷新Token有效期，默认7天
    @Value("${jwt.refresh-expiration:604800000}")
    private long refreshExpirationTime;
    
    // Token有效期：24小时
    private static final long DEFAULT_EXPIRATION_TIME = 86400000;
    
    // 刷新Token有效期：7天
    private static final long DEFAULT_REFRESH_EXPIRATION_TIME = 604800000;
    
    // 生成JWT Token
    public String generateToken(String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);
        claims.put("jti", UUID.randomUUID().toString()); // 添加JWT ID，用于撤销Token
        claims.put("iss", "student-manage-system"); // 添加签发者信息
        claims.put("iat", new Date()); // 添加签发时间
        
        SecretKey secretKey = Keys.hmacShaKeyFor(secretKeyString.getBytes());
        
        return Jwts.builder()
                .claims(claims)
                .subject(username)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + (expirationTime > 0 ? expirationTime : DEFAULT_EXPIRATION_TIME)))
                .signWith(secretKey)
                .compact();
    }
    
    // 生成刷新Token
    public String generateRefreshToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("jti", UUID.randomUUID().toString());
        claims.put("iss", "student-manage-system");
        claims.put("type", "refresh"); // 添加类型标识
        
        SecretKey secretKey = Keys.hmacShaKeyFor(secretKeyString.getBytes());
        
        return Jwts.builder()
                .claims(claims)
                .subject(username)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + (refreshExpirationTime > 0 ? refreshExpirationTime : DEFAULT_REFRESH_EXPIRATION_TIME)))
                .signWith(secretKey)
                .compact();
    }
    
    // 解析JWT Token
    public Claims extractClaims(String token) {
        SecretKey secretKey = Keys.hmacShaKeyFor(secretKeyString.getBytes());
        
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
    
    // 从Token中获取用户名
    public String extractUsername(String token) {
        return extractClaims(token).getSubject();
    }
    
    // 从Token中获取角色
    public String extractRole(String token) {
        return (String) extractClaims(token).get("role");
    }
    
    // 从Token中获取JWT ID
    public String extractJti(String token) {
        return (String) extractClaims(token).get("jti");
    }
    
    // 检查Token是否过期
    public boolean isTokenExpired(String token) {
        return extractClaims(token).getExpiration().before(new Date());
    }
    
    // 验证Token有效性
    public boolean validateToken(String token, String username) {
        try {
            final String extractedUsername = extractUsername(token);
            return (extractedUsername.equals(username) && !isTokenExpired(token));
        } catch (Exception e) {
            // Token无效，返回false
            return false;
        }
    }
    
    // 检查Token是否是刷新Token
    public boolean isRefreshToken(String token) {
        try {
            Claims claims = extractClaims(token);
            return "refresh".equals(claims.get("type"));
        } catch (Exception e) {
            return false;
        }
    }
}