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
						<!-- 이미지테스트 임시로 넣어뒀음 -->
						<li><a href="./login.jsp">로그인</a></li>
						<li><a href="./joinForm.jsp">회원가입</a></li>
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
			<div id="banner">배너 넣자</div>
			<p id="week">
				<a href="#">이 주의 레시피</a>
			</p>
			<div id="weekbest"></div>
			<p id="month">
				<a href="#">이 달의 레시피</a>
			</p>
			<div id="monthbest"></div>
		</main>
		<footer>푸터</footer>
	</div>
</body>
</html>