package com.example.studentmanagement.dto;

import lombok.Data;

@Data
public class GradeDTO {
    private Long id;
    private Long studentId;
    private String studentStudentId;
    private String studentName;
    private String studentClassName;
    private Long courseId;
    private String courseCourseId;
    private String courseName;
    private Double score;
    private Double gpa;
    private String semester;
    private String examDateTime;
    private Double creditGpa;
}
