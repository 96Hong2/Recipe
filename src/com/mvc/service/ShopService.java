package com.mvc.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.mvc.dao.ShopDAO;
import com.mvc.dto.MainDTO;

public class ShopService {
	HttpServletRequest req = null;
	HttpServletResponse resp = null;

	public ShopService(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
		try {
			req.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	public ArrayList<MainDTO> shop() { // 의건

		ShopDAO dao = new ShopDAO();
		ArrayList<MainDTO> shopList = dao.shopList();
		System.out.println("상품 개수 : " + shopList.size());
		dao.resClose();
		System.out.println("-----------------------------");
		return shopList;
	}

	public MainDTO shopDetail() { // 의건
		MainDTO dto = null;
		String productId = req.getParameter("productId");
		ShopDAO dao = new ShopDAO();
		dto = dao.shopDetail(productId);
		System.out.println("shopDetail_dto : " + dto);
		System.out.println(productId + "_상품 상세보기");
		dao.resClose();
		System.out.println("-----------------------------");
		return dto;
	}

	public ArrayList<MainDTO> shopSearch() { // 의건
		String shopKeyword = req.getParameter("shopKeyword");
		System.out.println(shopKeyword + "_로 쇼핑몰 상품 검색");
		ShopDAO dao = new ShopDAO();

		ArrayList<MainDTO> list = dao.shopSearch(shopKeyword);
		System.out.println("검색된 상품 개수 : " + list.size());
		System.out.println("-----------------------------");
		dao.resClose();
		return list;
	}

	public void cartAdd() throws IOException { // 의건
		String pId = (String) req.getSession().getAttribute("pId");
		String pName = (String) req.getSession().getAttribute("pName");
		String pPrice = (String) req.getSession().getAttribute("pPrice");
		String pCnt = (String) req.getSession().getAttribute("pCnt");
		String tPrice = (String) req.getSession().getAttribute("tPrice");
		String uId = (String) req.getSession().getAttribute("userLoginId");
		System.out.println(pId + "/" + pName + "/" + pPrice + "/" + pCnt + "/" + tPrice);

		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();

		int success = 0;
		MainDTO dto = dao.cartChk(pId, uId);
		
		System.out.println("addCart_dto : " + dto);
		System.out.println(uId);
		System.out.println("이미 담긴 상품의 개수 : " + dto.getProductCount());
		System.out.println("새로 담을 상품의 개수 : " + Integer.parseInt(pCnt));
		System.out.println("상품 재고 : " + dto.getStock());
		if (dto.getProductCount() + Integer.parseInt(pCnt) > dto.getStock()) {
			success = -1;
			map.put("success", success);

		} else {
			success = dao.cartAdd(tPrice, pPrice, pId, uId, pCnt, pName);
			map.put("success", success);
		}
		System.out.println("장바구니 담기_1이면 성공 -1이면 실패 : " + success);
		if (pId != null)
			req.getSession().removeAttribute("pId");
		if (pName != null)
			req.getSession().removeAttribute("pName");
		if (pPrice != null)
			req.getSession().removeAttribute("pPrice");
		if (tPrice != null)
			req.getSession().removeAttribute("tPrice");
		if (pCnt != null)
			req.getSession().removeAttribute("pCnt");
		if (pPrice != null)
			req.getSession().removeAttribute("pCnt");

		dao.resClose();
		resp.getWriter().print(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public void cartDel() throws IOException { // 의건
		String[] delList = req.getParameterValues("delList[]");
		System.out.println("카트에서 삭제할 상품 개수" + delList.length);

		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();

		try {
			int cnt = dao.cartDel(delList);
			System.out.println("삭제 개수 : " + delList.length + "개 중" + cnt + "개 삭제");
			map.put("cnt", cnt);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dao.resClose();
		}

		resp.getWriter().println(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public void payment() {
		String[] orderList = req.getParameterValues("orderList[]");
		String uId = (String) req.getSession().getAttribute("userLoginId");
		int size = orderList.length;
		ShopDAO dao = new ShopDAO();
		ArrayList<MainDTO> list = null;
		String[] productList = new String[size-3];
		MainDTO dto = null;
		
		int resultPrice = Integer.parseInt(orderList[size-3]);
		int orderPrice = Integer.parseInt(orderList[size-2]);
		int discount = Integer.parseInt(orderList[size-1]); 
		int success = 0;
		
		for (int i = 0; i < orderList.length-3; i++) {
			productList[i] = orderList[i];
			System.out.println("productList : " + productList[i]);
		}
		System.out.println(resultPrice);
		System.out.println(orderPrice);
		System.out.println(discount);
		dto = dao.payment(uId, resultPrice, orderPrice, discount);
		
		
		String paymentId = dto.getPaymentId();
		System.out.println("생성된 paymentId : " + paymentId);
		
		list = dao.payCart(uId, productList, paymentId);
		
		System.out.println(list.size());
		
	}

	public void cartModify() throws IOException {
		String pId = (String) req.getSession().getAttribute("pId");
		String pCnt = (String) req.getSession().getAttribute("pCnt");
		String uId = (String) req.getSession().getAttribute("userLoginId");

		System.out.println(pId + "/" + pCnt + "/" + uId);
		ShopDAO dao = new ShopDAO();
		MainDTO dto = dao.cartChk(pId);

		HashMap<String, Object> map = new HashMap<String, Object>();

		int success = 0;

		if (Integer.parseInt(pCnt) > dto.getStock()) {
			success = -1;
			System.out.println("수량체크" + success);
			map.put("success", success);

		} else {
			success = dao.cartModify(pId, pCnt, uId);
			map.put("success", success);
		}
		System.out.println("장바구니 수정_1이면 성공 -1이면 실패 : " + success);
		if (pId != null)
			req.getSession().removeAttribute("pId");
		if (pCnt != null)
			req.getSession().removeAttribute("pCnt");

		dao.resClose();
		resp.getWriter().print(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public void cartList() throws IOException { // 의건
		HashMap<String, Object> map = new HashMap<String, Object>();
		String uId = (String) req.getSession().getAttribute("userLoginId");
		ShopDAO dao = new ShopDAO();
		MainDTO dto = new MainDTO();

		ArrayList<MainDTO> cartList = dao.cartList(uId);
		System.out.println("장바구니에 담긴 물건 개수: " + cartList.size());
		dto = dao.memberDetail(uId);

		dao.resClose();
		map.put("cartList", cartList);
		map.put("member", dto.getDiscount());
		System.out.println(dto.getDiscount());

		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public ArrayList<MainDTO> order() throws IOException { // 의건
		String pId = (String) req.getSession().getAttribute("pId");
		String pName = (String) req.getSession().getAttribute("pName");
		String pPrice = (String) req.getSession().getAttribute("pPrice");
		String pCnt = (String) req.getSession().getAttribute("pCnt");
		String tPrice = (String) req.getSession().getAttribute("tPrice");
		String uId = (String) req.getSession().getAttribute("userLoginId");
		System.out.println(pId + "/" + pName + "/" + pPrice + "/" + pCnt + "/" + tPrice);

		MainDTO dto = null;
		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();
		ArrayList<MainDTO> list = null;
		if (pId == null) { // 장바구니에서 주문할 때
			String[] orderList = req.getParameterValues("orderList[]");
			System.out.println("앞에서__" + orderList.length);
			list = dao.paymentList(uId, orderList);
			System.out.println("주문 개수 : " + orderList.length);
			System.out.println(list);
			System.out.println(list.size());
			map.put("cnt", list.size());
		} else { // 상품 페이지에서 주문할 때
			dto = new MainDTO();
			list = new ArrayList<MainDTO>();
			dto.setProductId(pId);
			dto.setProductName(pName);
			dto.setPrice(Integer.parseInt(pPrice));
			dto.setProductCount(Integer.parseInt(pCnt));
			dto.setTotalPrice(Integer.parseInt(tPrice));
			list.add(dto);
		}

		resp.getWriter().println(new Gson().toJson(map));
		dao.resClose();
		System.out.println("-----------------------------");
		return list;
	}

	public MainDTO memberDetail() {
		String uId = (String) req.getSession().getAttribute("userLoginId");
		MainDTO dto = null;

		ShopDAO dao = new ShopDAO();

		dto = dao.memberDetail(uId);
		System.out.println("memberDetail : " + dto);
		System.out.println(uId + "_정보 불러오기");
		dao.resClose();
		System.out.println("-----------------------------");
		return dto;
	}

}
