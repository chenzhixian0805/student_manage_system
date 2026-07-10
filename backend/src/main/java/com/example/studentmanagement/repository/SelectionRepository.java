package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.Selection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SelectionRepository extends JpaRepository<Selection, Long> {
    
    // 根据课程ID查询选课记录
    List<Selection> findByCourse_Id(Long courseId);
    
    // 根据学生ID查询选课记录
    List<Selection> findByStudent_Id(Long studentId);
    
    // 根据学生ID删除选课记录
    void deleteByStudent_Id(Long studentId);
    
    // 根据课程ID删除选课记录
    void deleteByCourse_Id(Long courseId);
    
    // 根据学生ID和课程ID检查是否存在选课记录
    boolean existsByStudentIdAndCourseId(Long studentId, Long courseId);
}