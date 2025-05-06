package com.SE.entity;

import java.time.LocalDateTime;
import java.util.List;

import com.SE.entity.AuctionEntity.AuctionStatus;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "teams")
@Data
public class TeamEntity 
{
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer teamId;

    @ManyToOne
    @JoinColumn(name = "auction_id", nullable = false)
    private AuctionEntity auction; 
    private String teamName;
    private Integer wallet; 
    private LocalDateTime createdAt; 

    @OneToMany(mappedBy = "team", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PlayerEntity> players; 

    @OneToMany(mappedBy = "team", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BidEntity> bids; 	
	
	
}
