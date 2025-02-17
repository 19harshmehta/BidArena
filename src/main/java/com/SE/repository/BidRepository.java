package com.SE.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.SE.entity.BidEntity;

@Repository
public interface BidRepository extends JpaRepository<BidEntity, Integer>
{

}
