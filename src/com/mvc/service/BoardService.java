package com.mvc.service;

import java.awt.print.Printable;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jasper.tagplugins.jstl.core.Out;

import com.google.gson.Gson;
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
	
	public String write() { //영환
		String userId = (String) req.getSession().getAttribute("userId");  //테스트용 
		System.out.println("BoardService write() 실행");
		
		MemberDAO memberdao = new MemberDAO();
		
		String postId = "";
		BoardDAO dao = new BoardDAO();
		MainDTO dto = new MainDTO();
		
		String thImg = req.getParameter("thImg");
		String img = req.getParameter("img");
		System.out.println("th_imgid :"+thImg+"/"+"imgid: "+img);
		
		String title = req.getParameter("title");
		String categoryId = req.getParameter("categoryId");
		String recipePrice = req.getParameter("recipePrice");
		String item = req.getParameter("item");
		item=item.replace(" ", "");
		
		String contents = req.getParameter("contents");

		System.out.println("writeForm에서 받아온 파라메터 :"+"title:"+title+"/"+"categoryId:"+categoryId+"/"+"recipePrice:"+recipePrice+"/"+"item:"+item+"/"+"contents:"+contents);

		dto.setTitle(title);
		dto.setCategoryId(categoryId);
		dto.setRecipePrice(Integer.parseInt(recipePrice));
		dto.setItem(item);
		dto.setContents(contents);
		dto.setUserId(userId);
		System.out.println("write dto : "+dto);

		postId = dao.write(dto); 
		
		
		if(thImg != null) { //썸네일이 있으면,
			memberdao.setImgField(postId, thImg);
		}
		if(img != null) {// 첨부가 있으면,
			memberdao.setImgField(postId, img);
		}
		memberdao.getPoint(userId, "새 레시피 작성", 10);

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
		
		int start = 0;
		int end = 0;
		int startPage = 0;
		int endPage = 0;
		int pagePerCnt = 9; 
		int pagePerPage = 5; 
		
		int total = 0;
		try {
			total = dao.totalCount();
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int postPages = ((int)(total/pagePerCnt))+1;
		
		if(postPage > postPages) {
			postPage = postPages;
		}
		
		end = postPage*pagePerCnt; 
		start = end-(pagePerCnt-1);
		endPage = pagePerPage*((int)((postPage-1)/pagePerPage)+1);
		startPage = endPage-pagePerPage+1;
		
		list = dao.postList(end,start);
		System.out.println("총 게시글 수: "+total+"/"+"페이지 수: "+postPages);
		map.put("list", list);
		map.put("totalPage", postPages);
		map.put("currPage", postPage);
		map.put("start", startPage);
		map.put("end", endPage);
		
		dao.resClose();
		return map;
	}

	public HashMap<String, Object> categoryList(int postPage) { //영환
		System.out.println("BoardService categoryList() 실행");

		BoardDAO dao = new BoardDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map1 = new HashMap<String, Object>();
		int categoryId = Integer.parseInt(req.getParameter("categoryId"));
		System.out.println("검색된 카테고리ID"+categoryId);
		
		int start = 0;
		int end = 0;
		int startPage = 0;
		int endPage = 0;
		int pagePerCnt = 9; 
		int pagePerPage = 5; 
		
		int total = 0;
		try {
			total = dao.categoryCount(categoryId);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int postPages = ((int)(total/pagePerCnt))+1;
		
		if(postPage > postPages) {
			postPage = postPages;
		}
		
		end = postPage*pagePerCnt; 
		start = end-(pagePerCnt-1);
		endPage = pagePerPage*((int)((postPage-1)/pagePerPage)+1);
		startPage = endPage-pagePerPage+1;
		
		list = dao.categoryList(end,start,categoryId);
		System.out.println("총 게시글 수: "+total+"/"+"페이지 수: "+postPages);
		map1.put("list", list);
		map1.put("totalPage", postPages);
		map1.put("currPage", postPage);
		map1.put("start", startPage);
		map1.put("end", endPage);
		map1.put("categoryId", categoryId);
		dao.resClose();
		return map1;
	}

	public HashMap<String, Object> postSearch(int postPage) { //영환
		System.out.println("BoardServic postSearch() 실행 ");

		String searchPage = "searchPage";
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		BoardDAO dao = new BoardDAO();
			
		String keyword = req.getParameter("keyword");
		String keywordMin = req.getParameter("keywordMin");
		String keywordMax = req.getParameter("keywordMax");
		String keywordNickName = req.getParameter("keywordNickName");
		String keywordItem = req.getParameter("keywordItem");
		System.out.println("키워드 :"+keyword+" / "+"예산최소 :"+keywordMin+" / "+"예산최대 :"+keywordMax+"닉네임 :"+keywordNickName+" / "+"재료 :"+keywordItem);

		int categoryId = Integer.parseInt(req.getParameter("categoryId"));
		String postSearchOpt = req.getParameter("postSearchOpt");
		System.out.println("categoryId : "+categoryId+" / "+"postSearchOpt : "+postSearchOpt);
		
		int start = 0;
		int end = 0;
		int startPage = 0;
		int endPage = 0;
		int pagePerCnt = 9; 
		int pagePerPage = 5; 
		
		int total = 0;
		try {
			total = dao.searchCount(keyword,keywordMin,keywordMax,categoryId,postSearchOpt,keywordNickName,keywordItem);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		int postPages = ((int)(total/pagePerCnt))+1;
		
		if(postPage > postPages) {
			postPage = postPages;
		}
		
		end = postPage*pagePerCnt; 
		start = end-(pagePerCnt-1);
		endPage = pagePerPage*((int)((postPage-1)/pagePerPage)+1);
		startPage = endPage-pagePerPage+1;
		System.out.println("총 게시글 수: "+total+"/"+"페이지 수: "+postPages);
		
		list = dao.postSearch(keyword,keywordMin,keywordMax,categoryId,postSearchOpt,keywordNickName,keywordItem,start,end);
		
		map2.put("list", list);
		map2.put("totalPage", postPages);
		map2.put("currPage", postPage);
		map2.put("total", total);
		map2.put("searchPage", searchPage);
		map2.put("keyword", keyword);
		map2.put("keywordMin", keywordMin);
		map2.put("keywordMax", keywordMax);
		map2.put("keywordNickName", keywordNickName);
		map2.put("keywordItem", keywordItem);
		map2.put("postSearchOpt", postSearchOpt);
		map2.put("categoryId", categoryId);
		map2.put("start", startPage);
		map2.put("end", endPage);
		dao.resClose();
		return map2;
	}
	
	public boolean writeComment() { //은홍
		System.out.println("BoardService writeComment() 들어옴");
		boolean success = false;
		String postId = req.getParameter("postId");
		String content = req.getParameter("content");
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("댓글달기 postId/userId/content : "+postId+"/"+userId+"/"+content);
		
		BoardDAO dao = new BoardDAO(); 
		if(dao.writeComment(postId, content, userId) > 0) {
			success = true;
		}
		dao.resClose();
		System.out.println("댓글 추가 성공 여부 : " + success);
		return success;
	}

	public HashMap<String, Object> loadComments() { //은홍
		System.out.println("BoardService loadComments() 들어옴");
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		BoardDAO dao = new BoardDAO();
		ArrayList<MainDTO> list = null;
		String postId = req.getParameter("postId");
		String req_page = req.getParameter("page");
		String button_str = req.getParameter("button");
		if(button_str != "" && button_str != null && button_str != "-1") {
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
		
		try {
			map = dao.loadComments(postId, Integer.parseInt(req_page)); //댓글리스트
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.resClose();
		}
		return map;
	}

	public boolean updateComment() { //은홍
		System.out.println("BoardService updateComment() 들어옴");
		boolean success = false;
		String commentId = req.getParameter("commentId");
		String lev = req.getParameter("lev");
		String content = req.getParameter("content");
		System.out.println("댓글수정 commentId/lev/content : "+commentId+"/"+lev+"/"+content);
		
		BoardDAO dao = new BoardDAO(); 
		if(dao.updateComment(commentId, lev, content) > 0) {
			success = true;
		}
		dao.resClose();
		System.out.println("댓글 수정 성공 여부 : " + success);
		return success;
	}

	public boolean writeRecomment() { //은홍
		System.out.println("BoardService writeRecomment() 들어옴");
		boolean success = false;
		String commentId = req.getParameter("commentId");
		String content = req.getParameter("content");
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("대댓글달기 commentId/userId/content : "+commentId+"/"+userId+"/"+content);
		
		BoardDAO dao = new BoardDAO(); 
		if(dao.writeRecomment(commentId, content, userId) > 0) {
			success = true;
		}
		dao.resClose();
		System.out.println("대댓글 추가 성공 여부 : " + success);
		return success;
	}

	public boolean deleteComment() { //은홍
		System.out.println("BoardService deleteComment() 들어옴");
		boolean success = false;
		String commentId = req.getParameter("commentId");
		String lev = req.getParameter("lev");
		System.out.println("댓글 삭제 lev/commentId : "+lev+"/"+commentId);
		
		BoardDAO dao = new BoardDAO(); 
		if(dao.deleteComment(lev, commentId) > 0) {
			success = true;
		}
		dao.resClose();
		System.out.println("댓글 삭제 성공 여부 : " + success);
		return success;
	}
	
	public void itemListCall() throws IOException {//지현
		String item = req.getParameter("item");
		String postId = req.getParameter("postId");
		System.out.println("item / postId : "+item+"/"+postId);
		BoardDAO dao = new BoardDAO();
		ArrayList<MainDTO> list = null;
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		try {
			list = dao.itemListCall(item);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			dao.resClose();
			map.put("list", list);
		}
		
		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		
	}
	
	public boolean postLike() { //영환
		System.out.println("BoardService postLike() 실행");
		BoardDAO dao = new BoardDAO(); 
		boolean success = false;
		int result = 0;
		String postId = req.getParameter("postId");
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("postId : "+postId+"/"+"loginId : "+userId);
		
		result = dao.postLikeCheck(postId,userId); 
		if(result > 0) {
			success = false;
		}else {
		result = dao.postLikeCountUp(postId);
		if(result>0) {
			success = dao.postLike(postId,userId);
		};
		dao.isLike(success);
		}
		
		dao.resClose();
		return success;
	}
	
	public boolean postLikeCheck() { //영환
		System.out.println("BoardService postLike() 실행");
		BoardDAO dao = new BoardDAO(); 
		boolean success = false;
		int result = 0;
		String postId = req.getParameter("postId");
		String userId = (String) req.getSession().getAttribute("userId");
		System.out.println("postId : "+postId+"/"+"loginId : "+userId);
		
		result = dao.postLikeCheck(postId,userId); 
		if(result > 0) {
			System.out.println("좋아요 기록 있음");
			success = true;
		}else {
			System.out.println("좋아요 기록 없음");
			success = false;
		}
		
		dao.resClose();
		return success;
    }

	

}
