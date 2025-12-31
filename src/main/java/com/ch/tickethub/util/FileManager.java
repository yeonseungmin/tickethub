package com.ch.tickethub.util;

import java.io.File;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.exception.DirectoryException;
import com.ch.tickethub.exception.UploadException;

import lombok.extern.slf4j.Slf4j;

/*
 * 이 클래스의 정의 목적?
 * 기존 코드에서는 컨트롤러가 업로드를 처리하고 있었으므로, 문제였음
 * 파일 업로드는 모델 영역의 업무이므로, 컨트롤러가 절대 부담하면 안 됨, 따라서 모델영역의 객체이면서
 * DataBase 업무를 다루지 않는 객체이다..(DAO 아님)
 */

@Slf4j
// 스프링은 @Controller, @Service, @Repository 외에, 개발자가 정의한 객체도 자동으로 ComponentScan의 대상이 될 수 있는데
// 이때 개발자가 정의한 객체를 자동으로 빈으로 등록하면 @Component로 선언하면 된다..
@Component
public class FileManager {
	
	/*---------------------------------------------------------------
	 	원하는 이름으로 디렉토리 만들기
	 *---------------------------------------------------------------*/
	public void makeDirectory(String path) throws DirectoryException {
		// 모든 프로그래밍 언어에서는 디렉토리도 파일로 취급된다...
		File file = new File(path);
		
		if(!file.mkdirs()) {
			throw new DirectoryException("디렉토리 생성 실패");
		}
	}
	
	/*---------------------------------------------------------------
 	 확장자 추출하기, 메서드의 인수로 원하는 경로를 넣으면 알아서 확장자를 반환해주는 메서드
	 *---------------------------------------------------------------*/
	public String getExtend(String path) {
		return path.substring(path.lastIndexOf('.') + 1);
	}
	
	
	/* --------------------------------------------------------------------------
		원래 파일에 대한 처리는 트랜잭션의 대상이 되지 않는다. 하지만 우리의 경우 상품 등록 업무에 파일의 저장도 포함되어 있으므로 
		만약 파일 저장에 실패할 경우, Exception을 서비스객체에 던지면, 서비스는 예외가 발생할 경우 무조건 트랜잭션을 rollback해버리므로
		이 특징을 이용하자
	 --------------------------------------------------------------------------*/
	public void save(MultipartFile mf, String dir, String filename) throws UploadException {
		
		// new File(디렉토리, 파일명);
		File file = new File(dir, filename);
		
		// 임시 디렉토리 또는 메모리상의 파일정보를 이용하여, 실제 디스크에 저장
		try {
			mf.transferTo(file);
			//Thread.sleep(10);	// 일부러 시간을 지연시킨다.. 이유? 파일명을 생성하는 밀리세컨드보다 업로드 처리가 더 빠르면, 파일명의 중복 난 UUID 쓸 거라 상관 없다.
		} catch(Exception e) {
			throw new UploadException("file 저장 실패", e);
		}
		
	}

	
	/*---------------------------------------------------------------
 	 파일 삭제 : 이 메서드 호출 시, 제거 대상이 되는 디렉토리의 경로를 넘겨야 한다..
	 *---------------------------------------------------------------*/
	public void remove(String path) {
		// 1) 지정된 경로에 파일들이 존재하는지 조사
		File directory = new File(path);
		
		// 디렉토리 인지부터 판단하고, 만약 디렉토리임이 검증된 경우에 조사..
		if(directory.exists() && directory.isDirectory()) {	// 100% 확실히 디렉토리로 평가가 된다면...
			// 소속된 자식 구하기
			File[] files = directory.listFiles();		// 이 디렉토리 하위에 존재하는 디렉토리나, 파일을 File 배열로 반환해줌..
											// 우리의 경우 상품 사진만 넣었으므로, 디렉토리가 존재할 가능성이 없음
			
			if(files != null) {		// 자식이 존재한다면, 즉 상품 이미지가 존재한다면..
				for(File file : files) {
					boolean result = file.delete();
					if(!result) log.debug(file.getName() + "파일 삭제 실패");
				}
			}
			
			// 위에서 디렉토리 안의 자식 파일들을 모두 삭제했으므로, 디렉토리를 삭제하자
			if(directory.delete() == false) {
				log.debug("디렉토리 삭제 실패 " + directory.getAbsolutePath());	// 디렉토리의 풀 경로 기록하기
			}
		}
	}
}
