package com.ch.tickethub.util;

import java.io.File;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.exception.DirectoryException;
import com.ch.tickethub.exception.UploadException;

import lombok.extern.slf4j.Slf4j;

//이 클래스의 목적: 기존 코드에서는 컨트롤러가 업로드를 처리했었지만, MVC 원칙에 따라 업로드같은 로직은 컨트롤러가 수행해선 안 된다. 모델 영역의 업무이므로
//모델 영역의 객체이면서 DB 업무를 다루지 않는 객체를 정의하자.(DAO 아님) 모델에는 DAO만 있는 것이 아니다.

@Slf4j
// 스프링은 @Controller, @Service, @Repository(DAO) 외에 개발자가 정의한 객체도 자동으로
// ComponentScan 의 대상이 될 수 있는데,
// @Component 이다. 그래서 이게 뭔데? > Bean 들을 메모리에 자동으로 올려주는 애노테이션.
@Component
public class FileManager {

	/*---------------------------------------------------------------
	 	원하는 이름으로 디렉토리 만들기
	 *---------------------------------------------------------------*/
	public void makeDirectory(String path) throws DirectoryException {
		// 모든 프로그래밍 언어에서는 디렉토리(경로)도 파일로 취급된다.
		File file = new File(path);

		// file.mkdir(); 이 메서드와 아래 메서드의 차이는 "c:a/b" 이 경우, b 뿐만 아니라 a 까지 만들어준다. 지금은 아니지만
		// 혹시라도 오류가 날 경우 문제가 되므로
		// 실무에선 반드시 s를 붙여서 쓴다. 그리고 궁극적으로 s를 붙였을 떄 손해볼 여지가 없다. 마치 롬복을 쓸 때 손해볼 여지가 없는 것처럼.
		
		if(file.exists()) return; // 이미 동일한 경로가 존재하면, 생성하지 않고 종료.
		
		if (file.mkdirs() == false) { // 생성이 안 될 경우,
			throw new DirectoryException("디렉토리 생성 실패");
		}
	}

	/*----------------------------------------------------
	 확장자 추출하기.
	 메서드의 파라미터로 원하는 경로를 넣으면 알아서 확장자를 반환해주는 메서드.
	 ----------------------------------------------------*/
	public String getExtend(String path) {
		return path.substring(path.lastIndexOf('.') + 1);
	}

	/*----------------------------------------------------
	 원래 파일에 대한 처리는 트랜잭션의 대상이 되지 않지만, 지금의 경우 상품 등록이라는 하나의 로직에 파일의 저장도 포함되어 있으므로
	 파일 저장에 실패할 경우 Exception 을 서비스객체에 던지면 서비스는 예외가 발생할 경우 무조건 트랜잭션을 rollback 하므로 이 특징을 이용한다.
	 ----------------------------------------------------*/
	public void save(MultipartFile multipartFile, String directorypath, String filename) throws UploadException {

		File file = new File(directorypath, filename);

		// 임시 디렉토리 또는 메모리상의 파일 정보를 이용하여 실제 디스크에 저장하는 코드.
		try {
			multipartFile.transferTo(file);
			Thread.sleep(10); // 일부러 시간을 지연시킨다. 파일 명을 업로드 시간(밀리세컨드)으로 명명하는데, 1밀리세컨드에 2개 이상 업로드되면 파일명 중복되고 오류남.
		} catch (Exception e) {
			e.printStackTrace();
			throw new UploadException("파일 저장 실패", e);
		}
	}

	/*----------------------------------------------------
	 파일 삭제. 이 메서드 호출 시, 제거 대상이 되는 디렉토리의 경로를 넘겨야 한다.
	 ----------------------------------------------------*/
	public void remove(String path) {
		// 1단계 지정된 경로에 파일들이 존재하는지 조사
		File directory = new File(path);

		// 디렉토리가 맞는 지 부터 판단하고, 디렉토리가 맞으면 조사.
		if (directory.exists() && directory.isDirectory()) { // File의 메서드 중 exists() = 존재하냐?(boolean) / isDerectory() =
																// 디렉토리 맞아?(boolean)
			// 소속된 자식 구하기
			File[] files = directory.listFiles();
			// 이 디렉토리 하위에 존재하는 디렉토리나, 파일을 File의 배열로 변환해준다.
			// 지금의 경우, 상품 사진만 넣으므로, 디렉토리가 존재할 가능성이 없다.

			if (files != null) { // 파일이 존재한다면(그럴 경우는 거의 없겠지만) 로그에 남겨서 개발자가 나중에 직접 삭제하도록 처리.
				for (File file : files) {
					boolean result = file.delete();
					if (!result)
						log.debug(file.getName() + "의 파일 삭제가 안 됐음");
				}
			}

			// 위에서 디렉토리 안의 파일들을 모두 삭제했으므로, 디렉토리 삭제.
			if (directory.delete() == false) {
				log.debug(directory.getAbsolutePath() + "의 디렉토리 삭제가 안 됐음");
			}
		}
	}

	/*---------------------------------------------------------------
	 + 추가) 단일 파일 삭제
	*---------------------------------------------------------------*/
	public void delete(String path) {
		File file = new File(path);
		if (file.exists()) {
			boolean result = file.delete();
			if (!result)
				log.debug(path + " 파일 삭제 실패");
		}
	}
}