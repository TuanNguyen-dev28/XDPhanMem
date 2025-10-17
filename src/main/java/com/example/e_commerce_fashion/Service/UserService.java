package com.example.e_commerce_fashion.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.e_commerce_fashion.Model.User;
import com.example.e_commerce_fashion.Repository.UserRepository;
import com.example.e_commerce_fashion.exception.UsernameAlreadyExistsException;

import java.time.LocalDateTime;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new UsernameAlreadyExistsException("Tên đăng nhập '" + user.getUsername() + "' đã tồn tại. Vui lòng chọn tên khác.");
        }
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        user.setRole(User.Role.user);
        return userRepository.save(user);
    }
}