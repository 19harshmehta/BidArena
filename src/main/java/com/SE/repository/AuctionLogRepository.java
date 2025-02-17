package com.SE.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.SE.entity.AuctionLogEntity;

@Repository
public interface AuctionLogRepository extends JpaRepository<AuctionLogEntity, Integer>
{

}
