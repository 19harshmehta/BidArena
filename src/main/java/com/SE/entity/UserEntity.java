package com.SE.entity;

import java.util.Date;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class UserEntity 
{
	
	 	@Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Integer userId;
	 	private String username;
	    private String password;

	    @Enumerated(EnumType.STRING)
	    private Role role; // ENUM(‘auctioneer’, ‘viewer’)

	    @ManyToOne
	    @JoinColumn(name = "auction_id", nullable = true)
	    private AuctionEntity auction; // Links viewer to a specific auction (NULL for auctioneers)
	    
	    public enum Role {
	        AUCTIONEER, VIEWER
	    }
	
	
	
	
	

}
