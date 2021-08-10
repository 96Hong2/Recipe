<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>header_afterLogin.jsp</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />

</head>
<body>
	<c:choose>
		<c:when test="${not empty sessionScope.userId}">
			<div class="wrap">
				<div id="header" style="height: 100px; display: flex;">
					<div style="width:300px;">
						<a href="./"> <img src="hlogo.png" alt="로고"
							style="margin-left:20px; width:100px; height:100px;" /></a>
					</div>
					<div id="center_img" style="text-align:center; width: 300px; height:100px; line-height:100px;">
						<a href="./"><img src="center.png" alt="센터" style="width:250px; height:100px;"><a href="./">
					</div>
					<div id="top_menu" style="width: 300px; text-align:right; ">
						<div>
							<ul>
								<li>${sessionScope.nickName} 님, <a
									href="./cashHistory">&nbsp;보유캐시 :&nbsp; &nbsp; <b
										id="showCash"></b> 원
								</a></li>
							</ul>
						</div>
						<div>
							<ul>
								<li><a href="./myPage">마이페이지</a></li>
								<li><a href="cart.jsp">장바구니</a></li>
								<li><a href="myPage_chargeCash.jsp">캐시충전</a></li>
								<li><a href="./logout">로그아웃</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="search">
					<form action="postSearch?postSearchOpt=title_contentsSearch"
						method="get" id="search">
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
			<div id="header" style="height: 100px; display: flex;">
					<div style="width:300px;">
						<a href="./"> <img src="hlogo.png" alt="로고"
							style="margin-left:20px; width:100px; height:100px;" /></a>
					</div>
					<div id="center_img" style="text-align:center; width: 300px; height:100px; line-height:100px;">
						<img src="center.png" alt="센터" style="width:250px; height:100px;">
					</div>
					<div id="top_menu" style="width: 300px; text-align:right; ">
						<div>
							<ul>
								<li>안녕하세요! 로그인 해주세요</li>
							</ul>
						</div>
						<div>
							<ul>
								<li><a href="./login.jsp">로그인</a></li>
								<li><a href="./joinForm.jsp">회원가입</a></li>
								<li><a href="./cart.jsp">장바구니</a></li>
								<li><a href="./myPage">마이페이지</a></li>
							</ul>
						</div>
					</div>
				</div>
				
				<div class="search">
					<form action="postSearch?postSearchOpt=title_contentsSearch"
						method="get" id="search">
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