<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 주문내역</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
</head>
<script>
	if ("${sessionScope.userId}" == "") {
		alert("로그인이 필요한 서비스입니다.");
		location.href = "./";
	}
</script>
<body>
	<header>
		<c:import url="./header_afterLogin.jsp" />
	</header>
	<div class ="wrap">
	<main id="body" style="padding: 20px;">
		<a href='./myPage' id='backToMyPage'>
			<h4 style="border: 2px solid #bbb; border-radius: 10px; text-align: center; width: 230px;">
			← MY PAGE로 돌아가기</h4>
		</a>
		<div style="width: 900px; display: flex; margin-bottom: 20px;">
			<div style="width: 660px;">
				<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지"
					width='100px' height='100px' />

				<h3>${sessionScope.nickName} 님의 주문 내역</h3>
			</div>
		</div>
		
		<table id='orderListTable'>
		<tr>
			<th>주문번호</th><th>주문날짜</th><th>주문총액</th><th>주문상태</th><th>주문상세보기</th>
		</tr>
		<c:if test="${empty orderList}">
			<tr>
				<td>주문내역이 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach items='${orderList}' var='order'>
			<tr>
				<td>${order.paymentId}</td>
				<td>${order.paymentdate}</td>
				<td>${order.paymentPrice} 원</td>
				<td>
					<c:choose>
						<c:when test='${order.orderStatus eq "A"}'>
							<p><b style='color:rosybrown'>상품준비중</b></p>
						</c:when>
						<c:when test='${order.orderStatus eq "B"}'>
							<p><b style='color:darkred'>배송중</b></p>
						</c:when>
						<c:otherwise>
							<p><b style='color:darkgreen'>배송완료</b></p>
						</c:otherwise>
					</c:choose>
				</td>
				<td><button onclick="showOrderDetail('${order.paymentId}')">주문상세보기</button></td>
				</tr>
		</c:forEach>
		</table>
	</main>
	</div>
</body>
<script>
function showOrderDetail(pId){
	location.href='./orderHistory?paymentId='+pId;	
}
</script>
</html>