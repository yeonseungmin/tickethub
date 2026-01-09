package com.ch.tickethub.model.discountdetail;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.DiscountDetail;

@Service
public class DiscountDetailServiceImpl implements DiscountDetailService {

    @Autowired
    private DiscountDetailDAO discountDetailDAO;

    @Override
    public int addDiscount(DiscountDetail discountDetail) {
        return discountDetailDAO.insert(discountDetail);
    }

    @Override
    public List<DiscountDetail> getDiscountsByReservation(int reservation_id) {
        return discountDetailDAO.selectByReservation(reservation_id);
    }

    @Override
    public int removeDiscount(int discount_detail_id) {
        return discountDetailDAO.delete(discount_detail_id);
    }

}

