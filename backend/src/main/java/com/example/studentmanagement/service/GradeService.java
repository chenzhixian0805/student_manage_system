package com.example.studentmanagement.service;

import com.example.studentmanagement.entity.Course;
import com.example.studentmanagement.entity.Grade;
import com.example.studentmanagement.entity.GradeAnalysisResult;
import org.springframework.data.domain.Page;
import java.util.List;

public interface GradeService {
    List<Grade> getAllGrades();
    Page<Grade> getAllGrades(int page, int size);
    Grade getGradeById(Long id);
    Grade saveGrade(Grade grade);
    void deleteGrade(Long id);
    List<Grade> getGradesByStudentId(Long studentId);
    List<Grade> getGradesByStudentNumber(String studentNumber);
    List<Grade> getGradesByTeacherId(Long teacherId);
    List<Grade> getGradesByCourseId(Long courseId);
    List<Grade> getGradesBySemester(String semester);
    List<Grade> getGradesByStudentIdAndSemester(Long studentId, String semester);
    List<Grade> getGradesByCourseIdAndSemester(Long courseId, String semester);
    Double calculateCourseAverageScore(Long courseId);
    Double calculateCoursePassRate(Long courseId);
    Double calculateCourseExcellentRate(Long courseId);
    long countTotalGrades();
    Double calculateOverallAverageScore();
    Double calculateStudentGPA(Long studentId);
    Grade getGradeByStudentIdAndCourseId(Long studentId, Long courseId);
    // 获取成绩分布，返回5个区间的人数：[60以下, 60-69, 70-79, 80-89, 90-100]
    List<Long> getScoreDistribution();
    // 根据教师ID获取成绩分布
    List<Long> getScoreDistributionByTeacherId(Long teacherId);
    // 获取成绩分析结果
    GradeAnalysisResult getGradeAnalysis(Long courseId, String semester);
    // 根据课程列表统计成绩数量
    long countGradesByCourses(List<Course> courses);
    // 根据课程列表计算平均成绩
    Double calculateAverageScoreByCourses(List<Course> courses);
    // 计算学生平均成绩
    Double calculateStudentAverageScore(Long studentId);
}
