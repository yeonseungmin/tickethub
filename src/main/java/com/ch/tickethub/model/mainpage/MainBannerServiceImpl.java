package com.ch.tickethub.model.mainpage;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.MainBanner;
import com.ch.tickethub.exception.MainBannerException;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.util.FileManager;
import com.ch.tickethub.util.FileUtil;

@Service
public class MainBannerServiceImpl implements MainBannerService{

	@Autowired
	private MainBannerDAO mainBannerDAO;
	
	@Autowired
	private FileManager fileManager;
	
	private String roodDir = FileUtil.getRealRootDir() + "/banner";
	
	@Override
	public List<MainBanner> getList() {
		return mainBannerDAO.selectAll();
	}
	
	@Transactional
	@Override
	public void register(MainBanner mainBanner, MultipartFile file) {
		try {
			
            String ext = fileManager.getExtend(file.getOriginalFilename());
            String savedName = UUID.randomUUID() + "." + ext;
            
            mainBanner.setMain_image_url(savedName);
            
            mainBannerDAO.insert(mainBanner);

            fileManager.makeDirectory(roodDir);
            fileManager.save(file, roodDir, savedName);
            
        } catch (UploadException e) {
            throw e;
        } catch (Exception e) {
            e.printStackTrace();
            throw new MainBannerException("배너 등록 중 오류 발생", e);
        }
	}

	@Transactional
	@Override
	public void remove(int mainbanner_id) {
		try {
            MainBanner banner = mainBannerDAO.select(mainbanner_id);
            if(banner == null) {
                throw new MainBannerException("존재하지 않는 배너입니다.");
            }
            
            mainBannerDAO.delete(mainbanner_id);
            
            fileManager.delete(roodDir + "/" + banner.getMain_image_url());
        } catch (Exception e) {
            e.printStackTrace();
            throw new MainBannerException("배너 삭제 중 오류 발생", e);
        }
	}
}