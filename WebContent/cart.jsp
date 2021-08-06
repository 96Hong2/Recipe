<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

			<h1>장바구니</h1>
			<table>
				<tr>
					<th>전체 선택/해제</th>
					<th>상품이미지</th>
					<th>상품이름</th>
					<th>상품가격</th>
					<th>상품수량</th>
					<th>상품총가격</th>
				</tr>
				<tr>
					<td><input type="checkBox" value="" /></td>
					<td colspan="5"></td>
				</tr>
				<c:if test="${list eq null || list eq '' || list eq '[]'}">

					<tr>
						<td colspan="6">장바구니가 비어있습니다.</td>
					</tr>
				</c:if>
				<c:forEach items="${list}" var="cart">
					<tr>
						<td><input type="checkBox" value="${cart.productid}" /></td>
						<td><img src="logo.png" style="width: 80px; height: 80px;" /></td>
						<td>아직</td>
						<td><fmt:parseNumber
								value="${cart.totalprice/cart.productnumber}" integerOnly="true" /></td>
						<td>${cart.productnumber}</td>
						<td>${cart.totalprice}</td>
					</tr>
				</c:forEach>

			</table>
			<button onclick="del()">선택삭제</button>
			<button onclick="order()">주문하기</button>

		</main>
		<footer></footer>
	</div>
</body>
</html>