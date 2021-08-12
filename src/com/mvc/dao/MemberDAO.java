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

	public HashMap<String, Object> cashHistory(String userId, int page) { // 은홍
		System.out.println("MemberDAO cashHistory() 들어옴");
		MainDTO dto = null;
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		int start = 0;
		int end = 0;
		int startPage = 0;
		int endPage = 0;
		int pagePerCnt = 10; //한 페이지당 보여줄 게시글 수
		int pagePerPage = 5; //한 페이지당 보여줄 페이지 수
		
		int total = 0;
		try {
			total = totalCashCount(userId);
		} catch (Exception e1) {
			e1.printStackTrace();
		} //총 게시글 수
		int pages = total/pagePerCnt; //만들 수 있는 페이지 수
		if(pages == 0) {
			pages = 1;
		}
		System.out.println("DAO 총 데이터 수 : "+total+" / 페이지 수 : "+pages);
		
		if(page > pages) {
			page = pages;
		}
		System.out.println("DAO 요청 받은 페이지 : "+page);
		
		end = page*pagePerCnt; //1p:1~10 2p:11~20 3p:21~30
		start = end-(pagePerCnt-1);
		endPage = pagePerPage*((int)((page-1)/pagePerPage)+1);
		startPage = endPage-pagePerPage+1;
		System.out.println("DAO startPage/endPage : "+startPage+"/"+endPage);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		int cash_amount = 0;
		String cash_time = "로드실패";
		int cash_total = 0;
		String cash_details = "로드실패";
		try {
			sql = "SELECT * FROM (SELECT ROWNUM rnum, changedPrice, to_char(changedTime,'yyyy-mm-dd hh24:mi:ss') time, total FROM cash WHERE userId=? ORDER BY time DESC) WHERE rnum BETWEEN ? AND ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setInt(2, start);
			ps.setInt(3, end);
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
		map.put("list", list);
		map.put("totalPage", pages);
		map.put("currPage", page);
		map.put("start", startPage);
		map.put("end", endPage);
		return map;
	}
	
	private int totalCashCount(String userId) throws Exception { //은홍
		String sql = "SELECT COUNT(*) FROM cash WHERE userId=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		rs = ps.executeQuery();
		
		int total = 0;
		
		if(rs.next()) {
			total = rs.getInt(1);
		}
		return total;
	}

	public int changeCash(int amount, String userId) { // 은홍
		// 캐시 충전 또는 상품 구매로 캐시 히스토리를 추가하는 메소드, amount는 변동액
		System.out.println("MemberDAO changeCash() 들어옴");
		int success = 0; // 쿼리성공여부
		int total = 0; // 변동으로 인한 캐시총합
		int currCash = showCash(userId);
		total = currCash + amount;
		System.out.println("amount/currCash/total/userId : " + amount + "/" + currCash + "/" + total + "/" + userId);
		if(total < 0) {
			System.out.println("DAO 캐시 부족으로 상품 구매 불가 ");
			return success;
		}
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
		String imgNewName = ""; //썸네일파일명

		String commentid = ""; // 댓글 또는 대댓글 id
		String comment_content = "로드실패"; // 댓글 또는 대댓글 내용
		String comment_date = "로드실패"; // 작성날짜

		try {
			// 좋아요 불러오기
			sql = "SELECT i.imgNewName, u.* FROM (SELECT postId,likes,title,hits,item,recipePrice,(SELECT nickName FROM member WHERE userid=p.userid) nickName"
					+ " FROM (SELECT * FROM post WHERE postid IN (SELECT postId FROM "
					+ "(SELECT postId FROM postLike WHERE userId=? ORDER BY likedate DESC) WHERE ROWNUM < 4) ORDER BY postdate DESC) p) u "
					+ "LEFT OUTER JOIN image i ON u.postId=i.fieldid AND i.imgfield='post_th'";
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
				imgNewName = rs.getString("imgNewName");
				
				dto = new MainDTO();
				dto.setPostId(postId);
				dto.setLike(like);
				dto.setTitle(title);
				dto.setHits(hits);
				dto.setItem(item);
				dto.setRecipePrice(recipePrice);
				dto.setNickName(nickName);
				dto.setImgNewName(imgNewName);
				likeList.add(dto);
			}
			System.out.println("마지막줄 postId/like/title/hits/item/recipePrice/nickname/imgNewName : " + postId + "/" + like + "/"
					+ title + "/" + hits + "/" + item + "/" + recipePrice + "/" + nickName + "/" + imgNewName);
			System.out.println("likeList size : " + likeList.size());
			map.put("likeList", likeList);
			System.out.println("map안에서 likeList size : " + map.get("likeList").size());
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO myPage() - likeList");
			e.printStackTrace();
		}

		try {
			// 내가 쓴 글 불러오기
			sql = "SELECT i.imgNewName, u.* FROM (SELECT postId,likes,title,hits,item,recipePrice,"
					+ "(SELECT nickname FROM member WHERE userid=u.userid) nickname "
					+ "FROM (SELECT * FROM post WHERE userId=? ORDER BY postdate DESC) u WHERE ROWNUM<4) u"
					+ " LEFT OUTER JOIN image i ON u.postId=i.fieldid AND i.imgfield='post_th'";
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
				imgNewName = rs.getString("imgNewName");

				dto = new MainDTO();
				dto.setPostId(postId);
				dto.setLike(like);
				dto.setTitle(title);
				dto.setHits(hits);
				dto.setItem(item);
				dto.setRecipePrice(recipePrice);
				dto.setNickName(nickName);
				dto.setImgNewName(imgNewName);
				postList.add(dto);
			}
			System.out.println("마지막줄 postId/like/title/hits/item/recipePrice/nickname/imgNewName : " + postId + "/" + like + "/"
					+ title + "/" + hits + "/" + item + "/" + recipePrice + "/" + nickName+ "/" + imgNewName);
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
					+ "WHERE userid=?)) WHERE rnum<=3) c, post p "
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
	
	public HashMap<String, Object> pointHistory(String userId, int page) { //은홍
		//명예 획득 내역 리스트 조회
		System.out.println("MemberDAO pointHistory() 들어옴");
		MainDTO dto = null;
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		int start = 0;
		int end = 0;
		int startPage = 0;
		int endPage = 0;
		int pagePerCnt = 10; //한 페이지당 보여줄 데이터 수
		int pagePerPage = 5; //한 페이지당 보여줄 페이지 수
		
		int total = 0;
		try {
			total = totalPointCount(userId);
		} catch (Exception e1) {
			e1.printStackTrace();
		} //총 게시글 수
		int pages = total/pagePerCnt; //만들 수 있는 페이지 수
		if(pages == 0) {
			pages = 1;
		}
		System.out.println("DAO 총 데이터 수 : "+total+" / 페이지 수 : "+pages);
		
		if(page > pages) {
			page = pages;
		}
		System.out.println("DAO 요청 받은 페이지 : "+page);
		
		end = page*pagePerCnt; //1p:1~10 2p:11~20 3p:21~30
		start = end-(pagePerCnt-1);
		endPage = pagePerPage*((int)((page-1)/pagePerPage)+1);
		startPage = endPage-pagePerPage+1;
		System.out.println("DAO startPage/endPage : "+startPage+"/"+endPage);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String pointDate = "로드실패";
		String pointField = "로드실패";
		int getPoint = 0;
		int totalPoint = 0;
		try {
			sql = "SELECT * FROM (SELECT ROWNUM rnum, p.* FROM (SELECT to_char(pointDate,'yyyy-mm-dd hh24:mi') pointDate, "
					+ "pointField, getPoint, totalPoint FROM point WHERE userId=? ORDER BY pointDate DESC) p) "
					+ "WHERE rnum BETWEEN ? AND ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setInt(2, start);
			ps.setInt(3, end);
			rs = ps.executeQuery();
			while (rs.next()) {
				dto = new MainDTO();
				pointDate = rs.getString("pointDate");
				pointField = rs.getString("pointField");
				getPoint = rs.getInt("getPoint");
				totalPoint = rs.getInt("totalPoint");
				
				dto.setPointDate(pointDate);
				dto.setPointField(pointField);
				dto.setGetPoint(getPoint);
				dto.setTotalPoint(totalPoint);
				list.add(dto);
			}
			System.out.println("마지막줄 pointDate/pointField/getPoint/totalPoint : "+pointDate+"/"+pointField+"/"+getPoint+"/"+totalPoint);
			System.out.println("pointHistory list size : " + list.size());
		} catch (Exception e) {
			System.out.println("**에러 : MemberDAO pointHistory()");
			e.printStackTrace();
		}
		map.put("list", list);
		map.put("totalPage", pages);
		map.put("currPage", page);
		map.put("start", startPage);
		map.put("end", endPage);
		return map;
	}
	
	private int totalPointCount(String userId) throws Exception { //은홍
		String sql = "SELECT COUNT(*) FROM point WHERE userId=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		rs = ps.executeQuery();
		
		int total = 0;
		
		if(rs.next()) {
			total = rs.getInt(1);
		}
		return total;
	}
	
	public boolean getPoint(String userId, String pointField, int getPoint) { // 은홍
		// 명예점수를 더하고 획득내역 히스토리를 추가하는 메서드
		System.out.println("MemberDAO getPoint() 명예점수 획득 : + "+getPoint+"점!");
		boolean success = false;
			//먼저 현재의 명예점수를 가져온다
			String point_sql = "SELECT totalPoint FROM (SELECT totalPoint FROM point WHERE userId=? ORDER BY pointDate DESC) WHERE ROWNUM=1";
			int point_now = 0;
			try {
				ps = conn.prepareStatement(point_sql);
				ps.setString(1, userId);
				rs = ps.executeQuery();
				if (rs.next()) {
					point_now = Integer.parseInt(rs.getString("totalPoint"));
				}else {
					point_now = 0;
				}
				System.out.println("포인트나우"+point_now+"겟포인"+getPoint+"아이디"+userId);
				//현재 명예점수를 가져왔다면 명예점수 히스토리를 추가해준다
				sql = "INSERT INTO point(getPoint,totalPoint,userId,pointField)VALUES(?,?,?,?)";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, getPoint);
				ps.setInt(2, point_now+getPoint);
				ps.setString(3, userId);
				ps.setString(4, pointField);
				if (ps.executeUpdate() > 0) {
					success = true;
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("명예 획득 쿼리 적용 성공여부 : " + success);
		return success;
	}
	
	public MainDTO clientInfo(String userId) { // 찬호

		MainDTO dto = null;
		String sql = "SELECT m.userId as userid, m.pw as pw, m.name as name, m.nickName as nickname, r.rankName as rankName , m.address as address, m.tel as tel, m.blindCount as blindCount, m.regDate as regDate FROM member m left outer join rank r on m.rankid = r.rankid where userid = ?";

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			if (rs.next()) {
				dto = new MainDTO();
				dto.setUserId(rs.getString("userId"));
				dto.setPw(rs.getString("pw"));
				dto.setName(rs.getString("name"));
				dto.setNickName(rs.getString("nickName"));
				dto.setRankName(rs.getString("rankName"));
				dto.setAddress(rs.getString("address"));
				dto.setTel(rs.getString("tel"));
				dto.setBlindCount(rs.getInt("blindCount"));
				dto.setRegDate(rs.getDate("regDate"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dto;

	}

	public int update(String pw, String nickName, String tel, String address, String userId) { // 찬호

		int change = 0;
		String sql = "UPDATE member SET pw = ?, nickname = ?, tel = ?, address = ? WHERE userId=?";

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, pw);
			ps.setString(2, nickName);
			ps.setString(3, tel);
			ps.setString(4, address);
			ps.setString(5, userId);
			change = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return change;

	}

	public String userDel(String userId) { // 찬호

		String sql = "UPDATE member SET userDel = 'Y' where userId = ?";
		String del = "";

		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			int a = ps.executeUpdate();
			if (a > 0) {
				del = "Y";
			} else {
				del = "N";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return del;

	}

	public HashMap<String, Object> myWrite(int page, String userId) { // 찬호

		System.out.println("page : " + page);

		ArrayList<MainDTO> myWrite = new ArrayList<MainDTO>();
		String item = "로드실패";
		int start = 0;
		int end = 0;
		int endPage = 0;
		int startPage = 0;
		int pagePerCnt = 9; // 한 페이지당 보여줄 게시글 수
		int pagePerPage = 5; // 한 페이지당 보여줄 페이지 수
		int total = 0;
		try {
			total = myWriteTotalCount(userId);
		} catch (Exception e) {
			e.printStackTrace();
		} // 총 게시글 수
		int pages = total % pagePerCnt == 0 ? total / pagePerCnt : (total / pagePerCnt) + 1; // 만들 수 있는 페이지 수
		System.out.println("total pages : " + total + " / pages : " + pages);

		if (page > pages) {
			page = pages;
		}
		System.out.println("DAO 요청 받은 페이지 : " + page);

		start = ((page - 1) * pagePerCnt) + 1;
		end = page * pagePerCnt; 
		endPage = pagePerPage * ((int) ((page - 1) / pagePerPage) + 1);
		startPage = endPage - pagePerPage + 1;
		System.out.println("DAO startPage/endPage : " + startPage + "/" + endPage);

		HashMap<String, Object> map = new HashMap<String, Object>();

		String sql = "SELECT rnum, postid, title, recipePrice, hits ,likes, userid, item FROM "
				+ "(SELECT ROW_NUMBER() OVER (ORDER BY postid) AS rnum, post.* FROM post where userid = ?"
				+ " ORDER BY postid desc) WHERE rnum BETWEEN ? AND ?";


		myWrite = new ArrayList<MainDTO>();
		System.out.println("DAO myWrite() size : " + myWrite.size());
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setInt(2, start);
			ps.setInt(3, end);
			rs = ps.executeQuery();
			myWrite = new ArrayList<MainDTO>();
			System.out.println("들어오는지확인");
			while (rs.next()) {
				MainDTO dto = new MainDTO();
				item = rs.getString("item");
				dto.setPostId(rs.getString("postId"));
				dto.setTitle(rs.getString("title"));
				dto.setRecipePrice(rs.getInt("recipePrice"));
				dto.setHits(rs.getInt("hits"));
				dto.setLikes(rs.getInt("likes"));
				dto.setUserId(rs.getString("userId"));
				// 재료 3개만 가져오기
	            String[] itemArr = item.split(",");
	            item = "";
	            int i = 0;
	            while (i < 3 && itemArr.length > i) {
	               // 재료가 3개 미만일 경우 itemArr.length < i 에 걸린다
	               item += (",#" + itemArr[i]);
	               i += 1;
	               System.out.println("i : " + i);
	            }
	            item = item.substring(1);
	            // System.out.println("재료(item)3개만 : "+item);
				dto.setItem(item);
				System.out.println("dto : " + dto);
				myWrite.add(dto);
			}
			System.out.println("들어간 userId : " + userId);
			System.out.println("DAO myWrite() size : " + myWrite.size());

			map.put("myWrite", myWrite);
			map.put("totalPage", pages);
			map.put("currPage", page);
			map.put("start", startPage);
			map.put("end", endPage);
		} catch (Exception e) {
			System.out.println("**DAO list()에러**");
			e.printStackTrace();
		}
		return map;
	}

	public int myWriteTotalCount(String userId) throws SQLException {

		String sql = "SELECT count(*) FROM post where userid = ?";
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		rs = ps.executeQuery();

		int total = 0;

		if (rs.next()) {
			total = rs.getInt(1);
		}

		return total;
	}
	
	public int myCommentTotalCount(String userId) throws SQLException {

		String sql = "SELECT count(*)"
				+ "FROM (SELECT commentid, comment_content, userid, comment_date FROM (SELECT ROW_NUMBER() OVER (ORDER BY comment_date DESC) as rnum, commentid, comment_content, userid, comment_date "
				+ "FROM (SELECT commentid, comment_content, userid, comment_date FROM recomment WHERE userid = ? UNION SELECT commentid, comment_content, userid, comment_date "
				+ "FROM postcomment WHERE userid = ?))) c, post p WHERE p.postid IN (SELECT postid FROM postcomment WHERE commentid=c.commentid)";
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		ps.setString(2, userId);
		rs = ps.executeQuery();

		int total = 0;

		if (rs.next()) {
			total = rs.getInt(1);
		}

		return total;
	}
	
	public int myLikeTotalCount(String userId) throws SQLException {

		String sql = "SELECT count(*) "
				+ "FROM (SELECT * FROM post WHERE postid IN (SELECT postId "
				+ "FROM (SELECT postId FROM postLike WHERE userId= ? ORDER BY likedate DESC) ) ORDER BY postdate DESC) p";
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		rs = ps.executeQuery();

		int total = 0;

		if (rs.next()) {
			total = rs.getInt(1);
		}

		return total;
	}

	public HashMap<String, Object> myLike(int page, String userId) { // 찬호

		System.out.println("page : " + page);

		ArrayList<MainDTO> myLike = new ArrayList<MainDTO>();
		String item = "로드실패";
		int start = 0;
		int end = 0;
		int endPage = 0;
		int startPage = 0;
		int pagePerCnt = 9; // 한 페이지당 보여줄 게시글 수
		int pagePerPage = 5; // 한 페이지당 보여줄 페이지 수
		int total = 0;
		try {
			total = myLikeTotalCount(userId);
		} catch (Exception e) {
			e.printStackTrace();
		} // 총 게시글 수
		int pages = total % pagePerCnt == 0 ? total / pagePerCnt : (total / pagePerCnt) + 1; // 만들 수 있는 페이지 수
		System.out.println("total pages : " + total + " / pages : " + pages);

		if (page > pages) {
			page = pages;
		}
		System.out.println("DAO 요청 받은 페이지 : " + page);

		start = ((page - 1) * pagePerCnt) + 1;
		end = page * pagePerCnt; 
		endPage = pagePerPage * ((int) ((page - 1) / pagePerPage) + 1);
		startPage = endPage - pagePerPage + 1;
		System.out.println("DAO startPage/endPage : " + startPage + "/" + endPage);

		HashMap<String, Object> map = new HashMap<String, Object>();

		String sql = "SELECT postId,likes,title,hits,item,recipePrice,(SELECT nickName FROM member WHERE userid=p.userid) nickName FROM "
				+ "(SELECT * FROM post WHERE postid IN (SELECT postId FROM (SELECT postId FROM "
				+ "postLike WHERE userId=? ORDER BY likedate DESC) WHERE ROWNUM between ? and ?) ORDER BY postdate DESC) p";


		myLike = new ArrayList<MainDTO>();
		System.out.println("DAO myLike() size : " + myLike.size());
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setInt(2, start);
			ps.setInt(3, end);
			rs = ps.executeQuery();
			myLike = new ArrayList<MainDTO>();
			System.out.println("들어오는지확인");
			while (rs.next()) {
				MainDTO dto = new MainDTO();
				item = rs.getString("item");
				dto.setPostId(rs.getString("postId"));
				dto.setLikes(rs.getInt("likes"));
				dto.setTitle(rs.getString("title"));
				dto.setHits(rs.getInt("hits"));
				// 재료 3개만 가져오기
	            String[] itemArr = item.split(",");
	            item = "";
	            int i = 0;
	            while (i < 3 && itemArr.length > i) {
	               // 재료가 3개 미만일 경우 itemArr.length < i 에 걸린다
	               item += (",#" + itemArr[i]);
	               i += 1;
	               System.out.println("i : " + i);
	            }
	            item = item.substring(1);
	            // System.out.println("재료(item)3개만 : "+item);

				dto.setItem(item);
				dto.setRecipePrice(rs.getInt("recipePrice"));
				dto.setUserId(rs.getString("nickName"));
				System.out.println("dto : " + dto);
				myLike.add(dto);
			}
			System.out.println("들어간 userId : " + userId);
			System.out.println("DAO myWrite() size : " + myLike.size());

			map.put("myLike", myLike);
			map.put("totalPage", pages);
			map.put("currPage", page);
			map.put("start", startPage);
			map.put("end", endPage);
		} catch (Exception e) {
			System.out.println("**DAO list()에러**");
			e.printStackTrace();
		}
		return map;
	}
	
	

	public HashMap<String, Object> myComment(int page, String userId) { // 찬호

		System.out.println("page : " + page);

		ArrayList<MainDTO> myComment = new ArrayList<MainDTO>();
		int start = 0;
		int end = 0;
		int endPage = 0;
		int startPage = 0;
		int pagePerCnt = 10; 
		int pagePerPage = 5; 
		int total = 0;
		try {
			total = myCommentTotalCount(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		int pages = total % pagePerCnt == 0 ? total / pagePerCnt : (total / pagePerCnt) + 1; // 만들 수 있는 페이지 수
		System.out.println("total pages : " + total + " / pages : " + pages);

		if (page > pages) {
			page = pages;
		}
		System.out.println("DAO 요청 받은 페이지 : " + page);

		start = ((page - 1) * pagePerCnt) + 1;
		end = page * pagePerCnt; 
		endPage = pagePerPage * ((int) ((page - 1) / pagePerPage) + 1);
		startPage = endPage - pagePerPage + 1;
		System.out.println("DAO startPage/endPage : " + startPage + "/" + endPage);

		HashMap<String, Object> map = new HashMap<String, Object>();
		String sql = "SELECT c.commentid commentid, c.comment_content content, c.userid userid, to_char(c.comment_date,'yyyy-mm-dd hh24:mi') comment_date, p.postId postid, p.title title "
				+ "FROM (SELECT commentid, comment_content, userid, comment_date FROM (SELECT ROW_NUMBER() OVER (ORDER BY comment_date DESC) as rnum, commentid, comment_content, userid, comment_date "
				+ "FROM (SELECT commentid, comment_content, userid, comment_date FROM recomment WHERE userid = ? UNION SELECT commentid, comment_content, userid, comment_date "
				+ "FROM postcomment WHERE userid = ?)) where rnum between ? and ?) c, post p WHERE p.postid IN (SELECT postid FROM postcomment WHERE commentid=c.commentid)";


		myComment = new ArrayList<MainDTO>();
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			ps.setString(2, userId);
			ps.setInt(3, start);
			ps.setInt(4, end);
			rs = ps.executeQuery();
			myComment = new ArrayList<MainDTO>();
			System.out.println("들어오는지확인");
			
			while (rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setCommentId(rs.getString("commentId"));
				dto.setComment_content(rs.getString("content"));
				dto.setUserId(rs.getString("userId"));
				dto.setComment_date(rs.getString("comment_date"));
				dto.setPostId(rs.getString("postId"));
				dto.setTitle(rs.getString("title"));
				System.out.println("dto : " + dto);
				myComment.add(dto);
			}
			System.out.println("들어간 userId : " + userId);
			System.out.println("DAO myComment() size : " + myComment.size());

			map.put("myComment", myComment);
			map.put("totalPage", pages);
			map.put("currPage", page);
			map.put("start", startPage);
			map.put("end", endPage);
		} catch (Exception e) {
			System.out.println("**DAO list()에러**");
			e.printStackTrace();
		}
		return map;

	}
	
	public HashMap<String, Object> myOrderHistory(int page, String userId) { // 찬호

		System.out.println("page : " + page);

		ArrayList<MainDTO> myOrderHistory = new ArrayList<MainDTO>();
		int start = 0;
		int end = 0;
		int endPage = 0;
		int startPage = 0;
		int pagePerCnt = 10; 
		int pagePerPage = 5; 
		int total = 0;
		try {
			total = myOrderHistoryTotalCount(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		int pages = total % pagePerCnt == 0 ? total / pagePerCnt : (total / pagePerCnt) + 1; // 만들 수 있는 페이지 수
		System.out.println("total pages : " + total + " / pages : " + pages);

		if (page > pages) {
			page = pages;
		}
		System.out.println("DAO 요청 받은 페이지 : " + page);

		start = ((page - 1) * pagePerCnt) + 1;
		end = page * pagePerCnt; 
		endPage = pagePerPage * ((int) ((page - 1) / pagePerPage) + 1);
		startPage = endPage - pagePerPage + 1;
		System.out.println("DAO startPage/endPage : " + startPage + "/" + endPage);

		HashMap<String, Object> map = new HashMap<String, Object>();
		String sql = "select p.paymentid as paymentId, p.userid as ID, o.productname as productName, o.price as price, o.productcnt as productCount, "
				+ "p.orderprice as orderPrice, p.paymentprice as paymentPrice, p.discount as discount, p.paymentdate paymentDate "
				+ "from payment p, orderhistory o where p.paymentid = o.paymentid and userid = ?";


		myOrderHistory = new ArrayList<MainDTO>();
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			myOrderHistory = new ArrayList<MainDTO>();
			System.out.println("들어오는지확인");
			
			while (rs.next()) {
				MainDTO dto = new MainDTO();
				dto.setPaymentId(rs.getString("paymentId"));
				dto.setUserId(rs.getString("ID"));
				dto.setProductName(rs.getString("productName"));
				dto.setPrice(rs.getInt("price"));
				dto.setProductCount(rs.getInt("productCount"));
				dto.setOrderPrice(rs.getString("orderPrice"));
				dto.setPaymentPrice(rs.getString("paymentPrice"));
				dto.setDiscount(rs.getInt("discount"));
				dto.setPaymentDate(rs.getDate("paymentDate"));
				System.out.println("dto : " + dto);
				myOrderHistory.add(dto);
			}
			System.out.println("들어간 userId : " + userId);
			System.out.println("DAO myOrderHistory() size : " + myOrderHistory.size());

			map.put("myOrderHistory", myOrderHistory);
			map.put("totalPage", pages);
			map.put("currPage", page);
			map.put("start", startPage);
			map.put("end", endPage);
		} catch (Exception e) {
			System.out.println("**DAO list()에러**");
			e.printStackTrace();
		}
		return map;

	}
	
	public int myOrderHistoryTotalCount(String userId) throws SQLException {

		String sql = "select count(*) "
				+ "from payment p left outer join orderhistory o on p.paymentid = o.paymentid where p.userid = ?";
		
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		rs = ps.executeQuery();

		int total = 0;

		if (rs.next()) {
			total = rs.getInt(1);
		}

		return total;
	}
	
	
/*================================================진후============================================================================= */
	
	
	public int join(MainDTO dto) throws SQLException {// 진후
		System.out.println("멤버DAO 조인 들어옴");
		String sql = "INSERT INTO member(userId, pw, name, nickName, address, tel)" + "VALUES(?,?,?,?,?,?)";
		ps = conn.prepareStatement(sql);
		ps.setString(1, dto.getUserId());
		ps.setString(2, dto.getPw());
		ps.setString(3, dto.getName());
		ps.setString(4, dto.getNickName());
		ps.setString(5, dto.getAddress());
		ps.setString(6, dto.getTel());
		return ps.executeUpdate();
	}

	public boolean overlay(String userId) throws SQLException {// 진후
		System.out.println("아이디 중복체크DAO");
		String sql = "SELECT userId FROM member WHERE userId = ?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		rs = ps.executeQuery();
		return rs.next();
	}

	public boolean overlay1(String nickName) throws SQLException {// 진후
		System.out.println("닉네임 중복체크DAO");
		String sql = "SELECT nickName FROM member WHERE nickName = ?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, nickName);
		rs = ps.executeQuery();
		return rs.next();
	}

	public HashMap<String, Object> login(String userId, String pw) throws SQLException {//진후
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		System.out.println("멤버DAO 들어옴");
		String sql="SELECT userId, nickName, isAdmin FROM member WHERE userId=? AND pw=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, userId);
		ps.setString(2, pw);	
		rs = ps.executeQuery();			
		
		
		String loginId="";
		String nickName="";
		String isAdmin="";
		
		if(rs.next()) {
		loginId=rs.getString("userId");
		nickName=rs.getString("nickName");
		isAdmin=rs.getString("isAdmin");
		map.put("userId", loginId);
		map.put("nickName", nickName);
		map.put("isAdmin", isAdmin);
		}
		
		sql="SELECT suspendId, suspendReason, to_char(suspendDate,'yyyy-mm-dd hh24:mi') suspendDate From suspend WHERE userId=?";
		ps = conn.prepareStatement(sql);
		ps.setString(1, loginId);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			String suspendId=rs.getString("suspendId");
			String suspendReason=rs.getString("suspendReason");
			String suspendDate=rs.getString("suspendDate");
			map.put("suspendId", suspendId);
			map.put("suspendReason", suspendReason);
			map.put("suspendDate", suspendDate);
			}		
		
		return map;		
	}

	public ArrayList<MainDTO> myOrder(String userId) {
		System.out.println("MemberDAO myOrder 들어옴, userId : "+userId);
		String sql="select paymentId, to_char(paymentdate,'yyyy-mm-dd hh24:mi:ss') paymentdate,paymentprice,orderstatus FROM payment WHERE userId=? ORDER BY paymentdate DESC";
		MainDTO dto = null;
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);	
			rs = ps.executeQuery();	
			while(rs.next()) {
				dto = new MainDTO();
				dto.setPaymentId(rs.getString("paymentId"));
				dto.setPaymentdate(rs.getString("paymentdate"));
				dto.setPaymentPrice(rs.getString("paymentprice"));
				dto.setOrderStatus(rs.getString("orderStatus"));
				list.add(dto);
			}
			System.out.println("myOrder list size : "+list.size());
		} catch (Exception e) {
			System.out.println("MemberDAO myOrder() 에러");
			e.toString();
		}
		return list;
	}

	public HashMap<String, Object> orderHistory(String paymentId) { //은홍
		System.out.println("MemberDAO orderHistroy 들어옴, paymentId : "+paymentId);
		HashMap<String, Object> map = new HashMap<String, Object>();
		MainDTO dto = null;
		
		String paymentDate ="";
		String orderStatus = "";
		int orderPrice = 0;
		int discount = 0;
		int paymentPrice = 0;
		sql = "SELECT to_char(paymentdate,'yyyy-mm-dd hh24:mi:ss')paymentDate, paymentPrice, orderPrice, discount,orderstatus\r\n" + 
				"FROM payment WHERE paymentId=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, paymentId);
			rs = ps.executeQuery();
			if(rs.next()) {
				paymentDate = rs.getString("paymentDate");
				orderStatus = rs.getString("orderStatus");
				orderPrice = rs.getInt("orderPrice");
				discount = rs.getInt("discount");
				paymentPrice = rs.getInt("paymentPrice");
				System.out.println("paymentDate/orderStatus/orderPrice/discount/paymentPrice : "+paymentDate+" / "+orderStatus+" / "+orderPrice+" / "+discount+" / "+paymentPrice);
				map.put("paymentDate", paymentDate);
				map.put("orderStatus", orderStatus);
				map.put("orderPrice", orderPrice);
				map.put("discount", discount);
				map.put("paymentPrice", paymentPrice);
			}
		} catch (Exception e) {
			e.toString();
		}
		
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		String imgNewName = "";
		String productName = "";
		int productCnt = 0;
		int price = 0;
		String productId = "";
		sql = "SELECT (SELECT imgNewName FROM image WHERE imgField='product_th' AND fieldId=o.productId) imgNewName ,o.* fROM orderHistory o WHERE paymentId=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, paymentId);
			rs = ps.executeQuery();
			while(rs.next()) {
				dto = new MainDTO();
				imgNewName = rs.getString("imgNewName");
				productName = rs.getString("productName");
				productCnt = rs.getInt("productCnt");
				price = rs.getInt("price");
				productId = rs.getString("productId");
				System.out.println("imgNewName/productName/productCnt/price : "+imgNewName+"/"+productName+"/"+productCnt+"/"+price+"/"+productId);
				dto.setImgNewName(imgNewName);
				dto.setProductName(productName);
				dto.setProductCount(productCnt);
				dto.setPrice(price);
				dto.setProductId(productId);
				list.add(dto);
			}
		} catch (Exception e) {
			e.toString();
		}
		System.out.println("MemberDAO orderHistory() list size : "+list.size());
		map.put("orderList", list);
		
		return map;
	}
	
	
	

}
