package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.HotWork;

public interface HotWorkService {

    public List<HotWork> getList();

    public void register(HotWork hotWork);

    public void remove(int hotwork_id);

    public void updateOrders(List<HotWork> hotWorkList);
}
