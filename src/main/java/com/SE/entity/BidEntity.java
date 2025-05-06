package com.SE.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "bids")
@Data
public class BidEntity 
{
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer bidId;

    @ManyToOne
    @JoinColumn(name = "auction_id", nullable = false)
    private AuctionEntity auction; 

    @ManyToOne
    @JoinColumn(name = "player_id", nullable = false)
    private PlayerEntity player; // Links bid to a specific player

    @ManyToOne
    @JoinColumn(name = "team_id", nullable = false)
    private TeamEntity team; 
    private Integer bidAmount; 
    private LocalDateTime bidTime; // Time when the bid was recorded
}
