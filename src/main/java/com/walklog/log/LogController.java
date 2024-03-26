package com.walklog.log;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/log")
public class LogController {
	
	@GetMapping("/board-view")
	public String boardView(Model model) {
		model.addAttribute("viewName", "log/board");
		return "template/layout";
	}
}
