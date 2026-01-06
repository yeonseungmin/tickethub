package com.ch.tickethub.request;

import java.util.List;

import lombok.Data;

@Data
public class RoundDetail {
	private String round_start_time;
    private List<Casting> castingList;
}
