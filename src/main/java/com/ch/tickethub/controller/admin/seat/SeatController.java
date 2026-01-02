package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.model.seat.SeatService;
import com.ch.tickethub.model.seatgroup.SeatGroupService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class SeatController {

    @Autowired
    private SeatService seatService;

    @Autowired
    private SeatGroupService seatGroupService;

    /**
     * 좌석 관리자 메인 페이지
     * seat.jsp 반환
     */
    @GetMapping("/seatmanager/seat")
    public String seatManager(Model model) {

        log.debug("좌석 관리자 페이지 진입");

        // 임시 place_id (나중에 공연장 선택으로 변경 가능)
        int place_id = 1;

        // 좌석 + 좌석그룹 조회
        List<Seat> seatList = seatService.selectByPlace(place_id);
        List<SeatGroup> seatGroupList = seatGroupService.getByPlace(place_id);

        // JSP로 전달
        model.addAttribute("seatList", seatList);
        model.addAttribute("seatGroupList", seatGroupList);

        return "admin/seatmanager/seat/seat";
    }
}
