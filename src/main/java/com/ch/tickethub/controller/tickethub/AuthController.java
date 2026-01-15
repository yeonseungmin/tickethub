package com.ch.tickethub.controller.tickethub;

import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.ch.tickethub.dto.GoogleUser;
import com.ch.tickethub.dto.JoinDraft;
import com.ch.tickethub.dto.KakaoUserResponse;
import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.NaverUser;
import com.ch.tickethub.dto.NaverUserResponse;
import com.ch.tickethub.dto.OAuthClient;
import com.ch.tickethub.dto.OAuthTokenResponse;
import com.ch.tickethub.dto.OauthLoginResponse;
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

    // ==========================
    // 로그인 화면
    // ==========================
    @GetMapping("/login")
    public String loginForm(@RequestParam(value = "returnUrl", required = false) String returnUrl,
                            HttpSession session,
                            HttpServletRequest request) {

        // 쿼리로 returnUrl 들어오면 그걸 우선 저장
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            session.setAttribute("profileReturnUrl", sanitizeReturnUrl(returnUrl));
        }
        // 없으면 referer라도(선택)
        else if (session.getAttribute("profileReturnUrl") == null) {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.trim().isEmpty()) {
                session.setAttribute("profileReturnUrl", sanitizeReturnUrl(referer));
            }
        }

        return "tickethub/auth/login";
    }

    // ==========================
    // 일반 로그인 처리
    // ==========================
    @PostMapping("/login")
    public String login(@RequestParam("loginId") String loginId,
                        @RequestParam("password") String password,
                        @RequestParam(value = "returnUrl", required = false) String returnUrl,
                        HttpSession session,
                        Model model,
                        HttpServletRequest httpRequest) {

        loginId = (loginId != null) ? loginId.trim() : null;

        // POST로도 returnUrl 받을 수 있게(로그인 폼 hidden)
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            session.setAttribute("profileReturnUrl", sanitizeReturnUrl(returnUrl));
        }

        if (loginId == null || loginId.isEmpty() || password == null || password.isEmpty()) {
            model.addAttribute("alertMsg", "아이디/비밀번호를 입력해주세요");
            return "tickethub/auth/login";
        }

        LoginResult result = memberService.loginCheck(loginId, password);

        // 프로필 미완료면 프로필로 이동 (returnUrl 유지)
        if (result == LoginResult.PROFILE_REQUIRED) {

            ensureReturnUrl(session, httpRequest);

            Member member = memberService.login(loginId, password);
            if (member == null) {
                model.addAttribute("alertMsg", "로그인 처리 중 문제가 발생했습니다. 다시 시도해주세요.");
                return "tickethub/auth/login";
            }

            rotateSessionAndQueue(session, httpRequest);

            session.setAttribute("profileMemberId", member.getMemberId());
            session.setAttribute("profileReason", "PROFILE_INCOMPLETE");
            return "redirect:/auth/profile";
        }

        // 실패
        if (result != LoginResult.SUCCESS) {
            model.addAttribute("alertMsg", mapLoginMessage(result));
            return "tickethub/auth/login";
        }

        // 성공일 때만 member 조회
        Member member = memberService.login(loginId, password);
        if (member == null) {
            model.addAttribute("alertMsg", "로그인 처리 중 문제가 발생했습니다. 다시 시도해주세요.");
            return "tickethub/auth/login";
        }

        rotateSessionAndQueue(session, httpRequest);
        session.setAttribute("loginMember", member);

        // 로그인 성공 후 returnUrl 있으면 거기로, 없으면 /
        String target = popReturnUrlOrDefault(session, "/");
        return "redirect:" + target;
    }

    private String mapLoginMessage(LoginResult result) {
        switch (result) {
            case NOT_FOUND:
                return "가입되지 않은 아이디입니다.";
            case WRONG_PASSWORD:
                return "비밀번호가 일치하지 않습니다.";
            case BLOCKED:
                return "차단된 계정입니다. 관리자에게 문의하세요.";
            case SOCIAL_ACCOUNT:
                return "소셜 로그인으로 가입된 계정입니다. SNS 로그인을 이용해주세요.";
            default:
                return "로그인에 실패했습니다.";
        }
    }

    // ==========================
    // 로그아웃
    // ==========================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ==========================
    // SNS 로그인 버튼: 인증 URL 반환
    // returnUrl을 받아 세션에 저장
    // ==========================
    @GetMapping("/oauth2/authorize/{provider}")
    @ResponseBody
    public String getAuthUrl(@PathVariable("provider") String provider,
                             @RequestParam(value = "returnUrl", required = false) String returnUrl,
                             HttpSession session,
                             HttpServletRequest request) throws Exception {

        OAuthClient client = oauthClients.get(provider);
        if (client == null) return "ERROR:unsupported_provider";

        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            session.setAttribute("profileReturnUrl", sanitizeReturnUrl(returnUrl));
        } else if (session.getAttribute("profileReturnUrl") == null) {
            // returnUrl 없으면 referer 기반 저장(선택)
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.trim().isEmpty()) {
                session.setAttribute("profileReturnUrl", sanitizeReturnUrl(referer));
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.append(client.getAuthorizeUrl()).append("?")
          .append("response_type=code")
          .append("&client_id=").append(urlEncode(client.getClientId()))
          .append("&redirect_uri=").append(urlEncode(client.getRedirectUri()))
          .append("&scope=").append(urlEncode(client.getScope()));

        return sb.toString();
    }

    private String urlEncode(String s) throws Exception {
        return URLEncoder.encode(s, "UTF-8");
    }

    // ==========================
    // OAuth Callback - Google
    // ==========================
    @GetMapping("/login/callback/google")
    public String handleGoogleCallback(@RequestParam(value = "code", required = false) String code,
                                       @RequestParam(value = "error", required = false) String error,
                                       HttpSession session,
                                       Model model,
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

        OAuthTokenResponse token = fetchToken(google, code);
        if (token == null || token.getAccess_token() == null) {
            model.addAttribute("error", "구글 토큰 발급 실패");
            return "tickethub/auth/login";
        }

        GoogleUser user = fetchUserInfo(google.getUserInfoUrl(), token.getAccess_token(), GoogleUser.class);
        if (user == null || user.getId() == null) {
            model.addAttribute("error", "구글 사용자 정보 조회 실패");
            return "tickethub/auth/login";
        }

        OauthLoginResponse resp =
                memberService.loginOauthOrRegister("google", user.getId(), user.getEmail(), user.getName());

        return handleOauthLoginResponse(resp, session, httpRequest);
    }

    // ==========================
    // OAuth Callback - Naver
    // ==========================
    @GetMapping("/login/callback/naver")
    public String handleNaverCallback(@RequestParam(value = "code", required = false) String code,
                                      @RequestParam(value = "error", required = false) String error,
                                      HttpSession session,
                                      Model model,
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

        OAuthTokenResponse token = fetchToken(naver, code);
        if (token == null || token.getAccess_token() == null) {
            model.addAttribute("error", "네이버 토큰 발급 실패");
            return "tickethub/auth/login";
        }

        NaverUserResponse naverResp =
                fetchUserInfo(naver.getUserInfoUrl(), token.getAccess_token(), NaverUserResponse.class);

        NaverUser user = (naverResp != null) ? naverResp.getResponse() : null;
        if (user == null || user.getId() == null) {
            model.addAttribute("error", "네이버 사용자 정보를 가져오지 못했습니다");
            return "tickethub/auth/login";
        }

        OauthLoginResponse resp =
                memberService.loginOauthOrRegister("naver", user.getId(), user.getEmail(), user.getName());

        return handleOauthLoginResponse(resp, session, httpRequest);
    }

    // ==========================
    // OAuth Callback - Kakao
    // ==========================
    @GetMapping("/login/callback/kakao")
    public String handleKakaoCallback(@RequestParam(value = "code", required = false) String code,
                                      @RequestParam(value = "error", required = false) String error,
                                      HttpSession session,
                                      Model model,
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

        OAuthTokenResponse token = fetchToken(kakao, code);
        if (token == null || token.getAccess_token() == null) {
            model.addAttribute("error", "카카오 토큰 발급 실패");
            return "tickethub/auth/login";
        }

        KakaoUserResponse kakaoResp =
                fetchUserInfo(kakao.getUserInfoUrl(), token.getAccess_token(), KakaoUserResponse.class);

        if (kakaoResp == null || kakaoResp.getId() == null) {
            model.addAttribute("error", "카카오 사용자 정보를 가져오지 못했습니다");
            return "tickethub/auth/login";
        }

        String oauthId = String.valueOf(kakaoResp.getId());
        String email = null;
        String name = null;

        if (kakaoResp.getKakao_account() != null) {
            email = kakaoResp.getKakao_account().getEmail();
            if (kakaoResp.getKakao_account().getProfile() != null) {
                name = kakaoResp.getKakao_account().getProfile().getNickname();
            }
        }

        OauthLoginResponse resp =
                memberService.loginOauthOrRegister("kakao", oauthId, email, name);

        return handleOauthLoginResponse(resp, session, httpRequest);
    }

    // ==========================
    // 회원가입 화면
    // ==========================
    @GetMapping("/join")
    public String joinForm(@RequestParam(value = "returnUrl", required = false) String returnUrl,
                           HttpSession session) {
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            session.setAttribute("profileReturnUrl", sanitizeReturnUrl(returnUrl));
        }
        return "tickethub/auth/join";
    }

    // ==========================
    // 회원가입 처리 (최소가입 -> profile로)
    // ==========================
    @PostMapping("/join")
    public String join(@RequestParam("loginId") String loginId,
                       @RequestParam("password") String password,
                       @RequestParam("passwordConfirm") String passwordConfirm,
                       @RequestParam("name") String name,
                       @RequestParam("email") String email,
                       @RequestParam(value = "returnUrl", required = false) String returnUrl,
                       HttpSession session,
                       Model model) {

        loginId = (loginId != null) ? loginId.trim() : null;
        name    = (name != null) ? name.trim() : null;
        email   = (email != null) ? email.trim() : null;

        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            session.setAttribute("profileReturnUrl", sanitizeReturnUrl(returnUrl));
        }

        // 1) 필수값 검증
        if (loginId == null || loginId.isEmpty()) {
            model.addAttribute("error", "아이디는 필수입니다.");
            return "tickethub/auth/join";
        }
        if (password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "비밀번호는 필수입니다.");
            return "tickethub/auth/join";
        }
        if (passwordConfirm == null || passwordConfirm.trim().isEmpty()) {
            model.addAttribute("error", "비밀번호 확인은 필수입니다.");
            return "tickethub/auth/join";
        }
        if (name == null || name.isEmpty()) {
            model.addAttribute("error", "이름은 필수입니다.");
            return "tickethub/auth/join";
        }
        if (email == null || email.isEmpty()) {
            model.addAttribute("error", "이메일은 필수입니다.");
            return "tickethub/auth/join";
        }

        // 2) trim 기준 통일
        String pw  = password.trim();
        String pw2 = passwordConfirm.trim();
        if (!pw.equals(pw2)) {
            model.addAttribute("error", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            return "tickethub/auth/join";
        }

        // 3) ID/PW 정책 (서비스 registerFullFromDraft와 동일하게 유지)
        if (!loginId.matches("^[a-zA-Z0-9]{8,20}$")) {
            model.addAttribute("error", "아이디는 영문/숫자 8~20자로 입력해주세요.");
            return "tickethub/auth/join";
        }
        if (!pw.matches("^(?=.*[a-z])(?=.*\\d)[a-z\\d\\W]{8,20}$")) {
            model.addAttribute("error", "비밀번호는 8~20자이며 소문자+숫자를 포함해야 합니다.");
            return "tickethub/auth/join";
        }

        // 4) email normalize
        String normalizedEmail = email.toLowerCase();

        // 5) 선중복 체크(UX)
        if (memberService.existsLoginId(loginId)) {
            model.addAttribute("error", "이미 존재하는 ID가 있습니다.");
            return "tickethub/auth/join";
        }
        if (memberService.existsEmail(normalizedEmail)) {
            model.addAttribute("error", "이미 가입된 이메일입니다.");
            return "tickethub/auth/join";
        }

        // 6) DB 저장 금지: 세션에 draft로만 저장
        JoinDraft draft = new JoinDraft();
        draft.setLoginId(loginId);
        draft.setRawPassword(pw);
        draft.setName(name);
        draft.setEmail(normalizedEmail);

        session.setAttribute("joinDraft", draft);
        session.setAttribute("profileReason", "JOIN_FIRST");

        return "redirect:/auth/profile";
    }

    // ==========================
    // 프로필 입력 화면
    // ==========================
    @GetMapping("/profile")
    public String profileForm(HttpSession session, Model model) {

        // 1) 일반가입 임시세션(joinDraft) 우선 처리
        com.ch.tickethub.dto.JoinDraft draft =
                (com.ch.tickethub.dto.JoinDraft) session.getAttribute("joinDraft");

        if (draft != null) {
            model.addAttribute("reason", session.getAttribute("profileReason")); // JOIN_FIRST
            model.addAttribute("joinDraft", draft); // 필요하면 화면에 이름/이메일 표시
            model.addAttribute("returnUrl", session.getAttribute("profileReturnUrl"));
            return "tickethub/auth/profile";
        }

        // 2) 기존: 소셜/최소가입 profileMemberId 기반
        Object idObj = session.getAttribute("profileMemberId");
        if (idObj == null) return "redirect:/auth/login";

        int memberId = (idObj instanceof Integer)
                ? (Integer) idObj
                : Integer.parseInt(String.valueOf(idObj));

        Member member = memberService.selectForProfileForm(memberId);
        if (member == null) {
            session.removeAttribute("profileMemberId");
            session.removeAttribute("profileReason");
            session.removeAttribute("profileReturnUrl");
            return "redirect:/auth/login";
        }

        if ("Y".equals(member.getProfileCompleted())) {
            session.removeAttribute("profileMemberId");
            session.removeAttribute("profileReason");
            String target = popReturnUrlOrDefault(session, "/");
            return "redirect:" + target;
        }

        model.addAttribute("member", member);
        model.addAttribute("reason", session.getAttribute("profileReason"));
        model.addAttribute("returnUrl", session.getAttribute("profileReturnUrl"));
        return "tickethub/auth/profile";
    }

    // ==========================
    // 프로필 입력 처리 (completeProfile만 사용)
    // ==========================
    @PostMapping("/profile")
    public String profileSubmit(@RequestParam("phone") String phone,
                                @RequestParam("zipCode") String zipCode,
                                @RequestParam("address") String address,
                                HttpSession session,
                                Model model,
                                HttpServletRequest httpRequest) {

        // 1) 일반가입(joinDraft) 케이스: 여기서 최종 INSERT
        com.ch.tickethub.dto.JoinDraft draft =
                (com.ch.tickethub.dto.JoinDraft) session.getAttribute("joinDraft");

        if (draft != null) {
            try {
                int memberId = memberService.registerFullFromDraft(draft, phone, zipCode, address);

                // 세션 고정 방지 + queue 세션ID 교체
                String oldSessionId = session.getId();
                String newSessionId = httpRequest.changeSessionId();
                queueService.changeSessionId(oldSessionId, newSessionId);

                // 로그인 세션 부여
                Member loginMember = memberService.selectMyPage(memberId);
                session.setAttribute("loginMember", loginMember);

                // draft 제거 = 이제 진짜 가입완료
                session.removeAttribute("joinDraft");
                session.removeAttribute("profileReason");

                String target = popReturnUrlOrDefault(session, "/");
                return "redirect:" + target;

            } catch (RuntimeException e) {
                model.addAttribute("errorMsg", e.getMessage());
                model.addAttribute("reason", session.getAttribute("profileReason"));
                model.addAttribute("joinDraft", draft);
                model.addAttribute("returnUrl", session.getAttribute("profileReturnUrl"));
                return "tickethub/auth/profile";
            }
        }

        // 2) 기존 소셜/최소가입 케이스: profileMemberId 기반 completeProfile 그대로
        Object idObj = session.getAttribute("profileMemberId");
        if (idObj == null) return "redirect:/auth/login";

        int memberId = (idObj instanceof Integer)
                ? (Integer) idObj
                : Integer.parseInt(String.valueOf(idObj));

        Member form = new Member();
        form.setMemberId(memberId);
        form.setPhone(phone);
        form.setZipCode(zipCode);
        form.setAddress(address);

        try {
            boolean ok = memberService.completeProfile(form);
            if (!ok) {
                model.addAttribute("errorMsg", "프로필 저장에 실패했습니다. 다시 시도해주세요.");
                model.addAttribute("member", memberService.selectForProfileForm(memberId));
                model.addAttribute("reason", session.getAttribute("profileReason"));
                model.addAttribute("returnUrl", session.getAttribute("profileReturnUrl"));
                return "tickethub/auth/profile";
            }

            Member loginMember = memberService.selectMyPage(memberId);

            String oldSessionId = session.getId();
            String newSessionId = httpRequest.changeSessionId();
            queueService.changeSessionId(oldSessionId, newSessionId);

            session.setAttribute("loginMember", loginMember);

            session.removeAttribute("profileMemberId");
            session.removeAttribute("profileReason");

            String target = popReturnUrlOrDefault(session, "/");
            return "redirect:" + target;

        } catch (RuntimeException e) {
            model.addAttribute("errorMsg", e.getMessage());
            model.addAttribute("member", memberService.selectForProfileForm(memberId));
            model.addAttribute("reason", session.getAttribute("profileReason"));
            model.addAttribute("returnUrl", session.getAttribute("profileReturnUrl"));
            return "tickethub/auth/profile";
        } catch (Exception e) {
            model.addAttribute("errorMsg", "프로필 저장 중 오류가 발생했습니다.");
            model.addAttribute("member", memberService.selectForProfileForm(memberId));
            model.addAttribute("reason", session.getAttribute("profileReason"));
            model.addAttribute("returnUrl", session.getAttribute("profileReturnUrl"));
            return "tickethub/auth/profile";
        }
    }

    // ==========================
    // 공통 유틸
    // ==========================
    private void rotateSessionAndQueue(HttpSession session, HttpServletRequest httpRequest) {
        String oldSessionId = session.getId();
        String newSessionId = httpRequest.changeSessionId();
        queueService.changeSessionId(oldSessionId, newSessionId);
    }

    private OAuthTokenResponse fetchToken(OAuthClient client, String code) {
        MultiValueMap<String, String> param = new LinkedMultiValueMap<String, String>();
        param.add("grant_type", "authorization_code");
        param.add("code", code);
        param.add("client_id", client.getClientId());
        param.add("client_secret", client.getClientSecret());
        param.add("redirect_uri", client.getRedirectUri());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<MultiValueMap<String, String>> request =
                new HttpEntity<MultiValueMap<String, String>>(param, headers);

        ResponseEntity<OAuthTokenResponse> response =
                restTemplate.postForEntity(client.getTokenUrl(), request, OAuthTokenResponse.class);

        return response.getBody();
    }

    private <T> T fetchUserInfo(String userInfoUrl, String accessToken, Class<T> clazz) {
        HttpHeaders h = new HttpHeaders();
        h.add("Authorization", "Bearer " + accessToken);

        HttpEntity<String> req = new HttpEntity<String>("", h);

        ResponseEntity<T> resp = restTemplate.exchange(userInfoUrl, HttpMethod.GET, req, clazz);
        return resp.getBody();
    }

    private String handleOauthLoginResponse(OauthLoginResponse resp,
                                           HttpSession session,
                                           HttpServletRequest httpRequest) {
        if (resp == null || resp.getMember() == null) {
            return "redirect:/auth/login";
        }

        rotateSessionAndQueue(session, httpRequest);

        if (resp.isSuccess()) {
            session.setAttribute("loginMember", resp.getMember());

            // OAuth 로그인 성공도 returnUrl 있으면 거기로
            String target = popReturnUrlOrDefault(session, "/");
            return "redirect:" + target;
        }

        // 프로필 필요
        ensureReturnUrl(session, httpRequest);

        session.setAttribute("profileMemberId", resp.getMember().getMemberId());
        session.setAttribute("profileReason", resp.getReason());
        return "redirect:/auth/profile";
    }

    // --------------------------
    // returnUrl helpers
    // --------------------------
    private void ensureReturnUrl(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("profileReturnUrl") != null) return;

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.trim().isEmpty()) {
            session.setAttribute("profileReturnUrl", sanitizeReturnUrl(referer));
        }
    }

    private String popReturnUrlOrDefault(HttpSession session, String defaultUrl) {
        String returnUrl = (String) session.getAttribute("profileReturnUrl");
        session.removeAttribute("profileReturnUrl");

        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            return defaultUrl;
        }
        return sanitizeReturnUrl(returnUrl);
    }

    // 외부 리다이렉트(Open Redirect) 방지용
    private String sanitizeReturnUrl(String returnUrl) {
        if (returnUrl == null) return "/";

        returnUrl = returnUrl.trim();

        // referer가 전체 URL로 들어오는 경우가 있어 uri로 정리
        // (예: https://domain.com/ticket/detail -> /ticket/detail 로만 허용하고 싶음)
        // 여기서는 간단히 외부 차단만 수행
        if (returnUrl.startsWith("http://") || returnUrl.startsWith("https://") || returnUrl.startsWith("//")) {
            return "/";
        }

        if (!returnUrl.startsWith("/")) return "/";

        // auth 화면으로 다시 돌아가는 루프 방지(선택)
        if (returnUrl.startsWith("/auth/login")
                || returnUrl.startsWith("/auth/join")
                || returnUrl.startsWith("/auth/profile")
                || returnUrl.startsWith("/auth/logout")) {
            return "/";
        }

        return returnUrl;
    }
}