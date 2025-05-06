package com.SE.entity;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.gson.annotations.Expose;

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
	@Expose
    private Integer playerId;

	@ManyToOne
	@Expose
    @JoinColumn(name = "team_id", nullable = true)
    private TeamEntity team; 
	
	
    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "auction_id", nullable = false)
    private AuctionEntity auction; // Links player to a specific auction

    @Expose
    private String name;

    @Expose
    private String skills; 
    private Integer age;
    private String batting;
    private String balling;
    private String wicketkeeper;
    private String imageUrl; 

    @Enumerated(EnumType.STRING)
    @Expose
    private PlayerStatus status; // ENUM(‘unsold’, ‘sold’)

    @Expose
    private Integer soldPrice;

    
    @ManyToOne
    @Expose
    @JoinColumn(name = "sold_to_team", nullable = true)
    private TeamEntity soldToTeam; 

    @Expose
    @OneToMany(mappedBy = "player", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BidEntity> bids; // One player can have multiple bids

    public enum PlayerStatus {
        UNSOLD, SOLD
    }
}
