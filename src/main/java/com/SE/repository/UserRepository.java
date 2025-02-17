package com.SE.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.SE.entity.UserEntity;

@Repository
public interface UserRepository extends JpaRepository<UserEntity,Integer> 
{

}
