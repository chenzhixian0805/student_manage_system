package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    // 根据学号查询学生，同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c WHERE s.studentId = :studentId")
    Student findByStudentId(String studentId);
    
    // 根据姓名查询学生（支持模糊查询），同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c WHERE s.name LIKE %:name%")
    List<Student> findByNameContaining(String name);
    
    // 根据班级查询学生，同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c WHERE s.className = :className")
    List<Student> findByClassName(String className);
    
    // 根据学号查询学生，同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c WHERE s.studentId = :studentId")
    Student findByStudentIdWithMajorAndCollege(String studentId);
    
    // 根据姓名和班级查询学生，同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c WHERE s.name LIKE %:name% AND s.className = :className")
    List<Student> findByNameContainingAndClassName(String name, String className);
    
    // 查询所有学生，同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c")
    List<Student> findAllWithMajorAndCollege();
    
    // 自定义查询：获取学生总数
    @Query("SELECT COUNT(s) FROM Student s")
    long countTotalStudents();
    
    // 根据ID查询学生，同时获取专业和学院信息
    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c WHERE s.id = :id")
    Optional<Student> findByIdWithMajorAndCollege(Long id);
    
    // 自定义查询：根据性别统计学生数量
    @Query("SELECT s.gender, COUNT(s) FROM Student s GROUP BY s.gender")
    List<Object[]> countStudentsByGender();
    
    // 根据教师ID查询学生，通过课程表和选课表关联
    @Query("SELECT DISTINCT s FROM Student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 JOIN s.selections sel JOIN sel.course c WHERE c.teacher.id = :teacherId")
    List<Student> findStudentsByTeacherId(@Param("teacherId") Long teacherId);
    
    // 自定义查询：根据状态统计学生数量
    @Query("SELECT s.status, COUNT(s) FROM Student s GROUP BY s.status")
    List<Object[]> countStudentsByStatus();
}
