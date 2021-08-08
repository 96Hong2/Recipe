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


public class BoardDAO {

	PreparedStatement ps = null;
	ResultSet rs = null;
	Connection conn = null;
	String sql = "";
	public BoardDAO() {
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
			if(rs != null && !rs.isClosed()) {rs.close();}
			if(ps != null && !ps.isClosed()) {ps.close();}
			if(conn != null && !conn.isClosed()) {conn.close();}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String write(MainDTO dto) { //영환
		System.out.println("BoardDAO write() 실행");
		String postId = "";
		String sql = "INSERT INTO post(postId,title,categoryId,recipePrice,item,contents,userId)"+
				     "VALUES(postId_seq.NEXTVAL,?,?,?,?,?,?)";
		try {
			ps = conn.prepareStatement(sql,new String[] {"postId"});
			ps.setString(1, dto.getTitle());
			ps.setString(2, dto.getCategoryId());
			ps.setInt(3, dto.getRecipePrice());
			ps.setString(4, dto.getItem());
			ps.setString(5, dto.getContents());
			ps.setString(6, dto.getUserId());
			ps.executeUpdate();
			rs = ps.getGeneratedKeys(); //값만 받아오기
			if(rs.next()) {
				postId = rs.getString(1); // ps에서 String배열의 1번째 값(postId) 가져오기
				System.out.println("작성된 postId:" + postId);			
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return postId;
	}

	public int upHits(String postId) { //영환
		System.out.println("BoardDAO upHits() 실행 : 조회수 올리기");
		int result = 0;
		
		try {
			conn.setAutoCommit(false);
			String sql = "UPDATE post SET hits = hits+1 WHERE postId=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, postId);
			result = ps.executeUpdate();
			System.out.println("조회수 올리기 성공 : "+result);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public MainDTO detail(String postId) { //영환
		System.out.println("BoardDAO detail() 실행 : 게시글 상세보기");
		MainDTO dto = null;
		
			String sql = "SELECT p.postId, p.title, p.contents, m.nickName,p.isDel, "+
								"p.recipePrice, p.hits, p.likes, p.postDate,i.imgnewname, "+
								"p.item, p.userId, r.rankName, c.categoryname, p.categoryId "+ 
						        "FROM post p, member m, category c, rank r, image i "+
						        "WHERE p.postId = ? AND p.userId = m.userId "+
						        "AND m.rankId = r.rankId AND p.categoryId = c.categoryId "+
						        "AND i.fieldid =p.postId AND i.imgfield='post'";
			
			try {
				ps = conn.prepareStatement(sql);
				ps.setString(1, postId);
				rs = ps.executeQuery();
				if(rs.next()) {
				dto = new MainDTO();
				dto.setPostId(rs.getString("postId"));
				dto.setTitle(rs.getString("title"));
				dto.setContents(rs.getString("contents"));
				dto.setRecipePrice(rs.getInt("recipePrice"));
				dto.setHits(rs.getInt("hits"));
				dto.setLikes(rs.getInt("likes"));
				dto.setPostDate(rs.getDate("postDate"));
				dto.setItem(rs.getString("item"));
				dto.setUserId(rs.getString("userId")); //아이디
				dto.setNickName(rs.getString("nickName"));
				dto.setRankName(rs.getString("rankName"));
				dto.setCategoryName(rs.getString("categoryName"));
				dto.setCategoryId(rs.getString("categoryId"));
				dto.setIsDel(rs.getString("isDel"));
				dto.setImgNewName(rs.getString("imgNewName"));
				
				System.out.println("게시글 상세보기 dto :"+dto);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			if(dto == null) {
				String sql1 = "SELECT p.postId, p.title, p.contents, p.recipePrice, p.hits,p.isDel,p.categoryId, "+
						      "p.likes, p.postDate,p.item, p.userId, r.rankName, c.categoryname,m.nickName "+ 
						      "FROM post p, member m, category c, rank r WHERE p.postId = ? AND p.userId = m.userId "+
						      "AND m.rankId = r.rankId AND p.categoryId = c.categoryId";
				
				try {
					ps = conn.prepareStatement(sql1);
					ps.setString(1, postId);
					rs = ps.executeQuery();
					
					if(rs.next()) {
						dto = new MainDTO();
						dto.setPostId(rs.getString("postId"));
						dto.setTitle(rs.getString("title"));
						dto.setContents(rs.getString("contents"));
						dto.setRecipePrice(rs.getInt("recipePrice"));
						dto.setHits(rs.getInt("hits"));
						dto.setLikes(rs.getInt("likes"));
						dto.setPostDate(rs.getDate("postDate"));
						dto.setItem(rs.getString("item"));
						dto.setUserId(rs.getString("userId")); //아이디
						dto.setNickName(rs.getString("nickName"));
						dto.setRankName(rs.getString("rankName"));
						dto.setCategoryName(rs.getString("categoryName"));
						dto.setCategoryId(rs.getString("categoryId"));
						dto.setIsDel(rs.getString("isDel"));
					
						System.out.println("게시글 상세보기 dto :"+dto);
					}
				}catch (SQLException e) {
					e.printStackTrace();
				}
			}
			
		return dto;
	}
	
	public void isHits(MainDTO dto) { //영환
		System.out.println("BoardDAO isHits() 실행 : rollback/commit");
		System.out.println("dto :"+dto);
		try {
			if(dto == null) {
				conn.rollback();
				System.out.println("조회수 올리기 실패 롤백");
			} else {
				conn.commit();
				System.out.println("조회수 올리기 커밋 완료");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int postUpdate(MainDTO dto) { //영환
		System.out.println("BoardDAO postUpdate() 실행 : 게시글 수정 ");
		int result = 0;
		String sql="UPDATE post SET title=?, categoryId=?, recipePrice=?, item=?, contents=? WHERE postId=?";
	
		try {
		ps = conn.prepareStatement(sql);
		ps.setString(1, dto.getTitle());
		ps.setString(2, dto.getCategoryId());
		ps.setInt(3, dto.getRecipePrice());
		ps.setString(4, dto.getItem());
		ps.setString(5, dto.getContents());
		ps.setString(6, dto.getPostId());
		result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public MainDTO del(int postId) { //영환
		System.out.println("BoardDAO del() 실행 : 게시글 삭제여부 변경");
		MainDTO dto = null;
		try {
			String sql = "UPDATE post SET isDel='Y' WHERE postId=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, postId);
			ps.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		try {
			dto = new MainDTO();
			String sql = "SELECT isDel FROM post WHERE postId=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, postId);
			rs = ps.executeQuery();
			if(rs.next()) {
				dto.setIsDel(rs.getString("isDel"));
				}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	public ArrayList<MainDTO> postList(int end, int start) { //영환
		System.out.println("BoardDAO postList() 실행 : 게시글 리스트");
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		MainDTO dto = null;
		String sql = "SELECT rnum,postid, title,recipePrice, item, hits, likes, imgNewName, nickname, categoryId "+
					 "FROM(SELECT ROW_NUMBER() OVER(ORDER BY p.postDate DESC)AS RNUM "+
				     ",p.postId,p.title,p.recipePrice,p.item,p.hits,p.likes,i.imgNewName,p.categoryId "+
				     ",(SELECT nickname FROM member WHERE userid=p.userId) nickname "+
				     "FROM post p LEFT OUTER JOIN image i ON p.postId=i.fieldId AND i.imgField='post_th' "+
				     "ORDER BY p.postDate DESC) WHERE rnum between ? AND ?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			rs = ps.executeQuery();
			while(rs.next()) {
				dto = new MainDTO();
				dto.setPostId(rs.getString("postId"));
				dto.setTitle(rs.getString("title"));
				dto.setRecipePrice(rs.getInt("recipePrice"));
				dto.setItem(rs.getString("item"));
				dto.setHits(rs.getInt("hits"));
				dto.setLikes(rs.getInt("likes"));
				dto.setImgNewName(rs.getString("imgNewName"));
				dto.setNickName(rs.getString("nickName"));
				dto.setCategoryId(rs.getString("categoryId"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int totalCount() { //영환
		System.out.println("BoardDAO totalCount() 실행");
		String sql = "SELECT COUNT(postId) FROM post";
		int total = 0;
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			
			if(rs.next()) {
				total = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return total;
	}

	public ArrayList<MainDTO> categoryList(int end, int start, int categoryId) { //영환
		System.out.println("BoardDAO categoryList() 실행 : 게시글 리스트");
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		MainDTO dto = null;
		String sql = "SELECT rnum,postid, title,recipePrice, item, hits, likes, imgNewName, nickname,categoryId "+
					 "FROM(SELECT ROW_NUMBER() OVER(PARTITION BY categoryId ORDER BY p.postDate DESC)AS RNUM "+
				     ",p.postId,p.title,p.recipePrice,p.item,p.hits,p.likes,i.imgNewName "+
				     ",(SELECT nickname FROM member WHERE userid=p.userId) nickname,p.categoryId "+
				     "FROM post p LEFT OUTER JOIN image i ON p.postId=i.fieldId AND i.imgField='post_th' "+
				     "ORDER BY p.postDate DESC) WHERE categoryId=? AND rnum between ? AND ?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, categoryId);
			ps.setInt(2, start);
			ps.setInt(3, end);
			rs = ps.executeQuery();
			while(rs.next()) {
				dto = new MainDTO();
				dto.setPostId(rs.getString("postId"));
				dto.setTitle(rs.getString("title"));
				dto.setRecipePrice(rs.getInt("recipePrice"));
				dto.setItem(rs.getString("item"));
				dto.setHits(rs.getInt("hits"));
				dto.setLikes(rs.getInt("likes"));
				dto.setImgNewName(rs.getString("imgNewName"));
				dto.setNickName(rs.getString("nickName"));
				dto.setCategoryId(rs.getString("categoryId"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int categoryCount(int categoryId) { //영환
		System.out.println("BoardDAO categoryCount() 실행");
		String sql = "SELECT COUNT(postId) FROM post WHERE categoryId=?";
		int total = 0;
		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, categoryId);
			rs = ps.executeQuery();
			
			
			if(rs.next()) {
				total = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return total;
	}

	public ArrayList<MainDTO> postSearch(String keyword, String keywordMin, String keywordMax, int categoryId,
			String postSearchOpt, int start, int end) {
		System.out.println("BoardDAO postSearch() 실행");
		ArrayList<MainDTO> list = new ArrayList<MainDTO>();
		MainDTO dto = null;
		String sql = "SELECT rnum,postid, title,recipePrice, item, hits, likes, imgNewName, nickname,categoryId,contents "+ 
					"FROM(SELECT ROW_NUMBER() OVER(PARTITION BY categoryId ORDER BY p.postDate DESC)AS RNUM "+ 
					",p.postId,p.title,p.recipePrice,p.item,p.hits,p.likes,i.imgNewName,p.categoryId,p.contents "+ 
					",(SELECT nickname FROM member WHERE userid=p.userId) nickname "+ 
					"FROM post p LEFT OUTER JOIN image i ON p.postId=i.fieldId AND i.imgField='post_th' "+ 
					"ORDER BY p.postDate DESC) ";
					
		String keywords = '%' + keyword + '%';
		
		if(postSearchOpt.equals("title_contentsSearch") && categoryId != 0) {
			System.out.println("title_contentsSearch\") && categoryId != 0  실행");
		sql += "WHERE rnum between ? AND ? AND categoryId=? AND (title like ? OR contents like ?) ";
		try {
			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			ps.setInt(3, categoryId);
			ps.setString(4, keywords);
			ps.setString(5, keywords);
			rs = ps.executeQuery();
			while(rs.next()) {
				dto = new MainDTO();
				dto.setPostId(rs.getString("postId"));
				dto.setTitle(rs.getString("title"));
				dto.setRecipePrice(rs.getInt("recipePrice"));
				dto.setItem(rs.getString("item"));
				dto.setHits(rs.getInt("hits"));
				dto.setLikes(rs.getInt("likes"));
				dto.setImgNewName(rs.getString("imgNewName"));
				dto.setNickName(rs.getString("nickName"));
				dto.setCategoryId(rs.getString("categoryId"));
				dto.setContents(rs.getString("contents"));
				list.add(dto);
				}
			} catch (SQLException e) {
			e.printStackTrace();
			}
		}else if(postSearchOpt.equals("recipePriceSearch") && categoryId != 0) {
			System.out.println("postSearchOpt.equals(\"recipePriceSearch\") && categoryId != 0  실행");
				sql += "WHERE rnum between ? AND ? AND categoryId=? AND recipePrice between ? AND ? ";
				try {
					ps = conn.prepareStatement(sql);
					ps.setInt(1, start);
					ps.setInt(2, end);
					ps.setInt(3, categoryId);
					ps.setString(4, keywordMin);
					ps.setString(5, keywordMax);
					rs = ps.executeQuery();
					while(rs.next()) {
						dto = new MainDTO();
						dto.setPostId(rs.getString("postId"));
						dto.setTitle(rs.getString("title"));
						dto.setRecipePrice(rs.getInt("recipePrice"));
						dto.setItem(rs.getString("item"));
						dto.setHits(rs.getInt("hits"));
						dto.setLikes(rs.getInt("likes"));
						dto.setImgNewName(rs.getString("imgNewName"));
						dto.setNickName(rs.getString("nickName"));
						dto.setCategoryId(rs.getString("categoryId"));
						dto.setContents(rs.getString("contents"));
						list.add(dto);
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}else if(categoryId == 0 && postSearchOpt.equals("title_contentsSearch")) {
				System.out.println("categoryId == 0 && postSearchOpt.equals(\"title_contentsSearch\")  실행");
				sql += "WHERE rnum between ? AND ? AND (title like ? OR contents like ?)";
				try {
					ps = conn.prepareStatement(sql);
					ps.setInt(1, start);
					ps.setInt(2, end);
					ps.setString(3, keywords);
					ps.setString(4, keywords);
					rs = ps.executeQuery();
					while(rs.next()) {
						dto = new MainDTO();
						dto.setPostId(rs.getString("postId"));
						dto.setTitle(rs.getString("title"));
						dto.setRecipePrice(rs.getInt("recipePrice"));
						dto.setItem(rs.getString("item"));
						dto.setHits(rs.getInt("hits"));
						dto.setLikes(rs.getInt("likes"));
						dto.setImgNewName(rs.getString("imgNewName"));
						dto.setNickName(rs.getString("nickName"));
						dto.setCategoryId(rs.getString("categoryId"));
						dto.setContents(rs.getString("contents"));
						list.add(dto);
						}
					} catch (SQLException e) {
					e.printStackTrace();
					}
			}else if(categoryId == 0 && postSearchOpt.equals("recipePriceSearch")) {
				System.out.println("categoryId == 0 && postSearchOpt.equals(\"recipePriceSearch\")  실행");
				sql += "WHERE rnum between ? AND ? AND recipePrice between ? AND ? ";
				try {
					ps = conn.prepareStatement(sql);
					ps.setInt(1, start);
					ps.setInt(2, end);
					ps.setString(3, keywordMin);
					ps.setString(4, keywordMax);
					rs = ps.executeQuery();
					while(rs.next()) {
						dto = new MainDTO();
						dto.setPostId(rs.getString("postId"));
						dto.setTitle(rs.getString("title"));
						dto.setRecipePrice(rs.getInt("recipePrice"));
						dto.setItem(rs.getString("item"));
						dto.setHits(rs.getInt("hits"));
						dto.setLikes(rs.getInt("likes"));
						dto.setImgNewName(rs.getString("imgNewName"));
						dto.setNickName(rs.getString("nickName"));
						dto.setCategoryId(rs.getString("categoryId"));
						dto.setContents(rs.getString("contents"));
						list.add(dto);
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		return list;
	}

	public int searchCount(int categoryId, String keyword, String keywordMin, String keywordMax, String postSearchOpt) {
		System.out.println("BoardDAO searchCount() 실행");
		int total = 0;
		String keywords = '%' + keyword + '%';
		if(postSearchOpt.equals("title_contentsSearch") && categoryId != 0 ) {
			try {
				String sql = "SELECT COUNT(postId) FROM post WHERE categoryId=? AND title like ? OR contents like ? ";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, categoryId);
				ps.setString(2, keywords);
				ps.setString(3, keywords);
				rs = ps.executeQuery();
				
				if(rs.next()) {
					total = rs.getInt(1);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else if(postSearchOpt.equals("recipePriceSearch") && categoryId != 0) {
			try {
				String sql = "SELECT COUNT(postId) FROM post WHERE categoryId=? AND recipePrice between ? AND ?";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, categoryId);
				ps.setString(2, keywordMin);
				ps.setString(3, keywordMax);
				rs = ps.executeQuery();

				if(rs.next()) {
					total = rs.getInt(1);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else if(categoryId == 0 && postSearchOpt.equals("title_contentsSearch")) {
			try {
				String sql = "SELECT COUNT(postId) FROM post WHERE title like ? OR contents like ?  ";
				ps = conn.prepareStatement(sql);
				ps.setString(1, keywords);
				ps.setString(2, keywords);
				rs = ps.executeQuery();
				
				if(rs.next()) {
					total = rs.getInt(1);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else if(categoryId == 0 && postSearchOpt.equals("recipePriceSearch")) {
			try {
				String sql = "SELECT COUNT(postId) FROM post WHERE recipePrice between ? AND ? ";
				ps = conn.prepareStatement(sql);
				ps.setString(1, keywords);
				ps.setString(2, keywords);
				rs = ps.executeQuery();
				
				if(rs.next()) {
					total = rs.getInt(1);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		System.out.println("total : "+total);
		return total;
	}
}
