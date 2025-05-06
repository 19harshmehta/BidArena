package com.SE.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.SE.entity.AuctionEntity;
import com.SE.entity.UserEntity;

@Repository
public interface AuctionRepository extends JpaRepository<AuctionEntity, Integer>
{
	boolean existsByAuctionCode(String auctionCode);
	
	List<AuctionEntity> findByCreatedBy(UserEntity createdBy);
}
