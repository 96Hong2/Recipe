<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.userId}"==""){
   alert("로그인이 필요한 서비스입니다.");
   location.href = "./";
}
</script>
	<header>
		<%@include file="header_afterLogin.jsp"%>
	</header>
</head>
<body>
<div style="width: 900px; display: flex; margin-bottom: 20px;">
<div>
<!-- <button onclick = "location.href = './myPage'">MY PAGE로 돌아가기</button> -->
<a href='./myPage' id='backToMyPage'><h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MY PAGE로 돌아가기</h4></a>
</div>
<div>
<h3>내가 쓴 댓글 목록</h3>
</div>
<div>
<table>
	<c:if test="${empty myComment}">
		<tr>
			<td>작성한 댓글이 없습니다.</td>
		</tr>
	</c:if>
	<c:if test="${!empty myComment}">
		<c:forEach items = "${myComment}" var = "comment">
			<tr>				
				<td>${comment.comment_content}</td>
				<td>${comment.comment_date}</td>
			</tr>
		</c:forEach>
	</c:if>
</table>
</div>

	<div class="pageArea">
		<c:forEach var="i" begin="1" end="${totalPage}" step="1">
			<span class="page">
				<c:if test="${i ne currPage}"><a href="./myComment?page=${i}">${i}</a></c:if>
				<c:if test="${i eq currPage}"><b>${i}</b></c:if>
			</span>
		</c:forEach> 
	</div>
</div>
</body>
</html>