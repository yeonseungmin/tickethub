package com.ch.tickethub.model.member;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Member;

@Repository
public class MybatisMemberDAO implements MemberDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    // 로그인/조회
    @Override
    public Member selectByLoginId(String loginId) {
        return sqlSessionTemplate.selectOne("Member.selectByLoginId", loginId);
    }

    @Override
    public Member selectByOauth(Map<String, Object> param) {
        return sqlSessionTemplate.selectOne("Member.selectByOauth", param);
    }

    @Override
    public Member selectById(int memberId) {
        return sqlSessionTemplate.selectOne("Member.selectById", memberId);
    }

    // 가입
    @Override
    public int insert(Member member) {
        return sqlSessionTemplate.insert("Member.insert", member);
    }

    @Override
    public int insertMinimalMember(Member member) {
        return sqlSessionTemplate.insert("Member.insertMinimalMember", member);
    }

    // 로그인 기록
    @Override
    public int updateLastLoginAt(int memberId) {
        return sqlSessionTemplate.update("Member.updateLastLoginAt", memberId);
    }

    // 중복 체크
    @Override
    public int existsLoginId(String loginId) {
        Integer cnt = sqlSessionTemplate.selectOne("Member.existsLoginId", loginId);
        return (cnt == null) ? 0 : cnt;
    }

    @Override
    public int existsEmail(String email) {
        Integer cnt = sqlSessionTemplate.selectOne("Member.existsEmail", email);
        return (cnt == null) ? 0 : cnt;
    }

    // 비밀번호/내정보
    @Override
    public String selectPasswordHashById(int memberId) {
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

    // 프로필 완성 플로우
    @Override
    public Member selectForProfileForm(int memberId) {
        return sqlSessionTemplate.selectOne("Member.selectForProfileForm", memberId);
    }

    @Override
    public String selectProfileCompleted(int memberId) {
        return sqlSessionTemplate.selectOne("Member.selectProfileCompleted", memberId);
    }

    @Override
    public int completeProfile(Member member) {
        return sqlSessionTemplate.update("Member.completeProfile", member);
    }

    // 관리자
    @Override
    public List<Member> adminSearchMembers(Map<String, Object> param) {
        return sqlSessionTemplate.selectList("Member.adminSearchMembers", param);
    }

    @Override
    public List<Member> adminSelectMemberList(Map<String, Object> param) {
        return sqlSessionTemplate.selectList("Member.adminSelectMemberList", param);
    }

    @Override
    public int adminSelectMemberListCount(Map<String, Object> param) {
        Integer cnt = sqlSessionTemplate.selectOne("Member.adminSelectMemberListCount", param);
        return (cnt == null) ? 0 : cnt;
    }

    @Override
    public Member adminSelectMemberDetail(int memberId) {
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
	public Integer selectMemberIdByPhone(String phone) {
		return sqlSessionTemplate.selectOne("Member.selectMemberIdByPhone", phone);
	}

	@Override
	public int insertFullMember(Member member) {
		return sqlSessionTemplate.insert("Member.insertFullMember", member);
	}

	@Override
	public Integer selectMemberIdByLoginId(String loginId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("Member.selectMemberIdByLoginId", loginId);
	}
}