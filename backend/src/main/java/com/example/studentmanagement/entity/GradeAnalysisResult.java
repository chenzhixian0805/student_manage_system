package com.example.studentmanagement.entity;

import java.util.List;
import java.util.Map;

/**
 * 成绩分析结果DTO
 */
public class GradeAnalysisResult {
    // 基本统计数据
    private double averageScore;
    private double gpa;
    private double passRate;
    private double excellentRate;
    private long totalCount;
    
    // 成绩分布 [60以下, 60-69, 70-79, 80-89, 90-100]
    private List<Long> distribution;
    
    // 按课程分组的统计数据
    private Map<String, CourseGradeStats> courseStats;
    
    // 按学期分组的统计数据
    private Map<String, SemesterGradeStats> semesterStats;
    
    // 内部类：课程统计数据
    public static class CourseGradeStats {
        private long count;
        private double averageScore;
        private double passRate;
        private double excellentRate;
        
        // getter and setter methods
        public long getCount() {
            return count;
        }
        public void setCount(long count) {
            this.count = count;
        }
        public double getAverageScore() {
            return averageScore;
        }
        public void setAverageScore(double averageScore) {
            this.averageScore = averageScore;
        }
        public double getPassRate() {
            return passRate;
        }
        public void setPassRate(double passRate) {
            this.passRate = passRate;
        }
        public double getExcellentRate() {
            return excellentRate;
        }
        public void setExcellentRate(double excellentRate) {
            this.excellentRate = excellentRate;
        }
    }
    
    // 内部类：学期统计数据
    public static class SemesterGradeStats {
        private long count;
        private double averageScore;
        private double gpa;
        
        // getter and setter methods
        public long getCount() {
            return count;
        }
        public void setCount(long count) {
            this.count = count;
        }
        public double getAverageScore() {
            return averageScore;
        }
        public void setAverageScore(double averageScore) {
            this.averageScore = averageScore;
        }
        public double getGpa() {
            return gpa;
        }
        public void setGpa(double gpa) {
            this.gpa = gpa;
        }
    }
    
    // getter and setter methods
    public double getAverageScore() {
        return averageScore;
    }
    public void setAverageScore(double averageScore) {
        this.averageScore = averageScore;
    }
    public double getGpa() {
        return gpa;
    }
    public void setGpa(double gpa) {
        this.gpa = gpa;
    }
    public double getPassRate() {
        return passRate;
    }
    public void setPassRate(double passRate) {
        this.passRate = passRate;
    }
    public double getExcellentRate() {
        return excellentRate;
    }
    public void setExcellentRate(double excellentRate) {
        this.excellentRate = excellentRate;
    }
    public long getTotalCount() {
        return totalCount;
    }
    public void setTotalCount(long totalCount) {
        this.totalCount = totalCount;
    }
    public List<Long> getDistribution() {
        return distribution;
    }
    public void setDistribution(List<Long> distribution) {
        this.distribution = distribution;
    }
    public Map<String, CourseGradeStats> getCourseStats() {
        return courseStats;
    }
    public void setCourseStats(Map<String, CourseGradeStats> courseStats) {
        this.courseStats = courseStats;
    }
    public Map<String, SemesterGradeStats> getSemesterStats() {
        return semesterStats;
    }
    public void setSemesterStats(Map<String, SemesterGradeStats> semesterStats) {
        this.semesterStats = semesterStats;
    }
}