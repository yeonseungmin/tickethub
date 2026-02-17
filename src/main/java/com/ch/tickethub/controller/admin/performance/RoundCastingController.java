package com.ch.tickethub.controller.admin.performance;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ch.tickethub.dto.Round;
import com.ch.tickethub.model.round.RoundService;

@RestController // JSON 응답을 위해 RestController 사용
@RequestMapping("/performance/casting")
public class RoundCastingController {

    @Autowired
    private RoundService roundCastingService;

    @PostMapping("/update")
    public Map<String, String> updateCasting(@RequestBody Round round) {
        // 프론트에서 보낸 JSON이 Round 객체 내부의 castingList로 자동 매핑됩니다.
        // 구조: { "round_id": 10, "roundCastingList": [...] }
        
        Map<String, String> resultMap = new HashMap<>();
        
        try {
            roundCastingService.updateCasting(round);
            resultMap.put("message", "캐스팅 정보가 성공적으로 반영되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            resultMap.put("message", "캐스팅 업데이트 중 오류 발생: " + e.getMessage());
        }
        
        return resultMap;
    }
}