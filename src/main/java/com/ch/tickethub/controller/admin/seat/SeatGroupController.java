package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.Place;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.model.place.PlaceService;
import com.ch.tickethub.model.seatgroup.SeatGroupService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/seatgroup")
@Slf4j
public class SeatGroupController {

    @Autowired
    private SeatGroupService seatGroupService;
    
    @Autowired
    private PlaceService placeService;

    /**
     * 공연장별 구역 관리 페이지
     * @param place_id 공연장 ID
     */
    @GetMapping("/manager")
    public String manager(@RequestParam int place_id, Model model) {
    	// 1. 전체 장소 목록을 DB에서 가져와 모델에 추가
        List<SeatGroup> groupList = seatGroupService.getByPlace(place_id);
        List<Place> placeList = placeService.getList(); 
        model.addAttribute("placeList", placeList);
        
     // 2. 기존 로직 (선택된 장소의 구역 목록)
        if (place_id > 0) {
            model.addAttribute("groupList", seatGroupService.getByPlace(place_id));
            model.addAttribute("place_id", place_id);
        }
        // 공연장 전체 도면 위에서 구역들을 배치하는 관리자 페이지로 이동
        return "admin/seatmanager/group/manager";
    }

    /**
     * 구역 생성 (Ajax)
     */
    @PostMapping("/insert")
    @ResponseBody
    public String insert(SeatGroup seatGroup) {
        try {
            seatGroupService.insert(seatGroup);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 구역 위치 업데이트 (드래그 앤 드롭 결과 저장용)
     */
    @PostMapping("/updatePosition")
    @ResponseBody
    public String updatePosition(@RequestParam int seat_group_id, 
                                 @RequestParam int pos_x, 
                                 @RequestParam int pos_y) {
        try {
            seatGroupService.updatePosition(seat_group_id, pos_x, pos_y);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 구역 레이아웃(간격, 방향) 업데이트
     */
    @PostMapping("/updateLayout")
    @ResponseBody
    public String updateLayout(@RequestParam int seat_group_id,
                               @RequestParam int row_gap,
                               @RequestParam int col_gap,
                               @RequestParam String direction) {
        try {
            seatGroupService.updateLayout(seat_group_id, row_gap, col_gap, direction);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 구역 삭제
     */
    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int seat_group_id) {
        try {
            seatGroupService.delete(seat_group_id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
    
    /**
     * ✅ 추가: 특정 공연장의 구역 목록을 JSON으로 반환 (AJAX용)
     * 주소: /seatgroup/list?place_id=숫자
     */
    @GetMapping("/list")
    @ResponseBody // 데이터를 JSON 형태로 반환하기 위해 필수
    public List<SeatGroup> getGroupList(@RequestParam("place_id") int placeId) {
        log.debug("구역 목록 요청 수신 - 장소 ID: {}", placeId);
        // 이미 서비스에 구현된 getByPlace 메서드를 호출합니다.
        return seatGroupService.getByPlace(placeId);
    }
}