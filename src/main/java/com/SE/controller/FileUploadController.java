package com.SE.controller;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.SE.entity.AuctionEntity;
import com.SE.entity.TeamEntity;
import com.SE.entity.UserEntity;
import com.SE.repository.AuctionRepository;
import com.SE.service.PlayerService;
import com.SE.service.TeamService;

import jakarta.servlet.http.HttpSession;

@Controller
public class FileUploadController {

    @Autowired
    private TeamService teamService;

    @Autowired
    private PlayerService playerService;
    
    @Autowired
    private AuctionRepository auctionRepo;

    @PostMapping("/uploadfiles")
    public String uploadFiles(@RequestParam("teamsFile") MultipartFile teamsFile,
                              @RequestParam("playersFile") MultipartFile playersFile,
                              @RequestParam("auctionId") Integer auctionId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {

//        Integer auctionId = (Integer) session.getAttribute("auctionId"); // Fetch auctionId from session
        if (auctionId == null) {
            redirectAttributes.addFlashAttribute("error", "Auction ID not found. Please create an auction first.");
            return "redirect:/uploaddata?auctionId=" + auctionId;
        }

        try {
            String teamError = teamService.processAndSaveTeams(teamsFile, auctionId);
            if (teamError != null) {
                redirectAttributes.addFlashAttribute("error", teamError);
                return "redirect:/uploaddata?auctionId=" + auctionId;
            }

            List<TeamEntity> teams = teamService.getTeamsByAuctionId(auctionId);

            playerService.processAndSavePlayers(playersFile, auctionId, teams);

            redirectAttributes.addFlashAttribute("success", "Teams and Players uploaded successfully.");
            UserEntity user =(UserEntity) session.getAttribute("user");
            List<AuctionEntity> auctions = auctionRepo.findByCreatedBy(user);
			session.setAttribute("auctions", auctions);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error processing files: " + e.getMessage());
        }

        return "redirect:/welcome";
    }

}
