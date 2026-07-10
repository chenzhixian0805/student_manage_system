package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.College;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CollegeRepository extends JpaRepository<College, Long> {
    
    // 根据学院名称查询学院
    College findByCollegeName(String collegeName);
}
