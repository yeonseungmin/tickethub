package com.ch.tickethub.controller.tickethub;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.model.member.MemberService;

@Controller
@RequestMapping("/tickethub/mypage")
public class MyPageController {

    @Autowired
    private MemberService memberService;

    // ====== 공통 유틸 ======
    private Member getLogin(HttpSession session) {
        return (Member) session.getAttribute("loginMember");
    }

    private boolean isSocial(Member m) {
        return m != null && m.getOauthProvider() != null && !m.getOauthProvider().trim().isEmpty();
    }

    /** 일반회원만: 비번확인 플래그 체크 + 5분 만료 (타입 방어 포함) */
    private boolean isVerified(HttpSession session) {
        Object v = session.getAttribute("MYPAGE_VERIFIED");
        if (v == null || !"Y".equals(String.valueOf(v))) return false;

        Object atObj = session.getAttribute("MYPAGE_VERIFIED_AT");
        if (atObj == null) return false;

        long at;
        try {
            // Long / String 등 어떤 타입이 와도 long으로 변환되게 방어
            at = Long.parseLong(String.valueOf(atObj));
        } catch (Exception e) {
            clearVerified(session);
            return false;
        }

        if (System.currentTimeMillis() - at > 5 * 60 * 1000) { // 5분
            clearVerified(session);
            return false;
        }
        return true;
    }

    private void setVerified(HttpSession session) {
        session.setAttribute("MYPAGE_VERIFIED", "Y");
        session.setAttribute("MYPAGE_VERIFIED_AT", String.valueOf(System.currentTimeMillis())); // 타입 꼬임 방지
    }

    private void clearVerified(HttpSession session) {
        session.removeAttribute("MYPAGE_VERIFIED");
        session.removeAttribute("MYPAGE_VERIFIED_AT");
    }

    /** next 파라미터를 “안전한 경로”로만 매핑 (오픈리다이렉트 방지) */
    private String resolveNext(String next) {
        if (next == null || next.trim().isEmpty()) return "/tickethub/mypage/edit";

        // 허용할 next만 열어둠
        if ("password-change".equals(next)) return "/tickethub/mypage/password-change";
        if ("edit".equals(next)) return "/tickethub/mypage/edit";

        return "/tickethub/mypage/edit";
    }

    /** next 기본값 강제 */
    private String normalizeNext(String next) {
        if (next == null || next.trim().isEmpty()) return "edit";
        if ("password_change".equals(next)) return "password-change"; // 혹시 언더스코어로 들어와도 교정
        return next;
    }

    // ====== 1) 마이페이지 메인 ======
    @GetMapping
    public String mypageMain(HttpSession session, Model model) {
        Member login = getLogin(session);
        if (login == null) return "redirect:/auth/login";

        Member member = memberService.selectMyPage(login.getMemberId());
        model.addAttribute("member", member);
        return "tickethub/mypage/main";
    }

    // ====== 2) 회원정보 수정 폼 ======
    @GetMapping("/edit")
    public String editForm(HttpSession session, Model model) {
        Member login = getLogin(session);
        if (login == null) return "redirect:/auth/login";

        boolean social = isSocial(login);

        // 일반회원만 비번 확인 필요
        if (!social && !isVerified(session)) {
            return "redirect:/tickethub/mypage/password?next=edit";
        }

        Member member = memberService.selectMyPage(login.getMemberId());
        model.addAttribute("member", member);
        model.addAttribute("isSocial", social);
        return "tickethub/mypage/edit";
    }

    // ====== 3) 회원정보 수정 저장 (POST는 /edit로 통일) ======
    @PostMapping("/edit")
    public String editSubmit(Member form, HttpSession session, Model model) {
        Member login = getLogin(session);
        if (login == null) return "redirect:/auth/login";

        boolean social = isSocial(login);

        if (!social && !isVerified(session)) {
            return "redirect:/tickethub/mypage/password?next=edit";
        }

        // 본인만 수정
        form.setMemberId(login.getMemberId());

        try {
            memberService.updateMyInfo(form);

            // 세션 갱신
            Member refreshed = memberService.selectMyPage(login.getMemberId());
            session.setAttribute("loginMember", refreshed);

            // 일반회원은 다음 수정 때 다시 비번 확인하도록 플래그 제거
            if (!social) clearVerified(session);

            session.setAttribute("TOAST_SUCCESS", "회원정보가 수정되었습니다.");
            return "redirect:/tickethub/mypage";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("member", memberService.selectMyPage(login.getMemberId()));
            model.addAttribute("isSocial", social);
            return "tickethub/mypage/edit";
        }
    }

    // ====== 4) 비밀번호 확인 화면(일반회원만) ======
    @GetMapping("/password")
    public String passwordForm(
            @RequestParam(value = "next", required = false) String next,
            HttpSession session,
            Model model
    ) {
        Member login = getLogin(session);
        if (login == null) return "redirect:/auth/login";

        next = normalizeNext(next);

        // SNS 회원은 비번 확인 없이 next로
        if (isSocial(login)) {
            return "redirect:" + resolveNext(next);
        }

        // 이미 검증되어 있으면 next로
        if (isVerified(session)) {
            return "redirect:" + resolveNext(next);
        }

        // JSP에서 next 사용
        model.addAttribute("next", next);
        return "tickethub/mypage/password";
    }

    // ====== 5) 비밀번호 검증(JSON) + next redirectUrl 반환 ======
    @PostMapping(value = "/verify", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> verifyPassword(
            @RequestParam("password") String password,
            @RequestParam(value = "next", required = false) String next,
            HttpSession session
    ) {
        Map<String, Object> res = new HashMap<>();

        Member login = getLogin(session);
        if (login == null) {
            res.put("ok", false);
            res.put("message", "로그인이 필요합니다");
            return res;
        }

        next = normalizeNext(next);

        // SNS 회원은 비번 검증 불필요(방어)
        if (isSocial(login)) {
            setVerified(session);
            res.put("ok", true);
            res.put("redirectUrl", resolveNext(next));
            return res;
        }

        boolean ok = memberService.verifyPassword(login.getMemberId(), password);
        if (!ok) {
            res.put("ok", false);
            res.put("message", "비밀번호가 일치하지 않습니다");
            return res;
        }

        setVerified(session);
        res.put("ok", true);
        res.put("redirectUrl", resolveNext(next));
        return res;
    }

    // ====== 6) 비밀번호 변경 폼(일반회원만 + verify 필요) ======
    @GetMapping("/password-change")
    public String passwordChangeForm(HttpSession session) {
        Member login = getLogin(session);
        if (login == null) return "redirect:/auth/login";

        if (isSocial(login)) return "redirect:/tickethub/mypage/edit";

        // 변경도 비번확인 통과 필요
        if (!isVerified(session)) return "redirect:/tickethub/mypage/password?next=password-change";

        return "tickethub/mypage/password_change";
    }

    // ====== 7) 비밀번호 변경 처리(일반회원만 + verify 필요) ======
    @PostMapping("/password-change")
    public String passwordChangeSubmit(
            @RequestParam("newPassword") String newPassword,
            @RequestParam("newPasswordConfirm") String newPasswordConfirm,
            HttpSession session,
            Model model
    ) {
        Member login = getLogin(session);
        if (login == null) return "redirect:/auth/login";

        if (isSocial(login)) return "redirect:/tickethub/mypage/edit";
        if (!isVerified(session)) return "redirect:/tickethub/mypage/password?next=password-change";

        if (newPassword == null || !newPassword.equals(newPasswordConfirm)) {
            model.addAttribute("error", "비밀번호 확인이 일치하지 않습니다.");
            return "tickethub/mypage/password_change";
        }

        try {
            memberService.updatePassword(login.getMemberId(), newPassword);

            // 성공 시 verify 플래그 제거 (다음엔 다시 확인)
            clearVerified(session);

            // 세션 갱신
            Member refreshed = memberService.selectMyPage(login.getMemberId());
            session.setAttribute("loginMember", refreshed);

            session.setAttribute("TOAST_SUCCESS", "비밀번호가 변경되었습니다.");
            return "redirect:/tickethub/mypage";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "tickethub/mypage/password_change";
        }
    }
}