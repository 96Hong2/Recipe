package com.mvc.service;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class PhotoService {
	HttpServletRequest req = null;
	HttpServletResponse resp = null;
	public PhotoService(HttpServletRequest req, HttpServletResponse resp) {
		this.req = req;
		this.resp = resp;
		try {
			req.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
	
	public void method1() { //은홍
		System.out.println("PhotoService method1() 들어옴");
	}

}
