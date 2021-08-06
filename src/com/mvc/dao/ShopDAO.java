package com.mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/Oracle");
			conn = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void resClose() {
		try {
			if (rs != null && !rs.isClosed()) {
				rs.close();
				System.out.println("rsClose");
			}
			if (ps != null && !ps.isClosed()) {
				ps.close();
				System.out.println("psClose");
			}

			if (conn != null && !conn.isClosed()) {
				conn.close();
				System.out.println("connClose");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public ArrayList<MainDTO> shopList() { // 의건
		String sql = "SELECT productid, productname, price, stock, isdel FROM product ORDER BY productid DESC";
		ArrayList<MainDTO> list = null;
		MainDTO dto = null;

		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			list = new ArrayList<MainDTO>();
			while (rs.next()) {
				dto = new MainDTO();
				dto.setProductId(rs.getString("productid"));
				dto.setProductName(rs.getString("productname"));
				dto.setPrice(rs.getInt("price"));
				dto.setStock(rs.getInt("stock"));
				dto.setIsDel(rs.getString("isdel"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<MainDTO> shopSearch(String keyword) { // 의건
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
				dto.setProductId(rs.getString("productid"));
				dto.setProductName(rs.getString("productname"));
				dto.setPrice(rs.getInt("price"));
				dto.setStock(rs.getInt("stock"));
				dto.setIsDel(rs.getString("isdel"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public MainDTO shopDetail(String productid) { // 의건
		MainDTO dto = null;
		String sql = "SELECT * FROM product WHERE productid = ?";

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, productid);
			rs = ps.executeQuery();

			if (rs.next()) {
				dto = new MainDTO();
				dto.setProductId(rs.getString("productid"));
				dto.setProductName(rs.getString("productname"));
				dto.setPrice(rs.getInt("price"));
				dto.setStock(rs.getInt("stock"));
				dto.setProductDetail(rs.getString("productdetail"));
				dto.setIsDel(rs.getString("isdel"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public MainDTO cartChk(String pId, String uId) {
		System.out.println("상품이 이미 장바구니에 있는지 체크");
		MainDTO dto = null;

		// 장바구니에 담긴 수량 체크
		String sql_pCnt = "SELECT productCount FROM cart WHERE productId = ? AND userId = ?";
		// 상품 재고 체크
		String sql_stock = "SELECT stock FROM product WHERE productId = ?";
		try {
			ps = conn.prepareStatement(sql_pCnt);
			ps.setString(1, pId);
			ps.setString(2, uId);
			rs = ps.executeQuery();
			dto = new MainDTO();
			if (rs.next()) {
				dto.setProductCount(rs.getInt("productCount"));
			}

			ps = conn.prepareStatement(sql_stock);
			ps.setString(1, pId);
			rs = ps.executeQuery();
			if (rs.next()) {
				dto.setStock(rs.getInt("stock"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public MainDTO cartChk(String pId) {
		System.out.println("재고보다 더 많은 수량을 선택하는지 확인");
		MainDTO dto = null;

		// 상품 재고 체크
		String sql = "SELECT stock FROM product WHERE productId = ?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, pId);
			rs = ps.executeQuery();
			dto = new MainDTO();
			if (rs.next()) {
				dto.setStock(rs.getInt("stock"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public ArrayList<MainDTO> cartList(String uId) {
		String sql = "SELECT productcount, totalprice, productid, userid, productName, price FROM cart where userid = ?";
		ArrayList<MainDTO> list = null;
		MainDTO dto = null;

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, uId);
			rs = ps.executeQuery();
			list = new ArrayList<MainDTO>();
			while (rs.next()) {
				dto = new MainDTO();
				dto.setProductName(rs.getString("productName"));
				dto.setPrice(rs.getInt("price"));
				dto.setProductCount(rs.getInt("productcount"));
				dto.setTotalPrice(rs.getInt("totalprice"));
				dto.setProductId(rs.getString("productId"));
				dto.setUserId(rs.getString("userid"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(list.size());
		return list;
	}

	public int cartAdd(String tPrice, String pPrice, String pId, String uId, String pCnt, String pName) {
		System.out.println("장바구니에 담기");
		// 장바구니 확인
		String sql = "SELECT productId FROM cart WHERE productId = ? AND userId = ?";
		// 장바구니에 같은 상품이 없을 때
		String sql_insert = "INSERT INTO cart VALUES (?,?,?,?,?,?)";
		// 장바구니에 같은 상품이 있을 때
		String sql_update = "UPDATE cart SET totalPrice = totalPrice + ?, productCount = productCount + ? WHERE productId = ? AND userId = ?";

		int success = 0;
		try {
			System.out.println("장바구니에 이미 담겼는지 확인");
			ps = conn.prepareStatement(sql);
			ps.setString(1, pId);
			ps.setString(2, uId);
			rs = ps.executeQuery();
			if (rs.next()) {
				System.out.println("이미 담겨 있으면 수량 수정");
				ps = conn.prepareStatement(sql_update);
				ps.setString(1, tPrice);
				ps.setString(2, pCnt);
				ps.setString(3, pId);
				ps.setString(4, uId);
				success = ps.executeUpdate();
			} else {
				System.out.println("담겨있지 않으면 장바구니에 추가");
				ps = conn.prepareStatement(sql_insert);
				ps.setString(1, tPrice);
				ps.setString(2, pId);
				ps.setString(3, uId);
				ps.setString(4, pCnt);
				ps.setString(5, pName);
				ps.setString(6, pPrice);
				success = ps.executeUpdate();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return success;
	}

	public int cartModify(String pId, String pCnt, String uId) {
		String sql = "SELECT price FROM product WHERE productId = ?";
		String sql_update = "UPDATE cart SET totalPrice = ?, productCount = ? WHERE productId = ? AND userId = ?";

		MainDTO dto = new MainDTO();
		int success = 0;
		int pPrice = 0;
		int tPrice = 0;
		String s_tPrice = "";
		try {
			System.out.println("장바구니에서 수량 수정");
			ps = conn.prepareStatement(sql);
			ps.setString(1, pId);
			rs = ps.executeQuery();
			if (rs.next()) {
				dto.setPrice(rs.getInt("price"));
				pPrice = dto.getPrice();
				tPrice = Integer.parseInt(pCnt) * pPrice;
				s_tPrice = Integer.toString(tPrice);

				ps = conn.prepareStatement(sql_update);
				ps.setString(1, s_tPrice);
				ps.setString(2, pCnt);
				ps.setString(3, pId);
				ps.setString(4, uId);
				success = ps.executeUpdate();
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return success;
	}

	public int cartDel(String uId, String[] delList) throws SQLException {
		String sql = "DELETE FROM cart WHERE productid = ? AND uId = ?";
		int cnt = 0;
		for (String productId : delList) {
			ps = conn.prepareStatement(sql);
			ps.setString(1, productId);
			ps.setString(2,  uId);
			cnt += ps.executeUpdate();
		}
		return cnt;
	}

	public ArrayList<MainDTO> paymentList(String uId, String[] orderList) {
		//장바구니에서 선택해서 주문
		String sql = "SELECT productcount, totalprice, productId, userid, productname, price FROM cart WHERE productid = ? AND userId = ?";
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		MainDTO dto = null;

		for (String productId : orderList) {
			try {
				ps = conn.prepareStatement(sql);
				ps.setString(1, productId);
				ps.setString(2, uId);
				rs = ps.executeQuery();
				while (rs.next()) {
					dto = new MainDTO();
					dto.setProductCount(rs.getInt("productcount"));
					dto.setTotalPrice(rs.getInt("totalprice"));
					dto.setProductId(rs.getString("productId"));
					dto.setPrice(rs.getInt("price"));
					dto.setUserId(rs.getString("userid"));
					dto.setProductName(rs.getString("productname"));
					System.out.println(dto.getProductName());
					list.add(dto);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		System.out.println(list.size());
		return list;
	}

	public MainDTO memberDetail(String uId) {
		MainDTO dto = null;

		String sql = "SELECT m.name name, m.address address , m.tel tel, r.discount discount FROM rank r, member m WHERE r.rankid = m.rankid and m.userid = ?";

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, uId);
			rs = ps.executeQuery();

			if (rs.next()) {
				dto = new MainDTO();
				dto.setName(rs.getString("name"));
				dto.setAddress(rs.getString("address"));
				dto.setTel(rs.getString("tel"));
				dto.setDiscount(rs.getInt("discount"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public MainDTO payment(String uId, int resultPrice, int orderPrice, int discount) {
		String sql_insert = "INSERT INTO payment(paymentId, orderPrice, paymentPrice, userId, discount) VALUES (paymentId_seq.NEXTVAL,?,?,?,?)";
		//payment에 주문한 상품 추가
		String sql_paymentid = "SELECT paymentId FROM payment WHERE userId = ? AND orderPrice = ? AND paymentPrice = ?";
		//생성된 paymentId 가져오기

		MainDTO dto = null;

		try {
			ps = conn.prepareStatement(sql_insert);
			ps.setInt(1, orderPrice);
			ps.setInt(2, resultPrice);
			ps.setString(3, uId);
			ps.setInt(4, discount);

			if (ps.executeUpdate() > 0) {
				ps = conn.prepareStatement(sql_paymentid);
				ps.setString(1, uId);
				ps.setInt(2, orderPrice);
				ps.setInt(3, resultPrice);

				rs = ps.executeQuery();
				if (rs.next()) {
					dto = new MainDTO();
					dto.setPaymentId((rs.getString("paymentId")));
				}
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return dto;
	}

	public ArrayList<MainDTO> payCart(String uId, String[] productList, String paymentId) {
		String sql = "SELECT productName, productId, productCount, price FROM cart WHERE productId = ? AND userId = ?";
		
		String sql_del = "DELETE FROM cart WHERE productId = ? AND userId = ?";
		
		String sql_order = "INSERT INTO orderHistory (productName, productCnt, price, paymentId, productId) VALUES (?,?,?,?,?)";
		String sql_product = "UPDATE product SET stock = stock - ? WHERE productId = ?"; 
		
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		MainDTO dto = null;
		int del = 0;
		int cnt = 0;
		int stock = 0;

		//주문해서 주문내역에 먼저 넣고 그다음에 카트 체크
		for (String productId : productList) {
			try {
				ps = conn.prepareStatement(sql);//장바구니에서 주문했으면
				ps.setString(1, productId);
				ps.setString(2, uId);
				rs = ps.executeQuery();
				while (rs.next()) { //장바구니에서 주문한 상품들 정보 가져옴
					dto = new MainDTO();
					dto.setProductId(rs.getString("productId"));
					dto.setProductCount(rs.getInt("productCount"));
					dto.setPrice(rs.getInt("price"));
					dto.setProductName(rs.getString("productName"));

					list.add(dto);
					
					
					ps = conn.prepareStatement(sql_order); //장바구니에서 주문한 상품들 정보   주문 내역에 추가
					ps.setString(1, dto.getProductName());
					ps.setInt(2, dto.getProductCount());
					ps.setInt(3, dto.getPrice());
					ps.setString(4, paymentId);
					ps.setString(5,  dto.getProductId());
					cnt += ps.executeUpdate();
					
					ps = conn.prepareStatement(sql_product);
					ps.setInt(1, dto.getProductCount());
					ps.setString(2,  dto.getProductId());
					stock += ps.executeUpdate();
					
				}

			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		System.out.println("리스트사이즈 : " + list.size());
		System.out.println("오더리스트 크기 : " + productList.length);
		if (list.size() == productList.length) {//장바구니에서 주문했으면 장바구니에서 해당 내용 삭제
			System.out.println("삭제");
			for (String productId : productList) {
				try {
					ps = conn.prepareStatement(sql_del);
					ps.setString(1, productId);
					ps.setString(2, uId);
					del += ps.executeUpdate();

				} catch (SQLException e) {
					e.printStackTrace();
				}

			}
			System.out.println("삭제된 개수 : " + del);

		}
		System.out.println("오더 : " + cnt);
		System.out.println("수량수정 : " + stock);
		
		return list;
	}

	

}
