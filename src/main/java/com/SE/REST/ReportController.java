package com.SE.REST;

import com.SE.entity.PlayerEntity;
import com.SE.entity.TeamEntity;
import com.SE.repository.PlayerRepository;
import com.SE.repository.TeamRepository;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

@RestController  
@RequestMapping("/report")
public class ReportController {
    private final TeamRepository teamRepo;
    private final PlayerRepository playerRepo;

    public ReportController(TeamRepository teamRepo, PlayerRepository playerRepo) {
        this.teamRepo = teamRepo;
        this.playerRepo = playerRepo;
    }

    @GetMapping("/download")
    public ResponseEntity<byte[]> generatePdfReport(@RequestParam(name = "auctionId") Integer auctionId) throws IOException, DocumentException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4.rotate()); // Landscape mode
        PdfWriter.getInstance(document, outputStream);
        document.open();

        // Title
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, BaseColor.BLACK);
        Paragraph title = new Paragraph("Auction Report - Auction ID: " + auctionId, titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph("\n\n")); // Spacing

        // Fetch teams for the auction
        List<TeamEntity> teams = teamRepo.findTeamsByAuctionIdList(auctionId);
        for (TeamEntity team : teams) {
            List<PlayerEntity> soldPlayers = playerRepo.findSoldPlayersByTeamAndAuction(team, auctionId);

            if (!soldPlayers.isEmpty()) {
                // Add Team Name
                Font teamFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, BaseColor.BLUE);
                Paragraph teamHeader = new Paragraph(team.getTeamName(), teamFont);
                teamHeader.setSpacingBefore(10f);
                teamHeader.setSpacingAfter(5f);
                document.add(teamHeader);

                // Create Table
                PdfPTable table = new PdfPTable(new float[]{1.5f, 2.5f, 1f, 2f, 2f, 2f}); // Adjust column widths
                table.setWidthPercentage(100);
                table.setSpacingBefore(10f);
                table.setSpacingAfter(15f);

                // Add Column Headers
                addTableHeader(table);

                // Add Player Data
                for (PlayerEntity player : soldPlayers) {
                    addPlayerToTable(table, player);
                }

                document.add(table);
            }
        }

        document.close();
        
        byte[] pdfBytes = outputStream.toByteArray();
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=Auction_Report_" + auctionId + ".pdf");
        headers.add(HttpHeaders.CONTENT_TYPE, "application/pdf");

        return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);
    }

    private void addTableHeader(PdfPTable table) {
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);
        BaseColor headerBgColor = new BaseColor(50, 50, 150); // Dark Blue

        String[] headers = {"Image", "Name", "Age", "Batting", "Bowling", "Bid Amount"};
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(headerBgColor);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(8);
            table.addCell(cell);
        }
    }

    private void addPlayerToTable(PdfPTable table, PlayerEntity player) {
        try {
            if (player.getImageUrl() != null && !player.getImageUrl().isEmpty()) {
                Image img = Image.getInstance(player.getImageUrl());
                img.scaleToFit(60, 60);
                PdfPCell imageCell = new PdfPCell(img, true);
                imageCell.setPadding(5);
                imageCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(imageCell);
            } else {
                table.addCell(new PdfPCell(new Phrase("No Image")));
            }
        } catch (Exception e) {
            table.addCell(new PdfPCell(new Phrase("Image Error")));
        }

        table.addCell(new PdfPCell(new Phrase(player.getName())));
        table.addCell(new PdfPCell(new Phrase(String.valueOf(player.getAge()))));
        table.addCell(new PdfPCell(new Phrase(player.getBatting())));
        table.addCell(new PdfPCell(new Phrase(player.getBalling())));
        table.addCell(new PdfPCell(new Phrase("₹" + player.getSoldPrice())));
    }
}
