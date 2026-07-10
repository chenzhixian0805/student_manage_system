package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    
    // 根据课程ID查询课程
    Course findByCourseId(String courseId);
    
    // 根据课程名称查询课程（支持模糊查询）
    @Query("SELECT c FROM Course c WHERE c.name LIKE %:name%")
    List<Course> findByNameContaining(String name);
    
    // 根据教师ID查询课程
    List<Course> findByTeacher_Id(Long teacherId);
    
    // 根据教师ID统计课程数量
    long countByTeacher_Id(Long teacherId);
}
