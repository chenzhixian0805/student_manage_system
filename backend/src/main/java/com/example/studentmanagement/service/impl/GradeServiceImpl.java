package com.example.studentmanagement.service.impl;

import com.example.studentmanagement.entity.Course;
import com.example.studentmanagement.entity.Grade;
import com.example.studentmanagement.entity.GradeAnalysisResult;
import com.example.studentmanagement.repository.GradeRepository;
import com.example.studentmanagement.service.GradeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class GradeServiceImpl implements GradeService {

    @Autowired
    private GradeRepository gradeRepository;

    @Override
    public List<Grade> getAllGrades() {
        return gradeRepository.findAllWithStudentAndCourse();
    }
    
    @Override
    public Page<Grade> getAllGrades(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return gradeRepository.findAllWithStudentAndCourse(pageable);
    }

    @Override
    public Grade getGradeById(Long id) {
        return gradeRepository.findByIdWithStudentAndCourse(id);
    }

    @Override
    public Grade saveGrade(Grade grade) {
        // 计算GPA
        if (grade.getScore() != null) {
            double gpa = calculateGPA(grade.getScore());
            // 保留两位小数
            gpa = Math.round(gpa * 100.0) / 100.0;
            grade.setGpa(gpa);
            
            // 计算学分绩点（GPA×学分）
            if (grade.getCourse() != null && grade.getCourse().getCredit() != null) {
                double credit = grade.getCourse().getCredit();
                double creditGpa = gpa * credit;
                // 保留两位小数
                creditGpa = Math.round(creditGpa * 100.0) / 100.0;
                grade.setCreditGpa(creditGpa);
            }
        }
        return gradeRepository.save(grade);
    }

    @Override
    public void deleteGrade(Long id) {
        gradeRepository.deleteById(id);
    }

    @Override
    public List<Grade> getGradesByStudentId(Long studentId) {
        return gradeRepository.findByStudent_Id(studentId);
    }
    
    @Override
    public List<Grade> getGradesByStudentNumber(String studentNumber) {
        return gradeRepository.findByStudent_StudentId(studentNumber);
    }
    
    @Override
    public List<Grade> getGradesByTeacherId(Long teacherId) {
        return gradeRepository.findByCourse_Teacher_Id(teacherId);
    }

    @Override
    public List<Grade> getGradesByCourseId(Long courseId) {
        return gradeRepository.findByCourse_Id(courseId);
    }

    @Override
    public List<Grade> getGradesBySemester(String semester) {
        return gradeRepository.findBySemester(semester);
    }

    @Override
    public List<Grade> getGradesByStudentIdAndSemester(Long studentId, String semester) {
        return gradeRepository.findByStudent_IdAndSemester(studentId, semester);
    }

    @Override
    public List<Grade> getGradesByCourseIdAndSemester(Long courseId, String semester) {
        return gradeRepository.findByCourse_IdAndSemester(courseId, semester);
    }

    @Override
    public Double calculateCourseAverageScore(Long courseId) {
        return gradeRepository.calculateCourseAverageScore(courseId);
    }

    @Override
    public Double calculateCoursePassRate(Long courseId) {
        return gradeRepository.calculateCoursePassRate(courseId);
    }

    @Override
    public Double calculateCourseExcellentRate(Long courseId) {
        return gradeRepository.calculateCourseExcellentRate(courseId);
    }
    
    @Override
    public long countTotalGrades() {
        return gradeRepository.count();
    }
    
    @Override
    public Double calculateOverallAverageScore() {
        return gradeRepository.calculateOverallAverageScore();
    }
    
    @Override
    public Double calculateStudentGPA(Long studentId) {
        List<Grade> grades = gradeRepository.findByStudent_Id(studentId);
        if (grades.isEmpty()) {
            return 0.0;
        }
        
        double totalWeightedGPA = 0.0;
        double totalCredits = 0.0;
        
        for (Grade grade : grades) {
            if (grade.getCourse() != null) {
                // 如果学分是null或者0，使用默认值1.0
                Double creditValue = grade.getCourse().getCredit();
                double credits = (creditValue == null || creditValue == 0.0) ? 1.0 : creditValue.doubleValue();
                // 如果gpa是null，默认为0.0
                Double gpaValue = grade.getGpa();
                double gpa = gpaValue == null ? 0.0 : gpaValue.doubleValue();
                totalWeightedGPA += gpa * credits;
                totalCredits += credits;
            }
        }
        
        if (totalCredits == 0) {
            // 如果总学分为0，返回0
            return 0.0;
        }
        
        return totalWeightedGPA / totalCredits;
    }

    /**
     * 计算GPA（5分制）
     * @param score 分数
     * @return GPA（0-59=0.0，60分=1.0，每增加1分+0.1，最高不超过5.0，保留两位小数）
     */
    private double calculateGPA(double score) {
        if (score < 60) {
            return 0.0;
        } else {
            // 0-59=0.0，60分=1.0，每增加1分+0.1，最高不超过5.0
            double gpa = (score - 60) * 0.1 + 1.0;
            double finalGpa = Math.min(gpa, 5.0);
            // 保留两位小数
            return Math.round(finalGpa * 100.0) / 100.0;
        }
    }
    
    @Override
    public Grade getGradeByStudentIdAndCourseId(Long studentId, Long courseId) {
        return gradeRepository.findByStudent_IdAndCourse_Id(studentId, courseId);
    }
    
    @Override
    public List<Long> getScoreDistribution() {
        // 获取所有成绩
        List<Grade> grades = gradeRepository.findAll();
        return calculateScoreDistribution(grades);
    }
    
    @Override
    public List<Long> getScoreDistributionByTeacherId(Long teacherId) {
        // 获取特定教师的所有成绩
        List<Grade> grades = gradeRepository.findByCourse_Teacher_Id(teacherId);
        return calculateScoreDistribution(grades);
    }
    
    @Override
    public GradeAnalysisResult getGradeAnalysis(Long courseId, String semester) {
        GradeAnalysisResult result = new GradeAnalysisResult();
        
        // 使用count()方法获取总记录数
        long totalCount = gradeRepository.count();
        result.setTotalCount(totalCount);
        
        if (totalCount == 0) {
            // 如果没有成绩数据，初始化默认值
            result.setAverageScore(0.0);
            result.setGpa(0.0);
            result.setPassRate(0.0);
            result.setExcellentRate(0.0);
            result.setDistribution(List.of(0L, 0L, 0L, 0L, 0L));
            result.setCourseStats(Map.of());
            result.setSemesterStats(Map.of());
            return result;
        }
        
        // 计算平均分
        Double averageScore = gradeRepository.calculateOverallAverageScore();
        result.setAverageScore(averageScore != null ? averageScore : 0.0);
        
        // 计算GPA（这里使用简单平均，实际应该根据业务需求调整）
        double gpa = result.getAverageScore() >= 60 ? (result.getAverageScore() - 60) * 0.1 + 1.0 : 0.0;
        gpa = Math.min(gpa, 5.0);
        result.setGpa(gpa);
        
        // 直接获取成绩分布，避免递归调用
        List<Long> distribution = this.getScoreDistribution();
        result.setDistribution(distribution);
        
        // 计算及格率（60分及以上）
        long passedCount = distribution.stream().skip(1).reduce(0L, Long::sum);
        double passRate = (double) passedCount / totalCount;
        result.setPassRate(passRate);
        
        // 计算优秀率（90分及以上）
        long excellentCount = distribution.get(4);
        double excellentRate = (double) excellentCount / totalCount;
        result.setExcellentRate(excellentRate);
        
        // 暂时返回空的课程统计和学期统计，后续可以扩展
        result.setCourseStats(Map.of());
        result.setSemesterStats(Map.of());
        
        return result;
    }
    
    @Override
    public long countGradesByCourses(List<Course> courses) {
        if (courses == null || courses.isEmpty()) {
            return 0;
        }
        
        // 提取课程ID列表
        List<Long> courseIds = courses.stream()
            .map(Course::getId)
            .toList();
        
        return gradeRepository.countByCourseIdIn(courseIds);
    }
    
    @Override
    public Double calculateAverageScoreByCourses(List<Course> courses) {
        if (courses == null || courses.isEmpty()) {
            return 0.0;
        }
        
        // 提取课程ID列表
        List<Long> courseIds = courses.stream()
            .map(Course::getId)
            .toList();
        
        // 获取所有课程的成绩
        List<Grade> grades = gradeRepository.findByCourseIdIn(courseIds);
        
        if (grades.isEmpty()) {
            return 0.0;
        }
        
        // 计算平均分
        double sum = grades.stream()
            .mapToDouble(Grade::getScore)
            .sum();
        
        return sum / grades.size();
    }
    
    @Override
    public Double calculateStudentAverageScore(Long studentId) {
        List<Grade> grades = gradeRepository.findByStudent_Id(studentId);
        
        if (grades.isEmpty()) {
            return 0.0;
        }
        
        // 计算平均分
        double sum = grades.stream()
            .mapToDouble(Grade::getScore)
            .sum();
        
        return sum / grades.size();
    }
    
    /**
     * 计算成绩分布
     * @param grades 成绩列表
     * @return 成绩分布数组，顺序为：[60以下, 60-69, 70-79, 80-89, 90-100]
     */
    private List<Long> calculateScoreDistribution(List<Grade> grades) {
        // 初始化分布数组，确保每个区间都是0
        long[] distribution = {0, 0, 0, 0, 0};
        
        grades.forEach(grade -> {
            if (grade.getScore() != null) {
                double score = grade.getScore();
                if (score < 60) distribution[0]++;
                else if (score < 70) distribution[1]++;
                else if (score < 80) distribution[2]++;
                else if (score < 90) distribution[3]++;
                else distribution[4]++;
            }
        });
        
        return List.of(distribution[0], distribution[1], distribution[2], distribution[3], distribution[4]);
    }
}
