<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>알다시피</title>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>
	
</script>
</head>
<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>

		<main id="body">
			<div id="banner">
				<img src="banner.png">
			</div>
			<p id="week">
				<a href="./bestPost"><h2>베스트 레시피</h2></a>
			</p>
			<div>
				<div class="mainContainer">
					<c:forEach items="${mainBestPost}" var="best">
						<div style="width: 280px; height: 252px;">
							<a href="postDetail?postId=${best.postId}">
								<figure class="mainFigure">
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
			</div>
			<p id="month">
				<a href="./postList"><h2>최근 레시피</h2></a>
			</p>
			<div>
				<div class="mainContainer">
					<c:forEach items="${mainPost}" var="post">
						<div style="width: 280px; height: 252px;">
							<a href="postDetail?postId=${post.postId}">
								<figure class="mainFigure">
									<c:set var="imgNewName" value="${post.imgNewName}" />
									<c:if test="${imgNewName eq null }">
										<img class="img" src="./defaultThum.png"
											style="height: 100px; width: 180px; margin: 10px;"
											onclick="location.href='postDetail?postId=${post.postId}'" />
									</c:if>
									<c:if test="${imgNewName ne null }">
										<img class="img" src="/photo/${post.imgNewName}"
											style="height: 100px; width: 180px; margin: 10px;"
											onclick="location.href='postDetail?postId=${post.postId}'" />


									</c:if>
									<figcaption>
										<div style="margin: 0 5px 5px 5px;">
											<div>
												<div style="font-size: 0.5em; float: left; width: 30px;">
													좋아요<br />${post.likes}</div>
												<div
													style="font-weight: bold; float: left; width: 122px; margin: 0 4px 0 4px; text-align: left;">
													<small>${post.title}</small>
												</div>
												<div style="font-size: 0.5em; float: left; width: 30px;">
													조회수<br />${post.hits}</div>
											</div>
											<div>
												<div>
													<div style="text-align: left; text-overflow: ellipsis;">
														<small>${post.item}</small>
													</div>
													<div style="text-align: left;">
														<small>${post.recipePrice}\</small>
													</div>
													<div style="text-align: right;">
														<small>${post.nickName}</small>
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
			</div>
		</main>
		<footer>
			<%@include file="footer.jsp"%>
		</footer>
	</div>
</body>
<script>
	var msg = "${msg}";
	if (msg != "") {
		alert(msg);
	}
</script>
</html>