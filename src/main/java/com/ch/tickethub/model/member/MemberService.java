package com.ch.tickethub.model.member;

import java.util.List;

import com.ch.tickethub.dto.JoinDraft;
import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.OauthLoginResponse;

public interface MemberService {
	
	//public int register(Member member); //일반 회원가입
	
	
	public Member login(String loginId, String password);
	
	public OauthLoginResponse loginOauthOrRegister(String oauthProvider, String oauthId, String email, String name);

	
	public LoginResult loginCheck(String loginId, String password);
	public List<Member> adminSearchMembers(String keyword, String status);
	public Member adminSelectMemberDetail(int memberId);
	public void adminUpdateMemberStatus(int memberId, String status);
	public void adminUpdateMemberGrade(int memberId, Integer gradeId);

	public Member selectMyPage(int memberId);
	
	public boolean verifyPassword(int memberId, String rawPassword);
	
	public void updateMyInfo(Member formMember);
	
	public void updatePassword(int memberId, String newRawPassword);
	
	public List<Member> adminSelectMemberList(String keyword, String status, Integer gradeId, int page, int size);
	public int adminSelectMemberListCount(String keyword, String status, Integer gradeId);
	
	public Member selectForProfileForm(int memberId);
	public boolean completeProfile(Member member);
	boolean existsLoginId(String loginId);
	boolean existsEmail(String email);

	int registerFullFromDraft(JoinDraft draft, String phone, String zipCode, String address);
}

