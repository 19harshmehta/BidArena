package com.SE.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.SE.entity.AuctionEntity;

@Repository
public interface AuctionRepository extends JpaRepository<AuctionEntity, Integer>
{
	boolean existsByAuctionCode(String auctionCode);
}
