package com.publicservice.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;

@Repository
public class UserDAO {

    @Autowired
    private DataSource dataSource;

    public void insertUser(
            String email,
            String password,
            String name,
            String phone,
            String role,
            String companyName,
            String bizNo,
            String businessStage,
            String industry,
            String status
    ) throws Exception {

        String sql = "INSERT INTO users (" +
                "email, password_hash, name, phone, role, " +
                "company_name, biz_no, business_stage, industry, status" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, name);
            ps.setString(4, phone);
            ps.setString(5, role);
            ps.setString(6, companyName);
            ps.setString(7, bizNo);
            ps.setString(8, businessStage);
            ps.setString(9, industry);
            ps.setString(10, status);

            ps.executeUpdate();
        }
    }

    // 이메일 중복 체크
    public boolean existsByEmail(String email) throws Exception {
    String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

    try (Connection conn = dataSource.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, email);

        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    }

    return false;
}


}