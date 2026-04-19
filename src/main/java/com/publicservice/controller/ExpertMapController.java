package com.publicservice.controller;

import com.publicservice.dto.ExpertMapDto;
import com.publicservice.service.ExpertMapService;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/experts")
public class ExpertMapController {

    private final ExpertMapService expertMapService;

    @Value("${naver.maps.client.id:}")
    private String naverClientId;

    public ExpertMapController(ExpertMapService expertMapService) {
        this.expertMapService = expertMapService;
    }

    @GetMapping("/map/data")
    @ResponseBody
    public ResponseEntity<ExpertMapDto> expertMapData(
            @RequestParam("type") String type,
            @RequestParam("id") Long id) {
        return expertMapService.findByTypeAndId(type, id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/map")
    public String expertMap(
            @RequestParam("type") String type,
            @RequestParam("id") Long id,
            Model model) {

        Optional<ExpertMapDto> result = expertMapService.findByTypeAndId(type, id);
        if (result.isEmpty()) {
            return "redirect:/consulting";
        }
        model.addAttribute("expert", result.get());
        model.addAttribute("naverClientId", naverClientId);
        return "home/expertMap";
    }
}
