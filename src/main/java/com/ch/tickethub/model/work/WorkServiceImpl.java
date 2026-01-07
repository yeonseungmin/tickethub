package com.ch.tickethub.model.work;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Round;
import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.WorkException;
import com.ch.tickethub.util.FileManager;
import com.ch.tickethub.util.FileUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class WorkServiceImpl implements WorkService{
	
	@Autowired
	private WorkDAO workDAO;
	
	@Autowired
	private FileManager fileManager;
	
	private String rootDir = FileUtil.getRootDir() + "/work";

	@Transactional
	@Override
	public void regist(Work work, MultipartFile work_poster_img, MultipartFile work_content_img) throws WorkException {
		
		String posterFilename = UUID.randomUUID() + "." + fileManager.getExtend(work_poster_img.getOriginalFilename());
		String contentFilename = UUID.randomUUID() + "." + fileManager.getExtend(work_content_img.getOriginalFilename());
		
		work.setWork_poster_url(posterFilename);
		work.setWork_content_url(contentFilename);
		
		workDAO.insert(work);
		log.debug("insert 직후 mybatis selectKey 동작 후 work의 work_id 값은 " + work.getWork_id());
		
		String dirName = rootDir + "/p" + work.getWork_id();
		fileManager.makeDirectory(dirName);
		
		fileManager.save(work_poster_img, dirName, posterFilename);
		fileManager.save(work_content_img, dirName, contentFilename);
		
	}

	@Override
	public List getList() {
		return workDAO.selectAll();
	}

	@Override
	public void cancelUpload(Work work) {
		
		String dirName = rootDir + "/p" + work.getWork_id();
		
		fileManager.remove(dirName);
		
	}

	@Override
	public Work getWork(int work_id) {
		
		return workDAO.select(work_id);
	}

	@Override
	public List getUniqueCasting(Work work) {
		Map<Integer, RoundCasting> uniqueCastingMap = new HashMap();
		
		for(Round round : work.getRoundList()) {
			if(round.getRoundCastingList() != null) {
				for(RoundCasting roundCasting : round.getRoundCastingList()) {
					uniqueCastingMap.put(roundCasting.getPerson().getPerson_id(), roundCasting);
				}
			}
		}
		
		List<RoundCasting> uniqueCastingList = new ArrayList(uniqueCastingMap.values());
		
		// 역할로 묶기. 문제점 내 DTO 특성상 주역 구분이 안 된다. 어쩔 수 없다. 
		uniqueCastingList.sort((a, b) -> a.getRole().compareTo(b.getRole()));
		
		return uniqueCastingList;
	}

}
