package com.mvc.service;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dao.MemberDAO;
import com.mvc.dto.MainDTO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class UploadService {
	HttpServletRequest req = null;
	HttpServletResponse resp = null;

	public UploadService(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
		try {
			req.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	public MainDTO fileUpload() { //은홍  //파일업로드 및 수정
		//multipartRequest로 파일 업로드, 파일의 메타데이터를 받아서 dto에 전부 넣어준다
		System.out.println("UploadService fileUpload() - 파일 업로드 들어옴");
		// 1.저장경로 지정
		String savePath = "C:/img/";
		// 2.용량제한(10MB)
		int maxSize = 10 * 1024 * 1024;
		
		MainDTO dto = null;
		try {
			File dir = new File(savePath);
			// 폴더가 없을 경우 생성
			if (!dir.exists()) {
				dir.mkdir();
			}
			// 3.업로드
			MultipartRequest multi = new MultipartRequest(req, savePath, maxSize, "UTF-8",
					new DefaultFileRenamePolicy());
			dto = new MainDTO();

			//4. 업로드하는 영역이 post(레시피)인지 product(상품)인지
			String field = multi.getParameter("field");
			System.out.println("**imgField : "+field);

			//5. 게시글이 업로드된 후 수정하는 경우 postId 저장
			String fieldId = multi.getParameter("fieldId");
			if (fieldId != null && fieldId !="" ) {
				System.out.println("**파일 수정 fieldId : " + fieldId);
				dto.setFieldId(fieldId);
				dto.setTh_fieldId(fieldId);
			}

			//6. 수정하는 경우 기존 이미지 제거
			String del_thumbnail = multi.getParameter("del_thumbnail");
			String del_content_image = multi.getParameter("del_content_image");
			System.out.println("**제거할 기존 썸네일 : "+del_thumbnail);
			System.out.println("**제거할 기존 이미지 : "+del_content_image);
			boolean success = false;
			if(del_thumbnail != "" && del_thumbnail != null) { //기존썸네일이 존재한다면
				success = delImage(del_thumbnail);
				System.out.println("**기존 썸네일 삭제 완료 여부 : "+success);
			}
			if(del_content_image != "" && del_content_image != null) { //기존이미지가 존재한다면
				success = delImage(del_content_image);
				System.out.println("**기존 첨부이미지 삭제 완료 여부 : "+success);
			}

			// 7.이름변경 및 메타데이터 생성
			// 썸네일
			String oriFileName = multi.getFilesystemName("thumbnail");
			if (oriFileName != null) {// 업로드된 파일이 있다면
				String ext = oriFileName.substring(oriFileName.lastIndexOf("."));
				String newFileName = System.currentTimeMillis() + ext;
				System.out.println("thum_oriFileName/newFileName : " + oriFileName + "/" + newFileName);
				File oldName = new File(savePath + oriFileName); // 경로가 전체 들어가야함
				File newName = new File(savePath + newFileName); // C:/img/파일명
				oldName.renameTo(newName);
				if(field.equals("post")) {
					dto.setTh_imgField("post_th"); // 레시피 썸네일
				}else {
					dto.setTh_imgField("product_th"); //상품 썸네일
				}
				dto.setTh_imgOriName(oriFileName);
				dto.setTh_imgNewName(newFileName);
				dto.setTh_imgPath(savePath);
			}

			// 첨부이미지
			oriFileName = multi.getFilesystemName("content_image");
			if (oriFileName != null) {// 업로드된 파일이 있다면
				String ext = oriFileName.substring(oriFileName.lastIndexOf("."));
				String newFileName = System.currentTimeMillis() + ext;
				System.out.println("con_oriFileName/newFileName : " + oriFileName + "/" + newFileName);
				File oldName = new File(savePath + oriFileName); // 경로가 전체 들어가야함
				File newName = new File(savePath + newFileName); // C:/img/파일명
				oldName.renameTo(newName);
				if(field.equals("post")) {
					dto.setImgField("post"); // 레시피 썸네일
				}else {
					dto.setImgField("product"); //상품 썸네일
				}
				dto.setImgOriName(oriFileName);
				dto.setImgNewName(newFileName);
				dto.setImgPath(savePath);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 9.업로드한 파일의 모든 데이터 반환
		return dto;
	}

	public boolean delImage(String imgId) { // 은홍
		// 이미지id를 받아 이미지를 서버와 DB에서 모두 삭제
		boolean success = false;
		MemberDAO dao = new MemberDAO();
		MainDTO dto = dao.getFileName(imgId);
		if (dto != null) {
			//서버 저장소에서 파일 삭제
			String imgNewName = dto.getImgNewName();
			File file = new File("C:/img/" + imgNewName);
			if (file.exists()) {
				success = file.delete();
			}
			System.out.println("UploadService delImage :: 서버에서 파일 " + imgNewName + " 삭제 성공여부 : " + success);
			
			//DB에서 이미지 레코드 삭제
			success = dao.delImage(imgId);
			System.out.println("UploadService delImage :: DB에서 이미지 " + imgId + " 삭제 성공여부 : " + success);
		} else {
			System.out.println("UploadService delImage()의 dao.getFileName()로 받은 dto가 null입니다");
			success = false;
		}
		return success;
	}

}
