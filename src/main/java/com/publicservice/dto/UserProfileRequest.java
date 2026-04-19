package com.publicservice.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserProfileRequest {
    private String phone;
    private String city;
    private String district;
    private String roadAddress;
    private String detailAddress;
    private String businessStage;
    private String industry;
}
