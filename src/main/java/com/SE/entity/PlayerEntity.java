package com.SE.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "players")
@Data

public class PlayerEntity {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer playerId;

	@ManyToOne
    @JoinColumn(name = "team_id", nullable = true)
    private TeamEntity team; 
	
	
    @ManyToOne
    @JoinColumn(name = "auction_id", nullable = false)
    private AuctionEntity auction; // Links player to a specific auction

    private String name;

    private String skills; 

    private String imageUrl; 

    @Enumerated(EnumType.STRING)
    private PlayerStatus status; // ENUM(‘unsold’, ‘sold’)

    private Integer soldPrice;

    @ManyToOne
    @JoinColumn(name = "sold_to_team", nullable = true)
    private TeamEntity soldToTeam; // Team ID of the winning bid (NULL if unsold)

    @OneToMany(mappedBy = "player", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BidEntity> bids; // One player can have multiple bids

    public enum PlayerStatus {
        UNSOLD, SOLD
    }
}
