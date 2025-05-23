package com.SE.entity;


import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

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
import lombok.ToString;

@Entity
@Table(name = "auction")
@Data
@ToString(exclude = {"createdBy", "teams", "players", "bids"})
public class AuctionEntity 
{
	 	@Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Integer auctionId;
	    private String leagueName;
	    private Integer numTeams;
	    private Integer numPlayers;
	    private Integer maxNumPlayers;
	    private Integer walletPerTeam;
	    private String auctionCode;
	    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	    @JsonIgnore
	    private LocalDateTime createdAt;
	    private Integer basePrice;
	    
	    @ManyToOne
	    @JoinColumn(name = "created_by", nullable = false) 
	    private UserEntity createdBy;

	    @Enumerated(EnumType.STRING)
	    private AuctionStatus status; // ENUM(‘created’, ‘ongoing’, ‘completed’)

	    @OneToMany(mappedBy = "auction", cascade = CascadeType.ALL, orphanRemoval = true)
	    private List<TeamEntity> teams; // One auction has multiple teams
 
	    @OneToMany(mappedBy = "auction", cascade = CascadeType.ALL, orphanRemoval = true)
	    private List<PlayerEntity> players; // One auction has multiple players

	    @OneToMany(mappedBy = "auction", cascade = CascadeType.ALL, orphanRemoval = true)
	    private List<BidEntity> bids; // One auction has multiple bids

//	    @OneToMany(mappedBy = "auction", cascade = CascadeType.ALL, orphanRemoval = true)
//	    private List<UserEntity> users; // Viewers and auctioneer linked to the auction

	    
	    public enum AuctionStatus {
	        CREATED, ONGOING, COMPLETED
	    }
}
