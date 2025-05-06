package com.SE.controller;

import java.util.Date;
import java.util.List;
import java.util.Optional;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.SE.dto.LoginDto;
import com.SE.dto.ResetPasswordDto;
import com.SE.entity.AuctionEntity;
import com.SE.entity.UserEntity;
import com.SE.repository.AuctionRepository;
import com.SE.repository.UserRepository;
import com.SE.service.MailerService;
import com.SE.service.OtpGenerator;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {
	
	@Autowired
	UserRepository userRepo;
	
	@Autowired
	BCryptPasswordEncoder bcrypt;
	
	@Autowired
	OtpGenerator otpGeneratorService;
	
	@Autowired
	MailerService mailerService;
	
	@Autowired
	AuctionRepository auctionRepo;
	
	
	@GetMapping("signup")
	public String signUp() {
		return "Signup";
	}
	
	@GetMapping("welcome")
	public String welcomeFile() {
		return "Welcome";
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
					model.addAttribute("msg","Login Done");

					
					List<AuctionEntity> auctions = auctionRepo.findByCreatedBy(user);
					session.setAttribute("auctions", auctions);
		            	return "Welcome";
					}

			
		}
		model.addAttribute("error", "Invalid Credentials...");
		return "Login";
	}
	
	@GetMapping("verifyemail")
	public String emailVerify() {
		return "VerifyEmail";
	}
	
	@PostMapping("verifyemail")
	public String checkEmail(LoginDto loginDto, Model model) {
		Optional<UserEntity> opt = userRepo.findByEmail(loginDto.getEmail());
		if (opt.isPresent()) {
			UserEntity user = opt.get();	
					String otp = otpGeneratorService.generateOtp(6);
					user.setOtp(otp);
	
					Runnable r = () -> {
	
						mailerService.sendForgotPasswordOTP(user);
					};
					Thread t = new Thread(r);
					t.start();
					userRepo.save(user);
					return "ChangePassword";
			
		} else 
		{
			model.addAttribute("error", "Invalid email please check again or Sign up");
		}
		return "VerifyEmail";
	}
	
	@GetMapping("changepassword")
	public String changePasswd() {
		
		return "ChangePassword";
	}
	
	@PostMapping("changepassword")
	public String changePassword(ResetPasswordDto rDto, Model model) {
		Optional<UserEntity> userOptional = userRepo.findByEmail(rDto.getEmail());
		if (userOptional.isPresent()) {
			UserEntity user = userOptional.get();

			if (user.getOtp().equals(rDto.getOtp())) {
				user.setPassword(bcrypt.encode(rDto.getPassword()));
				userRepo.save(user);
				return "Login";
				
			}
		}
		model.addAttribute("error", "Invalid Credentials...");
		return "ChangePassword";
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
	    
	 
	    session.invalidate();

	    return "redirect:/login"; 
	}
	
}
