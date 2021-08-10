<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 마이페이지</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
</head>
<body>
	<div class="wrap">
		<header>
			<c:import url="./header_afterLogin.jsp" />
		</header>

		<main id="body"
			style="padding: 20px; ">
			<a href='./myPage' id='backToMyPage'><h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MY PAGE로 돌아가기</h4></a>
			<div style="width: 900px; display: flex; margin-bottom: 20px;">
				<div style="width: 660px;">
					<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지"
						width='100px' height='100px' />

					<h3>${sessionScope.nickName}님의누적명예점수</h3>
				</div>
				<div id="info" style="width: 200px;">
					<c:import url="./myPage_info.jsp" />
				</div>
			</div>
			<div id='rankInfo'>
				<b>♥ 등급UP 기준</b> [ Bronze : 0점&nbsp;&nbsp;Silver :
				3000점&nbsp;&nbsp;Gold : 10000점&nbsp;&nbsp;Vip : 50000점 ]
			</div>
			<div id='discountInfo'>
				<b>♥ 할인 적용률</b> [ Bronze : 0%&nbsp;&nbsp;Silver : 2%&nbsp;&nbsp;Gold
				: 3%&nbsp;&nbsp;Vip : 5% ]
			</div>
			<div>&nbsp;</div>
			<div style="text-align:center;">
				<div id='PointHistory'>
					<table id="pointTable">
						<tr>
							<th>획득 날짜</th>
							<th style="width:400px;">&nbsp;내 용&nbsp;</th>
							<th>획득점수</th>
							<th>총합</th>
						</tr>
						<c:if test="${pointList eq null || pointList eq ''}">
							<tr>
								<td colspan='4'>명예 획득 내역이 없습니다.</td>
							</tr>
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
					<br/>
				</div>

				<div class="pageArea">
					<button type='button'
						onclick='location.href="./pointHistory?page=${start}&button=1"'>이전</button>
					<c:choose>
						<c:when test="${totalPage < end}">
							<c:forEach var="i" begin="${start}" end="${totalPage}" step="1">
								<span class="page"> <c:if test="${i ne currPage}">
										<a href="./pointHistory?page=${i}">${i}</a>
									</c:if> <c:if test="${i eq currPage}">
										<b>${i}</b>
									</c:if>
								</span>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<c:forEach var="i" begin="${start}" end="${end}" step="1">
								<span class="page"> <c:if test="${i ne currPage}">
										<a href="./pointHistory?page=${i}">${i}</a>
									</c:if> <c:if test="${i eq currPage}">
										<b>${i}</b>
									</c:if>
								</span>
							</c:forEach>
						</c:otherwise>
					</c:choose>
					<button type='button'
						onclick='location.href="./pointHistory?page=${end}&button=2"'>다음</button>
				</div>

			</div>
		</main>
	</div>
</body>
<script>
	var msg = "${msg}";
	if (msg != "") {
		alert(msg);
	}
</script>
<footer> </footer>
</html>