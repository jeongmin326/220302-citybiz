package com.publicservice.config;

import com.publicservice.interceptor.PlanCheckInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private PlanCheckInterceptor planCheckInterceptor;

    @Override
    public void addResourceHandlers(@NonNull ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/img_space/**")
                .addResourceLocations("file:///F:/publicservice/img_space/");
    }

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        registry.addInterceptor(planCheckInterceptor)
                .addPathPatterns("/mypage/spaceRegi", "/mypage/spaceEdit", "/mypage/expertProfile");
    }
}