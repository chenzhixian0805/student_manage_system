import os
import shutil

# 实体类目录
target_dir = r"d:\student_manage_system\backend\src\main\java\com\example\studentmanagement\entity"

# 备份目录
backup_dir = r"d:\student_manage_system\backup"

# 创建备份目录
os.makedirs(backup_dir, exist_ok=True)

# 原始实体类内容
templates = {
    "College.java": '''package com.example.studentmanagement.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "sys_college")
public class College {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "college_name", unique = true, nullable = false, length = 50)
    private String collegeName;

    @Column(name = "college_code", unique = true, length = 20)
    private String collegeCode;

    @Column(name = "description", length = 255)
    private String description;

    @Column(name = "status", nullable = false)
    private Integer status = 1;
}
''',
    "Course.java": '''package com.example.studentmanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.Date;
import java.util.List;

@Data
@ToString(exclude = {"teacher", "grades", "selections"})
@Entity
@Table(name = "sys_course")
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "course_id", unique = true, nullable = false, length = 20)
    private String courseId;

    @Column(name = "course_name", nullable = false, length = 100)
    private String name;

    @Column(name = "credit", nullable = false)
    private Integer credit = 3;

    @Column(name = "semester", length = 20)
    private String semester;

    @Column(name = "teacher_id")
    private Long teacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", insertable = false, updatable = false)
    private User teacher;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Grade> grades;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Selection> selections;
}
''',
    "Grade.java": '''package com.example.studentmanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Data
@Entity
@Table(name = "sys_grade")
public class Grade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "student_id", nullable = false)
    private Long studentId;

    @Column(name = "course_id", nullable = false)
    private Long courseId;

    @Column(name = "score")
    private Double score;

    @Column(name = "gpa")
    private Double gpa;

    @Column(name = "semester", length = 20)
    private String semester;

    @Column(name = "exam_datetime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date examDateTime;

    @Column(name = "credit_gpa")
    private Double creditGpa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", insertable = false, updatable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Student student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", insertable = false, updatable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Course course;
}
''',
    "Major.java": '''package com.example.studentmanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Data
@Entity
@Table(name = "sys_major")
public class Major {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "major_name", unique = true, nullable = false, length = 50)
    private String majorName;

    @Column(name = "major_code", unique = true, length = 20)
    private String majorCode;

    @Column(name = "college_id", nullable = false)
    private Long collegeId;

    @Column(name = "description", length = 255)
    private String description;

    @Column(name = "status", nullable = false)
    private Integer status = 1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "college_id", insertable = false, updatable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private College college;

    @OneToMany(mappedBy = "major", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Student> students;
}
''',
    "ResponseResult.java": '''package com.example.studentmanagement.entity;

import lombok.Data;

import java.util.List;

@Data
public class ResponseResult<T> {
    private int code;
    private String message;
    private T data;

    public ResponseResult(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public static <T> ResponseResult<T> success(T data) {
        return new ResponseResult<>(200, "success", data);
    }

    public static <T> ResponseResult<T> success(String message, T data) {
        return new ResponseResult<>(200, message, data);
    }

    public static <T> ResponseResult<T> error(int code, String message) {
        return new ResponseResult<>(code, message, null);
    }
}
''',
    "Selection.java": '''package com.example.studentmanagement.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Data
@Entity
@Table(name = "sys_selection")
public class Selection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "student_id", nullable = false)
    private Long studentId;

    @Column(name = "course_id", nullable = false)
    private Long courseId;

    @Column(name = "semester", length = 20)
    private String semester;

    @Column(name = "selection_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date selectionTime;

    @Column(name = "status", nullable = false)
    private Integer status = 1;
}
''',
    "Student.java": '''package com.example.studentmanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.Date;
import java.util.List;

@Data
@ToString(exclude = {"grades", "selections", "major"})
@Entity
@Table(name = "sys_student")
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @JsonProperty("student_id")
    @Column(name = "student_id", unique = true, nullable = false, length = 20)
    private String studentId;

    @Column(name = "name", nullable = false, length = 50)
    private String name;

    @Column(name = "gender", length = 10)
    private String gender;

    @Column(name = "birth_date")
    @Temporal(TemporalType.DATE)
    private Date birthDate;

    @JsonProperty("class")
    @Column(name = "class_name", length = 50)
    private String className;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "status", length = 20)
    private String status = "在读";

    @Column(name = "admission_date")
    @Temporal(TemporalType.DATE)
    private Date admissionDate;

    @JsonProperty("created_at")
    @Column(name = "create_time", updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @JsonProperty("updated_at")
    @Column(name = "update_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    
    @Column(name = "college_id")
    private Long collegeId;
    
    @Column(name = "major_id")
    private Long majorId;
    
    @JsonProperty("id_card")
    @Column(name = "id_card", length = 18)
    private String idCard;
    
    // 关联到专业
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "major_id", insertable = false, updatable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Major major;
    
    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Grade> grades;
    
    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Selection> selections;
}
''',
    "User.java": '''package com.example.studentmanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.util.Date;
import java.util.List;

@Data
@ToString(exclude = {"courses"})
@Entity
@Table(name = "sys_user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonProperty("username")
    @Column(name = "user_name", unique = true, nullable = false, length = 50)
    private String username;

    @Column(name = "password", nullable = false, length = 60)
    private String password;

    @Column(name = "role", nullable = false, length = 255)
    private String role;

    @JsonProperty("name")
    @Column(name = "real_name", nullable = false, length = 50)
    private String name;

    @JsonProperty("created_at")
    @Column(name = "create_time", updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @JsonProperty("updated_at")
    @Column(name = "update_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    @Column(name = "status", nullable = false)
    private Integer status = 1;

    @Column(name = "employee_id", unique = true, length = 20)
    private String employeeId;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "phone", length = 255)
    private String phone;

    // 教师关联的课程
    @OneToMany(mappedBy = "teacher")
    @JsonIgnore
    private List<Course> courses;
}
'''
}

# 恢复每个实体类文件
for filename, content in templates.items():
    file_path = os.path.join(target_dir, filename)
    
    # 备份原始文件
    if os.path.exists(file_path):
        backup_path = os.path.join(backup_dir, filename)
        shutil.copy2(file_path, backup_path)
        print(f"已备份 {filename} 到 {backup_path}")
    
    # 写入原始内容
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"已恢复 {filename}")

print("\n所有实体类文件已恢复！")