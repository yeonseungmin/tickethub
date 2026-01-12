package com.ch.tickethub.model.member;

import java.util.List;

import com.ch.tickethub.dto.Member;

public interface MemberService {
	
	public void register(Member member); //일반 회원가입
	
	
	public Member login(String loginId, String password);
	
	public Member loginOauthOrRegister(String oauthProvider, String oauthId, String email, String name);
	
	public LoginResult loginCheck(String loginId, String password);
	public List<Member> adminSearchMembers(String keyword, String status);
	public Member adminSelectMemberDetail(Integer memberId);
	public void adminUpdateMemberStatus(Integer memberId, String status);
	public void adminUpdateMemberGrade(Integer memberId, Integer gradeId);

	public Member selectMyPage(Integer memberId);
}