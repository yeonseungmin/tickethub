package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.Place;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.model.place.PlaceService;
import com.ch.tickethub.model.seat.SeatService;
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
    
    @Autowired
    private SeatService seatService;

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
    public String updatePosition(@RequestParam int seat_group_id, @RequestParam int pos_x, 
    				@RequestParam int pos_y, @RequestParam double angle) {
        try {
            seatGroupService.updatePosition(seat_group_id, pos_x, pos_y,angle);
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
    
    @PostMapping("/createBulk")
    @ResponseBody
    public String createBulk(@RequestParam int seat_group_id, @RequestParam int row_count, @RequestParam int col_count) {
        try {
            // 핵심: 서비스 호출
        	log.debug("좌석 생성 시작...");
            seatGroupService.createBulkSeats(seat_group_id, row_count, col_count);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "error: " + e.getMessage();
        }
    }
    
    @PostMapping("/updateGroupsBulk")
    @ResponseBody
    public ResponseEntity<String> updateGroupsBulk(@RequestBody List<SeatGroup> groupList) {
        try {
            log.debug("일괄 업데이트 요청 수신. 구역 개수: " + groupList.size());
            seatGroupService.updateGroupsPositions(groupList);
            return ResponseEntity.ok("success"); // 명시적으로 200 OK와 success 전달
        } catch (Exception e) {
            log.error("업데이트 중 에러 발생: ", e); // 에러 원인을 콘솔에 찍음
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
    
    @PostMapping("/area/add")
    @ResponseBody
    public String addGroup(@RequestParam int place_id, @RequestParam String group_name) {
        try {
            SeatGroup seatGroup = new SeatGroup();
            
            // 1. Place 객체를 생성해서 ID만 세팅 (PlaceService를 호출할 필요 없음)
            Place place = new Place();
            place.setPlace_id(place_id); 
            
            // 2. SeatGroup DTO에 주입
            seatGroup.setPlace(place); 
            seatGroup.setGroup_name(group_name);
            
            // 초기 배치 설정 (정수형 변수이므로 int로 세팅)
            seatGroup.setPos_x(100);
            seatGroup.setPos_y(100);
            seatGroup.setAngle(0);
            seatGroup.setRow_gap(35);
            seatGroup.setCol_gap(35);
            
            // 3. DB 저장
            seatGroupService.insertGroupByPlace(seatGroup); 
            
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
 
}