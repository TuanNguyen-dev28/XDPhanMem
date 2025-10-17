package com.example.e_commerce_fashion.Service;

import com.example.e_commerce_fashion.Exception.UsernameAlreadyExistsException;
import com.example.e_commerce_fashion.Model.User;
import com.example.e_commerce_fashion.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new UsernameAlreadyExistsException("Tên đăng nhập '" + user.getUsername() + "' đã tồn tại.");
        }
        // Mã hóa mật khẩu trước khi lưu
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        // Gán vai trò mặc định là 'user'
        user.setRole(User.Role.user);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

}
