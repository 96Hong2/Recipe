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
import com.mvc.service.ShopService;

@WebServlet({ "/shop", "/shopDetail", "/cart", "/shopSearch", "/cartAdd", "/order", "/cartDel", "/cartModify",
		"/orderList", "/payment" })
public class ShopController extends HttpServlet {

	private static final long serialVersionUID = 1L;

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
		HashMap<String, Object> map = new HashMap<String, Object>();

		MainDTO dto = null;
		RequestDispatcher dis = null;
		String page = "";
		String msg = "";
		boolean success = false;
		int result = 0;

		String pId = "";
		String pCnt = "";
		String pPrice = "";
		String pName = "";
		String tPrice = "";

		switch (addr) {

		case "/shop": // 의건
			System.out.println("쇼핑몰 페이지");
			req.setAttribute("shop", service.shop());
			dis = req.getRequestDispatcher("shop.jsp");
			dis.forward(req, resp);
			break;

		case "/shopSearch": // 의건
			System.out.println("검색하기");
			req.setAttribute("shop", service.shopSearch());
			dis = req.getRequestDispatcher("shop.jsp");
			dis.forward(req, resp);
			break;

		case "/shopDetail": // 의건
			System.out.println("상품 상세보기");
			req.setAttribute("product", service.shopDetail());
			dis = req.getRequestDispatcher("detail.jsp");
			dis.forward(req, resp);
			break;

		case "/cart": // 의건
			System.out.println("장바구니 페이지");
			service.cartList();
			break;

		case "/cartDel":
			System.out.println("장바구니 삭제 요청");
			service.cartDel();
			break;

		case "/cartAdd":
			System.out.println("카드 담기 페이지");
			pId = req.getParameter("pId");
			pName = req.getParameter("pName");
			pPrice = req.getParameter("pPrice");
			pCnt = req.getParameter("pCnt");
			tPrice = req.getParameter("tPrice");
			req.getSession().setAttribute("pId", pId);
			req.getSession().setAttribute("pName", pName);
			req.getSession().setAttribute("pPrice", pPrice);
			req.getSession().setAttribute("pCnt", pCnt);
			req.getSession().setAttribute("tPrice", tPrice);
			service.cartAdd();
			break;
			
		case "/cartModify":
			System.out.println("장바구니 수정 요청");
			pId = req.getParameter("pId");
			pCnt = req.getParameter("pCnt");
			req.getSession().setAttribute("pId", pId);
			req.getSession().setAttribute("pCnt", pCnt);
			service.cartModify();
			break;
			
		case "/order":
			System.out.println("주문 버튼 클릭");
			pId = req.getParameter("pId");
			pName = req.getParameter("pName");
			pPrice = req.getParameter("pPrice");
			pCnt = req.getParameter("pCnt");
			tPrice = req.getParameter("tPrice");
			String imgNewName = req.getParameter("imgName");
			
			if(pId == null) {
				req.getSession().setAttribute("paymentList", service.order());
			} else {
				req.getSession().setAttribute("paymentList", service.order(pId, pName, pPrice, pCnt, tPrice, imgNewName));
			}
			// dis = req.getRequestDispatcher("orderList.jsp");
			// dis.forward(req, resp);
			break;

		case "/orderList":
			System.out.println("주문 페이지로 이동");
			req.setAttribute("member", service.memberDetail());
			req.setAttribute("list", req.getSession().getAttribute("paymentList"));
			dis = req.getRequestDispatcher("orderList.jsp");
			dis.forward(req, resp);
			break;

		case "/payment":
			System.out.println("결제");
			service.payment();
			break;

		}
	}

}
