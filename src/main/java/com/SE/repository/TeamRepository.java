package com.SE.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.SE.entity.TeamEntity;

@Repository
public interface TeamRepository extends JpaRepository<TeamEntity, Integer>
{
	List<TeamEntity> findByAuction_AuctionId(Integer auctionId);

	@Query("SELECT t FROM TeamEntity t WHERE t.auction.auctionId = :auctionId")
    List<TeamEntity> findTeamsByAuctionIdList(@Param("auctionId") Integer auctionId);
}
