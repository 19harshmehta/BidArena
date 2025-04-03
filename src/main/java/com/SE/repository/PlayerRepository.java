package com.SE.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.SE.entity.PlayerEntity;
import com.SE.entity.PlayerEntity.PlayerStatus;
import com.SE.entity.TeamEntity;


@Repository
public interface PlayerRepository extends JpaRepository<PlayerEntity, Integer>
{
	List<PlayerEntity> findByAuction_AuctionIdAndStatus(Integer auction_AuctionId, PlayerStatus status);
	Optional<PlayerEntity> findByPlayerId(Integer playerId);

	@Query("SELECT p FROM PlayerEntity p WHERE p.soldToTeam = :teamId AND p.soldPrice > 0 AND p.auction.auctionId = :auctionId")
	List<PlayerEntity> findSoldPlayersByTeamAndAuction(@Param("teamId") TeamEntity teamId, @Param("auctionId") Integer auctionId);
	
}