package com.ch.tickethub.model.discountdetail;

import java.util.List;
import com.ch.tickethub.dto.DiscountDetail;

public interface DiscountDetailDAO {

    // 할인 내역 추가
	public int insert(DiscountDetail discountDetail);

    // 예매별 할인 조회
	public List<DiscountDetail> selectByReservation(int reservation_id);

    // 할인 삭제
	public int delete(int discount_detail_id);
}
