package com.mvc.controller;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.mvc.dto.MainDTO;
import com.mvc.service.BoardService;
import com.mvc.service.MemberService;

@WebServlet({"/", "/postWriteForm","/postWrite","/postDetail","/postUpdateForm","/postUpdate","/postDel","/postList","/category","/postSearch","/writeComment", "/loadComments", "/updateComment", "/writeRecomment", "/deleteComment","/itemListCall","/postLike","/postLikeCheck", "/bestPost", "/bestWeek", "/bestMonth", "/bestSearch", "/bestSelect1", "/bestSelect2"})
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
		System.out.println("-------------------------");
		System.out.println("URI : "+addr);
		
		BoardService service = new BoardService(req, resp);
		MainDTO dto = null;
		RequestDispatcher dis = null;
		String page = "";
		String msg = "";
		boolean success = false;
		int result = 0;
		String postPage = null;
		String button_str = null;
		HashMap<String, Object> map = null;
		
		switch(addr) {
		
		case "/":
			System.out.println("메인페이지");
			map = service.indexBest();
			req.setAttribute("mainBestPost", map.get("bestPost"));
			map = service.indexPost();
			req.setAttribute("mainPost", map.get("post"));
			dis = req.getRequestDispatcher("main.jsp");
			dis.forward(req, resp);
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
			System.out.println("서비스dto"+dto);
			if(dto == null) {
				resp.sendRedirect("postBlind.jsp");
			}else if(dto.getIsDel().equals("Y")) {
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

			String postList = "postList";
			postPage = req.getParameter("postPage");
			button_str = req.getParameter("button");
			int categoryId = 0;
			
			if(button_str != null) {
				int button = Integer.parseInt(button_str);
				if(button == 1) {
					postPage = String.valueOf(Integer.parseInt(postPage)-1);
				}else if(button == 2) {
					postPage = String.valueOf(Integer.parseInt(postPage)+1);
				}				
			}
			
			if(postPage == null || Integer.parseInt(postPage) <= 0) {
				System.out.println("controller 처음 요청 받은 페이지 : "+postPage);
				postPage = "1";
			}
			
			
			map = service.postList(Integer.parseInt(postPage));
			req.setAttribute("list", map.get("list"));
			req.setAttribute("currPage", map.get("currPage"));
			req.setAttribute("totalPage", map.get("totalPage"));
			req.setAttribute("start", map.get("start"));
			req.setAttribute("end", map.get("end"));
			req.setAttribute("postList",postList);
			req.setAttribute("categoryId",categoryId);
			dis = req.getRequestDispatcher("postList.jsp");
			dis.forward(req, resp);
			break;
			
		case "/category" : //영환
			System.out.println("카테고리별 리스트 요청");
			
			String categoryPage = "categoryPage";		
			postPage = req.getParameter("postPage");
			button_str = req.getParameter("button");
			
			if(button_str != null) {
				int button = Integer.parseInt(button_str);
				if(button == 1) {
					postPage = String.valueOf(Integer.parseInt(postPage)-1);
				}else if(button == 2) {
					postPage = String.valueOf(Integer.parseInt(postPage)+1);
				}				
			}
			
			if(postPage == null || Integer.parseInt(postPage) <= 0) {
				System.out.println("controller 처음 요청 받은 페이지 : "+postPage);
				postPage = "1";
			}
			
			
			HashMap<String, Object> map1 = service.categoryList(Integer.parseInt(postPage));
			req.setAttribute("list", map1.get("list"));
			req.setAttribute("currPage", map1.get("currPage"));
			req.setAttribute("totalPage", map1.get("totalPage"));
			req.setAttribute("start", map1.get("start"));
			req.setAttribute("end", map1.get("end"));
			req.setAttribute("categoryPage", categoryPage);
			req.setAttribute("categoryId", map1.get("categoryId"));
			dis = req.getRequestDispatcher("postList.jsp");
			dis.forward(req, resp);
			break;
			
		case "/postSearch" : //영환
			System.out.println("게시글 검색 요청");
			
			String searchPage = "searchPage";
			postPage = req.getParameter("postPage");
			button_str = req.getParameter("button");
			
			if(button_str != null) {
				int button = Integer.parseInt(button_str);
				if(button == 1) {
					postPage = String.valueOf(Integer.parseInt(postPage)-1);
				}else if(button == 2) {
					postPage = String.valueOf(Integer.parseInt(postPage)+1);
				}				
			}
			
			if(postPage == null || Integer.parseInt(postPage) <= 0) {
				System.out.println("controller 처음 요청 받은 페이지 : "+postPage);
				postPage = "1";
			}
			
			HashMap<String, Object> map2 = service.postSearch(Integer.parseInt(postPage));
			req.setAttribute("list", map2.get("list"));
			req.setAttribute("currPage", map2.get("currPage"));
			req.setAttribute("totalPage", map2.get("totalPage"));
			req.setAttribute("start", map2.get("start"));
			req.setAttribute("end", map2.get("end"));
			req.setAttribute("categoryId", map2.get("categoryId"));
			req.setAttribute("keyword", map2.get("keyword"));
			req.setAttribute("keywordMin", map2.get("keywordMin"));
			req.setAttribute("keywordMax", map2.get("keywordMax"));
			req.setAttribute("keywordNickName", map2.get("keywordNickName"));
			req.setAttribute("keywordItem", map2.get("keywordItem"));
			req.setAttribute("postSearchOpt", map2.get("postSearchOpt"));
			req.setAttribute("searchPage",searchPage);
			dis = req.getRequestDispatcher("postList.jsp");
			dis.forward(req, resp);
			break;
			
		case "/loadComments": //은홍
			System.out.println("댓글 불러오기 요청");
			try {
				map = new HashMap<String, Object>();
				map = service.loadComments();
				
				//가져온 댓글 정보를 ajax success의 data로 넘기기
				Gson gson = new Gson();
				String obj = gson.toJson(map);
				resp.setContentType("text/html; charset=UTF-8");
				resp.getWriter().println(obj);
			} catch (Exception e) {
				e.printStackTrace();
			}
		break;

		case "/writeComment": // 은홍
			System.out.println("댓글 작성 요청");
			try {
				success = service.writeComment();

				map = new HashMap<String, Object>();
				map.put("success", success);
				Gson gson = new Gson();
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
			} catch (IOException e) {
				e.printStackTrace();
			}
		break;
		
		case "/writeRecomment": // 은홍
			System.out.println("대댓글 작성 요청");
			try {
				success = service.writeRecomment();

				map = new HashMap<String, Object>();
				map.put("success", success);
				Gson gson = new Gson();
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
			} catch (IOException e) {
				e.printStackTrace();
			}
		break;
		
		case "/updateComment": // 은홍
			System.out.println("댓글 수정 요청");
			try {
				success = service.updateComment();

				map = new HashMap<String, Object>();
				map.put("success", success);
				Gson gson = new Gson();
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
			} catch (IOException e) {
				e.printStackTrace();
			}
		break;
		
		case "/deleteComment": // 은홍
			System.out.println("댓글 삭제 요청");
			try {
				success = service.deleteComment();

				map = new HashMap<String, Object>();
				map.put("success", success);
				Gson gson = new Gson();
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
			} catch (IOException e) {
				e.printStackTrace();
			}
		break;
		
		case "/itemListCall"://지현
			System.out.println("상품리스트 불러오기 요청");
			service.itemListCall();
			break;
			
		case "/postLike" : // 영환
			success = service.postLike();
			map = new HashMap<String, Object>();
			map.put("success", success);
			Gson gson = new Gson();
			String obj = gson.toJson(map);
			resp.getWriter().println(obj);
			
			break;
		
		case "/postLikeCheck" : // 영환
			success = service.postLikeCheck();
			map = new HashMap<String, Object>();
			map.put("success", success);
			gson = new Gson();
			obj = gson.toJson(map);
			resp.getWriter().println(obj);
			
			break;	
			
		case "/bestPost": // 찬호
			System.out.println("내가작성한 글 리스트 보기 요청");
			page = req.getParameter("page");
			if (page == null) {
				page = "1";
			}
			HashMap<String, Object> map11 = service.bestPost(Integer.parseInt(page));

			req.setAttribute("bestPost", map11.get("bestPost"));
			req.setAttribute("currPage", map11.get("currPage"));
			req.setAttribute("totalPage", map11.get("totalPage"));

			dis = req.getRequestDispatcher("bestPost.jsp");
			dis.forward(req, resp);
			break;
			
		case "/bestMonth": // 찬호
			System.out.println("내가작성한 글 리스트 보기 요청");
			page = req.getParameter("page");
			if (page == null) {
				page = "1";
			}
			HashMap<String, Object> map12 = service.bestMonth(Integer.parseInt(page));

			req.setAttribute("bestMonth", map12.get("bestMonth"));
			req.setAttribute("currPage", map12.get("currPage"));
			req.setAttribute("totalPage", map12.get("totalPage"));

			dis = req.getRequestDispatcher("bestMonth.jsp");
			dis.forward(req, resp);
			break;
			
		case "/bestWeek": // 찬호
			System.out.println("내가작성한 글 리스트 보기 요청");
			page = req.getParameter("page");
			if (page == null) {
				page = "1";
			}
			HashMap<String, Object> map13 = service.bestWeek(Integer.parseInt(page));

			req.setAttribute("bestWeek", map13.get("bestWeek"));
			req.setAttribute("currPage", map13.get("currPage"));
			req.setAttribute("totalPage", map13.get("totalPage"));

			dis = req.getRequestDispatcher("bestWeek.jsp");
			dis.forward(req, resp);
			break;
			
		case "/bestSearch": // 찬호
			System.out.println("베스트게시판 글 리스트 보기 요청");
			page = req.getParameter("page");
			if (page == null) {
				page = "1";
			}
			HashMap<String, Object> map14 = service.bestSearch(Integer.parseInt(page));

			req.setAttribute("bestSearch", map14.get("bestSearch"));
			req.setAttribute("currPage", map14.get("currPage"));
			req.setAttribute("totalPage", map14.get("totalPage"));
			req.setAttribute("startDate", req.getParameter("startDate"));
			req.setAttribute("endDate", req.getParameter("endDate"));

			dis = req.getRequestDispatcher("bestSearch.jsp");
			dis.forward(req, resp);
			break;
			
		case "/bestSelect1": // 찬호
			System.out.println("주간베스트 선정요청");
			result = service.bestSelect1();
			
			msg = "주간 베스트 선정이 실패했습니다.";
			if(result > 0) {
				msg = "주간 베스트 선정이 완료되었습니다";
			}
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher("bestPost");
			dis.forward(req, resp);
			break;
			
		case "/bestSelect2": // 찬호
			System.out.println("월간베스트 선정요청");
			result = service.bestSelect2();
			
			msg = "월간 베스트 선정이 실패했습니다.";
			if(result > 0) {
				msg = "월간 베스트 선정이 완료되었습니다";
			}
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher("bestPost");
			dis.forward(req, resp);
			break;
			
		}
	}
	
}
