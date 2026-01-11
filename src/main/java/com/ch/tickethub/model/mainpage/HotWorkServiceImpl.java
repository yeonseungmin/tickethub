package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.HotWork;

@Service
public class HotWorkServiceImpl implements HotWorkService {

    @Autowired
    private HotWorkDAO hotWorkDAO;

    @Override
    public List<HotWork> getList() {
        return hotWorkDAO.selectAll();
    }

    @Transactional
    @Override
    public void register(HotWork hotWork) {
        hotWorkDAO.insert(hotWork);
    }

    @Transactional
    @Override
    public void remove(int hotwork_id) {
        hotWorkDAO.delete(hotwork_id);
    }
}
