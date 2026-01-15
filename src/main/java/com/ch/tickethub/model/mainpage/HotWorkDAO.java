package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.HotWork;

public interface HotWorkDAO {

    public List<HotWork> selectAll();

    public void insert(HotWork hotWork);

    public void delete(int hotwork_id);

    public void updateOrder(HotWork hotWork);

}
