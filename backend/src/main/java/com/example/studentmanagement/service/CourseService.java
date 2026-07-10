package com.example.studentmanagement.service;

import com.example.studentmanagement.entity.Course;
import java.util.List;

public interface CourseService {
    List<Course> getAllCourses();
    Course getCourseById(Long id);
    Course getCourseByCourseCode(String courseCode);
    Course saveCourse(Course course);
    void deleteCourse(Long id);
    List<Course> searchCourses(String keyword, String courseType);
    List<Course> getCoursesBySemester(String semester);
    List<Course> getCoursesByTeacher(String teacher);
    List<Course> getCoursesByTeacherId(Long teacherId);
    long countTotalCourses();
    long countCoursesByTeacherId(Long teacherId);
}
