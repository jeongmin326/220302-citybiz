package com.publicservice.repository;

import com.publicservice.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);
    Optional<User> findByNameAndPhone(String name, String phone);
    Optional<User> findByEmailAndNameAndPhone(String email, String name, String phone);
}