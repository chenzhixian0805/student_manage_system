package com.example.studentmanagement.service.impl;

import com.example.studentmanagement.entity.Grade;
import com.example.studentmanagement.entity.Selection;
import com.example.studentmanagement.entity.Student;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.repository.GradeRepository;
import com.example.studentmanagement.repository.SelectionRepository;
import com.example.studentmanagement.repository.StudentRepository;
import com.example.studentmanagement.service.StudentService;
import com.example.studentmanagement.service.UserService;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class StudentServiceImpl implements StudentService {

    private static final Logger logger = LoggerFactory.getLogger(StudentServiceImpl.class);
    
    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private UserService userService;
    
    // 应用启动时自动同步学生性别到用户表
    @PostConstruct
    public void init() {
        logger.info("开始同步学生性别到用户表...");
        syncStudentGenderToUser();
        logger.info("学生性别同步完成");
    }

    @Override
    public List<Student> getAllStudents() {
        // 使用自定义的查询方法，确保同时获取专业和学院信息
        return studentRepository.findAllWithMajorAndCollege();
    }

    @Override
    public Student getStudentById(Long id) {
        return studentRepository.findByIdWithMajorAndCollege(id).orElse(null);
    }

    @Override
    public Student getStudentByStudentId(String studentId) {
        return studentRepository.findByStudentIdWithMajorAndCollege(studentId);
    }

    @Override
    public Student saveStudent(Student student) {
        // 保存学生表
        Student savedStudent = studentRepository.save(student);
        
        // 如果是新创建的学生，尝试更新用户表中的性别信息
        String studentId = savedStudent.getStudentId();
        User user = userService.findByUsername(studentId);
        if (user != null && student.getGender() != null) {
            user.setGender(student.getGender());
            userService.saveUser(user);
        }
        
        return savedStudent;
    }
    
    @Override
    public Student updateStudent(Long id, Student studentUpdate) {
        // 使用自定义查询方法获取现有学生（包含关联信息）
        Student existingStudent = studentRepository.findByIdWithMajorAndCollege(id).orElse(null);
        if (existingStudent != null) {
            // 保存学生ID用于后续用户表更新
            String studentId = existingStudent.getStudentId();
            
            // 只更新传递的非空字段
            if (studentUpdate.getName() != null) {
                existingStudent.setName(studentUpdate.getName());
            }
            if (studentUpdate.getEmail() != null) {
                existingStudent.setEmail(studentUpdate.getEmail());
            }
            if (studentUpdate.getPhone() != null) {
                existingStudent.setPhone(studentUpdate.getPhone());
            }
            if (studentUpdate.getStatus() != null) {
                existingStudent.setStatus(studentUpdate.getStatus());
            }
            if (studentUpdate.getGender() != null) {
                existingStudent.setGender(studentUpdate.getGender());
            }
            
            // 保存学生表更新
            Student savedStudent = studentRepository.save(existingStudent);
            
            // 无论是否有变更，都尝试更新用户表，确保数据一致性
            // 根据学生ID查找对应的用户
            User user = userService.findByUsername(studentId);
            if (user != null) {
                // 更新用户表中的姓名、邮箱、手机号和性别
                if (studentUpdate.getName() != null) {
                    user.setName(studentUpdate.getName());
                }
                if (studentUpdate.getEmail() != null) {
                    user.setEmail(studentUpdate.getEmail());
                }
                if (studentUpdate.getPhone() != null) {
                    user.setPhone(studentUpdate.getPhone());
                }
                if (studentUpdate.getGender() != null) {
                    user.setGender(studentUpdate.getGender());
                }
                // 保存用户表更新
                userService.saveUser(user);
            }
            
            return savedStudent;
        } else {
            return null;
        }
    }

    @Autowired
    private GradeRepository gradeRepository;
    
    @Autowired
    private SelectionRepository selectionRepository;
    
    @Override
    @Transactional
    public void deleteStudent(Long id) {
        logger.debug("开始删除学生，学生ID: {}", id);
        try {
            // 直接删除关联的成绩记录
            logger.debug("删除学生关联的成绩记录，学生ID: {}", id);
            gradeRepository.deleteByStudent_Id(id);
            logger.debug("成绩记录删除成功，学生ID: {}", id);
            
            // 直接删除关联的选课记录
            logger.debug("删除学生关联的选课记录，学生ID: {}", id);
            selectionRepository.deleteByStudent_Id(id);
            logger.debug("选课记录删除成功，学生ID: {}", id);
            
            // 最后删除学生记录
            logger.debug("删除学生记录，学生ID: {}", id);
            studentRepository.deleteById(id);
            logger.debug("学生记录删除成功，学生ID: {}", id);
        } catch (Exception e) {
            logger.error("删除学生失败，学生ID: {}", id, e);
            throw e;
        }
        logger.debug("学生删除完成，学生ID: {}", id);
    }

    @Override
    public List<Student> searchStudents(String keyword, String className) {
        if (keyword != null && !keyword.isEmpty() && className != null && !className.isEmpty()) {
            return studentRepository.findByNameContainingAndClassName(keyword, className);
        } else if (keyword != null && !keyword.isEmpty()) {
            return studentRepository.findByNameContaining(keyword);
        } else if (className != null && !className.isEmpty()) {
            return studentRepository.findByClassName(className);
        } else {
            // 使用自定义的查询方法，确保同时获取专业和学院信息
            return studentRepository.findAllWithMajorAndCollege();
        }
    }

    @Override
    public long countTotalStudents() {
        // 直接使用JpaRepository的count()方法，确保能正确返回学生总数
        return studentRepository.count();
    }

    @Override
    public List<Object[]> countStudentsByGender() {
        return studentRepository.countStudentsByGender();
    }
    
    @Override
    public List<Student> getStudentsByTeacherId(Long teacherId) {
        // 通过成绩表查询该教师课程的所有学生
        return studentRepository.findStudentsByTeacherId(teacherId);
    }
    
    @Override
    public List<Object[]> countStudentsByStatus() {
        return studentRepository.countStudentsByStatus();
    }
    
    @Override
    public void syncStudentGenderToUser() {
        // 获取所有学生
        List<Student> students = studentRepository.findAllWithMajorAndCollege();
        
        // 提取所有学生ID
        List<String> studentIds = students.stream()
                .filter(student -> student.getStudentId() != null)
                .map(Student::getStudentId)
                .toList();
        
        // 批量查询所有相关用户
        List<User> users = userService.findUsersByUsernames(studentIds);
        
        // 创建学生ID到性别的映射
        Map<String, String> studentGenderMap = students.stream()
                .filter(student -> student.getStudentId() != null && student.getGender() != null)
                .collect(Collectors.toMap(Student::getStudentId, Student::getGender));
        
        // 创建学生ID到用户的映射
        Map<String, User> userMap = users.stream()
                .collect(Collectors.toMap(User::getUsername, Function.identity()));
        
        // 遍历所有用户，更新性别信息
        List<User> usersToUpdate = new ArrayList<>();
        for (Map.Entry<String, User> entry : userMap.entrySet()) {
            String studentId = entry.getKey();
            User user = entry.getValue();
            String gender = studentGenderMap.get(studentId);
            
            if (gender != null && !gender.equals(user.getGender())) {
                user.setGender(gender);
                usersToUpdate.add(user);
            }
        }
        
        // 批量保存更新后的用户
        if (!usersToUpdate.isEmpty()) {
            userService.batchSaveUsers(usersToUpdate);
        }
    }
}
