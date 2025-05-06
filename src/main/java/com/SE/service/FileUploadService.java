package com.SE.service;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.SE.entity.PlayerEntity;
import com.SE.entity.TeamEntity;
import com.SE.repository.PlayerRepository;
import com.SE.repository.TeamRepository;
import com.SE.util.ExcelHelper;

@Service
public class FileUploadService 
{
	@Autowired
    private PlayerRepository playerRepo;

    @Autowired
    private TeamRepository teamRepo;

    public void savePlayers(MultipartFile file) {
        try {
            List<PlayerEntity> players = ExcelHelper.excelToPlayers(file.getInputStream());
            playerRepo.saveAll(players);
        } catch (IOException e) {
            throw new RuntimeException("Error processing players file: " + e.getMessage());
        }
    }

    public void saveTeams(MultipartFile file) {
        try {
            List<TeamEntity> teams = ExcelHelper.excelToTeams(file.getInputStream());
            teamRepo.saveAll(teams);
        } catch (IOException e) {
            throw new RuntimeException("Error processing teams file: " + e.getMessage());
        }
    }
}
