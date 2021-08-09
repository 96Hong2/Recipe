<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>알다시피</title>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />

</head>
<body>
	<div class="wrap">
		<header>
			<div id="header">

				<a href="./"> <img src="logo.png" alt="로고" width="150px"
					height="50px" /></a>

				<div id="top_menu">
					<ul>
						<li><a href="./login.jsp">로그인</a></li>
						<li><a href="./logout">로그아웃</a></li>
						<li><a href="./cart.jsp">장바구니</a></li>
						<li><a href="./myPage">마이페이지</a></li>
					</ul>
				</div>

			</div>

			<div class="search">
				<form action="#" method="get" id="search">
					<input type="text" id="keyword" placeholder="검색어입력" />
					<button>검색</button>
				</form>
			</div>

			<div id="menu">
				<ul>
					<li><a href="#">알다시피란?</a></li>
					<li><a href="#">베스트레시피</a></li>
					<li><a href="./postList">레시피게시판</a></li>
					<li><a href="./shop">쇼핑몰</a></li>
				</ul>
			</div>
		</header>

		<main id="body">

			<div class="searchShop">
				<form action="shopSearch" method="get" id="searchShop">
					<input type="text" name="shopKeyword" id="keyword" placeholder="상품입력" />
					<button>검색</button>
				</form>
			</div>

			<div class="container">
				<c:if test="${shop eq null || shop eq '' || shop eq '[]'}">
						
						상품이 없습니다.
				</c:if>
				<c:forEach items="${shop}" var="product">
					<div style="width: 280px; height: 232px;">
						<a href="shopDetail?productId=${product.productId}"	style="background-color: black">
							<figure class="figure">
								<c:if test="${product.stock eq 0}">
									<label style="color: white !important; position: absolute; background: red; ">품절</label>
								</c:if>

								<img class="img" src="logo.png" style="height: 100px; width: 180px; margin: 10px;">
								<figcaption>
									${product.productName}<br />
									${product.price}원
								</figcaption>

							</figure>
						</a>
					</div>
				</c:forEach>
			</div>
		</main>
		<footer></footer>
	</div>
	</body>
</html>