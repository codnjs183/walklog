package com.walklog.user.bo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.walklog.user.entity.UserEntity;
import com.walklog.user.mapper.UserMapper;
import com.walklog.user.repository.UserRepository;


@Service
public class UserBO {

	@Autowired
	private UserRepository userRepository;
	@Autowired
	private UserMapper userMapper;
	
	public UserEntity getUserEntityByEmail(String email) {
		return userRepository.findByEmail(email);
	}
	
	// 회원가입
	public Integer addUser(String nickname, String email, String password) {
		UserEntity userEntity = userRepository.save(
				UserEntity.builder()
					.nickname(nickname)
					.email(email)
					.password(password)
					.build());
		
		return userEntity == null ? null : userEntity.getId();
	}
	
	// 로그인
	public UserEntity getUserEntityByEmailPassword(String email, String password) {
		return userRepository.findByEmailAndPassword(email, password);
	}
	
	
	// 회원 탈퇴
	public void deleteUserById (int id) {
		userMapper.deleteUserById(id);
	}
}
