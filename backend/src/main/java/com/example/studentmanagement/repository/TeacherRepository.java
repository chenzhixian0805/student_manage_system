package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TeacherRepository extends JpaRepository<Teacher, Long> {
    Teacher findByTeacherId(String teacherId);
    Teacher findByUserId(Long userId);
    void deleteByUserId(Long userId);
}