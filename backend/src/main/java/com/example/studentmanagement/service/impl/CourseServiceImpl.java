package com.example.studentmanagement.service.impl;

import com.example.studentmanagement.entity.Course;
import com.example.studentmanagement.entity.Grade;
import com.example.studentmanagement.entity.Selection;
import com.example.studentmanagement.repository.CourseRepository;
import com.example.studentmanagement.repository.GradeRepository;
import com.example.studentmanagement.repository.SelectionRepository;
import com.example.studentmanagement.service.CourseService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {
    
    private static final Logger logger = LoggerFactory.getLogger(CourseServiceImpl.class);
    
    @Autowired
    private CourseRepository courseRepository;
    
    @Autowired
    private com.example.studentmanagement.repository.UserRepository userRepository;

    @Override
    public List<Course> getAllCourses() {
        List<Course> courses = courseRepository.findAll();
        logger.info("getAllCourses() 返回了 {} 个课程", courses.size());
        // 确保每个课程的credit字段有值，默认为0.0
        courses.forEach(course -> {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        });
        return courses;
    }

    @Override
    public Course getCourseById(Long id) {
        Course course = courseRepository.findById(id).orElse(null);
        // 确保credit字段有值，默认为0.0
        if (course != null) {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        }
        return course;
    }

    @Override
    public Course getCourseByCourseCode(String courseCode) {
        Course course = courseRepository.findByCourseId(courseCode);
        // 确保credit字段有值，默认为0.0
        if (course != null) {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        }
        return course;
    }

    @Override
    public Course saveCourse(Course course) {
        // 如果teacherId不为空，加载对应的User对象并设置到teacher属性
        if (course.getTeacherId() != null) {
            userRepository.findById(course.getTeacherId()).ifPresent(course::setTeacher);
        }
        return courseRepository.save(course);
    }

    @Autowired
    private GradeRepository gradeRepository;
    
    @Autowired
    private SelectionRepository selectionRepository;
    
    @Override
    @Transactional
    public void deleteCourse(Long id) {
        logger.debug("开始删除课程，课程ID: {}", id);
        try {
            // 直接删除关联的成绩记录
            logger.debug("删除课程关联的成绩记录，课程ID: {}", id);
            gradeRepository.deleteByCourse_Id(id);
            logger.debug("成绩记录删除成功，课程ID: {}", id);
            
            // 直接删除关联的选课记录
            logger.debug("删除课程关联的选课记录，课程ID: {}", id);
            selectionRepository.deleteByCourse_Id(id);
            logger.debug("选课记录删除成功，课程ID: {}", id);
            
            // 最后删除课程记录
            logger.debug("删除课程记录，课程ID: {}", id);
            courseRepository.deleteById(id);
            logger.debug("课程记录删除成功，课程ID: {}", id);
        } catch (Exception e) {
            logger.error("删除课程失败，课程ID: {}", id, e);
            throw e;
        }
        logger.debug("课程删除完成，课程ID: {}", id);
    }

    @Override
    public List<Course> searchCourses(String keyword, String courseType) {
        List<Course> courses;
        if (keyword != null && !keyword.isEmpty()) {
            courses = courseRepository.findByNameContaining(keyword);
        } else {
            courses = courseRepository.findAll();
        }
        // 确保每个课程的credit字段有值，默认为0.0
        courses.forEach(course -> {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        });
        return courses;
    }

    @Override
    public List<Course> getCoursesBySemester(String semester) {
        // 暂时返回所有课程，因为数据库中没有semester字段
        List<Course> courses = courseRepository.findAll();
        // 确保每个课程的credit字段有值，默认为0.0
        courses.forEach(course -> {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        });
        return courses;
    }

    @Override
    public List<Course> getCoursesByTeacher(String teacher) {
        // 暂时返回所有课程，因为数据库中没有teacher字段
        List<Course> courses = courseRepository.findAll();
        // 确保每个课程的credit字段有值，默认为0.0
        courses.forEach(course -> {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        });
        return courses;
    }
    
    @Override
    public List<Course> getCoursesByTeacherId(Long teacherId) {
        // 根据教师ID查询课程
        List<Course> courses = courseRepository.findByTeacher_Id(teacherId);
        // 确保每个课程的credit字段有值，默认为0
        courses.forEach(course -> {
            if (course.getCredit() == null) {
                course.setCredit(0.0);
            }
        });
        return courses;
    }
    
    @Override
    public long countTotalCourses() {
        return courseRepository.count();
    }
    
    @Override
    public long countCoursesByTeacherId(Long teacherId) {
        return courseRepository.countByTeacher_Id(teacherId);
    }
}
