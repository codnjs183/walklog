package com.walklog.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.walklog.user.entity.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity, Integer>{

	public UserEntity findByEmail(String email);
	
	public UserEntity findById (int id);
	
	public UserEntity findByEmailAndPassword (String email, String password);
}
