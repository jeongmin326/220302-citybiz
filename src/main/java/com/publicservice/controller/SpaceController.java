package com.publicservice.controller;

import com.publicservice.entity.Space;
import com.publicservice.repository.SpaceRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/spaces")
public class SpaceController {

    private final SpaceRepository spaceRepository;

    public SpaceController(SpaceRepository spaceRepository) {
        this.spaceRepository = spaceRepository;
    }

    @GetMapping
    public List<Space> getSpaces() {
        return spaceRepository.findAll();
    }
}