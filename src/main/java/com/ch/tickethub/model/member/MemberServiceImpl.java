package com.ch.tickethub.model.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.JoinDraft;
import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.OauthLoginResponse;
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

	// normalize helpers
	private String normalizeEmail(String email) {
		if (email == null) return null;
		email = email.trim();
		if (email.isEmpty()) return null;
		return email.toLowerCase();
	}

	private String normalizePhone(String phone) {
		if (phone == null) return null;
		phone = phone.trim();
		if (phone.isEmpty()) return null;
		// 숫자만
		phone = phone.replaceAll("[^0-9]", "");
		return phone;
	}

	private Integer getWelcomeGradeId() {
		Integer welcomeGradeId = gradeDAO.selectGradeIdByCode(100);
		if (welcomeGradeId == null) {
			throw new RuntimeException("WELCOME 등급이 DB에 없습니다. grade 테이블을 확인하세요.");
		}
		return welcomeGradeId;
	}

	// =========================================================
	// 1) 일반 로그인 (일반회원만)
	// =========================================================
	@Override
	@Transactional
	public Member login(String loginId, String password) {
		if (loginId == null) return null;
		loginId = loginId.trim();
		if (loginId.isEmpty()) return null;

		Member member = memberDAO.selectByLoginId(loginId);

		if (member == null) return null;
		if ("BLOCKED".equals(member.getStatus())) return null;

		// 소셜계정이 일반로그인 시도 방지
		if (member.getPasswordHash() == null) return null;

		if (!PasswordUtil.matches(password, member.getPasswordHash())) return null;

		memberDAO.updateLastLoginAt(member.getMemberId());
		return member;
	}

	// =========================================================
	// 2) 소셜 로그인 or 최초 최소가입
	// - 반환: OauthLoginResponse
	// - 정책: profile_completed='N'이면 PROFILE_REQUIRED로 보내기
	// =========================================================
	@Override
	@Transactional
	public OauthLoginResponse loginOauthOrRegister(String oauthProvider, String oauthId, String email, String name) {

		if (oauthProvider == null || oauthProvider.trim().isEmpty() || oauthId == null || oauthId.trim().isEmpty()) {
			throw new RuntimeException("소셜 로그인 정보(oauthProvider, oauthId)가 없습니다");
		}

		Map<String, Object> param = new HashMap<>();
		param.put("oauthProvider", oauthProvider);
		param.put("oauthId", oauthId);

		// 1) 기존 소셜회원 조회
		Member member = memberDAO.selectByOauth(param);

		if (member != null) {
			if ("BLOCKED".equals(member.getStatus())) {
				// 차단이면 로그인 불가(프론트에서 처리할 수 있게)
				// 프로젝트 정책에 맞게 reason 조정 가능
				return OauthLoginResponse.profileRequired("BLOCKED", null);
			}

			memberDAO.updateLastLoginAt(member.getMemberId());

			// 프로필 미완료면 추가 입력
			if ("N".equals(member.getProfileCompleted())) {
				return OauthLoginResponse.profileRequired("PROFILE_INCOMPLETE", member);
			}

			// 정상 로그인
			return OauthLoginResponse.success(member);
		}

		// 2) 없으면 최소가입
		Member newMember = new Member();

		newMember.setOauthProvider(oauthProvider);
		newMember.setOauthId(oauthId);

		// loginId 정책: provider_oauthId
		newMember.setLoginId(oauthProvider + "_" + oauthId);

		newMember.setPasswordHash(null); // 소셜회원은 비밀번호 없음
		newMember.setName((name == null || name.trim().isEmpty()) ? "소셜회원" : name.trim());

		// 이메일은 있을 수도/없을 수도 → normalize + 비어있으면 null
		newMember.setEmail(normalizeEmail(email));

		// 기본값(폼에서 받지 않기)
		newMember.setStatus("NORMAL");
		newMember.setRole("USER");
		newMember.setGradeId(getWelcomeGradeId());

		try {
			int r = memberDAO.insertMinimalMember(newMember);
			if (r != 1) throw new RuntimeException("소셜 회원 최소가입 실패");
		} catch (DuplicateKeyException e) {
			// 유니크 충돌(특히 email, oauth, login_id)
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

		// 3) memberId 확보 위해 재조회 + lastLogin 갱신
		Member created = memberDAO.selectByOauth(param);
		if (created == null) throw new RuntimeException("소셜 가입 후 회원 조회 실패");

		memberDAO.updateLastLoginAt(created.getMemberId());

		// 4) 최초 소셜 로그인 → 프로필 입력 필요
		return OauthLoginResponse.profileRequired("OAUTH_FIRST_LOGIN", created);
	}

	// =========================================================
	// 3) 일반회원 최소가입 (profile_completed='N')
	// =========================================================
	// (주석 그대로 유지)

	// =========================================================
	// 4) 로그인 체크 결과 (LoginResult)
	// - 여기서는 profile_required 분기까지 포함시키는 게 실무적으로 좋음
	// =========================================================
	@Override
	public LoginResult loginCheck(String loginId, String password) {
		if (loginId == null) return LoginResult.NOT_FOUND;
		loginId = loginId.trim();
		if (loginId.isEmpty()) return LoginResult.NOT_FOUND;

		Member member = memberDAO.selectByLoginId(loginId);

		if (member == null) return LoginResult.NOT_FOUND;
		if ("BLOCKED".equals(member.getStatus())) return LoginResult.BLOCKED;

		// 소셜계정이면 일반로그인 불가
		if (member.getPasswordHash() == null) return LoginResult.SOCIAL_ACCOUNT;

		if (!PasswordUtil.matches(password, member.getPasswordHash())) return LoginResult.WRONG_PASSWORD;

		//  프로필 미완료면 추가입력 유도(일반로그인도 동일 정책)
		if ("N".equals(member.getProfileCompleted())) return LoginResult.PROFILE_REQUIRED;

		return LoginResult.SUCCESS;
	}

	// =========================================================
	// 5) 관리자 검색(간단)
	// =========================================================
	@Override
	public List<Member> adminSearchMembers(String keyword, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("keyword", keyword);
		param.put("status", status);
		return memberDAO.adminSearchMembers(param);
	}

	@Override
	public Member adminSelectMemberDetail(int memberId) {
		return memberDAO.adminSelectMemberDetail(memberId);
	}

	@Override
	@Transactional
	public void adminUpdateMemberStatus(int memberId, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("memberId", memberId);
		param.put("status", status);

		int r = memberDAO.adminUpdateMemberStatus(param);
		if (r != 1) throw new RuntimeException("회원 상태 변경 실패");
	}

	@Override
	@Transactional
	public void adminUpdateMemberGrade(int memberId, Integer gradeId) {
		Map<String, Object> param = new HashMap<>();
		param.put("memberId", memberId);
		param.put("gradeId", gradeId);

		int r = memberDAO.adminUpdateMemberGrade(param);
		if (r != 1) throw new RuntimeException("회원 등급 변경 실패");
	}

	// =========================================================
	// 6) 마이페이지 조회
	// =========================================================
	@Override
	public Member selectMyPage(int memberId) {
		return memberDAO.selectById(memberId);
	}

	// =========================================================
	// 7) 비밀번호 검증/변경
	// =========================================================
	@Override
	public boolean verifyPassword(int memberId, String rawPassword) {
		if (memberId <= 0) return false;
		if (rawPassword == null || rawPassword.trim().isEmpty()) return false;

		String dbHash = memberDAO.selectPasswordHashById(memberId);
		if (dbHash == null || dbHash.trim().isEmpty()) return false;

		return PasswordUtil.matches(rawPassword, dbHash);
	}

	@Override
	@Transactional
	public void updatePassword(int memberId, String newRawPassword) {
		if (memberId <= 0) throw new RuntimeException("회원 식별자가 없습니다.");

		validatePasswordPolicy(newRawPassword);

		String hash = PasswordUtil.hash(newRawPassword.trim());

		Map<String, Object> p = new HashMap<>();
		p.put("memberId", memberId);
		p.put("passwordHash", hash);

		int r = memberDAO.updatePassword(p);
		if (r != 1) throw new RuntimeException("비밀번호 변경 실패");
	}

	// =========================================================
	// 8) 내정보 수정
	// - 정책: email/phone은 필수로 유지 (원하면 완화 가능)
	// =========================================================
	@Override
	@Transactional
	public void updateMyInfo(Member formMember) {
		if (formMember == null || formMember.getMemberId() == null) {
			throw new RuntimeException("회원 식별자가 없습니다.");
		}

		// email
		String email = normalizeEmail(formMember.getEmail());
		if (email == null) throw new RuntimeException("이메일은 필수입니다.");
		formMember.setEmail(email);

		// phone
		String phone = normalizePhone(formMember.getPhone());
		if (phone == null) throw new RuntimeException("휴대폰 번호는 필수입니다.");
		if (!phone.matches("^01\\d{8,9}$")) throw new RuntimeException("휴대폰 번호 형식이 올바르지 않습니다.");
		formMember.setPhone(phone);

		Member current = memberDAO.selectById(formMember.getMemberId());
		if (current == null) throw new RuntimeException("회원 정보를 찾을 수 없습니다.");

		// 애초에 프로필에 다 입력 안 하면 마이페이지에서 수정도 안 되고 바로 다시 프로필로 돌려보내기 (일단 방어용으로 추가..)
		// Y면 updateMyInfo()로 수정가능
		if ("N".equals(current.getProfileCompleted())) {
			throw new RuntimeException("추가 회원정보 입력이 필요합니다."); // 컨트롤러에서 프로필 페이지로 유도
		}

		// phone 변경 시 중복 체크 (본인 제외)
		String currentPhone = normalizePhone(current.getPhone()); // DB 값도 normalize
		if (currentPhone == null || !phone.equals(currentPhone)) {
			Integer existsId = memberDAO.selectMemberIdByPhone(phone);
			if (existsId != null && !existsId.equals(formMember.getMemberId())) {
				throw new RuntimeException("이미 등록된 휴대폰 번호입니다.");
			}
		}

		// 이메일 변경 시 중복 체크
		if (current.getEmail() == null || !email.equalsIgnoreCase(current.getEmail())) {
			if (memberDAO.existsEmail(email) > 0) {
				throw new RuntimeException("이미 사용 중인 이메일입니다.");
			}
		}

		try {
			int r = memberDAO.updateMyInfo(formMember);
			if (r != 1) throw new RuntimeException("회원 정보 수정 실패");
		} catch (DuplicateKeyException e) {
			throw new RuntimeException("이미 등록된 휴대폰 번호입니다.");
		}
	}

	// =========================================================
	// 9) 관리자 목록(검색+필터+페이징)
	// =========================================================
	@Override
	public List<Member> adminSelectMemberList(String keyword, String status, Integer gradeId, int page, int size) {
		int offset = (page - 1) * size;

		Map<String, Object> param = new HashMap<>();
		param.put("keyword", keyword);
		param.put("status", status);
		param.put("gradeId", gradeId);
		param.put("limit", size);
		param.put("offset", offset);

		return memberDAO.adminSelectMemberList(param);
	}

	@Override
	public int adminSelectMemberListCount(String keyword, String status, Integer gradeId) {
		Map<String, Object> param = new HashMap<>();
		param.put("keyword", keyword);
		param.put("status", status);
		param.put("gradeId", gradeId);

		return memberDAO.adminSelectMemberListCount(param);
	}

	// =========================================================
	// 10) 프로필 입력 폼 조회 / 프로필 완성 처리
	// =========================================================
	@Override
	public Member selectForProfileForm(int memberId) {
		return memberDAO.selectForProfileForm(memberId);
	}

	@Override
	@Transactional
	public boolean completeProfile(Member member) {
		if (member == null || member.getMemberId() == null) {
			throw new RuntimeException("회원 식별자가 없습니다.");
		}

		// 필수(정책): phone, address, zipCode
		String phone = normalizePhone(member.getPhone());
		if (phone == null) throw new RuntimeException("휴대폰 번호는 필수입니다.");
		if (!phone.matches("^01\\d{8,9}$")) {
			throw new RuntimeException("휴대폰 번호 형식이 올바르지 않습니다");
		}
		member.setPhone(phone);

		Integer existsId = memberDAO.selectMemberIdByPhone(phone);
		if (existsId != null && !existsId.equals(member.getMemberId())) {
			throw new RuntimeException("이미 등록된 휴대폰 번호입니다.");
		}

		if (member.getAddress() == null || member.getAddress().trim().isEmpty()) {
			throw new RuntimeException("주소는 필수입니다.");
		}
		member.setAddress(member.getAddress().trim());

		if (member.getZipCode() == null) {
			throw new RuntimeException("우편번호는 필수입니다.");
		}

		if (!member.getZipCode().matches("^\\d{5}$")) {
			throw new RuntimeException("우편번호 형식이 올바르지 않습니다.");
		}

		try {
			int r = memberDAO.completeProfile(member);
			return r == 1;
		} catch (DuplicateKeyException e) {
			throw new RuntimeException("이미 등록된 휴대폰 번호입니다.");
		}
	}

	@Override
	public boolean existsLoginId(String loginId) {
		if (loginId == null) return false;
		return memberDAO.existsLoginId(loginId.trim()) > 0;
	}

	@Override
	public boolean existsEmail(String email) {
		String e = normalizeEmail(email);
		if (e == null) return false;
		return memberDAO.existsEmail(e) > 0;
	}

	@Override
	@Transactional
	public int registerFullFromDraft(JoinDraft draft, String phone, String zipCode, String address) {
		if (draft == null) throw new RuntimeException("회원가입 정보가 없습니다. 다시 시도해주세요.");

		String loginId = (draft.getLoginId() == null) ? null : draft.getLoginId().trim();
		String rawPw = (draft.getRawPassword() == null) ? null : draft.getRawPassword().trim();
		String name = (draft.getName() == null) ? null : draft.getName().trim();
		String email = normalizeEmail(draft.getEmail());

		if (loginId == null || loginId.isEmpty()) throw new RuntimeException("아이디는 필수입니다.");
		if (rawPw == null || rawPw.isEmpty()) throw new RuntimeException("비밀번호는 필수입니다.");
		if (name == null || name.isEmpty()) throw new RuntimeException("이름은 필수입니다.");
		if (email == null) throw new RuntimeException("이메일은 필수입니다.");

		//  원래 register에서 하던 정책 검증을 여기서 확실히 적용 (중복 없이 함수로 통일)
		validateLoginIdPolicy(loginId);
		validatePasswordPolicy(rawPw);

		// profile 입력값 검증 (너 completeProfile과 동일 정책)
		String nPhone = normalizePhone(phone);
		if (nPhone == null) throw new RuntimeException("휴대폰 번호는 필수입니다.");
		if (!nPhone.matches("^01\\d{8,9}$")) throw new RuntimeException("휴대폰 번호 형식이 올바르지 않습니다.");

		if (zipCode == null || !zipCode.matches("^\\d{5}$")) throw new RuntimeException("우편번호 형식이 올바르지 않습니다.");
		if (address == null || address.trim().isEmpty()) throw new RuntimeException("주소는 필수입니다.");

		// 선조회(UX용) + 최종 DuplicateKeyException 방어(동시성)
		if (memberDAO.existsLoginId(loginId) > 0) throw new RuntimeException("이미 존재하는 ID가 있습니다.");
		if (memberDAO.existsEmail(email) > 0) throw new RuntimeException("이미 가입된 이메일입니다.");
		// phone은 UNIQUE면 선조회 추가 가능
		Integer existsId = memberDAO.selectMemberIdByPhone(nPhone);
		if (existsId != null) throw new RuntimeException("이미 등록된 휴대폰 번호입니다.");

		Member m = new Member();
		m.setLoginId(loginId);
		m.setPasswordHash(PasswordUtil.hash(rawPw));
		m.setName(name);
		m.setEmail(email);

		m.setPhone(nPhone);
		m.setZipCode(zipCode);
		m.setAddress(address.trim());

		m.setStatus("NORMAL");
		m.setRole("USER");
		m.setGradeId(getWelcomeGradeId());
		m.setProfileCompleted("Y");

		try {
			int r = memberDAO.insertFullMember(m);
			if (r != 1) throw new RuntimeException("회원가입 실패");

			Integer memberId = m.getMemberId(); // useGeneratedKeys면 여기 채워짐
			if (memberId == null) throw new RuntimeException("회원가입 후 회원번호 생성 실패");

			mailSender.send(email, "Tickethub 가입을 환영합니다", "<h3>가입 완료</h3>");
			return memberId;

		} catch (DuplicateKeyException e) {
			// 제약명으로 분기(너 스타일대로)
			String msg = (e.getMostSpecificCause() != null) ? e.getMostSpecificCause().getMessage() : "";
			if (msg.contains("uk_member_login")) return throwDup("이미 존재하는 ID가 있습니다.");
			if (msg.contains("uk_member_email")) return throwDup("이미 가입된 이메일입니다.");
			if (msg.contains("uk_member_phone")) return throwDup("이미 등록된 휴대폰 번호입니다.");
			throw new RuntimeException("이미 가입된 정보가 있습니다.");
		}
	}

	private int throwDup(String m) {
		throw new RuntimeException(m);
	}

	// 정책 함수(여기만 고치면 전부 반영됨)
	private void validateLoginIdPolicy(String loginId) {
		if (loginId == null) throw new RuntimeException("아이디는 필수입니다.");
		loginId = loginId.trim();
		if (loginId.isEmpty()) throw new RuntimeException("아이디는 필수입니다.");

		// ID: 영문/숫자 8~20
		if (!loginId.matches("^[a-zA-Z0-9]{8,20}$")) {
			throw new RuntimeException("아이디는 영문/숫자 8~20자로 입력해주세요.");
		}
	}

	private void validatePasswordPolicy(String rawPw) {
		if (rawPw == null) throw new RuntimeException("비밀번호는 필수입니다.");
		rawPw = rawPw.trim();
		if (rawPw.isEmpty()) throw new RuntimeException("비밀번호는 필수입니다.");

		// PW: 8~20 + 소문자 + 숫자 포함
		if (!rawPw.matches("^(?=.*[a-z])(?=.*\\d)[a-z\\d\\W]{8,20}$")) {
			throw new RuntimeException("비밀번호는 8~20자이며 소문자+숫자를 포함해야 합니다.");
		}
	}
}