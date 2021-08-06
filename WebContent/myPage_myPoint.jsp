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
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>

<body>
	<div class="body_wrap">
		<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지" width='100px'
			height='100px' />
		
		<h3>${sessionScope.nickName} 님의 누적 명예 점수</h3>
		<a href='./myPage' id='backToMyPage'>MY PAGE로 돌아가기</a>
		
		<div id="info">
			<c:import url="./myPage_info.jsp"/>
		</div>
		
		<div id='rankInfo'><b>♥ 등급UP 기준</b> [ Bronze : 0점&nbsp;&nbsp;Silver : 3000점&nbsp;&nbsp;Gold : 10000점&nbsp;&nbsp;Vip : 50000점 ]</div>
		<div id='discountInfo'><b>♥ 할인 적용률</b> [ Bronze : 0%&nbsp;&nbsp;Silver : 2%&nbsp;&nbsp;Gold : 3%&nbsp;&nbsp;Vip : 5% ]</div>
		<div>&nbsp;</div>
		<div id='PointHistory'>
			<table>
				<tr>
					<th>획득 날짜</th><th>&nbsp;내 용&nbsp;</th><th>획득점수</th><th>총합</th>
				</tr>
				<c:if test="${pointList eq null || pointList eq ''}">
					<tr><td colspan='4'>명예 획득 내역이 없습니다.</td></tr>
				</c:if>
				<c:forEach items='${pointList}' var='item'>
				<tr>
					<td>${item.pointDate}</td>
					<td>${item.pointField}</td>
					<td>${item.getPoint}</td>
					<td>${item.totalPoint}</td>
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