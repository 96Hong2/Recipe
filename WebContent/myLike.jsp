<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h3>~님의 좋아요 목록</h3>
<button onclick = "location.href = './myPage'">MY PAGE로 돌아가기</button>
<table>
	<c:if test="${myLike eq null || myLike eq ''}">
	<tr>
		<td>좋아요 누른 레시피가 없습니다.</td>
	</tr>
	</c:if>
	<c:set var="i" value="0" />
	<c:set var="j" value="3" />
	<c:forEach items = "${myLike}" var = "like">
			<c:if test='${i % j == 0}'>
			<tr>
			</c:if>				
				<td><a href="detail?idx=${like.title}">${like.title}</a></td>
				<td>${like.title}</td>
				<td>${like.recipePrice}</td>
				<td>${like.hits}</td>
				<td>${like.likes}</td>
				<td>${like.userId}</td>
				<td>${like.item}</td>
			<c:if test="${i % j == j-1}">
			</tr>
		</c:if>
		<c:set var="i" value="${i+1}" />
	</c:forEach>
		<div class="pageArea">
		<c:forEach var="i" begin="1" end="${totalPage}" step="1">
			<span class="page">
				<c:if test="${i ne currPage}"><a href="./myLike?page=${i}">${i}</a></c:if>
				<c:if test="${i eq currPage}"><b>${i}</b></c:if>
			</span>
		</c:forEach> 
	</div>
</table>
</body>
</html>