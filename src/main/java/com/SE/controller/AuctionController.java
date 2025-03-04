package com.SE.controller;

import java.time.LocalDateTime;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.SE.entity.AuctionEntity;
import com.SE.entity.AuctionEntity.AuctionStatus;
import com.SE.entity.UserEntity;
import com.SE.repository.AuctionRepository;
import com.SE.service.AuctionService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuctionController 
{
	@Autowired
	AuctionRepository auctionRepo;
	
	@Autowired
    private AuctionService auctionService;
	
	
	@GetMapping("createauction")
	public String createAucPage() {
		return "CreateAuction";
	}
	
	@PostMapping("createauction")
	public String createAuction(AuctionEntity aucEntity,HttpSession session) {
		
        String uniqueAuctionCode = auctionService.generateUniqueAuctionCode();
        aucEntity.setAuctionCode(uniqueAuctionCode);
        
        aucEntity.setStatus(AuctionStatus.CREATED);
        aucEntity.setCreatedAt(LocalDateTime.now());
        UserEntity user =(UserEntity) session.getAttribute("user");
        aucEntity.setCreatedBy(user);

        auctionRepo.save(aucEntity);
        session.setAttribute("auctionId", aucEntity.getAuctionId());
		return "AddData";
	}
	
	@GetMapping("uploaddata")
	public String dataUpload() {
		return "AddData";
	}

}
