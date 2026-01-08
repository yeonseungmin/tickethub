package com.ch.tickethub.controller.tickethub;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller("ticketReservationController")
public class ReservationController {

	@GetMapping("/reservation/seat")
	public String getReservation() {
		return "ticket/reservation/seat";
	}
}
