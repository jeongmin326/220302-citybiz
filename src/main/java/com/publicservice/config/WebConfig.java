package com.publicservice.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull; // 1. 이 줄을 추가하세요
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(@NonNull ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/img_space/**")
                .addResourceLocations("file:///F:/publicservice/img_space/");
    }
}