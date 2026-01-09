package com.ch.tickethub.controller.admin.seat;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ch.tickethub.dto.DiscountDetail;
import com.ch.tickethub.model.discountdetail.DiscountDetailService;

@RestController
@RequestMapping("/discount-detail")
public class DiscountDetailController {

    @Autowired
    private DiscountDetailService discountDetailService;

    /**
     * 특정 예매에 적용된 할인 내역 조회 (AJAX 용)
     */
    @GetMapping("/reservation/{reservation_id}")
    public List<DiscountDetail> getReservationDiscounts(@PathVariable int reservation_id) {
        return discountDetailService.getDiscountsByReservation(reservation_id);
    }

    /**
     * 할인 내역 삭제
     */
    @PostMapping("/delete")
    public String delete(@RequestParam int discount_detail_id) {
        int result = discountDetailService.removeDiscount(discount_detail_id);
        return result > 0 ? "success" : "fail";
    }
}