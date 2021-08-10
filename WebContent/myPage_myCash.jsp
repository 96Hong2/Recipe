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
			style="padding: 20px;">
			<a href='./myPage' id='backToMyPage'><h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MY PAGE로 돌아가기</h4></a>
			<div style="width: 900px; display: flex; margin-bottom: 20px;">
				<div style="width: 660px;">
					<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지"
						width='100px' height='100px' />

					<h3>${sessionScope.nickName}님의캐시내역조회</h3>
				</div>
				<div id="info" style="width: 200px;">
					<c:import url="./myPage_info.jsp" />
				</div>
			</div>



			<button id='charge' onclick='location.href="myPage_chargeCash.jsp"'>캐시충전</button>
			<div style="text-align: center;">
				<div id='cashHistory'>
					<table id="pointTable">
						<tr>
							<th>변동 시간</th>
							<th>캐시 변동 내역</th>
							<th style="width:400px;">변동 사유</th>
							<th>총합</th>
						</tr>
						<c:if test="${cashList eq null || cashList eq ''}">
							<tr>
								<td colspan='4'>캐시 내역이 없습니다.</td>
							</tr>
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

				<div class="pageArea">
					<button type='button'
						onclick='location.href="./cashHistory?page=${start}&button=1"'>이전</button>
					<c:choose>
						<c:when test="${totalPage < end}">
							<c:forEach var="i" begin="${start}" end="${totalPage}" step="1">
								<span class="page"> <c:if test="${i ne currPage}">
										<a href="./cashHistory?page=${i}">${i}</a>
									</c:if> <c:if test="${i eq currPage}">
										<b>${i}</b>
									</c:if>
								</span>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<c:forEach var="i" begin="${start}" end="${end}" step="1">
								<span class="page"> <c:if test="${i ne currPage}">
										<a href="./cashHistory?page=${i}">${i}</a>
									</c:if> <c:if test="${i eq currPage}">
										<b>${i}</b>
									</c:if>
								</span>
							</c:forEach>
						</c:otherwise>
					</c:choose>
					<button type='button'
						onclick='location.href="./cashHistory?page=${end}&button=2"'>다음</button>
					
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