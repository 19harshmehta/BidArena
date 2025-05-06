package com.SE.service;

import java.security.SecureRandom;
import java.util.Random;

import org.springframework.stereotype.Service;

import com.SE.repository.AuctionRepository;

@Service
public class AuctionService 
{
	private final AuctionRepository auctionRepository;
    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final int CODE_LENGTH = 6;
    private final Random random = new SecureRandom();

    public AuctionService(AuctionRepository auctionRepository) {
        this.auctionRepository = auctionRepository;
    }

    public String generateUniqueAuctionCode() {
        String auctionCode;

        // Keep generating until we find a truly unique code
        do {
            auctionCode = generateRandomCode();
        } while (auctionRepository.existsByAuctionCode(auctionCode));

        return auctionCode;
    }

    private String generateRandomCode() {
        StringBuilder code = new StringBuilder(CODE_LENGTH);
        for (int i = 0; i < CODE_LENGTH; i++) {
            code.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
        }
        return code.toString();
    }
}
