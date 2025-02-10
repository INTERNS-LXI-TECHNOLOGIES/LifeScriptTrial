package com.example.intern.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.intern.model.Intern;



@Repository
public interface  InternRepository extends JpaRepository<Intern, Long>{

   Intern findByName(String name);
    
    
}
