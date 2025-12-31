package com.ch.tickethub.model.person;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.exception.PersonException;
import com.ch.tickethub.util.FileManager;
import com.ch.tickethub.util.FileUtil;

import lombok.extern.slf4j.Slf4j;

/* DB transaction RuntimeException 발생 rollback */
@Slf4j
@Transactional
@Service
public class PersonServiceImpl implements PersonService{

	@Autowired
	PersonDAO personDAO;
	
	@Autowired
	FileManager fileManager;
	
	private String rootDir = FileUtil.getRootDir() + "/person";
	
	@Override
	public void regist(List<String> nameList, List<MultipartFile> imgList) throws PersonException{
		for(int i = 0; i < nameList.size(); i++) {
			String name = nameList.get(i);
			
			MultipartFile img = imgList.get(i);
			
			// 실패할 경우 저장소에 있는 이미지 다시 삭제 해야 됨
			List<Integer>savedFiles = new ArrayList();
			
			String personFilename = UUID.randomUUID() + "." + fileManager.getExtend(img.getOriginalFilename());
			
			try {
				
				Person person = new Person();
				
				person.setPerson_name(name);
				person.setProfile_url(personFilename);
				
				personDAO.insert(person);
				log.debug("insert 직후 mybatis selectKey 동작 후 person의 person_id값은 " + person.getPerson_id());
				
				savedFiles.add(person.getPerson_id());
				
				String dirName = rootDir + "/p" + person.getPerson_id();
				fileManager.makeDirectory(dirName);
				
				fileManager.save(img, dirName, personFilename);
				
			} catch (Exception e) {
				for(int person_id: savedFiles) {
					String dirName = rootDir + "/p" + person_id;
					
					fileManager.remove(dirName);
				}
				
				throw new PersonException("인물 등록 실패", e);
			}

		}
		
	}

}
