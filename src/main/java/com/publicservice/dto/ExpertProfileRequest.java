package com.publicservice.dto;

public class ExpertProfileRequest {

    private String expertType;
    private String name;
    private String office;
    private String phone;
    private String city;
    private String district;
    private String roadAddress;
    private String field;
    private String consultTime;
    private Integer experienceYears;
    private Integer price;

    public String getExpertType() { return expertType; }
    public void setExpertType(String expertType) { this.expertType = expertType; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getOffice() { return office; }
    public void setOffice(String office) { this.office = office; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getRoadAddress() { return roadAddress; }
    public void setRoadAddress(String roadAddress) { this.roadAddress = roadAddress; }
    public String getField() { return field; }
    public void setField(String field) { this.field = field; }
    public String getConsultTime() { return consultTime; }
    public void setConsultTime(String consultTime) { this.consultTime = consultTime; }
    public Integer getExperienceYears() { return experienceYears; }
    public void setExperienceYears(Integer experienceYears) { this.experienceYears = experienceYears; }
    public Integer getPrice() { return price; }
    public void setPrice(Integer price) { this.price = price; }
}
