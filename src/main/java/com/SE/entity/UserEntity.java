package com.SE.entity;

import java.util.Date;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
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
@Table(name = "users")
@Data
@ToString(exclude = {"createdAuctions"})
public class UserEntity 
{
	
	 	@Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Integer userId;
	 	private String username;
	 	private String email;
	    private String password;
	    private String otp;

	    @Enumerated(EnumType.STRING)
	    private Role role; // ENUM(‘auctioneer’, ‘viewer’)

//	    @ManyToOne
//	    @JoinColumn(name = "auction_id", nullable = true)
//	    private AuctionEntity auction; // Links viewer to a specific auction (NULL for auctioneers)
	    
	    @OneToMany(mappedBy = "createdBy", cascade = CascadeType.ALL, orphanRemoval = true)
	    private List<AuctionEntity> createdAuctions; // One user can create multiple auctions
	    
	    public enum Role {
	        AUCTIONEER, VIEWER
	    }
	
	
	
	
	

}
