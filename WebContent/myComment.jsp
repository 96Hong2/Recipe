<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>
	if ("${sessionScope.userId}" == "") {
		alert("로그인이 필요한 서비스입니다.");
		location.href = "./";
	}
</script>

</head>
<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>
		<main id="body">
			<div>
				<!-- <button onclick = "location.href = './myPage'">MY PAGE로 돌아가기</button> -->
				<a href='./myPage' id='backToMyPage'><h4
						style="border: 2px solid #bbb; border-radius: 10px; text-align: center; width: 230px;">
						← MY PAGE로 돌아가기</h4></a>
			</div>
			<div>
				<h3>${sessionScope.nickName}님이작성한댓글 목록</h3>
			</div>
			<div>
				<table>
					<c:if test="${empty myComment}">
						<tr>
							<td>작성한 댓글이 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${!empty myComment}">
						<c:forEach items="${myComment}" var="comment">
							<tr style="height: 70px;">
								<td style="width: 700px; text-align: left">&nbsp&nbsp${comment.comment_content}</td>
								<td style="width: 200px">${comment.comment_date}</td>
								<%-- <a href="postDetail?postId=${like.postId}"> --%>
							</tr>
						</c:forEach>
					</c:if>
				</table>
			</div>

			<div class="pageArea"
				style="width: 740px; margin: auto; text-align: center;">
				<c:forEach var="i" begin="1" end="${totalPage}" step="1">
					<span class="page"> <c:if test="${i ne currPage}">
							<a href="./myLike?page=${i}">${i}</a>
						</c:if> <c:if test="${i eq currPage}">
							<b>${i}</b>
						</c:if>
					</span>
				</c:forEach>
			</div>
		</main>
		<footer>
			<%@include file="footer.jsp"%>
		</footer>
	</div>
</body>
</html>