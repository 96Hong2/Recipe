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
						<li><a href="#">로그인</a></li>
						<li><a href="#">회원가입</a></li>
						<li><a href="./myPage">마이페이지</a></li>
						<li><a href="#">공지사항</a></li>
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
					<li><a href="#">레시피게시판</a></li>
					<li><a href="./shop">쇼핑몰</a></li>
				</ul>
			</div>

		</header>
		<main id="body">
			<div style="background-color: #D5D5D5; height: 700px;">
				<button onclick="location.href='./shop'">뒤로가기</button>
				<div style="height: 660px; background-color: black;">
					<div style="heght: 150px; width: 150px; float: left; margin: 15px;">
						<img src="logo.png" style="height: 150px; width: 150px;">
					</div>

					<div
						style="height: 230px; margin: 15px; background-color: #bbb; color: white;">
						상품 이름 : ${product.productname}
						<hr />
						상품 가격 : ${product.price}원
						<hr />
						<c:if test="${product.stock eq 0}">
							품절
						</c:if>
						<c:if test="${product.stock ne 0}">
							남은 수량 : ${product.stock}개
							<hr />
							선택 수량 : <input type="text">
							<hr />
							총 가격 : <input type="text" readonly>
							<hr />
							<button onclick="location.href='./cart'">장바구니</button>
							<button onclick="location.href='./order'">바로주문</button>
						</c:if>


					</div>
					<div
						style="height: 300px; margin: 15px; background-color: #bbb; color: white;">
						${product.productdetail}</div>
				</div>
			</div>
		</main>
		<footer></footer>
	</div>
</body>
</html>