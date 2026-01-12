package com.ch.tickethub.model.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.exception.DuplicateLoginIdException;
import com.ch.tickethub.model.grade.GradeDAO;
import com.ch.tickethub.util.MailSender;
import com.ch.tickethub.util.PasswordUtil;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	private MemberDAO memberDAO;

	@Autowired
	private GradeDAO gradeDAO;

	@Autowired
	private MailSender mailSender;

	private String normalizeEmail(String email) {
		if (email == null)
			return null;
		email = email.trim();
		if (email.isEmpty())
			return null;
		return email.toLowerCase();
	}

	private String normalizePhone(String phone) {
		if (phone == null)
			return null;
		phone = phone.trim();
		if (phone.isEmpty())
			return null;
		phone = phone.replaceAll("[^0-9]", ""); // 숫자만 남김
		return phone;
	}

	@Override
	@Transactional
	public Member login(String loginId, String password) {
		Member member = memberDAO.selectByLoginId(loginId);

		if (member == null)
			return null;
		if ("BLOCKED".equals(member.getStatus()))
			return null;
		if (member.getPasswordHash() == null)
			return null; // 소셜회원이 일반로그인 시도 방지
		if (!PasswordUtil.matches(password, member.getPasswordHash()))
			return null;

		memberDAO.updateLastLoginAt(member.getMemberId());
		return member;
	}

	// 소셜 로그인: 조회 + 차단검사 + lastLogin 갱신 (헬퍼)
	@Transactional
	private Member loginOauth(String oauthProvider, String oauthId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("oauthProvider", oauthProvider);
		param.put("oauthId", oauthId);

		Member member = memberDAO.selectByOauth(param);
		if (member == null)
			return null;
		if ("BLOCKED".equals(member.getStatus()))
			return null;

		memberDAO.updateLastLoginAt(member.getMemberId());
		return member;
	}

	@Override
	@Transactional
	public Member loginOauthOrRegister(String oauthProvider, String oauthId, String email, String name) {

		// 1) 기존 회원이면 바로 로그인 처리
		Member member = loginOauth(oauthProvider, oauthId);
		if (member != null)
			return member;

		if (oauthProvider == null || oauthProvider.trim().isEmpty() || oauthId == null || oauthId.trim().isEmpty()) {
			throw new RuntimeException("소셜 로그인 정보(oauthProvider, oauthId)가 없습니다");
		}

		// 2) 없으면 가입
		Member newMember = new Member();

		newMember.setEmail(normalizeEmail(email));

		// loginId 정책: provider_oauthId
		newMember.setLoginId(oauthProvider + "_" + oauthId);

		// 소셜회원은 비번 없음
		newMember.setPasswordHash(null);

		newMember.setName(name != null ? name : "소셜회원");
		newMember.setStatus("NORMAL");
		newMember.setRole("USER");

		Integer welcomeGradeId = gradeDAO.selectGradeIdByCode(100);
		if (welcomeGradeId == null) {
			throw new RuntimeException("WELCOME 등급이 DB에 없습니다. grade 테이블을 확인하세요.");
		}
		newMember.setGradeId(welcomeGradeId);

		newMember.setOauthProvider(oauthProvider);
		newMember.setOauthId(oauthId);

		try {
			int result = memberDAO.insert(newMember);
			if (result != 1) {
				throw new RuntimeException("소셜 회원가입 실패");
			}
		} catch (DuplicateKeyException e) {
			String m = (e.getMostSpecificCause() != null) ? e.getMostSpecificCause().getMessage() : "";

			if (m.contains("uk_member_email")) {
				throw new RuntimeException("이미 가입된 이메일입니다. 기존 방식으로 로그인 해주세요.");
			} else if (m.contains("uk_member_oauth")) {
				throw new RuntimeException("이미 연결된 소셜 계정입니다. 다시 시도해주세요.");
			} else if (m.contains("uk_member_login")) {
				throw new RuntimeException("이미 존재하는 ID가 있습니다. 소셜 계정 충돌");
			}
			throw new RuntimeException("회원가입 처리 중 중복 데이터가 발생했습니다.");
		}

		// 가입축하 메일(이메일 있을 때만)
		if (newMember.getEmail() != null && !newMember.getEmail().trim().isEmpty()) {
			mailSender.send(newMember.getEmail(), "Tickethub 가입을 환영합니다", "<h3>SNS 가입 완료</h3>");
		}

		// 3) 가입 후 로그인 처리(조회+lastLogin 갱신)
		return loginOauth(oauthProvider, oauthId);
	}

	@Override
	@Transactional
	public void register(Member member) {

		member.setEmail(normalizeEmail(member.getEmail()));

		// 일반회원(=소셜정보 없음)인 경우 비밀번호 필수
		if (member.getOauthProvider() == null || member.getOauthProvider().trim().isEmpty()) {
			if (member.getPasswordHash() == null || member.getPasswordHash().trim().isEmpty()) {
				throw new RuntimeException("일반 회원은 비밀번호가 필수입니다");
			}
		}
		if (member.getLoginId() == null || member.getLoginId().trim().isEmpty()) {
			throw new RuntimeException("아이디(loginId)는 필수입니다");
		}

		// 이메일 필수(일반회원 가입 정책)
		if (member.getEmail() == null || member.getEmail().trim().isEmpty()) {
			throw new RuntimeException("이메일은 필수입니다");
		}

		if (memberDAO.existsEmail(member.getEmail()) > 0) {
			throw new RuntimeException("이미 가입된 이메일입니다.");
		}

		String phone = normalizePhone(member.getPhone());
		if (phone == null)
			throw new RuntimeException("휴대폰 번호는 필수입니다");
		if (!phone.matches("^01\\d{8,9}$")) {
			throw new RuntimeException("휴대폰 번호 형식이 올바르지 않습니다");
		}
		member.setPhone(phone);

		if (memberDAO.existsLoginId(member.getLoginId()) > 0) {
			throw new DuplicateLoginIdException("이미 존재하는 ID가 있습니다.");
		}

		// 휴대폰 필수
		if (member.getPhone() == null || member.getPhone().trim().isEmpty()) {
			throw new RuntimeException("휴대폰 번호는 필수입니다");
		}

		// 기본값 채우기
		if (member.getStatus() == null || member.getStatus().trim().isEmpty()) {
			member.setStatus("NORMAL");
		}
		if (member.getRole() == null || member.getRole().trim().isEmpty()) {
			member.setRole("USER");
		}

		Integer welcomeGradeId = gradeDAO.selectGradeIdByCode(100);
		if (welcomeGradeId == null) {
			throw new RuntimeException("WELCOME 등급이 DB에 없습니다. grade 테이블을 확인하세요.");
		}
		member.setGradeId(welcomeGradeId);

		String hashed = PasswordUtil.hash(member.getPasswordHash());
		member.setPasswordHash(hashed);

		try {
			int result = memberDAO.insert(member);
			if (result != 1) {
				throw new RuntimeException("회원가입 실패");
			}
		} catch (org.springframework.dao.DuplicateKeyException e) {
			String msg = "이미 가입된 정보가 있습니다.";
			String m = (e.getMostSpecificCause() != null) ? e.getMostSpecificCause().getMessage() : "";

			if (m.contains("uk_member_email"))
				msg = "이미 가입된 이메일입니다.";
			else if (m.contains("uk_member_login"))
				msg = "이미 존재하는 ID가 있습니다.";

			throw new RuntimeException(msg);
		}

		// 가입축하 메일
		mailSender.send(member.getEmail(), "Tickethub 가입을 환영합니다", "<h3>가입 완료</h3>");
	}

	@Override
	public List<Member> adminSearchMembers(String keyword, String status) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("keyword", keyword);
		param.put("status", status);
		return memberDAO.adminSearchMembers(param);
	}

	@Override
	public Member adminSelectMemberDetail(Integer memberId) {
		return memberDAO.adminSelectMemberDetail(memberId);
	}

	@Override
	@Transactional
	public void adminUpdateMemberStatus(Integer memberId, String status) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("memberId", memberId);
		param.put("status", status);

		int result = memberDAO.adminUpdateMemberStatus(param);
		if (result != 1)
			throw new RuntimeException("회원 상태 변경 실패");
	}

	@Override
	@Transactional
	public void adminUpdateMemberGrade(Integer memberId, Integer gradeId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("memberId", memberId);
		param.put("gradeId", gradeId);

		int result = memberDAO.adminUpdateMemberGrade(param);
		if (result != 1)
			throw new RuntimeException("회원 등급 변경 실패");
	}

	@Override
	public LoginResult loginCheck(String loginId, String password) {
		Member member = memberDAO.selectByLoginId(loginId);

		if (member == null)
			return LoginResult.NOT_FOUND;
		if ("BLOCKED".equals(member.getStatus()))
			return LoginResult.BLOCKED;
		if (member.getPasswordHash() == null)
			return LoginResult.SOCIAL_ACCOUNT;

		if (!PasswordUtil.matches(password, member.getPasswordHash()))
			return LoginResult.WRONG_PASSWORD;
		return LoginResult.SUCCESS;
	}

	@Override
	public Member selectMyPage(Integer memberId) {
		return memberDAO.selectById(memberId);
	}

	@Override
	public boolean verifyPassword(Integer memberId, String rawPassword) {
	    if (memberId == null) return false;
	    if (rawPassword == null || rawPassword.trim().isEmpty()) return false;

	    String dbHash = memberDAO.selectPasswordHashById(memberId);
	    if (dbHash == null || dbHash.trim().isEmpty()) return false;

	    return PasswordUtil.matches(rawPassword, dbHash);
	}

	@Override
	@Transactional
	public void updateMyInfo(Member formMember) {
		// ID
		if (formMember.getMemberId() == null) {
			throw new RuntimeException("회원 식별자가 없습니다.");
		}

		// 이메일/폰번호
		String email = normalizeEmail(formMember.getEmail());
		if (email == null) {
			throw new RuntimeException("이메일은 필수입니다.");
		}

		String phone = normalizePhone(formMember.getPhone());
		if (phone == null)
			throw new RuntimeException("휴대폰 번호는 필수입니다.");
		// 번호 형식
		if (!phone.matches("^01\\d{8,9}$")) {
			throw new RuntimeException("휴대폰 번호 형식이 올바르지 않습니다");
		}

		formMember.setEmail(email);
		formMember.setPhone(phone);

		Member current = memberDAO.selectById(formMember.getMemberId());
		if (current == null)
			throw new RuntimeException("회원 정보를 찾을 수 없습니다.");

		if (current.getEmail() == null || !email.equalsIgnoreCase(current.getEmail())) {
			if (memberDAO.existsEmail(email) > 0) {
				throw new RuntimeException("이미 사용 중인 이메일입니다.");
			}
		}

		int r = memberDAO.updateMyInfo(formMember);
		if (r != 1) {
			throw new RuntimeException("회원 정보 수정 실패");
		}
	}

	@Override
	@Transactional
	public void updatePassword(Integer memberId, String newRawPassword) {
		if (memberId == null)
			throw new RuntimeException("회원 식별자가 없습니다.");
		if (newRawPassword == null || newRawPassword.trim().isEmpty())
			throw new RuntimeException("비밀번호는 필수입니다.");

		if (!newRawPassword.matches("^(?=.*[a-z])(?=.*\\d)[a-z\\d\\W]{8,20}$")) {
			throw new RuntimeException("비밀번호는 8~20자이며 소문자+숫자를 포함해야 합니다.");
		}

		String hash = PasswordUtil.hash(newRawPassword);
		Map<String, Object> p = new java.util.HashMap<String, Object>();
		p.put("memberId", memberId);
		p.put("passwordHash", hash);

		int r = memberDAO.updatePassword(p);
		if (r != 1)
			throw new RuntimeException("비밀번호 변경 실패");
	}
}