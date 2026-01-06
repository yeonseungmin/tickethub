package com.ch.tickethub.model.discountdetail;

import java.util.List;


import com.ch.tickethub.dto.DiscountDetail;

public interface DiscountDetailService {
	
    int addDiscount(DiscountDetail discountDetail);
    
    List<DiscountDetail> getDiscountsByReservation(int reservation_id);
    
    int removeDiscount(int discount_detail_id);
}
