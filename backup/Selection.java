package com.example.studentmanagement.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

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

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getStudentId() {
        return this.studentId;
    }

    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public Long getCourseId() {
        return this.courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getSemester() {
        return this.semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public Date getSelectionTime() {
        return this.selectionTime;
    }

    public void setSelectionTime(Date selectionTime) {
        this.selectionTime = selectionTime;
    }

}
