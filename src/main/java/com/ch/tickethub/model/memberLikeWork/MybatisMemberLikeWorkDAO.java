package com.ch.tickethub.model.memberLikeWork;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.MemberLikeWork;
import com.ch.tickethub.exception.MemberLikeWorkException;

@Repository
public class MybatisMemberLikeWorkDAO implements MemberLikeWorkDAO{
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int countByMemberId(int memberId) {
		
		return sqlSessionTemplate.selectOne("MemberLikeWork.countByMemberId", memberId);
	}

	@Override
	public void insert(MemberLikeWork memberLikeWork) throws MemberLikeWorkException {
		try {
			sqlSessionTemplate.insert("MemberLikeWork.insert", memberLikeWork);
		} catch (Exception e) {
			e.printStackTrace();
			throw new MemberLikeWorkException("작품 좋아요 등록 과정 중 오류 발생", e);
		}
	
	}
	
}
