package com.example.intern;

import java.util.Collections;

import org.junit.jupiter.api.Test;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.intern.controller.InternController;
import com.example.intern.model.Intern;
import com.example.intern.service.InternService;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebMvcTest(InternController.class)
public class InternControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private InternService internService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void testGetInterns() throws Exception {
        when(internService.getAllResources()).thenReturn(Collections.emptyList());

        mockMvc.perform(get("/api/intern"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }

    @Test
    public void testCreateIntern() throws Exception {
        Intern intern = new Intern();
        intern.setName("John Doe");
        intern.setAge(25);

        mockMvc.perform(post("/api/intern/create")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(intern)))
                .andExpect(status().isOk());

        verify(internService, times(1)).createIntern(any(Intern.class));
    }

    @Test
    public void testUpdateIntern() throws Exception {
        Intern updatedIntern = new Intern();
        updatedIntern.setName("Jane Doe");
        updatedIntern.setAge(28);

        mockMvc.perform(put("/api/intern/update/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updatedIntern)))
                .andExpect(status().isOk());

        verify(internService, times(1)).updateIntern(eq(1L), any(Intern.class));
    }

    @Test
    public void testUpdateInternByName() throws Exception {
        Intern updatedIntern = new Intern();
        updatedIntern.setName("Jane Doe");
        updatedIntern.setAge(28);

        mockMvc.perform(put("/api/intern/updateName/John")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updatedIntern)))
                .andExpect(status().isOk());

        verify(internService, times(1)).upIntern(eq("John"), any(Intern.class));
    }

    @Test
    public void testDeleteIntern() throws Exception {
        mockMvc.perform(delete("/api/intern/delete/1"))
                .andExpect(status().isOk());

        verify(internService, times(1)).deleteIntern(1L);
    }
}
