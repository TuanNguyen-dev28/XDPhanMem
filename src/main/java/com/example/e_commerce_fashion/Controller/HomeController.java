package com.example.e_commerce_fashion.Controller;

import com.example.e_commerce_fashion.Model.User;
import com.example.e_commerce_fashion.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class HomeController {
    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String home() {
        return "index.html";
    }

    @GetMapping("/login")
    public String login() {
        return "sign";
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        // Thêm thuộc tính để JS biết cần kích hoạt panel đăng ký
        model.addAttribute("showRegister", true);
        return "sign";
    }

    @PostMapping("/register")
    public String processRegistration(@ModelAttribute("user") User user, Model model) throws Exception {
        try {
            userService.registerUser(user);
            return "redirect:/login?register_success=true";
        } catch (UsernameNotFoundException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("showRegister", true); // Giữ form đăng ký mở khi có lỗi
            return "sign";
        }
    }
}
