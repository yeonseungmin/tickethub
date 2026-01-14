package com.ch.tickethub.controller.admin;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.Order;
import com.ch.tickethub.model.order.OrderService;

@Controller
@RequestMapping("/order")
public class AdminOrderController {

    @Autowired
    private OrderService orderService;

    private boolean isAdmin(HttpSession session) {
        Object obj = session.getAttribute("loginMember");
        if (obj == null)
            return false;
        return "ADMIN".equals(((Member) obj).getRole());
    }

    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/auth/login";

        List<Order> orders = orderService.getOrderList();
        model.addAttribute("orders", orders);

        return "admin/order/list";
    }
}
