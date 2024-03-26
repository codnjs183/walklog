package com.walklog.log.bo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.walklog.log.entity.LogEntity;
import com.walklog.log.repository.LogRepository;

@Service
public class LogBO {

	@Autowired
	private LogRepository logRepository;
	
	// 일지 기록
	public Integer addLog(int userId, int distance, int steps, int duration, String comment) {
		LogEntity logEntity = logRepository.save(
				LogEntity.builder()
				.userId(userId)
				.distance(distance)
				.steps(steps)
				.duration(duration)
				.comment(comment)
				.build());
		
		return logEntity == null ? null : logEntity.getId();
	}
	
}
