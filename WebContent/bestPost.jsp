<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>

		<main id="body">
			<div style="margin: auto; width: 740px;">
				<h3>베스트 게시판</h3>
				<button onclick="location.href='./bestPost'">전체</button>
				<button onclick="location.href='./bestMonth'">이달의 레시피</button>
				<button onclick="location.href='./bestWeek'">이주의 레시피</button>
				<c:if test="${not empty sessionScope.isAdmin}">
					<button onclick="location.href='./bestSelect1'" class="btns" id="blindBtn">주간베스트레시피 선정버튼</button>
					<button onclick="location.href='./bestSelect2'" class="btns" id="blindBtn">월간베스트레시피 선정버튼</button>
				</c:if>
				<div>
					<form action="bestSearch" method="get">
						<input type="date" name="startDate" value="${startDate}">
						~ <input type="date" name="endDate" value="${endDate}">
						<button type="submit">검색</button>
					</form>
				</div>
			</div>
			<c:if test="${bestPost eq null || bestPost eq ''}">
						베스트 레시피가 없습니다.
		</c:if>
			<div class="recipeContainer">

				<c:forEach items="${bestPost}" var="best">
					<div style="width: 280px; height: 252px;">
						<a href="postDetail?postId=${best.postId}">
							<figure class="recipeFigure">
								<c:set var="imgNewName" value="${best.imgNewName}" />
								<c:if test="${imgNewName eq null }">
									<img class="img" src="./defaultThum.png"
										style="height: 100px; width: 180px; margin: 10px;"
										onclick="location.href='postDetail?postId=${best.postId}'" />
								</c:if>
								<c:if test="${imgNewName ne null }">
									<img class="img" src="/photo/${post.imgNewName}"
										style="height: 100px; width: 180px; margin: 10px;"
										onclick="location.href='postDetail?postId=${best.postId}'" />


								</c:if>
								<figcaption>
									<div style="margin: 0 5px 5px 5px;">
										<div>
											<div style="font-size: 0.5em; float: left; width: 30px;">
												좋아요<br />${best.likes}</div>
											<div
												style="font-weight: bold; float: left; width: 122px; margin: 0 4px 0 4px; text-align: left;">
												<small>${best.title}</small>
											</div>
											<div style="font-size: 0.5em; float: left; width: 30px;">
												조회수<br />${best.hits}</div>
										</div>
										<div>
											<div>
												<div style="text-align: left; text-overflow: ellipsis;">
													<small>${best.item}</small>
												</div>
												<div style="text-align: left;">
													<small>${best.recipePrice}\</small>
												</div>
												<div style="text-align: right;">

													<small>${best.nickName}</small>

													<small>${best.nickname}</small>

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
							<a href="./bestPost?page=${i}">${i}</a>
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
<script>
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
</script>
</html>