package com.example.studentmanagement.service.impl;

import com.example.studentmanagement.entity.Course;
import com.example.studentmanagement.entity.User;
import com.example.studentmanagement.repository.UserRepository;
import com.example.studentmanagement.service.CourseService;
import com.example.studentmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private CourseService courseService;

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public User saveUser(User user) {
        // 如果密码不为空，才进行加密
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            // 如果密码为空，保留原密码
            if (user.getId() != null) {
                User existingUser = userRepository.findById(user.getId()).orElse(null);
                if (existingUser != null) {
                    user.setPassword(existingUser.getPassword());
                }
            }
        }
        return userRepository.save(user);
    }

    @Override
    public void deleteUser(Long id) {
        // 先获取该教师关联的所有课程
        List<Course> courses = courseService.getCoursesByTeacherId(id);
        // 删除所有关联的课程
        for (Course course : courses) {
            courseService.deleteCourse(course.getId());
        }
        // 然后删除用户
        userRepository.deleteById(id);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public List<User> findUsersByRole(String role) {
        return userRepository.findByRole(role);
    }

    @Override
    public User findByEmployeeId(String employeeId) {
        return userRepository.findByEmployeeId(employeeId);
    }

    @Override
    public boolean existsByEmployeeId(String employeeId) {
        return userRepository.existsByEmployeeId(employeeId);
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    @Override
    public void updateAllUsersPassword(String password) {
        List<User> users = userRepository.findAll();
        String encodedPassword = passwordEncoder.encode(password);
        users.forEach(user -> {
            user.setPassword(encodedPassword);
            userRepository.save(user);
        });
    }

    @Override
    public void resetPassword(Long id, String password) {
        User user = userRepository.findById(id).orElse(null);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(password));
            userRepository.save(user);
        }
    }
    
    @Override
    public List<User> findUsersByUsernames(List<String> usernames) {
        return userRepository.findByUsernameIn(usernames);
    }
    
    @Override
    public void batchSaveUsers(List<User> users) {
        userRepository.saveAll(users);
    }
}