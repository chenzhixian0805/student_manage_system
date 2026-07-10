package com.example.studentmanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.Date;
import java.util.List;

@Entity
@Table(name = "sys_user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", unique = true, nullable = false, length = 50)
    @JsonProperty("username")
    private String username;

    @Column(name = "password", nullable = false, length = 60)
    private String password;

    @Column(name = "role", nullable = false, length = 255)
    private String role;

    @Column(name = "real_name", nullable = false, length = 50)
    @JsonProperty("name")
    private String name;

    @Column(name = "create_time", updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    @JsonProperty("createdAt")
    private Date createdAt;

    @Column(name = "update_time")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonProperty("updatedAt")
    private Date updatedAt;

    @Column(name = "status", nullable = false)
    private Integer status = 1;

    @Column(name = "employee_id", unique = true, length = 20)
    @JsonProperty("employeeId")
    private String employeeId;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "phone", length = 255)
    private String phone;

    @Column(name = "gender", length = 10)
    private String gender;

    // 教师关联的课程
    @OneToMany(mappedBy = "teacher")
    @JsonIgnore
    private List<Course> courses;

    // 在保存前设置创建时间和更新时间
    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    // 在更新前设置更新时间
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = new Date();
    }

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return this.role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return this.updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Integer getStatus() {
        return this.status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getEmployeeId() {
        return this.employeeId;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return this.phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return this.gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

}
