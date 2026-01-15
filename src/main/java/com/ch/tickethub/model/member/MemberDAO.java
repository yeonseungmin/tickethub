package com.ch.tickethub.model.member;

import java.util.List;
import java.util.Map;

import com.ch.tickethub.dto.Member;

public interface MemberDAO {

    // 로그인/조회
    Member selectByLoginId(String loginId);
    Member selectByOauth(Map<String, Object> param); // oauthProvider, oauthId
    Member selectById(int memberId);

    // 가입
    int insert(Member member);

    // 소셜/일반 공통: 최소 가입(프로필 N)
    int insertMinimalMember(Member member);

    // 로그인 기록
    int updateLastLoginAt(int memberId);

    // 중복 체크
    int existsLoginId(String loginId);
    int existsEmail(String email);
    Integer selectMemberIdByPhone(String phone);

    // 비밀번호/내정보
    String selectPasswordHashById(int memberId);
    int updateMyInfo(Member member);
    int updatePassword(Map<String, Object> param); // memberId, passwordHash

    // 프로필 완성을 위해서 추가함..
    Member selectForProfileForm(int memberId);
    String selectProfileCompleted(int memberId);
    int completeProfile(Member member);

    // 관리자 관련
    List<Member> adminSearchMembers(Map<String, Object> param);
    List<Member> adminSelectMemberList(Map<String, Object> param);
    int adminSelectMemberListCount(Map<String, Object> param);

    Member adminSelectMemberDetail(int memberId);
    int adminUpdateMemberStatus(Map<String, Object> param); // memberId, status
    int adminUpdateMemberGrade(Map<String, Object> param);  // memberId, gradeId
    
    int insertFullMember(Member member);
    Integer selectMemberIdByLoginId(String loginId);
}