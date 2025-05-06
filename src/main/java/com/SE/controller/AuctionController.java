package com.SE.controller;

import java.net.URL;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.util.StreamUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.SE.dto.PlayerAuctionData;
import com.SE.entity.AuctionEntity;
import com.SE.entity.AuctionEntity.AuctionStatus;
import com.SE.entity.PlayerEntity;
import com.SE.entity.PlayerEntity.PlayerStatus;
import com.SE.entity.TeamEntity;
import com.SE.entity.UserEntity;
import com.SE.repository.AuctionRepository;
import com.SE.repository.PlayerRepository;
import com.SE.repository.TeamRepository;
import com.SE.service.AuctionService;
import com.SE.service.PlayerService;
import com.SE.util.LocalDateTimeAdapter;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.itextpdf.text.pdf.codec.Base64.InputStream;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuctionController 
{
	private static final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();
	@Autowired
	AuctionRepository auctionRepo;
	
	@Autowired
	PlayerRepository playerRepo;
	
	@Autowired
	TeamRepository teamRepo;
	
	@Autowired
	PlayerService playerService;
	
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
        List<AuctionEntity> auctions = auctionRepo.findByCreatedBy(user);
		session.setAttribute("auctions", auctions);
		return "redirect:/welcome";
	}
	
	@GetMapping("uploaddata")
	public String dataUpload(@RequestParam("auctionId") Integer auctionId, Model model) {
	    model.addAttribute("auctionId", auctionId);
	    return "AddData"; // This is your AddData.jsp
	}
	private static final Logger logger = LoggerFactory.getLogger(AuctionController.class);
	@GetMapping("/startAuction")
	public String startAuction(@RequestParam("id") Integer auctionId, HttpSession session,Model model) {
		Optional<AuctionEntity> auctionOpt = auctionRepo.findById(auctionId);

	    if (auctionOpt.isPresent()) {
	        AuctionEntity auction = auctionOpt.get();
	        auction.setStatus(AuctionStatus.ONGOING);
	        auctionRepo.save(auction);
	        
	        List<PlayerEntity> players = playerRepo.findByAuction_AuctionIdAndStatus(auctionId, PlayerStatus.UNSOLD);
	        List<TeamEntity> teams = teamRepo.findByAuction_AuctionId(auctionId);
 
	        logger.info("Players found for auction {}: {}", auctionId, players.size());

	        model.addAttribute("auction", auction);
	        model.addAttribute("teams", teams);
	        model.addAttribute("players",players);
	        
	    } else {
	        logger.warn("Auction with ID {} not found!", auctionId);
	    }


	    return "AuctionPage";
	}

	
	@GetMapping("auctionpage")
	public String startAuction() {
		return "AuctionPage";
	}

	
	@PostMapping("/saveAuctionedPlayers")
	public ResponseEntity<?> saveAuctionedPlayers(@RequestBody List<PlayerAuctionData> players) {
	    for (PlayerAuctionData playerData : players) {
	        PlayerEntity player = playerRepo.findById(playerData.getPlayerId()).orElse(null);
	        TeamEntity team = teamRepo.findById(playerData.getSoldToTeam()).orElse(null);

	        if (player != null && team != null) {
	            player.setSoldToTeam(team);
	            player.setSoldPrice(playerData.getSoldPrice());
	            player.setStatus(PlayerEntity.PlayerStatus.SOLD);
	            team.setWallet(team.getWallet() - playerData.getSoldPrice()); // Deduct balance
	            playerRepo.save(player);
	            teamRepo.save(team);
	        }
	    }
	    return ResponseEntity.ok("Players saved successfully.");
	}
	
	@PostMapping("/endAuction")
	public ResponseEntity<?> endAuction(@RequestParam("id") Integer auctionId, HttpSession session) {
	    Optional<AuctionEntity> auctionOpt = auctionRepo.findById(auctionId);

	    if (auctionOpt.isPresent()) {
	        AuctionEntity auction = auctionOpt.get();
	        auction.setStatus(AuctionStatus.COMPLETED);
	        auctionRepo.save(auction);

	        session.setAttribute("auctions", auctionRepo.findByCreatedBy((UserEntity) session.getAttribute("user")));
	        
	        return ResponseEntity.ok("{\"success\": true}");
	    }
	    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("{\"success\": false, \"message\": \"Auction not found\"}");
	}

	@GetMapping("/viewdetails")
    public String viewAuctionDetails(@RequestParam("auctionId") Integer auctionId, Model model) {

        List<PlayerEntity> players = playerRepo.findByAuction_AuctionId(auctionId);
        List<TeamEntity> teams = teamRepo.findTeamsByAuctionIdList(auctionId);

        Integer totalPlayers = players.size();
        Integer totalTeams = teams.size();

        Integer soldPlayers = (int) players.stream().filter(p -> p.getStatus().toString().equals("SOLD")).count();
        Integer unsoldPlayers = (int) players.stream().filter(p -> p.getStatus().toString().equals("UNSOLD")).count();

        Map<Integer, PlayerEntity> teamHighestBidPlayerMap = new HashMap<>();

        Map<Integer, PlayerEntity> teamLowestBidPlayerMap = new HashMap<>();
        
        Map<Integer, List<PlayerEntity>> teamPlayersMap = new HashMap<>();
        
        PlayerEntity overallHighestBidPlayer = null;
        PlayerEntity overallLowestBidPlayer = null;
        
     
        for (TeamEntity team : teams) {
            List<PlayerEntity> teamPlayers = playerRepo.findSoldPlayersByTeamAndAuction(team, auctionId);
            teamPlayersMap.put(team.getTeamId(), teamPlayers);
            
         // Highest Bid Player of Team
            PlayerEntity highestBidPlayer = teamPlayers.stream()
                    .max(Comparator.comparing(PlayerEntity::getSoldPrice))
                    .orElse(null);

            // Lowest Bid Player of Team
            PlayerEntity lowestBidPlayer = teamPlayers.stream()
                    .min(Comparator.comparing(PlayerEntity::getSoldPrice))
                    .orElse(null);

            teamHighestBidPlayerMap.put(team.getTeamId(), highestBidPlayer);
            teamLowestBidPlayerMap.put(team.getTeamId(), lowestBidPlayer);
            
            
            
            
        }
     // Highest Bid Player in Auction
        overallHighestBidPlayer = players.stream()
                .filter(p -> p.getStatus().toString().equals("SOLD"))
                .max(Comparator.comparing(PlayerEntity::getSoldPrice))
                .orElse(null);

        //Lowest Bid Player in Auction
        overallLowestBidPlayer = players.stream()
                .filter(p -> p.getStatus().toString().equals("SOLD"))
                .min(Comparator.comparing(PlayerEntity::getSoldPrice))
                .orElse(null);
        
        model.addAttribute("totalPlayers", totalPlayers);
        model.addAttribute("totalTeams", totalTeams);
        model.addAttribute("soldPlayers", soldPlayers);
        model.addAttribute("unsoldPlayers", unsoldPlayers);
        model.addAttribute("teams", teams);
        model.addAttribute("teamPlayersMap", teamPlayersMap);
        model.addAttribute("teamHighestBidPlayerMap", teamHighestBidPlayerMap);
        model.addAttribute("teamLowestBidPlayerMap", teamLowestBidPlayerMap);
        model.addAttribute("overallHighestBidPlayer", overallHighestBidPlayer);
        model.addAttribute("overallLowestBidPlayer", overallLowestBidPlayer);

        return "ViewAuctionDetails"; 
    }
	
	
	@GetMapping("/reports")
	public String viewUserReports(HttpSession session, Model model) {
	    
	    UserEntity user = (UserEntity) session.getAttribute("user");

	    List<AuctionEntity> userAuctions = auctionRepo.findByCreatedBy(user);  // Assuming you have this method

	    model.addAttribute("userAuctions", userAuctions);

	    return "Reports";
	}
	
	
	
	
	
}
