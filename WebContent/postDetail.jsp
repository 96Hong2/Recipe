<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 게시글 상세보기</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/board.css" media="all" />
</head>
<body>
	<h2>게시글 상세보기</h2>	
	<table>
		<tr>
			<th>글번호</th>
			<td>${post.postId}</td>
			<th>작성자</th>
			<td>${post.nickName}</td>
			<th>등급</th>
			<td>${post.rankName}</td>
			<th>제목</th>
			<td>${post.title}</td>
			<th>작성날짜</th>
			<td>${post.postDate}</td>
			<th>좋아요</th>
			<td>${post.likes}</td>
			<th>조회수</th>
			<td>${post.hits}</td>
		</tr>
		<tr>
			<th>카테고리</th>
			<td>${post.categoryName}</td>
			<th>예상금액</th>
			<td>${post.recipePrice}￦</td>
			<th>재료</th>
			<td colspan="9">${post.item}</td>
		</tr>
		<tr>
			<th>첨부 이미지</th>
			<td colspan="14"><c:if test="${post.imgNewName ne null }"><img src="/photo/${post.imgNewName}" width="500px" height="500px"/></c:if></td>
		</tr>
		<tr>
		<th>Recipe</th>
		<td colspan="14">${post.contents}</td>
		</tr>
		<tr>
			<td colspan="14">
				<button onclick="location.href='./신고폼?postId=${post.postId}'">신고</button>
				<button onclick="location.href='./블라인드폼?postId=${post.postId}'">블라인드</button>
				<button onclick="location.href='./postUpdateForm?postId=${post.postId}'">수정</button>
				<input type="button" value="삭제" onclick="button_evert()"/>
				<button onclick="location.href='./postList'">리스트</button>
			</td>
		</tr>
	</table>
</body>
<script>	
	function button_evert(){
		var result = confirm("정말 삭제하시겠습니까?");
		if(result){
			location.href='./postDel?postId=${post.postId}';
		}else{
			return;
		}
	}
	
</script>
</html>