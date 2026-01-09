package com.ch.tickethub.model.discountdetail;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.ch.tickethub.dto.DiscountDetail;

@Repository
public class MybatisDiscountDetailDAO implements DiscountDetailDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public int insert(DiscountDetail discountDetail) {
        return sqlSessionTemplate.insert("DiscountDetail.insert", discountDetail);
    }

    @Override
    public List<DiscountDetail> selectByReservation(int reservation_id) {
        return sqlSessionTemplate.selectList("DiscountDetail.selectByReservation", reservation_id);
    }

    @Override
    public int delete(int discount_detail_id) {
        return sqlSessionTemplate.delete("DiscountDetail.delete", discount_detail_id);
    }
}