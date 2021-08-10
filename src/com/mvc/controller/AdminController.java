package com.mvc.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dto.MainDTO;
import com.mvc.service.AdminService;

@WebServlet({"/memberList","/memberSearch","/memberInfo","/memberUpdate","/memberUpdateForm",
	"/memberSusPopUp", "/memberSuspend","/memberSusNot","/nickOverlay","/memberBlind", "/blindSth",
	"/report/reportList","/report/reportSearch","/report/reportNotYet","/report/reportChk","/blindList","/blindSearch","/blindNot",
	"/susMemberList","/susMemberSearch","/reportSth","/memberReport", "/adminProductList", "/adminProductSearch","/addProduct","/productDetail","/productUpdate",
	"/productUpdateForm","/productDel", "/adminList","/adminSet","/adminNot","/adminInfo"})
public class AdminController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			dual(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			dual(req, resp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void dual(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		
		String uri = req.getRequestURI();
		String context = req.getContextPath();
		String addr = uri.substring(context.length());
		String msg = "";
		String page = "";
		System.out.println("\nURI : "+addr);
		
		
		RequestDispatcher dis = null;
		AdminService adService = new AdminService(req, resp);
		req.setCharacterEncoding("UTF-8");
		
		switch(addr) {
		
		case "/memberList": //지현
			System.out.println("전체 회원 리스트 요청");
			adService.memberList();
			break;
			
		case "/memberSearch": //지현
			System.out.println("회원 검색 요청");
			adService.memberSearch();
			break;
			
		case "/memberInfo"://지현
			System.out.println("관리자의 회원정보 상세보기 요청");	
			String currId = req.getParameter("userId");
			System.out.println("받아온 아이디 : "+currId);
			req.setAttribute("member", adService.memberInfo(currId));
			dis = req.getRequestDispatcher("memberInfo.jsp");
			dis.forward(req, resp);
			break;
			
		case "/memberUpdateForm": //지현
			System.out.println("관리자의 회원정보 수정 요청");
			currId = req.getParameter("userId");
			req.setAttribute("member", adService.updateForm(currId));
			dis = req.getRequestDispatcher("memberUpdateForm.jsp");
			dis.forward(req, resp);
			break;
			
		case "/memberUpdate"://지현
			System.out.println("관리자의 회원정보 수정 중...");

			currId = req.getParameter("userId");
			msg = "수정에 실패했습니다.";
			page = "memberUpdateForm?userId="+currId;
			if(adService.memberUpdate(currId) > 0) {
				msg = "수정에 성공했습니다.";
				page = "memberInfo?userId="+currId;
				System.out.println("관리자의 회원정보 수정 성공!!");
			}else {
				msg = "수정에 실패 했습니다.";
			}
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher(page);
			dis.forward(req, resp);
			
			break;
			
		case "/memberSusPopUp"://지현
			System.out.println("관리자가 회원의 정지 버튼 클릭");
			currId = req.getParameter("userId");
			String currNick = req.getParameter("nickname");
			
			req.setAttribute("Id", currId);
			req.setAttribute("Nickname", currNick);
			dis = req.getRequestDispatcher("memberSusPopUp.jsp");
			dis.forward(req, resp);
			break; 
			
		case "/memberSuspend"://지현
			System.out.println("관리자가 회원의 정지 사유 입력 후 제출");
			
			currId = req.getParameter("userId");
			msg = "회원 정지 실패";
			
			if(adService.memberSuspend() > 0) {
				System.out.println("관리자의 회원 정지 성공!!");
				msg = "해당 회원의 정지가 완료되었습니다.";
			}else {
				System.out.println("관리자의 회원 정지 실패!");
				msg = "회원 정지 실패";
			}
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher("memberSusPopUp.jsp");
			dis.forward(req, resp);

			break;
			
		case "/memberSusNot": //지현
			System.out.println("관리자가 회원 정지 해제 요청");
			adService.memberSusNot();
			break;
			
		case "/nickOverlay": //지현
			System.out.println("닉네임 중복체크 요청");
			adService.nickOverlay();
			break;
			
		case "/memberBlind"://지현
			System.out.println("게시글 또는 댓글의 블라인드 버튼 누름");
			String postId = req.getParameter("postId");
			currNick = req.getParameter("nickName");
			String classification = req.getParameter("classification");
			
			req.setAttribute("postId", postId);
			req.setAttribute("nickName", currNick);
			req.setAttribute("classification", classification);
			dis = req.getRequestDispatcher("memberBlind.jsp");
			dis.forward(req, resp);
			break; 
			
		case "/blindSth": //지현
			System.out.println("블라인드 요청");
			msg = "블라인드 실패";
			
			if(adService.memberBlind() > 0) {
				System.out.println("블라인드 성공!!");
				msg = "블라인드 성공";
			}else {
				System.out.println("블라인드 실패!!");
				msg = "블라인드 실패";
			}
			
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher("memberBlind.jsp");
			dis.forward(req, resp);

			break;
			
		case "/report/reportList": //지현
			System.out.println("신고 리스트 요청!");
			adService.reportList();
			break;
			
		case "/report/reportSearch": //지현
			System.out.println("신고 검색 요청!");
			adService.reportSearch();
			break;
			
		case "/report/reportNotYet": //지현
			System.out.println("미처리 신고 검색 요청!");
			adService.reportNotYet();
			break;
			
		case "/report/reportChk": //지현
			System.out.println("신고 처리 요청!");
			adService.reportChk();
			break;
			
		case "/blindList"://지현
			System.out.println("블라인드 리스트 요청!");
			adService.blindList();
			break;
			
		case "/blindSearch": //지현
			System.out.println("블라인드 검색 요청!");
			adService.blindSearch();
			break;
			
		case "/blindNot"://지현
			System.out.println("블라인드 해제 요청!");
			adService.blindNot();
			break;
		
		case "/susMemberList": //지현
			System.out.println("정지된 회원 리스트 요청!");
			adService.susMemberList();
			break;
			
		case "/susMemberSearch": //지현
			System.out.println("정지된 회원 검색 요청!");
			adService.susMemberSearch();
			break;
			
		case "/memberReport"://지현
			System.out.println("게시글 또는 댓글의 블라인드 버튼 누름");
			postId = req.getParameter("postId");
			currNick = req.getParameter("nickName");
			classification = req.getParameter("classification");
			System.out.println(postId+"/"+currNick+"/"+classification);
			
			req.setAttribute("postId", postId);
			req.setAttribute("nickName", currNick);
			req.setAttribute("classification", classification);
			dis = req.getRequestDispatcher("memberReport.jsp");
			dis.forward(req, resp);
			break; 
			
		case "/reportSth": //지현
			System.out.println("신고 요청");
			msg = "실패";
			
			if(adService.memberReport() > 0) {
				System.out.println("신고 성공!!");
				msg = "신고가 성공적으로 접수되었습니다.";
			}else {
				System.out.println("신고 실패!!");
				msg = "신고가 접수되지 못했습니다.";
			}
			
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher("memberReport.jsp");
			dis.forward(req, resp);

			break;
			
			
			/*-----------------------------------------------------진후----------------------------------------------------------*/		
		
		case "/adminProductList": // 진후		
			System.out.println("상품 리스트 보기 요청");
			page = req.getParameter("page");
			String productId = req.getParameter("productId");
			if (page == null) {
				page = "1";
			}
			HashMap<String, Object> map = AdminService.adminProductList(Integer.parseInt(page), productId);

			req.setAttribute("adminProductList", map.get("adminProductList"));
			req.setAttribute("currPage", map.get("currPage"));
			req.setAttribute("totalPage", map.get("totalPage"));

			dis = req.getRequestDispatcher("/adminProductList.jsp");
			dis.forward(req, resp);
			break;			
			
			
		case "/adminProductSearch": //진후
			System.out.println("관리자 컨트롤러 상품 검색");
			req.setAttribute("adminProductList", adService.adminProductSearch());
			dis = req.getRequestDispatcher("/adminProductList.jsp");
			dis.forward(req, resp);
			break;					
			
		case "/addProduct"://진후
			System.out.println("관리자 컨트롤러 상품 등록 요청");			
			productId = adService.addProduct();
			page = productId != null ? "./productDetail?productId="+productId:"adminProductRegister.jsp";
			resp.sendRedirect(page);
			break;
			
						
		case "/productDetail": //진후
			System.out.println("어드민 컨트롤러 상품 상세보기 요청");	
			req.setAttribute("product", adService.productDetail());
			dis = req.getRequestDispatcher("/adminProductDetail.jsp");
			dis.forward(req, resp);
			break;
			
		case "/productUpdateForm": //진후
			System.out.println("어드민 컨트롤러 상품 수정폼 요청");
			req.setAttribute("product", adService.productUpdateForm());
			dis = req.getRequestDispatcher("/adminProductUpdateForm.jsp");
			dis.forward(req, resp);
			break;
			
		case "/productUpdate": //진후
			System.out.println("어드민 컨트롤 수정 요청");
			productId = req.getParameter("productId");
			System.out.println("productId : "+productId);
			msg = "빈칸이 있습니다.";
			page = "productUpdateForm?productId="+productId;
			if(adService.productUpdate(productId)>0) {
				msg="수정에 성공 했습니다.";
				page = "productDetail?productId="+productId;
			} 
			req.setAttribute("msg", msg);
			dis = req.getRequestDispatcher(page);
			dis.forward(req, resp);
			
			break;
			
		case "/productDel": //진후
			System.out.println("어드민 컨트롤 상품 삭제 요청");
			adService.productDel();
			resp.sendRedirect("./adminProductList");	
			msg ="상품이 삭제 되었습니다.";
			req.setAttribute("msg",msg);		
			break;
			
		case "/adminList": //진후
			System.out.println("전체 관리자 리스트 요청");
			adService.adminList();
			break;
			
		case "/adminSet": //진후
			System.out.println("관리자 지정요청");
			adService.adminSet();
			break;
			
		case "/adminNot": //진후
			System.out.println("관리자 해제요청");
			adService.adminNot();
			break;
	
		case "/adminInfo"://진후
			System.out.println("관리자의 회원정보 상세보기 요청");	
			String userId = req.getParameter("userId");
			System.out.println("받아온 아이디 : "+userId);
			req.setAttribute("member", adService.adminInfo(userId));
			dis = req.getRequestDispatcher("adminInfo.jsp");
			dis.forward(req, resp);
			break;
			
			
		}
		
	}

	
	
	
}
