package com.ch.tickethub.controller.tickethub;

import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.ch.tickethub.dto.GoogleUser;
import com.ch.tickethub.dto.KakaoUserResponse;
import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.NaverUser;
import com.ch.tickethub.dto.NaverUserResponse;
import com.ch.tickethub.dto.OAuthClient;
import com.ch.tickethub.dto.OAuthTokenResponse;
import com.ch.tickethub.exception.DuplicateLoginIdException;
import com.ch.tickethub.model.member.LoginResult;
import com.ch.tickethub.model.member.MemberService;
import com.ch.tickethub.model.queue.QueueService;

@Controller
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private MemberService memberService;

	@Autowired
	private Map<String, OAuthClient> oauthClients;

	@Autowired
	private RestTemplate restTemplate;

	@Autowired
	private QueueService queueService;

	// 로그인 화면
	@GetMapping("/login")
	public String loginForm() {
		return "tickethub/auth/login";
	}

	// 일반 로그인 처리
	@PostMapping("/login")
	public String login(@RequestParam("loginId") String loginId, @RequestParam("password") String password,
			HttpSession session, Model model, HttpServletRequest httpRequest) {

		loginId = (loginId != null) ? loginId.trim() : null;

		if (loginId == null || loginId.isEmpty() || password == null || password.isEmpty()) {
			model.addAttribute("alertMsg", "아이디/비밀번호를 입력해주세요");
			return "tickethub/auth/login";
		}

		// 먼저 결과만 판정 (enum에 대한 추가 공부 필요....)
		LoginResult result = memberService.loginCheck(loginId, password);

		if (result != LoginResult.SUCCESS) {
			String msg;

			switch (result) {
			case NOT_FOUND:
				msg = "가입되지 않은 아이디입니다.";
				break;
			case WRONG_PASSWORD:
				msg = "비밀번호가 일치하지 않습니다.";
				break;
			case BLOCKED:
				msg = "차단된 계정입니다. 관리자에게 문의하세요.";
				break;
			case SOCIAL_ACCOUNT:
				msg = "소셜 로그인으로 가입된 계정입니다. SNS 로그인을 이용해주세요.";
				break;
			default:
				msg = "로그인에 실패했습니다.";
			}

			model.addAttribute("alertMsg", msg);
			return "tickethub/auth/login";
		}

		// 성공일 때만 member 조회(기존 login() 재사용)
		Member member = memberService.login(loginId, password);

		if (member == null) {
			model.addAttribute("alertMsg", "로그인 처리 중 문제가 발생했습니다. 다시 시도해주세요.");
			return "tickethub/auth/login";
		}

		/*--------------------------------------------------
		  redis 에 session ID 교체 및 로그인 정보 추가
		--------------------------------------------------*/
		String oldSessionId = session.getId();
		String newSessionId = httpRequest.changeSessionId();
		queueService.changeSessionId(oldSessionId, newSessionId);

		session.setAttribute("loginMember", member);

		if ("ADMIN".equals(member.getRole())) {
			return "redirect:/admin/index";
		}
		return "redirect:/";
	}

	// 로그아웃
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}

	// SNS 로그인 버튼 클릭 시 Provider 인증 URL 내려주기
	@GetMapping("/oauth2/authorize/{provider}")
	@ResponseBody
	public String getAuthUrl(@PathVariable("provider") String provider) throws Exception {
		OAuthClient client = oauthClients.get(provider);

		// ajax로 받는 값이라, 예외 던지면 화면이 깨지기 쉬움 -> 문자열 에러로 반환
		if (client == null) {
			return "ERROR:unsupported_provider";
		}

		StringBuilder sb = new StringBuilder();
		sb.append(client.getAuthorizeUrl()).append("?").append("response_type=code").append("&client_id=")
				.append(urlEncode(client.getClientId())).append("&redirect_uri=")
				.append(urlEncode(client.getRedirectUri())).append("&scope=").append(urlEncode(client.getScope()));

		return sb.toString();
	}

	private String urlEncode(String s) throws Exception {
		return URLEncoder.encode(s, "UTF-8");
	}

	/*
	 * ========================== OAuth Callback (공통 패턴) - code 없거나 error 오면 400 방지
	 * - oauthClients 설정 누락 시 NPE 방지 ==========================
	 */

	// 구글 콜백
	@GetMapping("/login/callback/google")
	public String handleGoogleCallback(@RequestParam(value = "code", required = false) String code,
			@RequestParam(value = "error", required = false) String error, HttpSession session, Model model,
			HttpServletRequest httpRequest) {

		if (error != null) {
			model.addAttribute("error", "구글 로그인에 실패했습니다: " + error);
			return "tickethub/auth/login";
		}
		if (code == null || code.trim().isEmpty()) {
			model.addAttribute("error", "구글 인증 코드가 없습니다(로그인 취소/실패)");
			return "tickethub/auth/login";
		}

		OAuthClient google = oauthClients.get("google");
		if (google == null) {
			model.addAttribute("error", "구글 OAuth 설정이 없습니다(oauthClients)");
			return "tickethub/auth/login";
		}

		// 1) code -> token
		MultiValueMap<String, String> param = new LinkedMultiValueMap<String, String>();
		param.add("grant_type", "authorization_code");
		param.add("code", code);
		param.add("client_id", google.getClientId());
		param.add("client_secret", google.getClientSecret());
		param.add("redirect_uri", google.getRedirectUri());

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(param,
				headers);

		ResponseEntity<OAuthTokenResponse> response = restTemplate.postForEntity(google.getTokenUrl(), request,
				OAuthTokenResponse.class);

		OAuthTokenResponse token = response.getBody();
		if (token == null || token.getAccess_token() == null) {
			model.addAttribute("error", "구글 토큰 발급 실패");
			return "tickethub/auth/login";
		}

		// 2) token -> userinfo
		String accessToken = token.getAccess_token();

		HttpHeaders userInfoHeaders = new HttpHeaders();
		userInfoHeaders.add("Authorization", "Bearer " + accessToken);

		HttpEntity<String> userInfoRequest = new HttpEntity<String>("", userInfoHeaders);

		ResponseEntity<GoogleUser> userInfoResponse = restTemplate.exchange(google.getUserInfoUrl(), HttpMethod.GET,
				userInfoRequest, GoogleUser.class);

		GoogleUser user = userInfoResponse.getBody();
		if (user == null || user.getId() == null) {
			model.addAttribute("error", "구글 사용자 정보 조회 실패");
			return "tickethub/auth/login";
		}

		// 3) 우리 회원 처리
		Member member = memberService.loginOauthOrRegister("google", user.getId(), user.getEmail(), user.getName());

		/*--------------------------------------------------
		 redis 에 session ID 교체 및 로그인 정보 추가
		--------------------------------------------------*/
		String oldSessionId = session.getId();
		String newSessionId = httpRequest.changeSessionId();
		queueService.changeSessionId(oldSessionId, newSessionId);

		session.setAttribute("loginMember", member);

		if ("ADMIN".equals(member.getRole())) {
			return "redirect:/admin/index";
		}

		return "redirect:/";
	}

	// 네이버 콜백
	@GetMapping("/login/callback/naver")
	public String handleNaverCallback(@RequestParam(value = "code", required = false) String code,
			@RequestParam(value = "error", required = false) String error, HttpSession session, Model model,
			HttpServletRequest httpRequest) {

		if (error != null) {
			model.addAttribute("error", "네이버 로그인에 실패했습니다: " + error);
			return "tickethub/auth/login";
		}
		if (code == null || code.trim().isEmpty()) {
			model.addAttribute("error", "네이버 인증 코드가 없습니다(로그인 취소/실패)");
			return "tickethub/auth/login";
		}

		OAuthClient naver = oauthClients.get("naver");
		if (naver == null) {
			model.addAttribute("error", "네이버 OAuth 설정이 없습니다(oauthClients)");
			return "tickethub/auth/login";
		}

		// 1) code -> token
		MultiValueMap<String, String> param = new LinkedMultiValueMap<String, String>();
		param.add("grant_type", "authorization_code");
		param.add("code", code);
		param.add("client_id", naver.getClientId());
		param.add("client_secret", naver.getClientSecret());
		param.add("redirect_uri", naver.getRedirectUri());

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(param,
				headers);

		ResponseEntity<OAuthTokenResponse> response = restTemplate.postForEntity(naver.getTokenUrl(), request,
				OAuthTokenResponse.class);

		OAuthTokenResponse token = response.getBody();
		if (token == null || token.getAccess_token() == null) {
			model.addAttribute("error", "네이버 토큰 발급 실패");
			return "tickethub/auth/login";
		}

		// 2) token -> userinfo
		String accessToken = token.getAccess_token();

		HttpHeaders userInfoHeaders = new HttpHeaders();
		userInfoHeaders.add("Authorization", "Bearer " + accessToken);

		HttpEntity<String> userInfoRequest = new HttpEntity<String>("", userInfoHeaders);

		ResponseEntity<NaverUserResponse> userInfoResponse = restTemplate.exchange(naver.getUserInfoUrl(),
				HttpMethod.GET, userInfoRequest, NaverUserResponse.class);

		NaverUserResponse naverResponse = userInfoResponse.getBody();
		NaverUser user = (naverResponse != null) ? naverResponse.getResponse() : null;

		if (user == null || user.getId() == null) {
			model.addAttribute("error", "네이버 사용자 정보를 가져오지 못했습니다");
			return "tickethub/auth/login";
		}

		// 3) 우리 회원 처리
		Member member = memberService.loginOauthOrRegister("naver", user.getId(), user.getEmail(), user.getName());

		/*--------------------------------------------------
		 redis 에 session ID 교체 및 로그인 정보 추가
		--------------------------------------------------*/
		String oldSessionId = session.getId();
		String newSessionId = httpRequest.changeSessionId();
		queueService.changeSessionId(oldSessionId, newSessionId);

		session.setAttribute("loginMember", member);

		if ("ADMIN".equals(member.getRole())) {
			return "redirect:/admin/index";
		}

		return "redirect:/";
	}

	// 카카오 콜백
	@GetMapping("/login/callback/kakao")
	public String handleKakaoCallback(@RequestParam(value = "code", required = false) String code,
			@RequestParam(value = "error", required = false) String error, HttpSession session, Model model,
			HttpServletRequest httpRequest) {

		if (error != null) {
			model.addAttribute("error", "카카오 로그인에 실패했습니다: " + error);
			return "tickethub/auth/login";
		}
		if (code == null || code.trim().isEmpty()) {
			model.addAttribute("error", "카카오 인증 코드가 없습니다(로그인 취소/실패)");
			return "tickethub/auth/login";
		}

		OAuthClient kakao = oauthClients.get("kakao");
		if (kakao == null) {
			model.addAttribute("error", "카카오 OAuth 설정이 없습니다(oauthClients)");
			return "tickethub/auth/login";
		}

		// 1) code -> token
		MultiValueMap<String, String> param = new LinkedMultiValueMap<String, String>();
		param.add("grant_type", "authorization_code");
		param.add("code", code);
		param.add("client_id", kakao.getClientId());
		param.add("client_secret", kakao.getClientSecret());
		param.add("redirect_uri", kakao.getRedirectUri());

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(param,
				headers);

		ResponseEntity<OAuthTokenResponse> response = restTemplate.postForEntity(kakao.getTokenUrl(), request,
				OAuthTokenResponse.class);

		OAuthTokenResponse token = response.getBody();
		if (token == null || token.getAccess_token() == null) {
			model.addAttribute("error", "카카오 토큰 발급 실패");
			return "tickethub/auth/login";
		}

		// 2) token -> userinfo
		String accessToken = token.getAccess_token();

		HttpHeaders userInfoHeaders = new HttpHeaders();
		userInfoHeaders.add("Authorization", "Bearer " + accessToken);

		HttpEntity<String> userInfoRequest = new HttpEntity<String>("", userInfoHeaders);

		ResponseEntity<KakaoUserResponse> userInfoResponse = restTemplate.exchange(kakao.getUserInfoUrl(),
				HttpMethod.GET, userInfoRequest, KakaoUserResponse.class);

		KakaoUserResponse kakaoResponse = userInfoResponse.getBody();
		if (kakaoResponse == null || kakaoResponse.getId() == null) {
			model.addAttribute("error", "카카오 사용자 정보를 가져오지 못했습니다");
			return "tickethub/auth/login";
		}

		String oauthId = String.valueOf(kakaoResponse.getId());
		String email = null;
		String name = null;

		if (kakaoResponse.getKakao_account() != null) {
			email = kakaoResponse.getKakao_account().getEmail();
			if (kakaoResponse.getKakao_account().getProfile() != null) {
				name = kakaoResponse.getKakao_account().getProfile().getNickname();
			}
		}

		// 3) 우리 회원 처리
		Member member = memberService.loginOauthOrRegister("kakao", oauthId, email, name);

		/*--------------------------------------------------
		 redis 에 session ID 교체 및 로그인 정보 추가
		--------------------------------------------------*/
		String oldSessionId = session.getId();
		String newSessionId = httpRequest.changeSessionId();
		queueService.changeSessionId(oldSessionId, newSessionId);

		session.setAttribute("loginMember", member);

		if ("ADMIN".equals(member.getRole())) {
			return "redirect:/admin/index";
		}

		return "redirect:/";
	}

	// 회원가입 화면
	@GetMapping("/join")
	public String joinForm() {
		return "tickethub/auth/join";
	}

	// 회원가입 처리
	@PostMapping("/join")
	public String join(@RequestParam("loginId") String loginId, @RequestParam("password") String password,
			@RequestParam("passwordConfirm") String passwordConfirm, @RequestParam("name") String name,
			@RequestParam("email") String email, Model model) {

		loginId = (loginId != null) ? loginId.trim() : null;
		name = (name != null) ? name.trim() : null;
		email = (email != null) ? email.trim() : null;

		// 1) loginId 체크
		if (loginId == null || loginId.isEmpty()) {
		    model.addAttribute("error", "아이디는 필수입니다");
		    return "tickethub/auth/join";
		}

		// 2) 아이디 규칙
		String idRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,20}$";
		if (!loginId.matches(idRegex)) {
		    model.addAttribute("error", "아이디는 6~20자 영문+숫자 조합(특수문자 불가)으로 입력해주세요.");
		    return "tickethub/auth/join";
		}

		// 3) password 체크
		if (password == null || password.trim().isEmpty()) {
		    model.addAttribute("error", "비밀번호는 필수입니다");
		    return "tickethub/auth/join";
		}

		// 4) passwordConfirm 체크 (비교보다 먼저!)
		if (passwordConfirm == null || passwordConfirm.trim().isEmpty()) {
		    model.addAttribute("error", "비밀번호 확인은 필수입니다");
		    return "tickethub/auth/join";
		}

		// 5) 비밀번호 규칙
		String pwRegex =  "^(?=.*[a-z])(?=.*\\d)[a-z\\d]{8,20}$";
		if (!password.matches(pwRegex)) {
		    model.addAttribute("error", "비밀번호는 8~20자이며 소문자, 숫자를 모두 포함해야 합니다.");
		    return "tickethub/auth/join";
		}

		// 6) 비밀번호 일치
		if (!password.equals(passwordConfirm)) {
		    model.addAttribute("error", "비밀번호가 일치하지 않습니다");
		    return "tickethub/auth/join";
		}

		// 7) name/email 체크
		if (name == null || name.isEmpty()) {
		    model.addAttribute("error", "이름은 필수입니다");
		    return "tickethub/auth/join";
		}
		if (email == null || email.isEmpty()) {
		    model.addAttribute("error", "이메일은 필수입니다");
		    return "tickethub/auth/join";
		}

		Member member = new Member();
		member.setLoginId(loginId);
		member.setPasswordHash(password); // 해시/검증은 service에서 담당하도록 유지 (나중에 개선)
		member.setName(name);
		member.setEmail(email);

		try {
			memberService.register(member);
		} catch (DuplicateLoginIdException e) {
			model.addAttribute("error", e.getMessage()); // "이미 존재하는 ID..."
			return "tickethub/auth/join";
		} catch (DuplicateKeyException e) {
			// 동시에 같은 ID 가입 누르면 서비스 체크를 통과해도 DB에서 터질 수 있음
			model.addAttribute("error", "이미 존재하는 ID가 있습니다.");
			return "tickethub/auth/join";
		} catch (RuntimeException e) {
			// 검증 실패(이메일 필수 등)는 e.getMessage() 노출 OK
			// 단, DB/시스템성 메시지는 여기로 섞일 수 있으니 문구를 통제하는 편이 안전
			model.addAttribute("error", e.getMessage());
			return "tickethub/auth/join";
		} catch (Exception e) {
			model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
			return "tickethub/auth/join";
		}
		return "redirect:/auth/login";
	}
}