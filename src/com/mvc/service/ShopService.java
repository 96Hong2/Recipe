package com.mvc.service;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
	
	public ArrayList<MainDTO> shop() { //의건
		
		ShopDAO dao = new ShopDAO();
		ArrayList<MainDTO> list = dao.list();
		System.out.println("상품 개수 : " + list.size());
		dao.resClose();
		System.out.println("-----------------------------");
		return list;
	}
	public MainDTO detail() { //의건
		MainDTO dto = null;
		String productid = req.getParameter("productid");
		ShopDAO dao = new ShopDAO();
		dto = dao.detail(productid);
		System.out.println(productid + "_상품 상세보기");
		dao.resClose();
		System.out.println("-----------------------------");
		return dto;
	}

	
	public ArrayList<MainDTO> search() { //의건
		String keyword = req.getParameter("keyword");
		System.out.println("검색한 키워드 : " + keyword);
		ShopDAO dao = new ShopDAO();
		
		ArrayList<MainDTO> list = dao.list(keyword);
		System.out.println("검색된 상품 개수 : " + list.size());
		System.out.println("-----------------------------");
		dao.resClose();
		return list;
	}
	
	public ArrayList<MainDTO> cartlist() { //의건

		ShopDAO dao = new ShopDAO();
		ArrayList<MainDTO> cartlist = dao.cartlist();
		System.out.println("장바구니에 담긴 물건 개수: " + cartlist.size());
		dao.resClose();
		System.out.println("-----------------------------");
		return cartlist;
	}


}
