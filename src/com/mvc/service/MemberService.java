package com.mvc.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
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

	public HashMap<String, Object> cashHistory() { //은홍
		System.out.println("MemberService cashHistory() 들어옴");
		
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("cashHistory() 세션에 저장된 userId : "+userId);
		String req_page = req.getParameter("page");
		String button_str = req.getParameter("button");
		if(button_str != null) {
			int button = Integer.parseInt(button_str);
			System.out.println("button 클릭됨(1이면 이전, 2이면 다음) : "+button);
			if(button == 1) {
				req_page = String.valueOf(Integer.parseInt(req_page)-1);
			}else if(button == 2) {
				req_page = String.valueOf(Integer.parseInt(req_page)+1);
			}				
		}
		
		if(req_page == null || Integer.parseInt(req_page) <= 0 || req_page.equals("")) {
			System.out.println("controller 처음 요청 받은 페이지 : "+req_page);
			req_page = "1";
		}
		System.out.println("controller 요청 받은 페이지 : "+req_page);
		
		MemberDAO dao = new MemberDAO();
		HashMap<String, Object> map = dao.cashHistory(userId, Integer.parseInt(req_page));
		dao.resClose();
		return map;
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
	
	public HashMap<String, Object> pointHistory() {
		System.out.println("MemberService pointHistory() 들어옴");
		
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("pointHistory() 세션에 저장된 userId : "+userId);
		String req_page = req.getParameter("page");
		String button_str = req.getParameter("button");
		if(button_str != null) {
			int button = Integer.parseInt(button_str);
			System.out.println("button 클릭됨(1이면 이전, 2이면 다음) : "+button);
			if(button == 1) {
				req_page = String.valueOf(Integer.parseInt(req_page)-1);
			}else if(button == 2) {
				req_page = String.valueOf(Integer.parseInt(req_page)+1);
			}				
		}
		
		if(req_page == null || Integer.parseInt(req_page) <= 0 || req_page.equals("")) {
			System.out.println("service 처음 요청 받은 페이지 : "+req_page);
			req_page = "1";
		}
		System.out.println("service 요청 받은 페이지 : "+req_page);
		
		MemberDAO dao = new MemberDAO();
		HashMap<String, Object> map = dao.pointHistory(userId, Integer.parseInt(req_page));
		dao.resClose();
		return map;
	}
	
	public MainDTO clientInfo() throws IOException { // 찬호
		String userId = (String) req.getSession().getAttribute("userId");

		System.out.println("userId : " + userId);

		MainDTO dto = null;
		MemberDAO dao = new MemberDAO();

		dto = dao.clientInfo(userId);

		System.out.println("clientInfo DTO : " + dto);
		dao.resClose();

		return dto;

	}

	public MainDTO updateForm() { // 찬호

		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("userId : " + userId);

		MemberDAO dao = new MemberDAO();
		MainDTO dto = dao.clientInfo(userId);
		System.out.println("dto : " + dto);
		dao.resClose();

		return dto;
	}

	public int update(String userId) { // 찬호

		int change = 0;
		
		userId = (String) req.getSession().getAttribute("userId");
		String pw = req.getParameter("pw");
		String nickname = req.getParameter("nickName");
		int tel = Integer.parseInt(req.getParameter("tel"));
		String address = req.getParameter("address");

		System.out.println(pw + "/" + nickname + "/" + tel + "/" + address+"/"+userId);
		MemberDAO dao = new MemberDAO();
		change = dao.update(pw, nickname, tel, address, userId);
		System.out.println("update change : " + change);
		dao.resClose();

		return change;
	}

	public String userDel() { // 찬호

		// String userId = (String) req.getSession().getAttribute("userId");
		// 원래대로 되돌릴려면 위에 주석풀고 아래 userId 지우고
		String userId = (String) req.getSession().getAttribute("userId");

		System.out.println("userId : " + userId);
		MemberDAO dao = new MemberDAO();
		String result = dao.userDel(userId);
		System.out.println("result : " + result);

		dao.resClose();
		return result;

	}

	public HashMap<String, Object> myWrite(int page, String userId) { // 찬호

		userId = (String) req.getSession().getAttribute("userId");
		MemberDAO dao = new MemberDAO();
		HashMap<String, Object> map = dao.myWrite(page, userId);
		System.out.println("map : " + map.size());
		System.out.println("map : " + map);

		dao.resClose();

		return map;
	}

	public  HashMap<String, Object> myLike(int page, String userId) { // 찬호

		userId = (String) req.getSession().getAttribute("userId");
		MemberDAO dao = new MemberDAO();
		HashMap<String, Object> map = dao.myLike(page, userId);
		System.out.println("map : " + map.size());
		System.out.println("map : " + map);


		dao.resClose();

		return map;
	}

	public HashMap<String, Object> myComment(int page, String userId) { // 찬호

		userId = (String) req.getSession().getAttribute("userId");
		MemberDAO dao = new MemberDAO();
		HashMap<String, Object> map = dao.myComment(page, userId);
		System.out.println("map : " + map.size());

		dao.resClose();

		return map;
	}
	
	public HashMap<String, Object> myOrderHistory(int page, String userId) { // 찬호

		userId = (String) req.getSession().getAttribute("userId");
		MemberDAO dao = new MemberDAO();
		HashMap<String, Object> map = dao.myOrderHistory(page, userId);
		System.out.println("map : " + map.size());

		dao.resClose();

		return map;
	}
	
	
	
	
	/*================================================진후============================================================================= */
	
	public void join() throws IOException {//회원가입(진후)
		String userId = req.getParameter("userId");
		String pw = req.getParameter("pw");
		String name = req.getParameter("name");
		String nickName = req.getParameter("nickName");
		String address = req.getParameter("address");
		String tel = req.getParameter("tel");	
		System.out.println(userId+"/"+pw+"/"+name+"/"+nickName+"/"+address+"/"+tel);
		System.out.println("멤버서비스 조인 들어옴");
		MainDTO dto = new MainDTO();
		dto.setUserId(userId);
		dto.setPw(pw);
		dto.setName(name);
		dto.setNickName(nickName);
		dto.setAddress(address);
		dto.setTel(tel);
		
		MemberDAO dao = new MemberDAO();
		int success = 0;
		try {
			success = dao.join(dto);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			dao.resClose();
			System.out.println("회원가입 성공 여부 : "+success);
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("success", success);
			Gson gson = new Gson();
			String obj = gson.toJson(map);
			resp.getWriter().println(obj);
		}		
		
	}
	public void overlay() throws IOException {//아이디 중복체크(진후)
		String userId = req.getParameter("userId");
		System.out.println("멤버서비스 오버레이(아이디)");
		System.out.println("중복 체크 ID : "+userId);
		boolean overlay = false;
		boolean success = false;		
		MemberDAO dao = new MemberDAO();
		try {
			overlay = dao.overlay(userId);
			success = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			dao.resClose();
			Gson json = new Gson();
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("success", success);
			map.put("overlay", overlay);
			String obj = json.toJson(map);			
			resp.getWriter().println(obj);			
		}		
	}
	
	public void overlay1() throws IOException {//닉네임 중복체크(진후)
		String nickName = req.getParameter("nickName");
		System.out.println("멤버서비스 오버레이(닉네임)");
		System.out.println("중복 체크 nickName : "+nickName);
		boolean overlay1 = false;
		boolean success = false;		
		MemberDAO dao = new MemberDAO();
		try {
			overlay1 = dao.overlay1(nickName);
			success = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			dao.resClose();
			Gson json = new Gson();
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("success", success);
			map.put("overlay1", overlay1);
			String obj = json.toJson(map);			
			resp.getWriter().println(obj);			
		}		
	}

	public HashMap<String, Object> login() throws IOException {//로그인(진후)
        System.out.println("멤버서비스 로그인 들어옴");
        String userId = req.getParameter("userId");
        String pw = req.getParameter("pw");
        System.out.println(userId+"/"+pw);
        HashMap<String, Object> map = new HashMap<String, Object>();
        MemberDAO dao = new MemberDAO();
        try {
            map = dao.login(userId, pw);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            dao.resClose();
        }   

        return map;
   }


	public ArrayList<MainDTO> myOrder() {
		System.out.println("MemberService myOrder() 들어옴");
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		String userId = (String) req.getSession().getAttribute("userId");
		MemberDAO dao = new MemberDAO();
		list = dao.myOrder(userId);
		dao.resClose();
		return list;
	}


	public HashMap<String, Object> orderHistory() {
		System.out.println("MemberService myOrder() 들어옴");
		HashMap<String, Object> map = new HashMap<String, Object>();
		String paymentId = req.getParameter("paymentId");
		MemberDAO dao = new MemberDAO();
		map = dao.orderHistory(paymentId);
		dao.resClose();
		return map;
	}
	

}
