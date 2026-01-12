package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.OpeningWork;

public interface OpeningWorkService {

    public List<OpeningWork> getList();

    public void register(OpeningWork openingWork);

    public void remove(int openingwork_id);

    public void updateOrders(List<OpeningWork> openingWorkList);
}
