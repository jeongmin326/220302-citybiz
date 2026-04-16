package com.publicservice.dto;

import com.publicservice.entity.Accountant;
import com.publicservice.entity.LaborAttorney;
import com.publicservice.entity.Lawyer;
import com.publicservice.entity.PatentAttorney;
import com.publicservice.entity.TaxAccountant;
import java.math.BigDecimal;

public class ExpertDto {

    private Long id;
    private String name;
    private String office;
    private String phone;
    private String field;
    private BigDecimal rating;
    private String consultTime;
    private Integer experienceYears;
    private Integer price;
    private String address;
    private String expertType;

    public static ExpertDto from(PatentAttorney e) {
        ExpertDto dto = new ExpertDto();
        dto.id = e.getPatentAttorneyId();
        dto.name = e.getName();
        dto.office = e.getOffice();
        dto.phone = e.getPhone();
        dto.field = e.getField();
        dto.rating = e.getRating();
        dto.consultTime = e.getConsultTime();
        dto.experienceYears = e.getExperienceYears();
        dto.price = e.getPrice();
        dto.address = e.getAddress();
        dto.expertType = "변리사";
        return dto;
    }

    public static ExpertDto from(TaxAccountant e) {
        ExpertDto dto = new ExpertDto();
        dto.id = e.getId();
        dto.name = e.getName();
        dto.office = e.getOffice();
        dto.phone = e.getPhone();
        dto.field = e.getField();
        dto.rating = e.getRating();
        dto.consultTime = e.getConsultTime();
        dto.experienceYears = e.getExperienceYears();
        dto.price = e.getPrice();
        dto.address = e.getAddr();
        dto.expertType = "세무사";
        return dto;
    }

    public static ExpertDto from(Accountant e) {
        ExpertDto dto = new ExpertDto();
        dto.id = e.getId();
        dto.name = e.getName();
        dto.office = e.getOffice();
        dto.phone = e.getPhone();
        dto.field = e.getField();
        dto.rating = e.getRating();
        dto.consultTime = e.getConsultTime();
        dto.experienceYears = e.getExperienceYears();
        dto.price = e.getPrice();
        dto.address = e.getAddr();
        dto.expertType = "회계사";
        return dto;
    }

    public static ExpertDto from(LaborAttorney e) {
        ExpertDto dto = new ExpertDto();
        dto.id = e.getId();
        dto.name = e.getName();
        dto.office = e.getOffice();
        dto.phone = e.getPhone();
        dto.field = e.getField();
        dto.rating = e.getRating();
        dto.consultTime = e.getConsultTime();
        dto.experienceYears = e.getExperienceYears();
        dto.price = e.getPrice();
        dto.address = e.getAddr();
        dto.expertType = "노무사";
        return dto;
    }

    public static ExpertDto from(Lawyer e) {
        ExpertDto dto = new ExpertDto();
        dto.id = e.getId();
        dto.name = e.getName();
        dto.office = e.getOffice();
        dto.phone = e.getPhone();
        dto.field = e.getField();
        dto.rating = e.getRating();
        dto.consultTime = e.getConsultTime();
        dto.experienceYears = e.getExperienceYears();
        dto.price = e.getPrice();
        dto.address = e.getAddr();
        dto.expertType = "변호사";
        return dto;
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public String getOffice() { return office; }
    public String getPhone() { return phone; }
    public String getField() { return field; }
    public BigDecimal getRating() { return rating; }
    public String getConsultTime() { return consultTime; }
    public Integer getExperienceYears() { return experienceYears; }
    public Integer getPrice() { return price; }
    public String getAddress() { return address; }
    public String getExpertType() { return expertType; }
}
