package com.mvc.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mvc.dto.MainDTO;
import com.mvc.service.ShopService;

@WebServlet({ "/shop", "/detail", "/cart", "/search" })
public class ShopController extends HttpServlet {

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
		System.out.println("URI : " + addr);

		ShopService service = new ShopService(req, resp);

		MainDTO dto = null;
		RequestDispatcher dis = null;
		String page = "";
		String msg = "";
		boolean success = false;
		int result = 0;

		switch (addr) {
		case "/shop": // 의건
			System.out.println("쇼핑몰 페이지");
			req.setAttribute("shop", service.shop());
			dis = req.getRequestDispatcher("shop.jsp");
			dis.forward(req, resp);
			break;

		case "/search": //의건
			System.out.println("검색하기");
			req.setAttribute("shop", service.search());
			dis = req.getRequestDispatcher("shop.jsp");
			dis.forward(req, resp);
			break;
		
		
		case "/detail": //의건
			System.out.println("상품 상세보기");
			req.setAttribute("product", service.detail());
			dis = req.getRequestDispatcher("detail.jsp");
			dis.forward(req, resp);
			break;

		case "/cart": //의건
			System.out.println("장바구니 페이지");
			req.setAttribute("list", service.cartlist());
			dis = req.getRequestDispatcher("cart.jsp");
			dis.forward(req, resp);
			break;
		}
	}

}
