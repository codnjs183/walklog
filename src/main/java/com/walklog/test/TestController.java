package com.walklog.test;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/test")
public class TestController {
  @ResponseBody
    public String helloWorld() {
        return "Hello world!";
    }
}
