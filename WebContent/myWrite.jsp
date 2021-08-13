<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
				<h3>${sessionScope.nickName}님의작성한레시피목록</h3>
			</div>
			<div>
				<!-- <button onclick = "location.href = './myPage'">MY PAGE로 돌아가기</button> -->
				<a href='./myPage' id='backToMyPage'><h4
						style="border: 2px solid #bbb; border-radius: 10px; text-align: center; width: 230px;">
						← MY PAGE로 돌아가기</h4></a>
			</div>
			<c:if test="${empty myWrite}">
				<tr>
					<td>작성한 레시피가 없습니다.</td>
				</tr>
			</c:if>
			<div class="recipeContainer">
				<c:forEach items="${myWrite}" var="write">
					<div style="width: 280px; height: 252px;">
						<a href="postDetail?postId=${write.postId}">
							<figure class="recipeFigure">
								<c:set var="imgNewName" value="${write.imgNewName}" />
								<c:if test="${imgNewName eq null }">
									<img class="img" src="./defaultThum.png"
										style="height: 100px; width: 180px; margin: 10px;"
										onclick="location.href='postDetail?postId=${write.postId}'" />
								</c:if>
								<c:if test="${imgNewName ne null }">
									<img class="img" src="/photo/${post.imgNewName}"
										style="height: 100px; width: 180px; margin: 10px;"
										onclick="location.href='postDetail?postId=${write.postId}'" />
								</c:if>
								<figcaption>
									<div style="margin: 0 5px 5px 5px;">
										<div>
											<div style="font-size: 0.5em; float: left; width: 30px;">
												좋아요<br />${write.likes}
											</div>
											<div
												style="font-weight: bold; float: left; width: 122px; margin: 0 4px 0 4px; text-align: left;">
												<small>${write.title}</small>
											</div>
											<div style="font-size: 0.5em; float: left; width: 30px;">
												조회수<br />${write.hits}
											</div>
										</div>
										<div>
											<div>
												<div style="text-align: left; text-overflow: ellipsis;">
													<small>${write.item}</small>
												</div>
												<div style="text-align: left;">
													<small>${write.recipePrice}\</small>
												</div>
												<div style="text-align: right;">
													<small>${write.userId}</small>
												</div>
											</div>
										</div>
									</div>
								</figcaption>
							</figure>
						</a>
					</div>
				</c:forEach>
			</div>
			<div class="pageArea"
				style="width: 740px; margin: auto; text-align: center;">
				<c:forEach var="i" begin="1" end="${totalPage}" step="1">
					<span class="page"> <c:if test="${i ne currPage}">
							<a href="./myWrite?page=${i}">${i}</a>
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