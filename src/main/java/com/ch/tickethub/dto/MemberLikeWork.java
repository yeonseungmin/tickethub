package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class MemberLikeWork {
	private int member_like_work_id;
	private Member member;
	private Work work;
}
