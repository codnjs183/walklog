package com.walklog.log.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.walklog.log.entity.LogEntity;

public interface LogRepository extends JpaRepository<LogEntity, Integer>{

}
