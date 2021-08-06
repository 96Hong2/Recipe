package com.mvc.service;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dao.BoardDAO;
import com.mvc.dao.MemberDAO;
import com.mvc.dto.MainDTO;

public class BoardService {
	HttpServletRequest req = null;
	HttpServletResponse resp = null;
	public BoardService(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
		try {
			req.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	
	public void method1() { //은홍
		System.out.println("BoardService method1() 들어옴");
	}

	public String write() { //영환
		String userId = "chanho@naver.com";  //테스트용 
		req.getSession().setAttribute("userId", userId); //테스트용 세션 저장
		System.out.println("BoardService write() 실행");
		
		MemberDAO memberdao = new MemberDAO();
		
		String postId = "";
		BoardDAO dao = new BoardDAO();
		MainDTO dto = new MainDTO();
		
		String th_imgid = req.getParameter("thImg");
		String imgid = req.getParameter("img");
		System.out.println("th_imgid :"+th_imgid+"/"+"imgid: "+imgid);
		
		String title = req.getParameter("title");
		String categoryId = req.getParameter("categoryId");
		String recipePrice = req.getParameter("recipePrice");
		String item = req.getParameter("item");
		String contents = req.getParameter("contents");
		System.out.println("writeForm에서 받아온 파라메터 :"+"title:"+title+"/"+"categoryId:"+categoryId+"/"+"recipePrice:"+recipePrice+"/"+"item:"+item+"/"+"contents:"+contents);

		dto.setTitle(title);
		dto.setCategoryId(categoryId);
		dto.setRecipePrice(Integer.parseInt(recipePrice));
		dto.setItem(item);
		dto.setContents(contents);
		dto.setUserId((String)req.getSession().getAttribute("userId"));
		System.out.println("write dto : "+dto);

		postId = dao.write(dto); 
		
		
		if(th_imgid != null) { //썸네일이 있으면,
			memberdao.setImgField(postId, th_imgid);
		}
		if(imgid != null) {// 첨부가 있으면,
			memberdao.setImgField(postId, imgid);
		}
		

		dao.resClose(); //자원닫기
		return postId;
	}

	public MainDTO detail() { //영환
		System.out.println("BoardService detail() 실행");
		BoardDAO dao = new BoardDAO();
		MainDTO dto = null;
		
		String postId = req.getParameter("postId");
		System.out.println("상세보기 postId : "+postId);
		int result = dao.upHits(postId);
		if(result>0) {
			dto = dao.detail(postId);	
		}else {
			System.out.println("조회수 올리기 실패");
		}
		dao.isHits(dto);
		
		
		dao.resClose();
		return dto;
	
		
		
	}

	  public MainDTO postUpdateForm() { //영환
		  System.out.println("BoardService postUpdateForm() 실행 : 수정 양식으로 이동"); 
		  String postId = req.getParameter("postId");
		  System.out.println("수정 양식 postId : "+postId);
		  BoardDAO dao = new BoardDAO();
		  MainDTO dto = dao.detail(postId);
		  System.out.println("detail() 반환 dto :"+dto);
		  dao.resClose();
	  	return dto;
	  }

	public int postUpdate() { //영환
		System.out.println("BoardService postUpdate() 실행 : 게시글 수정");
		int PI = 0;
		
		MainDTO dto = new MainDTO();
		BoardDAO dao = new BoardDAO();
		String postId = req.getParameter("postId");
		String title = req.getParameter("title");
		String categoryId =req.getParameter("categoryId");
		String recipePrice = req.getParameter("recipePrice");
		String item = req.getParameter("item");
		String contents = req.getParameter("contents");
		System.out.println("postUpdateForm에서 받아온 파라메터 :"+"title:"+title+"/"+"categoryId:"+categoryId+"/"+"recipePrice:"+recipePrice+"/"+"item:"+item+"/"+"contents:"+contents);
		
		dto.setPostId((postId));
		dto.setTitle(title);
		dto.setCategoryId(categoryId);
		dto.setRecipePrice(Integer.parseInt(recipePrice));
		dto.setItem(item);
		dto.setContents(contents);
		
		System.out.println("postUpdate dto : "+dto);
		int result = dao.postUpdate(dto);
		if(dto != null && result>0) {
			PI = Integer.parseInt(dto.getPostId());
		}
		dao.resClose();
		return PI;
	}

	public MainDTO del() { //영환
		System.out.println("BoardService del() 실행");
		
		BoardDAO dao = new BoardDAO();
		int postId = Integer.parseInt(req.getParameter("postId"));
		System.out.println("삭제 요청 postId : "+postId);
		MainDTO dto = dao.del(postId);
		System.out.println("삭제하기 DTO : "+dto);
		dao.resClose();
		System.out.println("삭제완료");
		 return dto;
	}

	public HashMap<String, Object> postList(int postPage) { //영환
		System.out.println("BoardService postList() 실행");
		BoardDAO dao = new BoardDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		//한 페이지당 게시글 수
		int pagePerCnt = 9;
		int end = postPage * pagePerCnt;
		int start=(end-pagePerCnt);
		
		list = dao.postList(end,start);
		int total = dao.totalCount();
		int postPages = (total/pagePerCnt)+1;
		System.out.println("총 게시글 수: "+total+"/"+"페이지 수: "+postPages);
		map.put("list", list);
		map.put("totalPage", postPages);
		map.put("currPage", postPage);
		
		dao.resClose();
		
		
		return map;
	}

	public HashMap<String, Object> categoryList(int postPage) {
		System.out.println("BoardService categoryList() 실행");
		BoardDAO dao = new BoardDAO();
		ArrayList<MainDTO> list = null;
		int categoryId = Integer.parseInt(req.getParameter("categoryId"));
		System.out.println(categoryId);
		HashMap<String, Object> map1 = new HashMap<String, Object>();
		//한 페이지당 게시글 수
		int pagePerCnt = 9;
		int end = postPage * pagePerCnt;
		int start=(end-pagePerCnt);
		
		list = dao.categoryList(end,start,categoryId);
		int total = dao.categoryCount(categoryId);
		int postPages = (total/pagePerCnt)+1;
		System.out.println("총 게시글 수: "+total+"/"+"페이지 수: "+postPages);
		map1.put("list", list);
		map1.put("totalPage", postPages);
		map1.put("currPage", postPage);
		
		dao.resClose();
		return map1;
	}

	public HashMap<String, Object> postSearch(int parseInt) {
		System.out.println("BoardServic postSearch() 실행 ");
		
		String keyword = req.getParameter("keyword");
		String keywordMin = req.getParameter("keywordMin");
		String keywordMax = req.getParameter("keywordMax");
		String categoryId = req.getParameter("categoryId");
		System.out.println("키워드 :"+keyword+"/"+"예산최소 :"+keywordMin+"/"+"예산최대 :"+keywordMax+"/"+categoryId);
		return null;
	}
	

	

	

}
