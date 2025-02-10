package com.example.intern.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.intern.model.Intern;

@Service
public class InternService {
    private final List<Intern> internList = new ArrayList<>();

    public List<Intern> getAllResources() {
        return internList;
    }

    public void createIntern(Intern intern) {
        internList.add(intern);
    }

    public void updateIntern(Long id, Intern intern) {
        for (Intern existingIntern : internList) {
            if (existingIntern.getId() == id) {
                existingIntern.setName(intern.getName());
                existingIntern.setAge(intern.getAge());
                return;
            }
        }
    }

    public void upIntern(String name, Intern intern) {
        for (Intern existingIntern : internList) {
            if (existingIntern.getName().equals(name)) {
                existingIntern.setName(intern.getName());
                existingIntern.setAge(intern.getAge());
                return;
            }
        }
    }

    public void deleteIntern(Long id) {
        internList.removeIf(intern -> intern.getId() == id);
    }
}
