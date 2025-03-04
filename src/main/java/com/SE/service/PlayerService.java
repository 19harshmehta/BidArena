package com.SE.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.SE.entity.AuctionEntity;
import com.SE.entity.PlayerEntity;
import com.SE.entity.TeamEntity;
import com.SE.repository.AuctionRepository;
import com.SE.repository.PlayerRepository;
import com.SE.repository.TeamRepository;

@Service
public class PlayerService {

    @Autowired
    private PlayerRepository playerRepo;

    @Autowired
    private TeamRepository teamRepo;

    @Autowired
    private AuctionRepository auctionRepository;

    private static final Logger logger = LoggerFactory.getLogger(PlayerService.class);
    
    public void processAndSavePlayers(MultipartFile file, Integer auctionId, List<TeamEntity> teams) throws IOException {
        logger.info("Processing players file for auctionId: {}", auctionId);
        logger.info("Teams available: {}", (teams != null) ? teams.size() : "No teams found");

        if (teams == null || teams.isEmpty()) {
            throw new RuntimeException("No teams found for this auction. Players cannot be assigned.");
        }

        List<PlayerEntity> players = new ArrayList<>();
        AuctionEntity auction = auctionRepository.findById(auctionId)
                .orElseThrow(() -> new RuntimeException("Auction not found"));

        Map<String, TeamEntity> teamMap = teams.stream()
                .collect(Collectors.toMap(TeamEntity::getTeamName, team -> team));

        Workbook workbook = new XSSFWorkbook(file.getInputStream());
        Sheet sheet = workbook.getSheetAt(0);

        for (Row row : sheet) {
            if (row.getRowNum() == 0) continue; // Skip header

            PlayerEntity player = new PlayerEntity();
            player.setAuction(auction);
            player.setName(row.getCell(0).getStringCellValue());
            player.setSkills(row.getCell(1).getStringCellValue());
            player.setImageUrl(row.getCell(2).getStringCellValue());
            player.setStatus(PlayerEntity.PlayerStatus.valueOf(row.getCell(3).getStringCellValue().toUpperCase()));

            if (row.getCell(4).getCellType() == CellType.NUMERIC) {
                player.setSoldPrice((int) row.getCell(4).getNumericCellValue());
            } else {
                player.setSoldPrice(null);
            }

            String soldToTeamName = row.getCell(5).getStringCellValue();
            player.setSoldToTeam(teamMap.getOrDefault(soldToTeamName, null));

            players.add(player);
            logger.info("Processed player: {}", player.getName());
        }

        workbook.close();

        savePlayers(players);
    }

    public void savePlayers(List<PlayerEntity> players) {
        playerRepo.saveAll(players);
    }
}
