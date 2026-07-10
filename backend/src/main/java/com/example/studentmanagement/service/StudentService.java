package com.example.studentmanagement.service;

import com.example.studentmanagement.entity.Student;
import java.util.List;

public interface StudentService {
    List<Student> getAllStudents();
    Student getStudentById(Long id);
    Student getStudentByStudentId(String studentId);
    Student saveStudent(Student student);
    Student updateStudent(Long id, Student student);
    void deleteStudent(Long id);
    List<Student> searchStudents(String keyword, String className);
    long countTotalStudents();
    List<Object[]> countStudentsByGender();
    List<Object[]> countStudentsByStatus();
    
    // 同步所有学生的性别信息到用户表
    void syncStudentGenderToUser();
    List<Student> getStudentsByTeacherId(Long teacherId);
}
