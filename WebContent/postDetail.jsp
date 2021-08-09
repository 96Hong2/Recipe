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
<script>
	if("${sessionScope.userId}"==""){
  		 location.href = "./postList";
  		 alert("로그인이 필요한 서비스입니다.");
	}
</script>
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
				<%-- <c:if test="${sessionScope.userId != null}"><button onclick="reportPopUp(${post.postId},'${post.nickName}')">신고</button></c:if> --%>
				<!-- 신고버튼 교체 -->
				<button onclick="reportPopUp('${post.postId}','${post.nickName}')">신고</button>
				
				<%-- <c:if test="${sessionScope.isAdmin != null}"><button onclick="blindPopUp(${post.postId},'${post.nickName}')">블라인드</button></c:if> --%>
				<!-- 블라인드 버튼 교체 -->
				<button onclick="blindPopUp('${post.postId}','${post.nickName}')">블라인드</button>
				
				<%-- <c:if test="${sessionScope.userId == post.userId}"><button onclick="location.href='./postUpdateForm?postId=${post.postId}'">수정</button></c:if> --%>
				<!-- 수정 버튼 교체 -->
				<button onclick="location.href='./postUpdateForm?postId=${post.postId}'">수정</button>
				
				<%-- <c:if test="${sessionScope.userId == post.userId}"><input type="button" value="삭제" onclick="button_evert()"/></c:if> --%>
				<input type="button" value="삭제" onclick="button_evert()"/>
				<button onclick="location.href='./postList'">리스트</button>
			</td>
		</tr>
	</table>
	
	
	
	<!-- 댓글창 -->
	
	
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
	
	function reportPopUp(postId, nickName){
		   var url = "./memberReport?classification=P&&postId="+postId+"&&nickName="+nickName;
		   var option = "width=650, height=500, top=500, location = no, resizable = no";
		   window.open(url, "reportPopUp", option);
		          
		}	
	function blindPopUp(postId, nickName){
		   var url = "./memberBlind?classification=P&&postId="+postId+"&&nickName="+nickName;
		   var option = "width=650, height=500, top=500, location = no, resizable = no";
		   window.open(url, "blindPopUp", option);         
		}	
	function reloadPage(){
	       console.log("새로고침");
	       location.reload();
	    }
</script>
</html>