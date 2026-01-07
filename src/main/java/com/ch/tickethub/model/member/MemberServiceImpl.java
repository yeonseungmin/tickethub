package com.ch.tickethub.model.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Member;

import ch.qos.logback.core.status.Status;

@Service
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	private MemberDAO memberDAO;
	
	@Override
	@Transactional
	public Member login(String loginId, String password) {
		Member member = memberDAO.selectByLoginId(loginId);
		
		//id없음
		if(member == null) {
			return null;
		}
		
		//차단된 회원
		if("BLOCKED".equals(member.getStatus())) {
			return null;
		}
		
		// 패스워드가 틀림
		if(!password.equals(member.getPasswordHash())) {
			return null;
		}
		
		//마지막 로그인 시간 갱신
		memberDAO.updateLastLoginAt(member.getMemberId());
		
		return member;
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
		
		if(result != 1) {
			throw new RuntimeException("회원 상태 변경 실패");
		}
		
	}

	@Override
	@Transactional
	public void adminUpdateMemberGrade(Integer memberId, Integer gradeId) {
	
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("memberId", memberId);
		param.put("gradeId", gradeId);
		
		int result = memberDAO.adminUpdateMemberGrade(param);
		
		if(result != 1) {
			throw new RuntimeException("회원 등급 변경 실패");
		}
	}

	//
	@Override
	@Transactional
	public Member loginOauth(String oauthProvider, String oauthId) {
		
		Map<String, Object> param = new HashMap<>();
		param.put("oauthProvider", oauthProvider);
		param.put("oauthId", oauthId);
		
		Member member = memberDAO.selectByOauth(param);
		
		memberDAO.updateLastLoginAt(member.getMemberId());
		
		return member;
	}

}
