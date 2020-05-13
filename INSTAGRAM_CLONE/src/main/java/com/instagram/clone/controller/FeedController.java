package com.instagram.clone.controller;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.instagram.clone.model.vo.MemberVo;

@RestController
@RequestMapping("/feed")
public class FeedController {

	private static final Logger logger = LoggerFactory.getLogger(FeedController.class);

	// feed.jsp 로 이동
	@GetMapping(value = "/feed")
	public ModelAndView loginPage() {
		logger.info("FEED/FEED.GET");
		return new ModelAndView("feed/feed");
	}

	@PostMapping(value = "/feedlist")
	public Map<String, String> feedList(int startNo) {
		logger.info("FEED/FEEDLIST");

		Map<String, String> map = new HashMap<String, String>();

		return map;
	}
}
