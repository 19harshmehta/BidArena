package com.SE.service;

import org.springframework.stereotype.Service;

@Service
public class OtpGenerator 
{

	public int generateNumericOtp(int length) {
		return 0;
	}

	public String generateOtp(int length) {
		String Capital_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		String Small_chars = "abcdefghijklmnopqrstuvwxyz";
		String numbers = "0123456789";

		String values = Capital_chars + Small_chars + numbers;

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length; i++) {
			
			int index = (int) (Math.random() * values.length());
			sb.append(values.charAt(index));
		}
		return sb.toString();
	}
}
