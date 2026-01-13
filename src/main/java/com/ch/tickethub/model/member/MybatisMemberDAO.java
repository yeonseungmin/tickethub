package com.ch.tickethub.model.member;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Member;

@Repository
public class MybatisMemberDAO implements MemberDAO{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public Member selectByLoginId(String loginId) {
		return sqlSessionTemplate.selectOne("Member.selectByLoginId", loginId);
	}

	@Override
	public int updateLastLoginAt(Integer memberId) {
		return sqlSessionTemplate.update("Member.updateLastLoginAt", memberId);
	}

	@Override
	public List<Member> adminSearchMembers(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("Member.adminSearchMembers", param);
	}

	@Override
	public Member adminSelectMemberDetail(Integer memberId) {
		return sqlSessionTemplate.selectOne("Member.adminSelectMemberDetail", memberId);
	}

	@Override
	public int adminUpdateMemberStatus(Map<String, Object> param) {
		return sqlSessionTemplate.update("Member.adminUpdateMemberStatus", param);
	}

	@Override
	public int adminUpdateMemberGrade(Map<String, Object> param) {
		return sqlSessionTemplate.update("Member.adminUpdateMemberGrade", param);
	}

	@Override
	public Member selectByOauth(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("Member.selectByOauth", param);
	}

	@Override
	public int insert(Member member) {
		return sqlSessionTemplate.insert("Member.insert", member);
	}

	@Override
	public int existsLoginId(String loginId) {
		Integer cnt = sqlSessionTemplate.selectOne("Member.existsLoginId", loginId);
		return (cnt == null)? 0 : cnt; // 결과가 null로 넘어올 수도 있으니깐 0이나 cnt로 바꿔주기! 
	}

	@Override
	public int existsEmail(String email) {
		Integer cnt = sqlSessionTemplate.selectOne("Member.existsEmail", email);
		return (cnt == null)? 0 : cnt;
	}

	@Override
	public Member selectById(Integer memberId) {
		return sqlSessionTemplate.selectOne("Member.selectById", memberId);
	}

	@Override
	public String selectPasswordHashById(Integer memberId) {
		return sqlSessionTemplate.selectOne("Member.selectPasswordHashById", memberId);
	}

	@Override
	public int updateMyInfo(Member member) {
		return sqlSessionTemplate.update("Member.updateMyInfo", member);
		
	}

	@Override
	public int updatePassword(Map<String, Object> param) {
		return sqlSessionTemplate.update("Member.updatePassword", param);
		
	}

	@Override
	public List<Member> adminSelectMemberList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("Member.adminSelectMemberList", param);
	}

	@Override
	public int adminSelectMemberListCount(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("Member.adminSelectMemberListCount", param);
	}

}
