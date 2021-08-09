package com.mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.mvc.dto.MainDTO;

public class AdminDAO {
	
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	String sql = "";
	
	public AdminDAO() {
		Context ctx;
		try {
			ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/Oracle");
			conn = ds.getConnection();
			System.out.println("커넥션 상황 : "+conn);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void resClose() {

		try {
			if(rs != null && !rs.isClosed()) {
				rs.close();
				System.out.println("rs 닫혔는지 확인 : "+rs.isClosed());
			}
			if(ps != null && !ps.isClosed()) {
				ps.close();
				System.out.println("ps 닫혔는지 확인 : "+ps.isClosed());
			}
			if(conn != null && !conn.isClosed()) {
				conn.close();
				System.out.println("커넥션 닫혔는지 확인 : "+conn.isClosed());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public ArrayList<MainDTO> memberList() throws SQLException{ //지현
		sql = "SELECT userid, nickname, name, rankid FROM member WHERE userdel = ?";
		String sql2 = "SELECT userid FROM suspend WHERE userid= ?";
		ArrayList<MainDTO> memberList = new ArrayList<MainDTO>();

			ps = conn.prepareStatement(sql);
			ps.setString(1, "N");
			rs = ps.executeQuery();
			ResultSet rs2 = null;
			PreparedStatement ps2 = null;
			
			while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setUserId( rs.getString("userid"));
				dto.setNickname(rs.getString("nickname"));
				dto.setName(rs.getString("name"));
				dto.setRankId(rs.getString("rankid"));
					ps2 = conn.prepareStatement(sql2);
					ps2.setString(1, rs.getString("userid"));
					rs2 = ps2.executeQuery();
					if(rs2.next()) {
						dto.setUserSus("Y");
					}else {
						dto.setUserSus("N");
					}
				memberList.add(dto);
			}
			
			/* while(rs.next()) {
				MainDTO dto = new MainDTO();
				String usersus = rs.getString("userid");
				if(userid == usersus) {
					dto.setUserSus("Y");
					memberList.add(dto);
				}else {
					dto.setUserSus("N");
					memberList.add(dto);
				}
			} */
			
			return memberList;
	}

	public ArrayList<MainDTO> memberSearch(String options, String content) throws SQLException{ //지현
		sql = "SELECT userid, nickname, name, rankid FROM member WHERE ";

		ArrayList<MainDTO> searchList = new ArrayList<MainDTO>();	
		
		String keywords = '%' + content + '%';

		/*
		 * ps = conn.prepareStatement(sql); ps.setString(1, "admin"); rs =
		 * ps.executeQuery(); while(rs.next()) { System.out.println("while문 실행중...");
		 * MainDTO dto = new MainDTO(); dto.setUserId(rs.getString("userid"));
		 * dto.setNickname(rs.getString("nickname")); dto.setName(rs.getString("name"));
		 * dto.setRankId(rs.getString("rankid"));
		 * dto.setUserDel(rs.getString("userdel")); System.out.println("dto2에 담기 완료");
		 * searchList.add(dto); System.out.println("DAO의 searchList : "+searchList); }
		 */
		
		
		  if(options.equals("userId") && !content.equals("")) {
		  
		  sql += "userid LIKE ? AND userdel = ?"; 
		  System.out.println("userId 옵션일때 sql문은 "+sql); 
		  System.out.println("DAO의 content 값 : "+content); 
		  
		  ps = conn.prepareStatement(sql);
		  ps.setString(1, keywords);
		  ps.setString(2, "N");
		  rs = ps.executeQuery(); 
		  while(rs.next()) { 
		  MainDTO dto = new MainDTO();
		  dto.setUserId(rs.getString("userid"));
		  dto.setNickname(rs.getString("nickname")); 
		  dto.setName(rs.getString("name"));
		  dto.setRankId(rs.getString("rankid"));
		  searchList.add(dto);
		  }
		  
		  }else if(options.equals("nickname") && !content.equals("")) {
		  
		  sql += "nickname LIKE ? AND userdel = ?"; 
		  ps = conn.prepareStatement(sql);
		  
		  ps.setString(1, keywords); 
		  ps.setString(2, "N");
		  rs = ps.executeQuery(); 
		  while(rs.next()) { 
		  MainDTO dto = new MainDTO(); 
		  dto.setUserId(rs.getString("userid"));
		  dto.setNickname(rs.getString("nickname")); 
		  dto.setName(rs.getString("name"));
		  dto.setRankId(rs.getString("rankid"));
		  searchList.add(dto); 
		  }
		  
		  }else if(options.equals("rankId") && !content.equals("")) {
		  
		  sql += "rankid = ?  AND userdel = ?"; 
		  ps = conn.prepareStatement(sql);
		  String keyword2 = "";
		  
		  if(content.equals("브론즈")) {
			  keyword2 = "1";
		  }else if(content.equals("실버")) {
			  keyword2 = "2";
		  }else if(content.equals("골드")) {
			  keyword2 = "3";
		  }else if(content.equals("VIP")) {
			  keyword2 = "4";
		  }
		  
		  ps.setString(1, keyword2); 
		  ps.setString(2, "N");
		  rs = ps.executeQuery(); 
		  System.out.println("rs : "+rs);
		  while(rs.next()) { 
		  MainDTO dto = new MainDTO(); 
		  dto.setUserId(rs.getString("userid"));
		  dto.setNickname(rs.getString("nickname")); 
		  dto.setName(rs.getString("name"));
		  dto.setRankId(rs.getString("rankid"));
		  searchList.add(dto); 
		  } 
		  }else {
		  System.out.println("오류 발생! options 값은 "+options);
		  System.out.println("오류 발생! content 값은 "+content); 
		  }
		 
		System.out.println("DAO에서 searchList에 담긴 값 : "+searchList);
		return searchList;
		
	}

	public MainDTO memberInfo(String currId) {//지현
		
		MainDTO dto = null;
		String sql = "SELECT userId, pw, name, nickname, address, tel, rankId, blindCount, regDate FROM member where userId = ?";
		String rank = "";
		
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, currId);
			rs = ps.executeQuery();
			System.out.println("DAO에서 인식된 아이디 : " + currId);
			
			if(rs.next()) {
				dto = new MainDTO();
				dto.setUserId(rs.getString("userId"));
				dto.setPw(rs.getString("pw"));
				dto.setName(rs.getString("name"));
				dto.setNickname(rs.getString("nickName"));
				dto.setAddress(rs.getString("address"));
				dto.setTel(rs.getString("tel"));
				dto.setBlindCount(rs.getInt("blindCount"));
				dto.setReg_date(rs.getDate("regDate"));
				if(rs.getString("rankId").equals("1")) {
					rank = "브론즈";
				}else if(rs.getString("rankId").equals("2")) {
					rank = "실버";
				}else if(rs.getString("rankId").equals("3")) {
					rank = "골드";
				}else if(rs.getString("rankId").equals("4")) {
					rank = "VIP";
				}
				dto.setRankId(rank);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	public int memberUpdate(String currId, String nickname) {//지현
		
		int change = 0;
		String sql = "UPDATE member SET nickname = ? where userid = ?";
		
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, nickname);
			ps.setString(2, currId);
			change = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return change;
	}

	public int memberSuspend(String userId, String adminName, String opt, String textArea) {//지현
		
		int change = 0;
		String option = "";
		String sql = "INSERT INTO suspend(suspendid, suspendreason, managerid, userid, categoryid) "
				+ "values(SUSPEND_SEQ.nextval, ?, ?, ?, ?)";
		if(opt.equals("blind")) {
			option = "s1";
		}else if(opt.equals("inappropriate")) {
			option = "s2";
		}else if(opt.equals("else")){
			option = "s3";
		}else {
			System.out.println("정지 사유 radio에서 오류 발생!");
		}
		
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, textArea);
			ps.setString(2, adminName);
			ps.setString(3, userId);
			ps.setString(4, option);
			change = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return change;
	}

	public int memberSusNot(String userId) {//지현
		int change = 0;
		String sql = "DELETE FROM suspend WHERE userId = ?";
		
			try {
				ps = conn.prepareStatement(sql);
				ps.setString(1, userId);
				change = ps.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		return change;
	}

	public boolean nickOverlay(String nickname) throws SQLException {//지현

		String sql = "SELECT nickname FROM member WHERE nickname = ?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, nickname);
		rs = ps.executeQuery();
		
		return rs.next();
	}

	public int memberBlind(String nickName, String postId, String adminName, String blindReason, String classification) throws SQLException {//지현

		int change = 0;
		
		String sql = "INSERT INTO blind (blindid, userid, classification, fieldid, blindreason, managerid) "
				+ "VALUES(blind_seq.NEXTVAL, ?, ?, ?, ?, ?)";
		String sql2 = "SELECT userid FROM member WHERE nickname = ?";
		
			ps = conn.prepareStatement(sql2);
			ps.setString(1, nickName);
			rs = ps.executeQuery();
		
			if(rs.next()) {
				ps = conn.prepareStatement(sql);
				ps.setString(1, rs.getString("userid"));
				ps.setString(2, classification);
				ps.setString(3, postId);
				ps.setString(4, blindReason);
				ps.setString(5, adminName);
				change = ps.executeUpdate();
			}else {
				System.out.println("닉네임 오류 발생!");
			}
		
		return change;
	}

	public ArrayList<MainDTO> reportList() throws SQLException {//지현
		sql = "SELECT userid, reportid, classification, fieldid, categoryid, reportdate, details, reportstatus, managerid FROM report ORDER BY reportdate DESC";
		ArrayList<MainDTO> reportList = new ArrayList<MainDTO>();

			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setReportId(rs.getString("reportid"));
				dto.setClassification(rs.getString("classification"));
				dto.setUserId(rs.getString("userid"));
				dto.setFieldId(rs.getString("fieldid"));
				dto.setCategoryId(rs.getString("categoryid"));
				dto.setReportDate(rs.getDate("reportdate"));
				dto.setDetails(rs.getString("details"));
				dto.setReportStatus(rs.getString("reportstatus"));
				dto.setManagerId(rs.getString("managerid"));
				reportList.add(dto);
			}
		return reportList;
	}

	public ArrayList<MainDTO> reportSearch(String options, String content) throws SQLException {//지현
		sql = "SELECT userid, reportid, classification, fieldid, categoryid, reportdate, details, reportstatus, managerid FROM report WHERE ";

		ArrayList<MainDTO> searchList = new ArrayList<MainDTO>();	
		
		String keywords = '%' + content + '%';
		
		  if(options.equals("관리자") && !content.equals("")) {
		  
		  sql += "managerid LIKE ? ORDER BY reportdate DESC"; 
		  
		  ps = conn.prepareStatement(sql);
		  ps.setString(1, keywords);
		  rs = ps.executeQuery(); 
		  while(rs.next()) { 
			MainDTO dto = new MainDTO();
			dto.setReportId(rs.getString("reportid"));
			dto.setClassification(rs.getString("classification"));
		  	dto.setUserId(rs.getString("userid"));
			dto.setFieldId(rs.getString("fieldid"));
			dto.setCategoryId(rs.getString("categoryid"));
			dto.setReportDate(rs.getDate("reportdate"));
			dto.setDetails(rs.getString("details"));
			dto.setReportStatus(rs.getString("reportstatus"));
			dto.setManagerId(rs.getString("managerid"));
			searchList.add(dto);
		  }
		  
		  }else if(options.equals("신고자") && !content.equals("")) {
		  
		  sql += "userid LIKE ? ORDER BY reportdate DESC"; 
		  ps = conn.prepareStatement(sql);
		  
		  ps.setString(1, keywords); 
		  rs = ps.executeQuery(); 
		  while(rs.next()) { 
			  MainDTO dto = new MainDTO(); 
			  dto.setReportId(rs.getString("reportid"));
			  dto.setClassification(rs.getString("classification"));
		  	dto.setUserId(rs.getString("userid"));
			dto.setFieldId(rs.getString("fieldid"));
			dto.setCategoryId(rs.getString("categoryid"));
			dto.setReportDate(rs.getDate("reportdate"));
			dto.setDetails(rs.getString("details"));
			dto.setReportStatus(rs.getString("reportstatus"));
			dto.setManagerId(rs.getString("managerid"));
			searchList.add(dto);
		  }
		  
		  }else {
		  System.out.println("오류 발생! options 값은 "+options);
		  System.out.println("오류 발생! content 값은 "+content); 
		  }
		 
		//System.out.println("DAO에서 searchList에 담긴 값 : "+searchList);
		return searchList;
		
	}

	public ArrayList<MainDTO> reportNotYet() throws SQLException {//지현
		sql = "SELECT userid, fieldid, classification, reportid, categoryid, reportdate, details, reportstatus, managerid FROM report WHERE reportstatus = ? ORDER BY reportdate DESC";
		ArrayList<MainDTO> reportList = new ArrayList<MainDTO>();

			ps = conn.prepareStatement(sql);
			ps.setString(1, "N");
			rs = ps.executeQuery();
			
			while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setReportId(rs.getString("reportid"));
				dto.setClassification(rs.getString("classification"));
				dto.setUserId(rs.getString("userid"));
				dto.setFieldId(rs.getString("fieldid"));
				dto.setCategoryId(rs.getString("categoryid"));
				dto.setReportDate(rs.getDate("reportdate"));
				dto.setDetails(rs.getString("details"));
				dto.setReportStatus(rs.getString("reportstatus"));
				dto.setManagerId(rs.getString("managerid"));
				reportList.add(dto);
			}
		return reportList;
	}

	public int reportChk(String reportId, String adminWho) throws SQLException {//지현
		
		sql = "UPDATE report SET reportstatus = ? WHERE reportid = ?";
		int change = 0;
		int change2 = 0;
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, "Y");
		ps.setString(2, reportId);
		change2 = ps.executeUpdate();
		if(change2 > 0) {
			System.out.println("처리 상태 변경 완료! 이제 관리자 아이디를 넣겠습니다..");
			String sql2 = "UPDATE report SET managerid = ? WHERE reportid = ?";
			ps = conn.prepareStatement(sql2);
			ps.setString(1, adminWho);
			ps.setString(2, reportId);
			change = ps.executeUpdate();
		}
		
		return change;
	}

	public ArrayList<MainDTO> blindList() throws SQLException {//지현
		sql = "SELECT userid, blindid, classification, fieldid, blinddate, blindreason, managerid FROM blind ORDER BY blinddate DESC";
		ArrayList<MainDTO> blindList = new ArrayList<MainDTO>();

			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setUserId(rs.getString("userid"));
				dto.setBlindId(rs.getString("blindid"));
				dto.setClassification(rs.getString("classification"));
				dto.setFieldId(rs.getString("fieldid"));
				dto.setBlindDate(rs.getDate("blinddate"));
				dto.setBlindReason(rs.getString("blindreason"));
				dto.setManagerId(rs.getString("managerid"));
				blindList.add(dto);
			}
		return blindList;
	}

	public ArrayList<MainDTO> blindSearch(String options, String content) throws SQLException {//지현
		sql = "SELECT userid, blindid, classification, fieldid, blinddate, blindreason, managerid FROM blind WHERE ";

		ArrayList<MainDTO> blindList = new ArrayList<MainDTO>();	
		
		String keywords = '%' + content + '%';
		
		  if(options.equals("관리자") && !content.equals("")) {
		  
		  sql += "managerid LIKE ? ORDER BY blinddate DESC"; 
		  
		  ps = conn.prepareStatement(sql);
		  ps.setString(1, keywords);
		  rs = ps.executeQuery(); 
		  while(rs.next()) { 
			MainDTO dto = new MainDTO();
			dto.setUserId(rs.getString("userid"));
			dto.setBlindId(rs.getString("blindid"));
			dto.setClassification(rs.getString("classification"));
			dto.setFieldId(rs.getString("fieldid"));
			dto.setBlindDate(rs.getDate("blinddate"));
			dto.setBlindReason(rs.getString("blindreason"));
			dto.setManagerId(rs.getString("managerid"));
			blindList.add(dto);
		  }
		  
		  }else if(options.equals("회원아이디") && !content.equals("")) {
		  
		  sql += "userid LIKE ? ORDER BY blinddate DESC"; 
		  ps = conn.prepareStatement(sql);
		  
		  ps.setString(1, keywords); 
		  rs = ps.executeQuery(); 
		  while(rs.next()) { 
			  MainDTO dto = new MainDTO(); 
			  	dto.setUserId(rs.getString("userid"));
				dto.setBlindId(rs.getString("blindid"));
				dto.setClassification(rs.getString("classification"));
				dto.setFieldId(rs.getString("fieldid"));
				dto.setBlindDate(rs.getDate("blinddate"));
				dto.setBlindReason(rs.getString("blindreason"));
				dto.setManagerId(rs.getString("managerid"));
				blindList.add(dto);
		  }
		  
		  }else if(options.equals("블라인드사유") && !content.equals("")) {
			  
			  sql += "blindreason LIKE ? ORDER BY blinddate DESC"; 
			  ps = conn.prepareStatement(sql);
			  
			  ps.setString(1, keywords); 
			  rs = ps.executeQuery(); 
			  while(rs.next()) { 
				  MainDTO dto = new MainDTO(); 
				  	dto.setUserId(rs.getString("userid"));
					dto.setBlindId(rs.getString("blindid"));
					dto.setClassification(rs.getString("classification"));
					dto.setFieldId(rs.getString("fieldid"));
					dto.setBlindDate(rs.getDate("blinddate"));
					dto.setBlindReason(rs.getString("blindreason"));
					dto.setManagerId(rs.getString("managerid"));
					blindList.add(dto);
			  }
		  }else {
		  System.out.println("오류 발생! options 값은 "+options);
		  System.out.println("오류 발생! content 값은 "+content); 
		  }
		 
		//System.out.println("DAO에서 searchList에 담긴 값 : "+searchList);
		return blindList;
	}

	public int blindNot(String blindId) throws SQLException {//지현
		sql = "DELETE FROM blind WHERE blindid = ?";
		System.out.println("dao에서 받는 블라인드아이디 : "+blindId);
		int change = 0;
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, blindId);
		change = ps.executeUpdate();
		if(change > 0) {
			System.out.println("블라인드 해제 완료!");
		}else {
			System.out.println("블라인드 해제 실패!");
		}
		
		return change;
	}

	public ArrayList<MainDTO> susMemberList() throws SQLException {
		sql = "SELECT u.userId, u.nickname, u.name , s.suspendid, s.suspendreason, s.suspenddate, s.managerid, s.categoryid FROM member u, suspend s "
				+ "WHERE u.userDel ='N' AND u.userId=s.userId";
		ArrayList<MainDTO> memberList = new ArrayList<MainDTO>();

			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setUserId(rs.getString("userid"));
				dto.setNickname(rs.getString("nickname"));
				dto.setName(rs.getString("name"));
				dto.setSuspendId(rs.getString("suspendid"));
				dto.setSuspendReason(rs.getString("suspendreason"));
				dto.setSuspendDate(rs.getDate("suspenddate"));
				dto.setManagerId(rs.getString("managerid"));
				dto.setCategoryId(rs.getString("categoryid"));
				memberList.add(dto);
			}
			
		
		return memberList;
	}

	public ArrayList<MainDTO> susMemberSearch(String options, String content) throws SQLException {
		sql = "SELECT u.userId, u.nickname, u.name , s.suspendid, s.suspendreason, s.suspenddate, s.managerid, s.categoryid FROM member u, suspend s "
				+ "WHERE u.userDel ='N' AND u.userId=s.userId AND ";

		ArrayList<MainDTO> searchList = new ArrayList<MainDTO>();	
		
		String keywords = '%' + content + '%';
		
		  if(options.equals("userId") && !content.equals("")) {
		  
		  sql += "u.userId LIKE ?"; 
		  
		  ps = conn.prepareStatement(sql);
		  ps.setString(1, keywords);
		  rs = ps.executeQuery(); 
		  while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setUserId(rs.getString("userid"));
				dto.setNickname(rs.getString("nickname"));
				dto.setName(rs.getString("name"));
				dto.setSuspendId(rs.getString("suspendid"));
				dto.setSuspendReason(rs.getString("suspendreason"));
				dto.setSuspendDate(rs.getDate("suspenddate"));
				dto.setManagerId(rs.getString("managerid"));
				dto.setCategoryId(rs.getString("categoryid"));
				searchList.add(dto);
			}
		  
		  }else if(options.equals("nickname") && !content.equals("")) {
		  
		  sql += "u.nickname LIKE ?"; 
		  ps = conn.prepareStatement(sql);
		  
		  ps.setString(1, keywords); 
		  rs = ps.executeQuery(); 
		  while(rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setUserId(rs.getString("userid"));
				dto.setNickname(rs.getString("nickname"));
				dto.setName(rs.getString("name"));
				dto.setSuspendId(rs.getString("suspendid"));
				dto.setSuspendReason(rs.getString("suspendreason"));
				dto.setSuspendDate(rs.getDate("suspenddate"));
				dto.setManagerId(rs.getString("managerid"));
				dto.setCategoryId(rs.getString("categoryid"));
				searchList.add(dto);
			}
		  
		  }else if(options.equals("name") && !content.equals("")) {
			  
			  sql += "u.name LIKE ?"; 
			  ps = conn.prepareStatement(sql);
			  
			  ps.setString(1, keywords); 
			  rs = ps.executeQuery(); 
			  while(rs.next()) {
					MainDTO dto = new MainDTO();
					dto.setUserId(rs.getString("userid"));
					dto.setNickname(rs.getString("nickname"));
					dto.setName(rs.getString("name"));
					dto.setSuspendId(rs.getString("suspendid"));
					dto.setSuspendReason(rs.getString("suspendreason"));
					dto.setSuspendDate(rs.getDate("suspenddate"));
					dto.setManagerId(rs.getString("managerid"));
					dto.setCategoryId(rs.getString("categoryid"));
					searchList.add(dto);
				}
			  
			  }else if(options.equals("admin") && !content.equals("")) {
				  sql += "s.managerid LIKE ?"; 
				  ps = conn.prepareStatement(sql);
				  
				  ps.setString(1, keywords); 
				  rs = ps.executeQuery(); 
				  while(rs.next()) {
						MainDTO dto = new MainDTO();
						dto.setUserId(rs.getString("userid"));
						dto.setNickname(rs.getString("nickname"));
						dto.setName(rs.getString("name"));
						dto.setSuspendId(rs.getString("suspendid"));
						dto.setSuspendReason(rs.getString("suspendreason"));
						dto.setSuspendDate(rs.getDate("suspenddate"));
						dto.setManagerId(rs.getString("managerid"));
						dto.setCategoryId(rs.getString("categoryid"));
						searchList.add(dto);
					}
				  
				  }else {
					  System.out.println("오류 발생! options 값은 "+options);
					  System.out.println("오류 발생! content 값은 "+content); 
		  }
		 
		//System.out.println("DAO에서 searchList에 담긴 값 : "+searchList);
		return searchList;
	}

	public int memberReport(String nickName, String postId, String reportReason, String classification, String opt) throws SQLException {
	int change = 0;
		
		String sql = "INSERT INTO report (reportid, userid, classification, fieldid, details, categoryid) "
				+ "VALUES(blind_seq.NEXTVAL, ?, ?, ?, ?, ?)";
		String sql2 = "SELECT userid FROM member WHERE nickname = ?";
		
			ps = conn.prepareStatement(sql2);
			ps.setString(1, nickName);
			rs = ps.executeQuery();
		
			if(rs.next()) {
				ps = conn.prepareStatement(sql);
				ps.setString(1, rs.getString("userid"));
				ps.setString(2, classification);
				ps.setString(3, postId);
				ps.setString(4, reportReason);
				ps.setString(5, opt);
				change = ps.executeUpdate();
			}else {
				System.out.println("닉네임 오류 발생!");
			}
		
		return change;
	}


}
