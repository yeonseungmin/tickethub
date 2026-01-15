package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class GenreRanking {

    private int genreranking_id;
    private int work_id;
    private int display_order;

    private Work work; // 조인용
}
