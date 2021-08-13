<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>

		<main id="body">
			<h3>베스트 게시판</h3>
			<button onclick="location.href='./bestPost'">전체</button>
			<button onclick="location.href='./bestMonth'">이달의 레시피</button>
			<button onclick="location.href='./bestWeek'">이주의 레시피</button>

			<div>
				<form action="bestSearch" method="get">
					<input type="date" name="startDate" value="${startDate}"> ~
					<input type="date" name="endDate" value="${endDate}">
					<button type="submit">검색</button>
				</form>
			</div>
			<table>
				<c:if test="${bestSearch eq null || bestSearch eq ''}">
					<tr>
						<td>베스트 레시피가 없습니다.</td>
					</tr>
				</c:if>
				<c:set var="i" value="0" />
				<c:set var="j" value="3" />
				<c:forEach items="${bestSearch}" var="best">
					<c:if test='${i % j == 0}'>
						<tr>
					</c:if>
					<td><a href="postDetail?postId=${best.postId}">${best.title}</a></td>
					<td>${best.recipePrice}</td>
					<td>${best.hits}</td>
					<td>${best.likes}</td>
					<td>${best.userId}</td>
					<td>${best.item}</td>
					<c:if test="${i % j == j - 1}">
						</tr>
					</c:if>
					<c:set var="i" value="${i+1}" />
				</c:forEach>
			</table>
			<div class="pageArea">
				<c:forEach var="i" begin="1" end="${totalPage}" step="1">
					<span class="page"> <c:if test="${i ne currPage}">
							<a
								href="./bestSearch?page=${i}&startDate=${startDate}&endDate=${endDate}">${i}</a>
						</c:if> <c:if test="${i eq currPage}">
							<b>${i}</b>
						</c:if>
					</span>
				</c:forEach>
			</div>
			<footer>
				<%@include file="footer.jsp"%>
			</footer>
		</main>
	</div>
</body>
</html>