package com.mvc.controller;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dto.MainDTO;
import com.mvc.service.BoardService;
import com.mvc.service.MemberService;

@WebServlet({"/","/postWriteForm","/postDetail","/postUpdateForm","/postUpdate","/postDel","/postList","/category","/postSearch"})
public class BoardController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dual(req, resp);
	}


	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dual(req, resp);
	}
	
	private void dual(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	
		String uri = req.getRequestURI();
		String context = req.getContextPath();
		String addr = uri.substring(context.length());
		System.out.println("URI : "+addr);
		
		BoardService service = new BoardService(req, resp);
		MainDTO dto = null;
		RequestDispatcher dis = null;
		String page = "";
		String msg = "";
		boolean success = false;
		int result = 0;
		String postPage = null;
		switch(addr) {
		case "/": //은홍
			System.out.println("-- 메인 페이지 보기 요청 --");
			
			
		break;
		
		case "/postWrite" : //영환
			System.out.println("게시물 글쓰기 요청");
			
			String postId = service.write();
			page = postId != null ? "./postDetail?postId="+postId:"writeForm.jsp";
			resp.sendRedirect(page);
			break;
			
		case "/postDetail" : //영환
			System.out.println("레시피게시판 상세보기 요청");
			dto = new MainDTO();
			dto = service.detail();
			if(dto.getIsDel().equals("Y")) {
				resp.sendRedirect("postDel.jsp");
			}else {
		    req.setAttribute("post", dto);
		    dis = req.getRequestDispatcher("postDetail.jsp");
		    dis.forward(req, resp);
			}
		    break;
		    
		case "/postUpdateForm" : //영환
			System.out.println("게시글 수정 양식 요청");
			req.setAttribute("post", service.postUpdateForm());
			dis = req.getRequestDispatcher("postUpdateForm.jsp");
			dis.forward(req, resp);
			break;
			
		case "/postUpdate" : //영환
			System.out.println("게시글 수정하기 요청");
			result = service.postUpdate();
				
			page = result>0 ? "postDetail?postId="+result:"postUpdateForm?postId="+result;;
			resp.sendRedirect(page);
			break;
			
		case "/postDel" : //영환
			System.out.println("게시글 삭제하기 요청");
			dto = service.del();
			if(dto.getIsDel().equals("Y")) {
				
				resp.sendRedirect("postDel.jsp");
			}
			
			break;
			
		case "/postList" : //영환
			System.out.println("게시글 리스트 요청");
			postPage = req.getParameter("postPage");
			if(postPage == null) {
				postPage = "1";
			}
			HashMap<String, Object> map = service.postList(Integer.parseInt(postPage));
			req.setAttribute("list", map.get("list"));
			req.setAttribute("currPage", map.get("currPage"));
			req.setAttribute("totalPage", map.get("totalPage"));
			dis = req.getRequestDispatcher("postList.jsp");
			dis.forward(req, resp);
			break;
			
		case "/category" : //영환
			System.out.println("카테고리별 리스트 요청");
			postPage = req.getParameter("postPage");
			if(postPage == null) {
				postPage = "1";
			}
			HashMap<String, Object> map1 = service.categoryList(Integer.parseInt(postPage));
			req.setAttribute("list", map1.get("list"));
			req.setAttribute("currPage", map1.get("currPage"));
			req.setAttribute("totalPage", map1.get("totalPage"));
			dis = req.getRequestDispatcher("postList.jsp");
			dis.forward(req, resp);
			break;
			
		case "/postSearch" : //영환
			System.out.println("게시글 검색 요청");
			postPage = req.getParameter("postPage");
			if(postPage == null) {
				postPage = "1";
			}
			HashMap<String, Object> map2 = service.postSearch(Integer.parseInt(postPage));
			
			break;
		}
	}
	
}
