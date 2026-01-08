package com.ch.tickethub.controller.tickethub;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PaymentController {

	@GetMapping("/payment")
	public String getPayment() {
		return "ticket/reservation/payment";
	}
}
