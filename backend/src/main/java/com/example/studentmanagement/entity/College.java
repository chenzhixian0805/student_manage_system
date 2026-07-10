package com.example.studentmanagement.entity;

import jakarta.persistence.*;
import lombok.Data;

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

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCollegeName() {
        return this.collegeName;
    }

    public void setCollegeName(String collegeName) {
        this.collegeName = collegeName;
    }

    public String getCollegeCode() {
        return this.collegeCode;
    }

    public void setCollegeCode(String collegeCode) {
        this.collegeCode = collegeCode;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getStatus() {
        return this.status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

}
