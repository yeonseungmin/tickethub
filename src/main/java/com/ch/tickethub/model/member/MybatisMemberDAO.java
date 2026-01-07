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

}
