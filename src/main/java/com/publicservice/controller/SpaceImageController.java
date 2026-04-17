package com.publicservice.controller;

import com.publicservice.entity.SpaceImage;
import com.publicservice.service.SpaceImageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/space-images")
public class SpaceImageController {

    private final SpaceImageService spaceImageService;

    public SpaceImageController(SpaceImageService spaceImageService) {
        this.spaceImageService = spaceImageService;
    }

    // ---------------------------------------------------------------
    // GET /space-images/{imageId} — imageId 로 이미지 바이너리 응답
    // JSP: <img src="/space-images/42">
    // ---------------------------------------------------------------
    @GetMapping("/{imageId}")
    public ResponseEntity<byte[]> getImage(@PathVariable("imageId") Long imageId) {
        Optional<SpaceImage> opt = spaceImageService.findById(imageId);
        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return buildImageResponse(opt.get());
    }

    // ---------------------------------------------------------------
    // GET /space-images/main/{spaceId} — 대표 이미지(is_main=Y) 응답
    // JSP: <img src="/space-images/main/${space.spaceId}">
    // ---------------------------------------------------------------
    @GetMapping("/main/{spaceId}")
    public ResponseEntity<byte[]> getMainImage(@PathVariable("spaceId") Long spaceId) {
        Optional<SpaceImage> opt = spaceImageService.findMainImage(spaceId);
        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return buildImageResponse(opt.get());
    }

    // ---------------------------------------------------------------
    // POST /space-images/upload — 추가 이미지 업로드 (호스트 전용)
    // ---------------------------------------------------------------
    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("spaceId")                           Long spaceId,
            @RequestParam("image")                             MultipartFile image,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();

        if (session.getAttribute("loginUserId") == null) {
            result.put("error", "로그인이 필요합니다.");
            return ResponseEntity.status(401).body(result);
        }
        if (image == null || image.isEmpty()) {
            result.put("error", "이미지 파일이 없습니다.");
            return ResponseEntity.badRequest().body(result);
        }

        try {
            SpaceImage saved = spaceImageService.saveMainImage(spaceId, image);
            result.put("success",  true);
            result.put("imageId",  saved.getImageId());
            result.put("imageUrl", "/space-images/" + saved.getImageId());
            return ResponseEntity.ok(result);
        } catch (IOException e) {
            result.put("error", "이미지 저장 실패: " + e.getMessage());
            return ResponseEntity.status(500).body(result);
        }
    }

    // ---------------------------------------------------------------
    private ResponseEntity<byte[]> buildImageResponse(SpaceImage image) {
        String contentType = "image/jpeg";
        String raw = image.getContentType();
        if (raw != null && !raw.isBlank()) {
            contentType = raw;
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(contentType));
        headers.setContentLength(image.getImageData().length);

        return new ResponseEntity<>(image.getImageData(), headers, HttpStatus.OK);
    }
}
