package com.instagram.clone.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.instagram.clone.common.sns.KakaoRestAPI;
import com.instagram.clone.model.biz.member.MemberBiz;
import com.instagram.clone.model.vo.MemberJoinProfileVo;
import com.instagram.clone.model.vo.MemberProfileVo;
import com.instagram.clone.model.vo.MemberVo;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import oracle.jdbc.proxy.annotation.Post;

@RestController
@RequestMapping("/member")
public class MemberController {

	@Autowired
	private MemberBiz biz;

	private KakaoRestAPI kakaoRestAPI = new KakaoRestAPI();
	private static final String kakaoLoginLink = "https://kauth.kakao.com/oauth/authorize?client_id=d79e80b7ce7ff5ddf655cab6351ef911&redirect_uri=http://localhost:8787/member/oauth&response_type=code";

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	/*
	 * 로그인 부분
	 */
	// login.jsp 로 이동
	@GetMapping(value = "/login")
	public ModelAndView loginPage(Model model) {
		logger.info("MEMBER/LOGIN.GET");

		// kakao login 링크
		model.addAttribute("kakaoLoginLink", kakaoLoginLink);

		// nvaer login 링크
		/*
		 * 
		 */

		return new ModelAndView("member/login");
	}

	// login ajax 처리
	@PostMapping(value = "/login")
	public Map<String, Boolean> login(HttpSession session, @RequestBody MemberVo vo) {
		logger.info("MEMBER/LOGIN.POST (AJAX)");

		Map<String, Object> res = biz.login(vo);
		boolean check = false;

		if (res != null) {
			session.setAttribute("login", res.get("login"));
			session.setAttribute("profile", res.get("profile"));
			check = true;
		}

		Map<String, Boolean> map = new HashMap<String, Boolean>();
		map.put("check", check);

		return map;
	}

	// logout 처리
	@GetMapping(value = "/logout")
	public ModelAndView logout(HttpSession session) {
		logger.info("MEMBER/LOGOUT.GET");

		session.removeAttribute("login");
		session.removeAttribute("profile");

		return new ModelAndView("redirect:/member/login");
	}

	/*
	 * 회원가입 부분
	 */
	// join.jsp 로 이동
	@GetMapping(value = "/join")
	public ModelAndView JoinPage(Model model) {
		logger.info("MEMBER/JOIN.GET");

		// kakao login 링크
		model.addAttribute("kakaoLoginLink", kakaoLoginLink);

		// nvaer login 링크
		/*
		 * 
		 */

		return new ModelAndView("member/join");
	}

	// email 존재여부 체크
	@PostMapping(value = "/ajaxemailcheck")
	public Map<String, Boolean> emailCheck(@RequestBody MemberVo vo) {
		logger.info("MEMBER/AJAX ID CHECK");
		int res = biz.emailCheck(vo);
		boolean check = false;

		if (res > 0) {
			check = true;
		}

		Map<String, Boolean> map = new HashMap<String, Boolean>();
		map.put("check", check);

		return map;
	}

	// id 존재여부 체크
	@PostMapping(value = "/ajaxidcheck")
	public Map<String, Boolean> idCheck(@RequestBody MemberVo vo) {
		logger.info("MEMBER/AJAX ID CHECK");
		int res = biz.idCheck(vo);
		boolean check = false;

		if (res > 0) {
			check = true;
		}

		Map<String, Boolean> map = new HashMap<String, Boolean>();
		map.put("check", check);

		return map;
	}

	// join 처리
	@PostMapping(value = "/join")
	public ModelAndView join(HttpSession session, MemberVo vo) {
		logger.info("MEMBER/LOGIN.POST (AJAX)");

		if (biz.join(vo) > 0) {
			return new ModelAndView("member/login");
		} else {
			return new ModelAndView("member/join");
		}
	}

	// 프로필 변경
	@PostMapping(value = "/profileUpdate")
	public ModelAndView profileUpdate(HttpSession session, MemberVo vo, MemberProfileVo pvo) {

		int ress = biz.updateMember(vo);
		int res = biz.updateMemberProfile(pvo);

		if (res > 0 && ress > 0) {
			return new ModelAndView("member/profile");
		} else {
			return new ModelAndView("member/profileEdit");
		}
	}

	/*
	 * SNS
	 */
	// kakao oauth
	@RequestMapping(value = "/oauth", produces = "application/json", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView kakaoLogin(@RequestParam("code") String code, Model model, HttpSession session) {
		logger.info("MEMBER/oauth");

		String access_Token = kakaoRestAPI.getAccessToken(code);
		HashMap<String, String> userInfo = kakaoRestAPI.getUserInfo(access_Token);
		System.out.println("kakao userInfo : " + userInfo);

		MemberVo snsLogin = biz.snsLogin(new MemberVo(userInfo.get("email"), "KAKAO", userInfo.get("sns_id")));

		if (snsLogin != null) {
			session.setAttribute("login", snsLogin);
			return new ModelAndView("feed/feed");
		} else {
			return new ModelAndView("member/join");
		}
	}

	/*
	 * profile 부분
	 */
	// profile.jsp 로 이동
	@GetMapping(value = "/profile")
	public ModelAndView profilePage(Model model) {
		logger.info("MEMBER/PROFILE.GET");
		return new ModelAndView("member/profile");
	}

	@RequestMapping(value = "/profileEdit")
	public ModelAndView insert() {

		return new ModelAndView("member/profileEdit");
	}

	// 계정관리(정보: 이미지) 수정처리
	@PostMapping(value = "/updateprofileimage")
	private Map<String, Object> updateProfileImage(HttpServletRequest request, HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();

		// 업로드될 경로
		String filePath = "/resources/images/profileupload/";

		// 업로드될 실제 경로 (이클립스 상의 절대경로)
		String FILE_PATH = request.getSession().getServletContext().getRealPath(filePath);
		System.out.println("절대경로 : " + FILE_PATH);

		// 디렉토리 없을 시 자동 생성!
		File file;
		if (!(file = new File(FILE_PATH)).isDirectory()) {
			file.mkdirs();
		}

		MultipartRequest mr = null;

		try {

			mr = new MultipartRequest(request, // request 객체
					FILE_PATH, // 파일이 저장될 폴더
					1024 * 1024 * 3, // 최대 업로드크기 (3MB)
					"UTF-8", // 인코딩 방식
					new DefaultFileRenamePolicy() // 동일한 파일명이 존재하면 파일명 뒤에 일련번호를 부여
			);

		} catch (IOException e) {
			System.out.println("[ ERROR ] : BoardController - MultipartRequest 객체 생성 오류");
			e.printStackTrace();
		}

		MemberProfileVo member_profile = new MemberProfileVo();

		// 파라미터 받기
		int member_code = Integer.parseInt(mr.getParameter("member_code"));
		// 파일 첨부
		String MEMBER_IMG_SERVER_NAME = null;
		String MEMBER_IMG_ORIGINAL_NAME = null;
		String imgExtend = null;

		// 실제 저장된 파일명
		MEMBER_IMG_SERVER_NAME = mr.getFilesystemName("member_img_original_name");

		if (MEMBER_IMG_SERVER_NAME != null) {
			// 원래 이미지 이름
			MEMBER_IMG_ORIGINAL_NAME = mr.getOriginalFileName("member_img_original_name");

			// 이미지 확장자
			imgExtend = MEMBER_IMG_SERVER_NAME.substring(MEMBER_IMG_SERVER_NAME.lastIndexOf(".") + 1);
			System.out.println("이미지확장자:"+imgExtend);
		}

		member_profile.setMember_code(member_code);
		member_profile.setMember_img_original_name(MEMBER_IMG_ORIGINAL_NAME);
		member_profile.setMember_img_server_name(MEMBER_IMG_SERVER_NAME);
		member_profile.setMember_img_path(FILE_PATH);

		int res = biz.updateMemberProfileImage(member_profile);

		if (res > 0) {
			// 프로필 정보를 session에 리셋
			session = request.getSession();
			MemberProfileVo new_member_profile = biz.selectMemberProfile(member_code);
			session.removeAttribute("profile");
			session.setAttribute("profile", new_member_profile);
			System.out.println(new_member_profile);
		}

		map.put("res", res);
		map.put("img", biz.selectMemberProfile(member_code).getMember_img_server_name());
		return map;
	}

	/*
	 * alert추가하여 페이지 리턴
	 */
	private void jsResponse(String msg, String url, HttpServletResponse response) {
		try {
			response.setContentType("text/html; charset=UTF-8");

			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + msg + "')");
			out.println("location.href='" + url + "'");
			out.println("</script>");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}