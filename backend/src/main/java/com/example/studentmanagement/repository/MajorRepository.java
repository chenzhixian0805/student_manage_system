package com.example.studentmanagement.repository;

import com.example.studentmanagement.entity.Major;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MajorRepository extends JpaRepository<Major, Long> {
    
    // 根据专业名称查询专业
    Major findByMajorName(String majorName);
}
