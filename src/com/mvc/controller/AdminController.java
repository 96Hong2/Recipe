package com.mvc.controller;

import java.io.IOException;
import java.util.ArrayList;

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
	"/susMemberList","/susMemberSearch","/reportSth","/memberReport"})
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
		}
		
	}

	
	
	
}
