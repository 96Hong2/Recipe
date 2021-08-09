<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>header_afterLogin.jsp</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<!-- <link rel="stylesheet" type="text/css" href="css/myPage.css" media="all" /> -->
</head>
<body>
	<c:choose>
		<c:when test="${not empty sessionScope.userId}">
			<div class="wrap">
				<div id="header">
					<img src="./staticImg/noEat.jpg" alt="로고" width="200px"
						height="150px" />
					<h1>
						<a href="./" id='mainTitle'>알다시피</a>
					</h1>
					<div id="top_menu">
						<ul>
							<li><a href="./myPage">마이페이지</a></li>
							<li><a href="cart.jsp">장바구니</a></li>
							<li><a href="myPage_chargeCash.jsp">캐시충전</a></li>
							<li><a href="./logout">로그아웃</a></li>
						</ul>
					</div>
					<div id="greeting">
						안녕하세요! ${sessionScope.nickName} 님 ^ㅇ^ &nbsp; | <a
							href="./cashHistory">&nbsp;&nbsp;캐시 :&nbsp;</a>
						<p id='showCash'></p>
						<p>&nbsp; 원</p>
					</div>
				</div>
				<div class="search">
					<form action="postSearch?postSearchOpt=title_contentsSearch" method="get" id="search">
						<input type="text" id="keyword" placeholder="검색어입력" />
						<button>검색</button>
					</form>
				</div>
				<div id="menu">
					<ul>
						<li><a href="#">알다시피란?</a></li>
						<li><a href="./bestPost">베스트레시피</a></li>
						<li><a href="./postList">레시피게시판</a></li>
						<li><a href="./shop">쇼핑몰</a></li>
					</ul>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="wrap">
				<div id="header">
					<img src="./staticImg/noEat.jpg" alt="로고" width="200px"
						height="150px" />
					<h1>
						<a href="./" id='mainTitle'>알다시피</a>
					</h1>
					<div id="top_menu">
						<ul>
							<li><a href="./login.jsp">로그인</a></li>
							<li><a href="./joinForm.jsp">회원가입</a></li>
							<li><a href="./cart.jsp">장바구니</a></li>
							<li><a href="./myPage">마이페이지</a></li>
						</ul>
					</div>
					<div id="greeting">
						알다시피에 오신 것을 환영합니다! 로그인해주세요 ^ㅇ^
					</div>
				</div>
				<div class="search">
					<form action="postSearch?postSearchOpt=title_contentsSearch" method="get" id="search">
						<input type="text" id="keyword" placeholder="검색어입력" />
						<button>검색</button>
					</form>
				</div>
				<div id="menu">
					<ul>
						<li><a href="#">알다시피란?</a></li>
						<li><a href="./bestPost">베스트레시피</a></li>
						<li><a href="./postList">레시피게시판</a></li>
						<li><a href="./shop">쇼핑몰</a></li>
					</ul>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
</body>
<script>
	$.ajax({
		type : 'post',
		url : './showCash',
		dataType : 'JSON',
		success : function(currCash) {
			console.log("(header_afterLogin.jsp)ajax currCash :" + currCash);
			$('#showCash').html(currCash.currentCash);
		},
		error : function(e) {
			console.log("ajax 에러발생 :" + e);
		}
	});
</script>
</html>