package com.ch.tickethub.model.order;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.ch.tickethub.dto.Order;

@Repository
public class MybatisOrderDAO implements OrderDAO {
    @Autowired
    private SqlSession session;

    @Override
    public List<Order> selectOrderList() {
        return session.selectList("Order.selectOrderList");
    }
}
