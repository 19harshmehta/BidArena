package com.SE.util;

import com.SE.entity.PlayerEntity;
import com.SE.entity.TeamEntity;
import com.SE.entity.PlayerEntity.PlayerStatus;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ExcelHelper {

    public static List<PlayerEntity> excelToPlayers(InputStream is) {
        List<PlayerEntity> players = new ArrayList<>();
        try (Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rows = sheet.iterator();
            boolean firstRow = true;

            while (rows.hasNext()) {
                Row currentRow = rows.next();
                if (firstRow) {
                    firstRow = false;
                    continue;
                }

                PlayerEntity player = new PlayerEntity();
                player.setName(currentRow.getCell(0).getStringCellValue());
                player.setSkills(currentRow.getCell(1).getStringCellValue());
                player.setStatus(PlayerStatus.valueOf(currentRow.getCell(2).getStringCellValue().toUpperCase()));
                player.setSoldPrice((int) currentRow.getCell(3).getNumericCellValue());

                players.add(player);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return players;
    }

    public static List<TeamEntity> excelToTeams(InputStream is) {
        List<TeamEntity> teams = new ArrayList<>();
        try (Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rows = sheet.iterator();
            boolean firstRow = true;

            while (rows.hasNext()) {
                Row currentRow = rows.next();
                if (firstRow) {
                    firstRow = false;
                    continue;
                }

                TeamEntity team = new TeamEntity();
                team.setTeamName(currentRow.getCell(0).getStringCellValue());
                team.setWallet((int) currentRow.getCell(1).getNumericCellValue());

                teams.add(team);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return teams;
    }
}
