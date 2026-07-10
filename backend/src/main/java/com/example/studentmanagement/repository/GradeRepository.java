package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.Grade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GradeRepository extends JpaRepository<Grade, Long> {
    
    // 查询所有成绩，并预先加载学生、学生专业、学生学院和课程信息
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c")
    List<Grade> findAllWithStudentAndCourse();
    
    // 分页查询所有成绩，并预先加载学生、学生专业、学生学院和课程信息
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c")
    Page<Grade> findAllWithStudentAndCourse(Pageable pageable);
    
    // 根据ID查询成绩，并预先加载学生、学生专业、学生学院和课程信息
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.id = :id")
    Grade findByIdWithStudentAndCourse(@Param("id") Long id);
    
    // 根据学生ID查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.studentId = :studentId")
    List<Grade> findByStudent_Id(@Param("studentId") Long studentId);
    
    // 根据学生学号查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE s.studentId = :studentNumber")
    List<Grade> findByStudent_StudentId(@Param("studentNumber") String studentNumber);
    
    // 根据教师ID查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE c.teacher.id = :teacherId")
    List<Grade> findByCourse_Teacher_Id(@Param("teacherId") Long teacherId);
    
    // 根据课程ID查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.courseId = :courseId")
    List<Grade> findByCourse_Id(@Param("courseId") Long courseId);
    
    // 根据学生ID和课程ID查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.studentId = :studentId AND g.courseId = :courseId")
    Grade findByStudent_IdAndCourse_Id(@Param("studentId") Long studentId, @Param("courseId") Long courseId);
    
    // 根据学期查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.semester = :semester")
    List<Grade> findBySemester(@Param("semester") String semester);
    
    // 根据学生ID和学期查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.studentId = :studentId AND g.semester = :semester")
    List<Grade> findByStudent_IdAndSemester(@Param("studentId") Long studentId, @Param("semester") String semester);
    
    // 根据课程ID和学期查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.courseId = :courseId AND g.semester = :semester")
    List<Grade> findByCourse_IdAndSemester(@Param("courseId") Long courseId, @Param("semester") String semester);
    
    // 自定义查询：计算课程平均分
    @Query("SELECT AVG(g.score) FROM Grade g WHERE g.course.id = :courseId")
    Double calculateCourseAverageScore(@Param("courseId") Long courseId);
    
    // 自定义查询：计算课程及格率
    @Query("SELECT COUNT(g) * 1.0 / (SELECT COUNT(*) FROM Grade g2 WHERE g2.course.id = :courseId) FROM Grade g WHERE g.course.id = :courseId AND g.score >= 60")
    Double calculateCoursePassRate(@Param("courseId") Long courseId);
    
    // 自定义查询：计算课程优秀率
    @Query("SELECT COUNT(g) * 1.0 / (SELECT COUNT(*) FROM Grade g2 WHERE g2.course.id = :courseId) FROM Grade g WHERE g.course.id = :courseId AND g.score >= 90")
    Double calculateCourseExcellentRate(@Param("courseId") Long courseId);
    
    // 根据学生ID删除成绩记录
    void deleteByStudent_Id(Long studentId);
    
    // 根据课程ID删除成绩记录
    void deleteByCourse_Id(Long courseId);
    
    // 自定义查询：计算整体平均成绩
    @Query("SELECT AVG(g.score) FROM Grade g")
    Double calculateOverallAverageScore();
    
    // 根据课程ID列表查询成绩
    @Query("SELECT g FROM Grade g LEFT JOIN FETCH g.student s LEFT JOIN FETCH s.major m LEFT JOIN FETCH m.college c1 LEFT JOIN FETCH g.course c WHERE g.courseId IN :courseIds")
    List<Grade> findByCourseIdIn(@Param("courseIds") List<Long> courseIds);
    
    // 根据课程ID列表统计成绩数量
    @Query("SELECT COUNT(g) FROM Grade g WHERE g.course.id IN :courseIds")
    long countByCourseIdIn(@Param("courseIds") List<Long> courseIds);
}
