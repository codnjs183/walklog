package com.walklog.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.walklog.user.bo.UserBO;
import com.walklog.user.entity.UserEntity;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


@RequestMapping("/user")
@RestController

public class UserRestController {
	
	@Autowired
	private UserBO userBO;
	
	
	// 닉네임 중복 확인
	@GetMapping("/is-duplicated-nickname")
	public Map<String, Object> isDuplicatedNickname(@RequestParam("nickname") String nickname) {
		Map<String, Object> result = new HashMap<>();
		result.put("is_duplicated_nickname", false);
		
		// select 구현하기
		
		return result;
	}
	
	
	// 비밀번호 확인
	@GetMapping("/is-matching-password")
	public Map<String, Object> isMatchingPassword(
			@RequestParam("origPw") String origPw,
			@RequestParam("currPw") String currPw) {
		Map<String, Object> result = new HashMap<>();
		
		if(origPw.equals(currPw)) {
			result.put("is_matching_password", true);
		} else {
			result.put("is_matching_password", false);
		}
		
		return result;
	}
	
	
	// 회원가입
	@PostMapping("/sign-up")
	public Map<String, Object> signUp(
			@RequestParam("nickname") String nickname,
			@RequestParam("email") String email,
			@RequestParam("password") String password) {
		
		// 비밀번호 암호화
		
		// DB Insert
		Integer userId = userBO.addUser(nickname, email, password);
		
		Map<String, Object> result = new HashMap<>();
		if (userId != null) {
			result.put("code",  200);
			result.put("result", "성공");
		} else {
			result.put("code", 500);
			result.put("error_message", "회원가입에 실패했습니다.");
		}
		
		return result;
	}
	
	
	// 로그인
	@PostMapping("/sign-in")
	public Map<String, Object> signIn(
			@RequestParam("email") String email,
			@RequestParam("password") String password,
			HttpServletRequest request) {
		
		// 비밀번호 암호화
		
		// DB 조회
		UserEntity userEntity = userBO.getUserEntityByEmailPassword(email, password);
		
		Map<String, Object> result = new HashMap<>();
		
		if (userEntity != null) {
			// 로그인 성공
			HttpSession session = request.getSession();
			session.setAttribute("userId", userEntity.getId());
			session.setAttribute("nickname", userEntity.getNickname());
			
			result.put("code", 200);
			result.put("result", "성공");
		} else {
			// 로그인 실패
			result.put("code", 500);
			result.put("errorMessage", "아이디와 비밀번호를 확인 해 주세요.");
		}
		
		return result;
	}
	
	// 회원 탈퇴
		@DeleteMapping("/delete")
		public Map<String, Object> delete(HttpSession session) {
			int userId = (int)session.getAttribute("userId");
			
			userBO.deleteUserById(userId);
			
			session.removeAttribute("userId");
			
			Map<String, Object> result = new HashMap<>();
			result.put("code", 200);
			result.put("result", "성공");
			return result;
		}

}
