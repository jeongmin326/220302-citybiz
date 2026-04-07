package com.publicservice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.publicservice.dao.UserDAO;
import com.publicservice.repository.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserDAO userDAO;

   public String findEmailByNameAndPhone(String name, String phone) {

        return userRepository.findByNameAndPhone(name, phone)
                .map(user -> user.getEmail())
                .orElse(null);
    }

    public boolean resetPassword(String email, String name, String phone) {
        return userRepository.findByEmailAndNameAndPhone(email, name, phone)
                .map(user -> {
                    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
                    user.setPasswordHash(encoder.encode("1234"));
                    userRepository.save(user);
                    return true;
                })
                .orElse(false);
    }
}