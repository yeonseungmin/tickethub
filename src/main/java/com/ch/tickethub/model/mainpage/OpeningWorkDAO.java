package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.OpeningWork;

public interface OpeningWorkDAO {

    public List<OpeningWork> selectAll();

    public void insert(OpeningWork openingWork);

    public void delete(int openingwork_id);

}
