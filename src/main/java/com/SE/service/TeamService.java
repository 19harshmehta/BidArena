package com.SE.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.SE.entity.AuctionEntity;
import com.SE.entity.TeamEntity;
import com.SE.repository.AuctionRepository;
import com.SE.repository.TeamRepository;

@Service
public class TeamService {

    @Autowired
    private TeamRepository teamRepo;

    @Autowired
    private AuctionRepository auctionRepo;
    
    public List<TeamEntity> getTeamsByAuctionId(Integer auctionId) {
        return teamRepo.findByAuction_AuctionId(auctionId);
    }

    public String processAndSaveTeams(MultipartFile file, Integer auctionId) throws IOException {
        AuctionEntity auction = auctionRepo.findById(auctionId)
                .orElseThrow(() -> new RuntimeException("Auction not found"));

        int expectedTeams = auction.getNumTeams(); 
        List<TeamEntity> teams = new ArrayList<>();

        Workbook workbook = new XSSFWorkbook(file.getInputStream());
        Sheet sheet = workbook.getSheetAt(0);
        int uploadedTeamsCount = sheet.getPhysicalNumberOfRows() - 1; 

        workbook.close();

        if (uploadedTeamsCount != expectedTeams) {
            return "The number of teams in the uploaded file (" + uploadedTeamsCount + ") does not match the expected number (" + expectedTeams + ").";
        }

        for (Row row : sheet) {
            if (row.getRowNum() == 0) continue; 

            TeamEntity team = new TeamEntity();
            team.setAuction(auction);
            team.setTeamName(row.getCell(0).getStringCellValue());
            team.setWallet((int) row.getCell(1).getNumericCellValue());

            teams.add(team);
        }

        teamRepo.saveAll(teams);
        return null; // No error, upload successful
    }
}
