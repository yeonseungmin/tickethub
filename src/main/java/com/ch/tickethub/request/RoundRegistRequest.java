package com.ch.tickethub.request;

import java.util.List;

import lombok.Data;

@Data
public class RoundRegistRequest {
    private int work_id;
    private int place_id;
    private String round_date;
    private List<RoundDetail> roundList; // 프론트의 roundList와 이름이 같아야 함
}