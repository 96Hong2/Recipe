package com.mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.mvc.dto.MainDTO;

public class ShopDAO {
	
	PreparedStatement ps = null;
	ResultSet rs = null;
	Connection conn = null;
	String sql = "";
	public ShopDAO() {
		Context ctx;
		try {
			ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Oracle");
			conn = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void resClose() {
		try {
			if(rs != null && !rs.isClosed()) {rs.close();
			System.out.println("rs close");}
			if(ps != null && !ps.isClosed()) {ps.close();
			System.out.println("ps close");}
			
			if(conn != null && !conn.isClosed()) {conn.close();
			System.out.println("conn close");}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<MainDTO> list() { //의건
		String sql = "SELECT productid, productname, price, stock, isdel FROM product ORDER BY productid DESC";
		ArrayList<MainDTO> list = null;
		MainDTO dto = null;

		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			list = new ArrayList<MainDTO>();
			while (rs.next()) {
				dto = new MainDTO();
				dto.setProductid(rs.getString("productid"));
				dto.setProductname(rs.getString("productname"));
				dto.setPrice(rs.getInt("price"));
				dto.setStock(rs.getInt("stock"));
				dto.setIsdel(rs.getString("isdel"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<MainDTO> list(String keyword) { //의건
		String sql = "SELECT productid, productname, price, stock, isdel FROM product WHERE productname LIKE ?";
		ArrayList<MainDTO> list = null;
		MainDTO dto = null;
		String keywords = '%' + keyword + '%';
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, keywords);
			rs = ps.executeQuery();
			list = new ArrayList<MainDTO>();
			while (rs.next()) {
				dto = new MainDTO();
				dto.setProductid(rs.getString("productid"));
				dto.setProductname(rs.getString("productname"));
				dto.setPrice(rs.getInt("price"));
				dto.setStock(rs.getInt("stock"));
				dto.setIsdel(rs.getString("isdel"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public MainDTO detail(String productid) { //의건
		MainDTO dto = null;
		String sql = "SELECT * FROM product WHERE productid = ?";
		
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, productid);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				dto = new MainDTO();
				dto.setProductid(rs.getString("productid"));
				dto.setProductname(rs.getString("productname"));
				dto.setPrice(rs.getInt("price"));
				dto.setStock(rs.getInt("stock"));
				dto.setProductdetail(rs.getString("productdetail"));
				dto.setIsdel(rs.getString("isdel"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public ArrayList<MainDTO> cartlist() {
		String sql = "SELECT productnumber, totalprice, productid, userid FROM cart";
		ArrayList<MainDTO> list = null;
		MainDTO dto = null;

		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			list = new ArrayList<MainDTO>();
			while (rs.next()) {
				dto = new MainDTO();
				dto.setProductnumber(rs.getInt("productnumber"));
				dto.setTotalprice(rs.getInt("totalprice"));
				dto.setProductid(rs.getString("productid"));
				dto.setUserid(rs.getString("userid"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("cartlist");
		return list;
	}
}
