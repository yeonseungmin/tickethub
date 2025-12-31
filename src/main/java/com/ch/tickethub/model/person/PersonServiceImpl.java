package com.ch.tickethub.model.person;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.exception.PersonException;
import com.ch.tickethub.util.FileUtil;

/* DB transaction RuntimeException 발생 rollback */
@Transactional
@Service
public class PersonServiceImpl implements PersonService{

	@Autowired
	PersonDAO personDAO;
	
	@Override
	public void regist(List<String> nameList, List<MultipartFile> imgList) throws PersonException{
		for(int i = 0; i < nameList.size(); i++) {
			String name = nameList.get(i);
			
			MultipartFile img = imgList.get(i);
			
			// 실패할 경우 저장소에 있는 이미지 다시 삭제 해야 됨
			List<String>savedFiles = new ArrayList();
			
			try {
				String url = FileUtil.saveFile("C:/tickethub/performance/person", img);
				savedFiles.add(url);
				
				Person person = new Person();
				
				person.setPerson_name(name);
				person.setProfile_url(url);
				
				personDAO.insert(person);
				
			} catch (Exception e) {
				for(String url: savedFiles) {
					FileUtil.deleteFile(url);
				}
				
				throw new PersonException("인물 등록 실패", e);
			}

		}
		
	}
	


}
