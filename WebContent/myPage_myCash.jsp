<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 마이페이지</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/myPage.css" media="all" />
</head>
<% session.setAttribute("nickName", "사나이광배"); %>
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>

<body>
	<div class="body_wrap">
		<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지" width='100px'
			height='100px' />
		
		<h3>${sessionScope.nickName} 님의 캐시 내역 조회</h3>
		<a href='index.jsp' id='main'>MAIN PAGE로 돌아가기</a>
		
		<div id="info">
			<c:import url="./myPage_info.jsp"/>
		</div>
		
		<button id='charge' onclick='location.href="myPage_chargeCash.jsp"'>캐시충전</button>
		
		<div id='cashHistory'>
			<table>
				<tr>
					<th>변동 시간</th><th>캐시 변동 내역</th><th>변동 사유</th><th>총합</th>
				</tr>
				<c:if test="${cashList eq null || cashlist eq ''}">
					<tr><td colspan='4'>캐시 내역이 없습니다.</td></tr>
				</c:if>
				<c:forEach items='${cashList}' var='item'>
				<tr>
					<td>${item.cash_time}</td>
					<td>${item.cash_amount}</td>
					<td>${item.cash_details}</td>
					<td>${item.cash_total}</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		
		<button>더보기</button>

	</div>
</body>
<script>
var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>
<footer>
</footer>
</html>