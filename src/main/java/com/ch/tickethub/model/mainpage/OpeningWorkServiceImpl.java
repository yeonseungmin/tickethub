package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.OpeningWork;

@Service
public class OpeningWorkServiceImpl implements OpeningWorkService {

    @Autowired
    private OpeningWorkDAO openingWorkDAO;

    @Override
    public List<OpeningWork> getList() {
        return openingWorkDAO.selectAll();
    }

    @Transactional
    @Override
    public void register(OpeningWork openingWork) {
        openingWorkDAO.insert(openingWork);
    }

    @Transactional
    @Override
    public void remove(int openingwork_id) {
        openingWorkDAO.delete(openingwork_id);
    }
}
