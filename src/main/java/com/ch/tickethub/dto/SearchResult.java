package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class SearchResult {

    private int work_id;

    private Work work; // 조인용 (Work.select 재사용)
}