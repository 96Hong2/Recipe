<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 주문 상세보기</title>
<script src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.userId}"==""){
   alert("로그인이 필요한 서비스입니다.");
   location.href = "./";
}
</script>
	<header>
		<%@include file="header_afterLogin.jsp"%>
	</header>
</head>
<body>
<a href='./myPage' id='backToMyPage'><h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MY PAGE로 돌아가기</h4></a>
<h3>${sessionScope.nickName}님의 주문 내역</h3>

	<div id='orderDetail' style='background-color:snow;'>
		<div>▶ <b>${map.paymentDate}</b></div>
		<div><h3>주문번호 ${map.paymentId} 상세보기</h3></div>
		<button onclick='location.href="./myOrder"'>주문내역으로 돌아가기</button>
		<div>
		<c:choose>
			<c:when test='${map.orderStatus eq "A"}'>
				<p><b style='color:rosybrown'>♥ 상품준비중</b></p>
			</c:when>
			<c:when test='${map.orderStatus eq "B"}'>
				<p><b style='color:darkred'>♥ 배송중</b></p>
			</c:when>
			<c:otherwise>
				<p><b style='color:darkgreen'>♥ 배송완료</b></p>
			</c:otherwise>
		</c:choose>
		</div>
		<div>● 결제정보</div>
		<div>총 주문금액&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${map.orderPrice} 원</div>
		<div>총 할인액&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-${map.discount} 원</div>
		<div>총 결제금액 :: ${map.paymentPrice} 원</div>

		<c:forEach items = "${map.orderList}" var = "item">
			<hr/>
			<a href="./shopDetail?productId=${item.productId}"><div id='orderItem'>
			<div><img src='/photo/${item.imgNewName}' alt='주문상품' width='120' height='100'/></div>
			<div>${item.productName}</div>
			<div>수량 &nbsp;${item.productCount} 개 &nbsp;&nbsp;|&nbsp;&nbsp;${item.price} 원</div>
			</div>
			</a>
		</c:forEach>
		<%-- <a href="./shopDetail?productId='${item.productName}'"></a> --%>
	</div>
</body>
</html>