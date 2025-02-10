package com.example.intern.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.intern.model.Intern;
import com.example.intern.service.InternService;

@RestController
@RequestMapping("/api/intern")
public class InternController {

    private final InternService internService;

    public InternController(InternService internService) {
        this.internService = internService;
    }

    @GetMapping
    public ResponseEntity<List<Intern>> getAllInterns() {
        return ResponseEntity.ok(internService.getAllResources());
    }

    @PostMapping("/create")
    public ResponseEntity<String> createIntern(@RequestBody Intern intern) {
        internService.createIntern(intern);
        return ResponseEntity.ok("Intern created successfully");
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateIntern(@PathVariable Long id, @RequestBody Intern intern) {
        internService.updateIntern(id, intern);
        return ResponseEntity.ok("Intern updated successfully");
    }

    @PutMapping("/updateName/{name}")
    public ResponseEntity<String> updateInternByName(@PathVariable String name, @RequestBody Intern intern) {
        internService.upIntern(name, intern);
        return ResponseEntity.ok("Intern updated successfully");
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteIntern(@PathVariable Long id) {
        internService.deleteIntern(id);
        return ResponseEntity.ok("Intern deleted successfully");
    }
}
