package com.mvc.service;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dao.MemberDAO;
import com.mvc.dto.MainDTO;

public class MemberService {
	HttpServletRequest req = null;
	HttpServletResponse resp = null;
	public MemberService(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
		try {
			req.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	

	public MainDTO info() { //은홍
		System.out.println("MemberService info() 들어옴");
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("info() 세션에 저장된 userId : "+userId);
		MemberDAO dao = new MemberDAO();
		MainDTO dto = new MainDTO();
		dto = dao.info(userId);
		dao.resClose();
		return dto;
	}

	public int showCash() { //은홍
		System.out.println("MemberService showCash() 들어옴");
		int currCash = 0;
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("showCash() 세션에 저장된 userId : "+userId);
		MemberDAO dao = new MemberDAO();
		currCash = dao.showCash(userId);
		dao.resClose();
		return currCash;
	}

	public ArrayList<MainDTO> cashHistory() { //은홍
		System.out.println("MemberService cashHistory() 들어옴");
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("cashHistory() 세션에 저장된 userId : "+userId);
		MemberDAO dao = new MemberDAO();
		list = dao.cashHistory(userId);
		dao.resClose();
		return list;
	}

	public int chargeCash() { //은홍
		System.out.println("MemberService chargeCash() 들어옴");
		MemberDAO dao = new MemberDAO();
		int charge = Integer.parseInt(req.getParameter("amount"));
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("충전금액 : "+charge+" 원, userId : "+userId);
		int result = dao.changeCash(charge, userId); 
		dao.resClose();
		return result;
	}

	public HashMap<String, ArrayList<MainDTO>> myPage() { //은홍
		System.out.println("MemberService myPage() 들어옴");
		MemberDAO dao = new MemberDAO();
		String userId = (String) req.getSession().getAttribute("userId");
		HashMap<String, ArrayList<MainDTO>> map = dao.myPage(userId); 
		dao.resClose();
		return map;
	}

	public HashMap<String, Object> fileUpload() { //은홍 //파일업로드 ajax방식
		System.out.println("MemberService fileUpload() 들어옴");
		UploadService upload = new UploadService(req, resp);
		//upload.fileUpload() : 서버에 파일업로드 메소드
		//multipartRequest로 파일 업로드, 파일의 메타데이터를 받아서 dto에 전부 넣어준다
		MainDTO dto = upload.fileUpload();
		HashMap<String, Object> map = null;
		
		MemberDAO dao = new MemberDAO();
		//dao.fileUpload(dto) : 파일데이터 DB에 저장 메소드
		//upload.fileUpload()로 받아온 dto에서 데이터를 꺼내어 DB에 저장한다
		map = dao.fileUpload(dto);
		
		dao.resClose();
		
		return map;
	}

}
