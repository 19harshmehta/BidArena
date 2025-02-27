package com.SE.controller;

import java.util.Optional;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.SE.dto.LoginDto;
import com.SE.entity.UserEntity;
import com.SE.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {
	
	@Autowired
	UserRepository userRepo;
	
	@Autowired
	BCryptPasswordEncoder bcrypt;
	
//	@GetMapping( value ={"/" , "landingpage"})
//	public String landingPage()
//	{
//		return "LandingPage";
//	}
	
	@GetMapping("signup")
	public String signUp() {
		return "Signup";
	}

	@GetMapping("login")
	public String loginfile() {
		return "Login";
	}
	
	@PostMapping("saveuser")
	public String saveUser(UserEntity user) {
		String encoPassword = bcrypt.encode(user.getPassword());
		user.setPassword(encoPassword);
		user.setRole(UserEntity.Role.AUCTIONEER);
		

		userRepo.save(user);
		
		return "Login";
	}
	
	@PostMapping("/authenticate")
	public String authenticate(LoginDto loginDto, Model model, HttpSession session) {

		Optional<UserEntity> opt = userRepo.findByEmail(loginDto.getEmail());

		if (opt.isPresent()) {
			UserEntity user = opt.get();
				if (bcrypt.matches(loginDto.getPassword(), user.getPassword())) {

					session.setAttribute("user", user);
					session.setAttribute("userId", user.getUserId());
//					session.setMaxInactiveInterval(43200);
					model.addAttribute("msg","Login Done");

					
					
						return "redirect:/signup";
					}

			
		}
		model.addAttribute("error", "Invalid Credentials...");
		return "Login";
	}
}
