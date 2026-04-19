package com.publicservice.dto;

import java.math.BigDecimal;

public class ExpertMapDto {

    private Long id;
    private String name;
    private String office;
    private String phone;
    private String address;
    private String expertType;
    private BigDecimal latitude;
    private BigDecimal longitude;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getOffice() { return office; }
    public void setOffice(String office) { this.office = office; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getExpertType() { return expertType; }
    public void setExpertType(String expertType) { this.expertType = expertType; }

    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }

    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }
}
