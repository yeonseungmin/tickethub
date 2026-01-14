package com.ch.tickethub.model.order;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ch.tickethub.dto.Order;

@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private OrderDAO orderDAO;

    @Override
    public List<Order> getOrderList() {
        return orderDAO.selectOrderList();
    }
}
