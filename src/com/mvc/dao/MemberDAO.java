package com.mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.mvc.dto.MainDTO;

public class MemberDAO {

	PreparedStatement ps = null;
	ResultSet rs = null;
	Connection conn = null;
	String sql = "";

	public MemberDAO() {
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
				// System.out.println("rs closed");
			}
			if (ps != null && !ps.isClosed()) {
				ps.close();
				// System.out.println("ps closed");
			}
			if (conn != null && !conn.isClosed()) {
				conn.close();
				// System.out.println("conn closed");
			}
			System.out.println("자원 닫힘");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public MainDTO info(String userId) { //은홍
		System.out.println("MemberDAO info() 들어옴");
		MainDTO dto = new MainDTO();
		try {
			// 회원등급(RANK) 불러오기
			String rank_sql = "SELECT rankName FROM rank WHERE rankId=(SELECT rankId FROM member WHERE userId=?)";
			String rank = "로드 실패";
			ps = conn.prepareStatement(rank_sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			if (rs.next()) {
				rank = rs.getString("rankName");
			}
			dto.setRankName(rank);

			// 보유 캐시 불러오기
			String cash_sql = "SELECT total FROM (SELECT total FROM cash WHERE userId=? ORDER BY changedTime DESC) WHERE ROWNUM=1";
			int cash = 0;
			ps = conn.prepareStatement(cash_sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			if (rs.next()) {
				cash = Integer.parseInt(rs.getString("total"));
			}
			dto.setCash(cash);

			// 명예 점수 불러오기
			String point_sql = "SELECT totalPoint FROM (SELECT totalPoint FROM point WHERE userId=? ORDER BY pointDate DESC) WHERE ROWNUM=1";
			int point = 0;
			ps = conn.prepareStatement(point_sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			if (rs.next()) {
				point = Integer.parseInt(rs.getString("totalPoint"));
			}
			dto.setTotalPoint(point);
			;

			System.out.println("current rank/cash/point : " + rank + "/" + cash + "/" + point);
			System.out.println("dto : " + dto);
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO info()");
			e.printStackTrace();
		}
		return dto;
	}

	public int showCash(String userId) { // 은홍
		System.out.println("MemberDAO showCash() 들어옴");
		sql = "SELECT total FROM (SELECT total FROM cash WHERE userId=? ORDER BY changedTime DESC) WHERE ROWNUM=1";
		int cash = 0;
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			if (rs.next()) {
				cash = Integer.parseInt(rs.getString("total"));
			}
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO showCash()");
			e.printStackTrace();
		}
		return cash;
	}

	public ArrayList<MainDTO> cashHistory(String userId) { // 은홍
		System.out.println("MemberDAO cashHistory() 들어옴");
		MainDTO dto = null;
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		int cash_amount = 0;
		String cash_time = "로드실패";
		int cash_total = 0;
		String cash_details = "로드실패";
		try {
			sql = "SELECT changedPrice, to_char(changedTime,'yyyy-mm-dd hh24:mi') time,"
					+ " total FROM cash WHERE userId=? ORDER BY time DESC";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			while (rs.next()) {
				dto = new MainDTO();
				cash_amount = rs.getInt("changedPrice");
				cash_time = rs.getString("time");
				cash_total = rs.getInt("total");
				if (cash_amount > 0) {
					cash_details = "캐시 충전";
				} else {
					cash_details = "상품 구매";
				}
				dto.setCash_amount(cash_amount);
				dto.setCash_time(cash_time);
				dto.setCash_total(cash_total);
				dto.setCash_details(cash_details);
				list.add(dto);
			}
			System.out.println("마지막줄 amount/time/total/details : " + cash_amount + "/" + cash_time + "/" + cash_total
					+ "/" + cash_details);
			System.out.println("cashHistory list size : " + list.size());
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO cashHistory()");
			e.printStackTrace();
		}
		return list;
	}

	public int changeCash(int amount, String userId) { // 은홍
		// 캐시 충전 또는 상품 구매로 캐시 히스토리를 추가하는 메소드, amount는 변동액
		System.out.println("MemberDAO changeCash() 들어옴");
		int success = 0; // 쿼리성공여부
		int total = 0; // 변동으로 인한 캐시총합
		int currCash = showCash(userId);
		total = currCash + amount;
		System.out.println("amount/currCash/total/userId : " + amount + "/" + currCash + "/" + total + "/" + userId);
		sql = "INSERT INTO cash(changedPrice,total,userId) VALUES(?,?,?)";
		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, amount); // 변동액
			ps.setInt(2, total); // 총합
			ps.setString(3, userId); // 유저 아이디
			success = ps.executeUpdate();
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO changeCash()");
			e.printStackTrace();
		}
		return success;
	}

	public HashMap<String, ArrayList<MainDTO>> myPage(String userId) { // 은홍
		// 마이페이지에 데이터를 전달하는 메소드
		System.out.println("MemberDAO myPage() 들어옴");
		// 좋아요한글 4개리스트, 내 레시피글 4개 리스트, 내댓글 4개 리스트를 각각 map에 넣어 전달
		HashMap<String, ArrayList<MainDTO>> map = new HashMap<String, ArrayList<MainDTO>>();
		MainDTO dto = null;

		ArrayList<MainDTO> likeList = new ArrayList<MainDTO>();
		ArrayList<MainDTO> postList = new ArrayList<MainDTO>();
		ArrayList<MainDTO> commentList = new ArrayList<MainDTO>();
		String postId = ""; // 글아이디
		int like = 0; // 좋아요수
		String title = "로드실패"; // 제목
		int hits = 0; // 조회수
		String item = "로드실패"; // 재료
		int recipePrice = 0; // 예산
		String nickName = ""; // 작성자닉네임

		String commentid = ""; // 댓글 또는 대댓글 id
		String comment_content = "로드실패"; // 댓글 또는 대댓글 내용
		String comment_date = "로드실패"; // 작성날짜

		try {
			// 좋아요 불러오기
			sql = "SELECT postId,likes,title,hits,item,recipePrice,"
					+ "(SELECT nickName FROM member WHERE userid=p.userid) nickName "
					+ "FROM (SELECT * FROM post WHERE postid "
					+ "IN (SELECT postId FROM (SELECT postId FROM postLike WHERE userId=? ORDER BY likedate DESC) WHERE ROWNUM < 5) ORDER BY postdate DESC) p";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			while (rs.next()) {
				postId = rs.getString("postId");
				like = rs.getInt("likes");
				title = rs.getString("title");
				hits = rs.getInt("hits");

				item = rs.getString("item");
				// 재료 3개만 가져오기
				String[] itemArr = item.split(",");
				item = "";
				int i = 0;
				while (i < 3 && itemArr.length > i) {
					// 재료가 3개 미만일 경우 itemArr.length < i 에 걸린다
					item += (",#" + itemArr[i]);
					i += 1;
				}
				item = item.substring(1);
				// System.out.println("재료(item)3개만 : "+item);

				recipePrice = rs.getInt("recipePrice");
				nickName = rs.getString("nickName");

				dto = new MainDTO();
				dto.setPostId(postId);
				dto.setLike(like);
				dto.setTitle(title);
				dto.setHits(hits);
				dto.setItem(item);
				dto.setRecipePrice(recipePrice);
				dto.setnickName(nickName);
				likeList.add(dto);
			}
			System.out.println("마지막줄 postId/like/title/hits/item/recipePrice/nickname : " + postId + "/" + like + "/"
					+ title + "/" + hits + "/" + item + "/" + recipePrice + "/" + nickName);
			System.out.println("likeList size : " + likeList.size());
			map.put("likeList", likeList);
			System.out.println("map안에서 likeList size : " + map.get("likeList").size());
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO myPage() - likeList");
			e.printStackTrace();
		}

		try {
			// 내가 쓴 글 불러오기
			sql = "SELECT postId,likes,title,hits,item,recipePrice,"
					+ "(SELECT nickname FROM member WHERE userid=u.userid) nickname "
					+ "FROM (SELECT * FROM post WHERE userId=? ORDER BY postdate DESC) u WHERE ROWNUM<5";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			while (rs.next()) {
				postId = rs.getString("postId");
				like = rs.getInt("likes");
				title = rs.getString("title");
				hits = rs.getInt("hits");

				item = rs.getString("item");
				// 재료 3개만 가져오기
				String[] itemArr = item.split(",");
				item = "";
				int i = 0;
				while (i < 3 && itemArr.length > i) {
					// 재료가 3개 미만일 경우 itemArr.length < i 에 걸린다
					item += (",#" + itemArr[i]);
					i += 1;
				}
				item = item.substring(1);
				// System.out.println("재료(item)3개만 : "+item);

				recipePrice = rs.getInt("recipePrice");
				nickName = rs.getString("nickName");

				dto = new MainDTO();
				dto.setPostId(postId);
				dto.setLike(like);
				dto.setTitle(title);
				dto.setHits(hits);
				dto.setItem(item);
				dto.setRecipePrice(recipePrice);
				dto.setnickName(nickName);
				postList.add(dto);
			}
			System.out.println("마지막줄 postId/like/title/hits/item/recipePrice/nickname : " + postId + "/" + like + "/"
					+ title + "/" + hits + "/" + item + "/" + recipePrice + "/" + nickName);
			System.out.println("postList size : " + postList.size());
			map.put("postList", postList);
			System.out.println("map안에서 postListsize : " + map.get("postList").size());
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO myPage() - postList");
			e.printStackTrace();
		}

		try {
			// 내가 쓴 댓글/대댓글 불러오기
			sql = "SELECT c.commentid commentid, c.comment_content content, c.userid userid,"
					+ " to_char(c.comment_date,'yyyy-mm-dd hh24:mi') comment_date, p.postId postid, p.title title "
					+ "FROM (SELECT commentid, comment_content, userid, comment_date "
					+ "FROM (SELECT ROW_NUMBER() OVER (ORDER BY comment_date DESC) as rnum, "
					+ "commentid, comment_content, userid, comment_date "
					+ "FROM (SELECT commentid, comment_content, userid, comment_date "
					+ "FROM recomment WHERE userid=? " + "UNION "
					+ "SELECT commentid, comment_content, userid, comment_date FROM postcomment "
					+ "WHERE userid=?)) WHERE rnum<=4) c, post p "
					+ "WHERE p.postid IN(SELECT postid FROM postcomment WHERE commentid=c.commentid)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setString(2, userId);
			rs = ps.executeQuery();
			while (rs.next()) {
				commentid = rs.getString("commentid");
				comment_content = rs.getString("content");
				comment_date = rs.getString("comment_date");
				postId = rs.getString("postid");
				title = rs.getString("title");

				dto = new MainDTO();
				dto.setCommentid(commentid);
				dto.setComment_content(comment_content);
				dto.setComment_date(comment_date);
				dto.setPostId(postId);
				dto.setTitle(title);
				commentList.add(dto);
			}
			System.out.println("마지막줄 commentid/comment_content/comment_date/postId/title : " + commentid + "/"
					+ comment_content + "/" + comment_date + "/" + postId + "/" + title);
			System.out.println("commentList size : " + commentList.size());
			map.put("commentList", commentList);
			System.out.println("map안에서 commentList size : " + map.get("commentList").size());
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO myPage() - commentList");
			e.printStackTrace();
		}

		return map;
	}


	public MainDTO getFileName(String imgId) { // 은홍
		// 이미지id로 이미지의 oriName과 newName을 반환
		MainDTO dto = null;
		String sql = "SELECT imgOriName, imgNewName FROM image WHERE imgId=?";
		// System.out.println("DAO getFileName imgID : "+imgId);
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, imgId);
			rs = ps.executeQuery();

			if (rs.next()) {
				dto = new MainDTO();
				String imgOriName = rs.getString("imgOriName");
				String imgNewName = rs.getString("imgNewName");
				// System.out.println("DAO getFileName imgOriName/imgNewName :
				// "+imgOriName+"/"+imgNewName);
				dto.setImgOriName(imgOriName);
				dto.setImgNewName(imgNewName);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		// System.out.println("DAO getFileName dto : "+dto);
		return dto;
	}

	public String getImgId(String imgField, String fieldId) { // 은홍
		// 이미지의 필드(상품/게시글 썸네일/일반이미지)와 게시글id를 받아서 이미지id를 반환하는 메서드
		String imgId = "";
		String sql = "SELECT imgId FROM image WHERE imgField=? AND fieldId=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, imgField);
			ps.setString(2, fieldId);
			rs = ps.executeQuery();

			if (rs.next()) {
				imgId = rs.getString("imgId");
				System.out.println("DAO getImgId : " + imgId);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return imgId;
	}

	public HashMap<String, Object> fileUpload(MainDTO dto) { // 은홍 
		//파일 업로드 및 수정시 이미지 메타데이터를 DB에 저장하는 메소드
		HashMap<String, Object> map = new HashMap<String, Object>();

		int success = 0;
		
		//일반 업로드(수정이 아닌 경우)
		if (dto.getFieldId() == null || dto.getFieldId() == "") {
			
			System.out.println("DAO fileUpload() 일반업로드(수정이 아닌 경우) 들어옴");
			sql = "INSERT INTO image(imgId, imgField, fieldId, imgPath, imgOriName, imgNewName)"
					+ "VALUES(image_seq.NEXTVAL,?,null,?,?,?)";
			try {
				if (dto.getImgOriName() != null) {
					// 썸네일 insert
					ps = conn.prepareStatement(sql, new String[] { "imgId" });
					ps.setString(1, dto.getImgField());
					ps.setString(2, dto.getImgPath());
					ps.setString(3, dto.getImgOriName());
					ps.setString(4, dto.getImgNewName());
					success += ps.executeUpdate();
					rs = ps.getGeneratedKeys();
					if (rs.next())
						map.put("imgId", rs.getInt(1));
					System.out.println("DAO fileUpload() 추가 imgId : " + map.get("imgId"));
				}
				if (dto.getTh_imgOriName() != null) {
					// 첨부이미지 insert
					ps = conn.prepareStatement(sql, new String[] { "imgId" });
					ps.setString(1, dto.getTh_imgField());
					ps.setString(2, dto.getTh_imgPath());
					ps.setString(3, dto.getTh_imgOriName());
					ps.setString(4, dto.getTh_imgNewName());
					success += ps.executeUpdate();
					rs = ps.getGeneratedKeys();
					if (rs.next())
						map.put("th_imgId", rs.getInt(1));
					System.out.println("DAO fileUpload() 추가 th_imgId : " + map.get("th_imgId"));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		
		//파일 수정인 경우
		}else { 
			System.out.println("DAO fileUpload() 파일 수정 들어옴");
			sql = "INSERT INTO image(imgId, imgField, fieldId, imgPath, imgOriName, imgNewName)"
					+ "VALUES(image_seq.NEXTVAL,?,?,?,?,?)";
			try {
				if (dto.getImgOriName() != null) {
					// 썸네일 insert
					ps = conn.prepareStatement(sql, new String[] { "imgId" });
					ps.setString(1, dto.getImgField());
					ps.setString(2, dto.getFieldId());
					ps.setString(3, dto.getImgPath());
					ps.setString(4, dto.getImgOriName());
					ps.setString(5, dto.getImgNewName());
					success += ps.executeUpdate();
					rs = ps.getGeneratedKeys();
					if (rs.next())
						map.put("imgId", rs.getInt(1));
					System.out.println("DAO fileUpload() 변경 imgId : " + map.get("imgId"));
				}
				if (dto.getTh_imgOriName() != null) {
					// 첨부이미지 insert
					ps = conn.prepareStatement(sql, new String[] { "imgId" });
					ps.setString(1, dto.getTh_imgField());
					ps.setString(2, dto.getTh_fieldId());
					ps.setString(3, dto.getTh_imgPath());
					ps.setString(4, dto.getTh_imgOriName());
					ps.setString(5, dto.getTh_imgNewName());
					success += ps.executeUpdate();
					rs = ps.getGeneratedKeys();
					if (rs.next())
						map.put("th_imgId", rs.getInt(1));
					System.out.println("DAO fileUpload() 변경 th_imgId : " + map.get("th_imgId"));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		System.out.println("파일업로드 쿼리 적용 성공 개수 : " + success);
		map.put("success", success);
		return map;
	}

	public boolean delImage(String imgId) { // 은홍
		// DB에서 이미지 삭제. 이미지PK를 받아 존재하면 삭제한다.
		boolean success = false;
		sql = "DELETE FROM image WHERE imgId=?";
		try {
			if (imgId != null && imgId != "") {
				ps = conn.prepareStatement(sql);
				ps.setString(1, imgId);
				if (ps.executeUpdate() > 0) {
					success = true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("파일 삭제 쿼리 적용 성공여부 : " + success);
		return success;
	}

	public int setImgField(String postId, String imgId) { // 은홍
		// 게시글 업로드 이후 postId와 imgId를 받아 해당 이미지의 fieldId를 넣어주는 메소드
		int success = 0;
		sql = "UPDATE image SET fieldId=? WHERE imgId=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, postId);
			ps.setString(2, imgId);
			success = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return success;
	}

}
