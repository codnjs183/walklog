package com.walklog.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.data.repository.query.Param;

@Mapper
public interface UserMapper {
	
	// 회원 탈퇴
	public void deleteUserById(@Param("id") int id);
}
