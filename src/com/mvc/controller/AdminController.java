package com.mvc.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dto.MainDTO;
import com.mvc.service.MemberService;

@WebServlet({"/Example1"})
public class AdminController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dual(req, resp);
	}


	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dual(req, resp);
	}
	
	private void dual(HttpServletRequest req, HttpServletResponse resp) {
		String uri = req.getRequestURI();
		String context = req.getContextPath();
		String addr = uri.substring(context.length());
		System.out.println("URI : "+addr);
		
		MemberService service = new MemberService(req, resp);
		MainDTO dto = null;
		RequestDispatcher dis = null;
		String page = "";
		String msg = "";
		boolean success = false;
		int result = 0;
		
		switch(addr) {
		case "/": //은홍
			System.out.println("-- 메인 페이지 보기 요청 --");
		break;
		}
	}
	
}
