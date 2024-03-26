package com.walklog.log;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.walklog.log.bo.LogBO;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/log")
@RestController
public class LogRestController {
	
	@Autowired
	private LogBO logBO;
	
	@PostMapping("/do-record")
	public Map<String, Object> doRecord (
			@RequestParam("distance") int distance,
			@RequestParam("steps") int steps,
			@RequestParam("duration") int duration,
			@RequestParam(value="comment", required = false) String comment,
			HttpSession session) {
		
		int userId = (int)session.getAttribute("userId");
		
		// DB Insert
		Integer logId = logBO.addLog(userId, distance, steps, duration, comment);
		
		Map<String, Object> result = new HashMap<>();
		if (logId != null) {
			result.put("code",  200);
			result.put("result", "성공");
		} else {
			result.put("code", 500);
			result.put("error_message", "일지 기록에 실패했습니다.");
		}
		
		return result;
	}
}
