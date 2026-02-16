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
	
	private String rootDir = FileUtil.getRealRootDir() + "/performance/person";
	
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

	@Override
	public List getList() {
		
		return personDAO.selectAll();
	}

	@Override
	public void remove(int person_id) throws PersonException{
		
		try {
			personDAO.delete(person_id);
			String dirName = rootDir + "/p" + person_id;
			fileManager.remove(dirName);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new PersonException("인물 삭제 실패", e);
		}
	}

	@Override
	public void setPerson(Person person, MultipartFile img) throws PersonException {

	    String ext = fileManager.getExtend(img.getOriginalFilename());
	    String newFilename = UUID.randomUUID().toString() + "." + ext;
	    
	    // DTO에 새 파일명 세팅
	    person.setProfile_url(newFilename);

	    // 저장 경로 설정 (/p[id] 형태)
	    String dirName = rootDir + "/p" + person.getPerson_id();

	    try {
	        personDAO.update(person); 

	        fileManager.remove(dirName); 
	        fileManager.makeDirectory(dirName);
	        
	        // 새 이미지 저장
	        fileManager.save(img, dirName, newFilename);
	        
	        log.debug("인물 수정 성공: ID={}, NewFile={}", person.getPerson_id(), newFilename);

	    } catch (Exception e) {
	        log.error("인물 수정 중 에러 발생: {}", e.getMessage());

	        throw new PersonException("인물 정보 수정 중 오류가 발생했습니다.", e);
	    }
	}

}
