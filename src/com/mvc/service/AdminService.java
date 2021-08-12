package com.mvc.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.mvc.dao.AdminDAO;
import com.mvc.dao.MemberDAO;
import com.mvc.dto.MainDTO;

public class AdminService {
	
	private HttpServletRequest req = null;
	private HttpServletResponse resp = null;
	
	public AdminService(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
	}
	
	public void memberList() throws IOException {//지현
		
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = adDao.memberList();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("list", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void memberSearch() throws IOException {//지현
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> searchList = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String[] searchOpt = req.getParameterValues("searchOpt");
		String options = "";
		for(String opt : searchOpt) {
			options = opt;
			System.out.println("memberList에서 넘긴 옵션 값 : "+options);
		}
		
		String[] cnt = req.getParameterValues("cnt");
		String content = "";
		for(String cont : cnt) {
			content = cont;
			System.out.println("memberList에서 검색창에 입력된 값 : "+content);
		}
		
		try {
			searchList = adDao.memberSearch(options, content);
			System.out.println("Service에서 반환하는 list : "+searchList);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("searchList", searchList);
		}
		//System.out.println("map : "+map);
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
		
	}

	public MainDTO memberInfo(String currId) throws IOException {//지현

		MainDTO dto = null;
		AdminDAO adDao = new AdminDAO();
		
		dto = adDao.memberInfo(currId);
		System.out.println("서비스의 memberInfo DTO : "+dto);
		adDao.resClose();
		System.out.println("자원 반납");

		return dto;

	}

	public MainDTO updateForm(String currId) {//지현
		
		System.out.println("정보를 수정할 userId : "+currId);
		
		AdminDAO adDao = new AdminDAO();
		MainDTO dto = new MainDTO();
		dto = adDao.memberInfo(currId);
		System.out.println("서비스의 updateForm DTO : "+dto);
		adDao.resClose();
				
		return dto;
	}

	public int memberUpdate(String currId) {//지현
		
		int change = 0;

		String nickname = req.getParameter("nickname");
		System.out.println("수정할 nickname : "+nickname);
		
		AdminDAO adDao = new AdminDAO();
		change = adDao.memberUpdate(currId, nickname);
		if(change > 0) {
			System.out.println("업데이트 성공 : "+change);
		}else {
			System.out.println("업데이트 실패");
		}
		
		adDao.resClose();			
		return change;
	}


	public int memberSuspend() {//지현
		
		int change = 0;
		
		String userId = req.getParameter("userId");
		String adminName = req.getParameter("adminName");
		String opt = req.getParameter("opt");
		String textArea = req.getParameter("textArea");
		System.out.println("아이디 : "+userId+" /어드민 : "+adminName+" /옵션 : "+opt+" /내용 "+textArea);
		
		AdminDAO adDao = new AdminDAO();
		change = adDao.memberSuspend(userId, adminName, opt, textArea);
		if(change > 0) {
			System.out.println("정지 성공 : "+change);
		}else {
			System.out.println("정지 실패");
		}
		
		adDao.resClose();
		return change;

	}

	public void memberSusNot() throws IOException {//지현
		String userId = req.getParameter("userId");
		int change = 0;
		HashMap<String, Object> map = new HashMap<String, Object>();
		System.out.println("아이디 : "+userId);
		
			AdminDAO adDao = new AdminDAO();
			change = adDao.memberSusNot(userId);
			if(change > 0) {
				System.out.println("정지 해제 성공 : "+change);
			map.put("msg", "성공");
		}else {
			System.out.println("정지 해제 실패!");
			map.put("msg", "실패");
		}
			adDao.resClose();
			resp.setContentType("text/html; charset=UTF-8");
			resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void nickOverlay() throws IOException {//지현
		String nickname = req.getParameter("nickName");
		System.out.println("중복 체크 닉네임 : "+nickname);
		boolean overlay = false;
		boolean success = false;
		
		AdminDAO adDao = new AdminDAO();
		try {
			overlay = adDao.nickOverlay(nickname);
			success = true;
		}catch (SQLException e) {
			e.printStackTrace();
	}finally {
		adDao.resClose();
		Gson json = new Gson();
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("success", success);
		map.put("overlay", overlay);
		String obj = json.toJson(map);
		resp.setContentType("text/html charset=UTF-8");
		resp.getWriter().println(obj);	
		}
	}

	public int memberBlind() {//지현
		
		int change = 0;
		String nickName = req.getParameter("nickName");
		String postId = req.getParameter("postId");
		String adminName = req.getParameter("adminName");
		String blindReason = req.getParameter("textArea");
		String classification = req.getParameter("classification");
		
		System.out.println("글 아이디 : "+postId+" /작성자 닉 : "+nickName+" /어드민 : "+adminName+" /블라인드 이유 : "+blindReason+" /분류 : "+classification);
		
		AdminDAO adDao = new AdminDAO();
		try {
			change = adDao.memberBlind(nickName, postId, adminName, blindReason, classification);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if(change > 0) {
			System.out.println("블라인드 성공 : "+change);
		}else {
			System.out.println("블라인드 실패");
		}
		
		adDao.resClose();
		return change;
		
	}

	public void reportList() throws IOException {//지현
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = adDao.reportList();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("reportList", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
		
	}

	public void reportSearch() throws IOException {//지현
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> searchList = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String[] searchOpt = req.getParameterValues("searchOpt");
		String options = "";
		for(String opt : searchOpt) {
			options = opt;
			System.out.println("reportList에서 넘긴 옵션 값 : "+options);
		}
		
		String[] cnt = req.getParameterValues("cnt");
		String content = "";
		for(String cont : cnt) {
			content = cont;
			System.out.println("reportList에서 검색창에 입력된 값 : "+content);
		}
		
		try {
			searchList = adDao.reportSearch(options, content);
			System.out.println("Service에서 반환하는 list : "+searchList);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("searchList", searchList);
		}
		System.out.println("map : "+map);
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void reportNotYet() throws IOException {//지현
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = adDao.reportNotYet();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("searchList", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public int reportChk() throws SQLException {//지현
		AdminDAO adDao = new AdminDAO();
		int change = 0; 
		String reportId = req.getParameter("reportId");
		String adminWho = req.getParameter("adminWho");
		System.out.println("관리자 아이디 : "+adminWho);
		
		change = adDao.reportChk(reportId, adminWho);
		
		if(change > 0) {
			System.out.println("신고 미처리 -> 처리 변경 성공!");
		}else {
			System.out.println("신고 처리 실패!");
		}
		
		adDao.resClose();
		return change;
		
	}

	public void blindList() throws IOException {//지현
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = adDao.blindList();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("blindList", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void blindSearch() throws IOException {//지현
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> blindList = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String[] searchOpt = req.getParameterValues("searchOpt");
		String options = "";
		for(String opt : searchOpt) {
			options = opt;
			System.out.println("reportList에서 넘긴 옵션 값 : "+options);
		}
		
		String[] cnt = req.getParameterValues("cnt");
		String content = "";
		for(String cont : cnt) {
			content = cont;
			System.out.println("reportList에서 검색창에 입력된 값 : "+content);
		}
		
		try {
			blindList = adDao.blindSearch(options, content);
			//System.out.println("Service에서 반환하는 list : "+blindList);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("searchList", blindList);
		}
		System.out.println("map : "+map);
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void blindNot() throws SQLException, IOException {//지현
		AdminDAO adDao = new AdminDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();
		int change = 0; 
		boolean success = false;
		String blindId = req.getParameter("blindId");
		System.out.println("블라인드 해제할 글 또는 댓글 아이디 : "+blindId);
		
		change = adDao.blindNot(blindId);
		
		if(change > 0) {
			System.out.println("블라인드 해제 성공!");
			success = true;
			map.put("success", success);
		}else {
			System.out.println("블라인드 해제 실패!");
			success = false;
			map.put("success", success);
		}
		
		adDao.resClose();
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void susMemberList() throws IOException {
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = adDao.susMemberList();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("list", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void susMemberSearch() throws IOException {
		AdminDAO adDao = new AdminDAO();
		ArrayList<MainDTO> searchList = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String[] searchOpt = req.getParameterValues("searchOpt");
		String options = "";
		for(String opt : searchOpt) {
			options = opt;
			System.out.println("susMemberList에서 넘긴 옵션 값 : "+options);
		}
		
		String[] cnt = req.getParameterValues("cnt");
		String content = "";
		for(String cont : cnt) {
			content = cont;
			System.out.println("susMemberList에서 검색창에 입력된 값 : "+content);
		}
		
		try {
			searchList = adDao.susMemberSearch(options, content);
			System.out.println("Service에서 반환하는 list : "+searchList);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			adDao.resClose();
			map.put("searchList", searchList);
		}
		//System.out.println("map : "+map);
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
		
	}

	public int memberReport() {
		int change = 0;
		String nickName = req.getParameter("nickName");
		String postId = req.getParameter("postId");
		String reportReason = req.getParameter("textArea");
		String classification = req.getParameter("classification");
		String opt = req.getParameter("opt");
		
		System.out.println("글 아이디 : "+postId+" /작성자 닉 : "+nickName+" /블라인드 이유 : "+reportReason+" /분류 : "+classification+" /옵션 : "+opt);
		
		AdminDAO adDao = new AdminDAO();
		try {
			change = adDao.memberReport(nickName, postId, reportReason, classification, opt);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(change > 0) {
			System.out.println("신고 성공 : "+change);
		}else {
			System.out.println("신고 실패");
		}
		
		adDao.resClose();
		return change;
	}
	
	
	/*-----------------------------------------------------진후----------------------------------------------------------*/
	
	
	public static HashMap<String, Object> adminProductList(int page, String productId) { //어드민 서비스 상품관리(진후)
		System.out.println("어드민서비스 상품리스트");
		AdminDAO dao = new AdminDAO();
		HashMap<String, Object> map = dao.adminProductList(page, productId);
		System.out.println("map : " + map.size());
		System.out.println("map : " + map);

		dao.resClose();

		return map;
	}
	
	
	
	public ArrayList<MainDTO> adminProductSearch() {//어드민 상품관리 검색 (진후)
		System.out.println("관리자 상품 검색 요청");
		String keyword = req.getParameter("keyword");
		System.out.println("검색한 상품 : " + keyword);
		AdminDAO dao = new AdminDAO();		
		ArrayList<MainDTO> adminProductList = dao.adminProductList(keyword);
		System.out.println("검색된 상품 개수 : " + adminProductList.size());		
		dao.resClose();
		return adminProductList;
	}

	
	
	public String addProduct() {//어드민 상품 추가(진후)
		System.out.println("관리자 서비스 상품 등록 요청");		
		
		MemberDAO memberdao = new MemberDAO();
		MainDTO dto = new MainDTO();		
		AdminDAO dao = new AdminDAO();
		String productId ="";
		
		
		String thImg = req.getParameter("thImg");
		String img = req.getParameter("img");
		System.out.println("th_imgid :"+thImg+"/"+"imgid: "+img);
		
		
		String productName = req.getParameter("productName");			
		int price = Integer.parseInt(req.getParameter("price"));		
		int stock = Integer.parseInt(req.getParameter("stock"));
		String productDetail = req.getParameter("productDetail");
		System.out.println(productName+"/"+price+"/"+stock+"/"+productDetail);
		
		dto.setProductName(productName);
		dto.setPrice(price);
		dto.setStock(stock);
		dto.setProductDetail(productDetail);	
		
		productId = dao.addProduct(dto);
		
		if(thImg != null) { //썸네일이 있으면,
			memberdao.setImgField(productId, thImg);
		}
		if(img != null) {// 첨부가 있으면,
			memberdao.setImgField(productId, img);
		}		

		dao.resClose(); //자원닫기
		return productId;	
			
		}		
		
	

	public MainDTO productDetail() { //진후
		System.out.println("어드민 서비스 상품상세보기");
		MainDTO dto = null;
		String productId = req.getParameter("productId");
		System.out.println("productId : "+productId);
		
		AdminDAO dao = new AdminDAO();		
		
			dto = dao.productDetail(productId);				
			dao.resClose();			
			
		return dto;
	}

	public Object productUpdateForm() { //진후
		System.out.println("어드민서비스 상품 수정폼");
		String productId = req.getParameter("productId");
		System.out.println("productId : "+productId);		
		AdminDAO dao = new AdminDAO();
		MainDTO dto = dao.productDetail(productId);
		System.out.println("dto : "+dto);
		dao.resClose();		
		return dto;
	}

	public int productUpdate(String productId) { //진후
		System.out.println("어드민서비스 상품 수정");
		int success = 0;		
		String productName = req.getParameter("productName");			
		int price = Integer.parseInt(req.getParameter("price"));		
		int stock = Integer.parseInt(req.getParameter("stock"));
		String productDetail = req.getParameter("productDetail");
		System.out.println(productName+"/"+price+"/"+stock+"/"+productDetail);
		
		AdminDAO dao = new AdminDAO();
		success = dao.productUpdate(productId, productName, price, stock, productDetail);
		System.out.println("수정 성공 : "+success);
		dao.resClose();
		
		
		return success;
	}

	public int productDel() { //진후
		System.out.println("어드민 서비스 상품 삭제 요청");
		String productId = req.getParameter("productId");
		System.out.println("productId : "+productId);
		
		AdminDAO dao = new AdminDAO();
		int success = dao.productDel(productId);
		System.out.println("삭제 성공 : "+success);
		dao.resClose();
		
		return success;
		
	}

	public void adminList() throws IOException { //진후
		System.out.println("어드민 서비스 관리자 리스트 요청");
		AdminDAO dao = new AdminDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = dao.adminList();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			dao.resClose();
			map.put("list", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}

	public void adminSet() throws IOException { //진후
		System.out.println("어드민 서비스 관리자 지정");
		String cnt = req.getParameter("cnt");
		int success = 0;
		HashMap<String, Object> map = new HashMap<String, Object>();
		System.out.println("아이디 : "+cnt);
		
			AdminDAO dao = new AdminDAO();
			success = dao.adminSet(cnt);
			if(success > 0) {
				System.out.println("관리자 지정 성공 : "+success);
			map.put("msg", "성공");
		}else {
			System.out.println("관리자 지정 실패!");
			map.put("msg", "실패");
		}
			dao.resClose();
			resp.setContentType("text/html; charset=UTF-8");
			resp.getWriter().println(new Gson().toJson(map));

	}
	
	public void adminNot() throws IOException {//진후
		System.out.println("어드민 서비스 관리자 해제");
		String userId = req.getParameter("userId");
		int success = 0;
		HashMap<String, Object> map = new HashMap<String, Object>();
		System.out.println("아이디 : "+userId);
		
			AdminDAO dao = new AdminDAO();
			success = dao.adminNot(userId);
			if(success > 0) {
				System.out.println("관리자 해제 성공 : "+success);			
		}else {
			System.out.println("관리자 해제 실패!");
			
		}
			dao.resClose();
			resp.setContentType("text/html; charset=UTF-8");
			resp.getWriter().println(new Gson().toJson(map));
	}
	
	public MainDTO adminInfo(String userId) {//진후
		System.out.println("어드민 서비스 관리자 정보");
		MainDTO dto = null;
		AdminDAO dao = new AdminDAO();
		
		dto = dao.adminInfo(userId);
		System.out.println("서비스의 memberInfo DTO : "+dto);
		dao.resClose();
		System.out.println("자원 반납");

		return dto;
	}


}
