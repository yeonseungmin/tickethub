package com.ch.tickethub.model.order;

import java.util.List;
import com.ch.tickethub.dto.Order;

public interface OrderDAO {
    List<Order> selectOrderList();
}
