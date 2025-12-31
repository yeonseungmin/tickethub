package com.ch.tickethub.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.exception.UploadException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class FileUtil {
	public static String saveFile(String absDir, MultipartFile img) throws UploadException {
		/* Universally Unique Idenfitier */

		String oriName = img.getOriginalFilename();
		String ext = getExtension(oriName);
		
		String fileName = UUID.randomUUID() + ext;
		
		// path: C:/galleryspring/person
		Path path = Paths.get(absDir, fileName);
		
		
		try {
			// person까지의 directory 만들기
			Files.createDirectories(path.getParent());
			img.transferTo(path.toFile());
		} catch(Exception e) {
			throw new UploadException("file 저장 실패", e);
		}
		
		String url = getRelative(absDir)+ fileName;
		
		return url;
	}
	
	public static String getExtension(String oriName) {
		return oriName.substring(oriName.lastIndexOf('.'));
	}
	
	public static String getRelative(String dir) {
		return dir.substring(dir.indexOf('/')) + "/";
	}
	
	public static void deleteFile(String url) {
		
		if(url ==null || url.isEmpty()) return;
		
		String baseDir = "C:/galleryspring";
		Path path = Paths.get(baseDir, url.replace("/galleryspring", ""));
		
		try {
			Files.deleteIfExists(path);
		} catch (IOException e) {
			e.printStackTrace();
			log.debug("이미지 삭제 실패 " + path);
		}
	}
	
	
}
