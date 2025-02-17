package com.SE.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.SE.entity.UserEntity;
import com.SE.repository.UserRepository;

@Controller
public class SessionController {
	
	@Autowired
	UserRepository userRepo;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@GetMapping( value ={"/" , "landingpage"})
	public String landingPage()
	{
		return "LandingPage";
	}
	
	@GetMapping("signup")
	public String signUp() {
		return "SignUp";
	}

	@GetMapping("login")
	public String login() {
		return "Login";
	}
	
	@PostMapping("saveuser")
	public String saveUser(UserEntity user) {
		String encoPassword = passwordEncoder.encode(user.getPassword());
		user.setPassword(encoPassword);

		

		userRepo.save(user);
		
		return "Login";
	}
}
