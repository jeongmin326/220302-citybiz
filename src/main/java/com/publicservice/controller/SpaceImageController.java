package com.publicservice.controller;

import com.publicservice.entity.SpaceImage;
import com.publicservice.repository.SpaceImageRepository;
import com.publicservice.service.SpaceImageService;
import jakarta.servlet.http.HttpServletRequest;
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
    private final SpaceImageRepository spaceImageRepository;

    public SpaceImageController(SpaceImageService spaceImageService,
                                SpaceImageRepository spaceImageRepository) {
        this.spaceImageService = spaceImageService;
        this.spaceImageRepository = spaceImageRepository;
    }

    @GetMapping("/{imageId}")
    public ResponseEntity<byte[]> getImage(@PathVariable("imageId") Long imageId,
                                           HttpServletRequest request) {
        Optional<SpaceImage> opt = spaceImageService.findById(imageId);
        if (opt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        SpaceImage img = opt.get();
        String etag = "\"img-" + img.getImageId() + "\"";
        if (etag.equals(request.getHeader("If-None-Match"))) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }
        return buildImageResponse(img.getImageData(), img.getContentType(), etag);
    }

    @GetMapping("/main/{spaceId}")
    public ResponseEntity<byte[]> getMainImage(@PathVariable("spaceId") Long spaceId,
                                               HttpServletRequest request) {
        Optional<SpaceImage> opt = spaceImageService.findMainImage(spaceId);
        if (opt.isPresent()) {
            SpaceImage img = opt.get();
            String etag = "\"img-" + img.getImageId() + "\"";
            if (etag.equals(request.getHeader("If-None-Match"))) {
                return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
            }
            return buildImageResponse(img.getImageData(), img.getContentType(), etag);
        }

        return spaceImageRepository.findFirstByIsMain("D")
                .map(def -> {
                    String etag = "\"img-default\"";
                    if (etag.equals(request.getHeader("If-None-Match"))) {
                        return ResponseEntity.status(HttpStatus.NOT_MODIFIED).<byte[]>build();
                    }
                    return buildImageResponse(def.getImageData(), def.getContentType(), etag);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("spaceId") Long spaceId,
            @RequestParam("image")   MultipartFile image,
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

    private ResponseEntity<byte[]> buildImageResponse(byte[] data, String rawContentType, String etag) {
        String contentType = (rawContentType != null && !rawContentType.isBlank())
                ? rawContentType : "image/jpeg";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(contentType));
        headers.setContentLength(data.length);
        headers.setCacheControl("public, max-age=86400");
        headers.setETag(etag);
        return new ResponseEntity<>(data, headers, HttpStatus.OK);
    }
}
