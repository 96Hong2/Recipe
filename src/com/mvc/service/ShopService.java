package com.mvc.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

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
		System.out.println("shopDetail_dto_check : " + dto);
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
		String uId = (String) req.getSession().getAttribute("userId");
		System.out.println("장바구니에 담을 회원 : " + uId);
		System.out.println("장바구니에 담을 상품 : " + pId + "/" + pName + "/" + pPrice + "/" + pCnt + "/" + tPrice);

		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();

		int success = 0;

		MainDTO dto = dao.cartChk(pId, uId);

		System.out.println("addCart_dto_check : " + dto);
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

		dao.resClose();
		resp.getWriter().print(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public void cartDel() throws IOException { // 의건
		String uId = (String) req.getSession().getAttribute("userId");
		String[] delList = req.getParameterValues("delList[]");
		System.out.println("장바구니 삭제할 회원 : " + uId);
		System.out.println("장바구니에서 삭제할 상품 개수" + delList.length);

		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();

		try {
			int cnt = dao.cartDel(uId, delList);
			System.out.println("삭제 완료 개수 : " + delList.length + "개 중" + cnt + "개 삭제");
			map.put("cnt", cnt);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dao.resClose();
		}

		resp.getWriter().println(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public void cartModify() throws IOException {
		String pId = (String) req.getSession().getAttribute("pId");
		String pCnt = (String) req.getSession().getAttribute("pCnt");
		String uId = (String) req.getSession().getAttribute("userId");

		System.out.println("수정할 회원 : " + uId);
		System.out.println("수정할 상품 : " + pId + "/" + pCnt);
		ShopDAO dao = new ShopDAO();
		MainDTO dto = dao.cartChk(pId);

		System.out.println("cartModify_dto_check : " + dto);

		HashMap<String, Object> map = new HashMap<String, Object>();

		int success = 0;

		if (Integer.parseInt(pCnt) > dto.getStock()) {
			success = -1;
			map.put("success", success);

		} else {
			success = dao.cartModify(pId, pCnt, uId);
			map.put("success", success);
		}
		System.out.println("장바구니 수량 수정_1이면 성공 -1이면 실패 : " + success);
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
		String uId = (String) req.getSession().getAttribute("userId");
		ShopDAO dao = new ShopDAO();
		MainDTO dto = null;

		System.out.println("장바구니 확인 회원 : " + uId);
		ArrayList<MainDTO> cartList = dao.cartList(uId);
		System.out.println("장바구니에 담긴 물건 개수: " + cartList.size());
		dto = dao.memberDetail(uId);
		System.out.println("회원 등급 할인 % : " + dto.getDiscount());
		System.out.println("cartList_check_dto : " + dto);

		dao.resClose();
		map.put("cartList", cartList);
		map.put("member", dto.getDiscount());

		resp.setContentType("text/html; charset=UTF-8");
		resp.getWriter().println(new Gson().toJson(map));
		System.out.println("-----------------------------");
	}

	public ArrayList<MainDTO> order() throws IOException { // 의건
		String uId = (String) req.getSession().getAttribute("userId");
		System.out.println("주문한 회원 : " + uId);

		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();
		ArrayList<MainDTO> list = null;

		System.out.println("장바구니에서 주문");
		String[] orderList = req.getParameterValues("orderList[]");
		System.out.println("앞에서__" + orderList.length);
		list = dao.paymentList(uId, orderList);
		System.out.println("주문 개수 : " + list.size());
		map.put("cnt", list.size());

		resp.getWriter().println(new Gson().toJson(map));
		dao.resClose();
		System.out.println("-----------------------------");
		return list;
	}

	public ArrayList<MainDTO> order(String pId, String pName, String pPrice, String pCnt, String tPrice,
			String imgNewName) throws IOException {

		String uId = (String) req.getSession().getAttribute("userId");
		System.out.println("주문한 회원 : " + uId);

		MainDTO dto = null;
		ShopDAO dao = new ShopDAO();
		HashMap<String, Object> map = new HashMap<String, Object>();
		ArrayList<MainDTO> list = null;

		System.out.println("상품 페이지에서 주문");
		dto = new MainDTO();
		list = new ArrayList<MainDTO>();
		dto.setProductId(pId);
		dto.setProductName(pName);
		dto.setPrice(Integer.parseInt(pPrice));
		dto.setProductCount(Integer.parseInt(pCnt));
		dto.setTotalPrice(Integer.parseInt(tPrice));
		dto.setImgNewName(imgNewName);
		System.out.println(dto.getProductId() + "/" + dto.getProductName() + "/" + dto.getPrice() + "/"
				+ dto.getProductCount() + "/" + dto.getPrice() + "/" + dto.getImgNewName());
		list.add(dto);

		resp.getWriter().println(new Gson().toJson(map));
		dao.resClose();
		System.out.println("-----------------------------");
		return list;
	}

	public void payment() throws IOException {
		String[] orderList = req.getParameterValues("orderList[]");
		String uId = (String) req.getSession().getAttribute("userId");
		int size = orderList.length;
		
		ShopDAO dao = new ShopDAO();
		ArrayList<MainDTO> list = null;
		String[] productList = new String[(size - 3) / 3];
		String[] countList = new String[(size - 3) / 3];
		String[] priceList = new String[(size - 3) / 3];
		String paymentId = "";
		boolean success = false;
		HashMap<String, Object> map = new HashMap<String, Object>();

		int resultPrice = Integer.parseInt(orderList[size - 3]);
		int orderPrice = Integer.parseInt(orderList[size - 2]);
		int discount = Integer.parseInt(orderList[size - 1]);

		System.out.println("여기" + size);
		for (int i = 0; i < size - 3; i++) {
			// 0 1 2 3 4 5 6 7 8
			// size 9
			if (i < (size - 3) / 3) { // i<3
				productList[i] = orderList[i];
				System.out.println("productList : " + productList[i]);

			} else if ((size - 3) / 3 <= i && i < ((size - 3) / 3) * 2) { // 3 <= i, i<6
				countList[i - (size - 3) / 3] = orderList[i];
				System.out.println("stockList : " + countList[i - (size - 3) / 3]);
			} else {
				priceList[i - ((size - 3) / 3) * 2] = orderList[i];
				System.out.println("priceList : " + priceList[i - ((size - 3) / 3) * 2]);
			}
		}

		success = dao.productChk(productList, countList);
		if (success) {
			System.out.println(resultPrice);
			System.out.println(orderPrice);
			System.out.println(discount);
			paymentId = dao.payment(uId, resultPrice, orderPrice, discount);
			System.out.println("생성된 paymentId : " + paymentId);

			int use = resultPrice;

			System.out.println("사용금액 : " + use + " 원, userId : " + uId);
			int result = dao.changeCash(-use, uId);
			System.out.println("???__" + result);

			list = dao.payCart(uId, productList, countList, paymentId);

			if (result * list.size() > 0) {
				success = true;
			} else {
				success = false;
			}
		}
		map.put("success", success);
		dao.resClose();
		resp.getWriter().print(new Gson().toJson(map));
		System.out.println("-----------------------------");

	}

	public MainDTO memberDetail() {
		String uId = (String) req.getSession().getAttribute("userId");
		System.out.println("주문 페이지에 정보 넣을 회원 : " + uId);
		MainDTO dto = null;

		ShopDAO dao = new ShopDAO();

		dto = dao.memberDetail(uId);
		System.out.println("memberDetail_check_dto :" + dto);
		dao.resClose();
		System.out.println("-----------------------------");
		return dto;
	}

}
