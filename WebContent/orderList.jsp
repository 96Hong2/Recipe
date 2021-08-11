<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>알다시피</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>
if("${sessionScope.userId}"==""){
	alert("로그인이 필요한 서비스입니다.");
	location.href = "login.jsp";
}
</script>
</head>

<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>

		<main id="body">

			<h1
				style="border: 2px solid #bbb; border-radius: 10px; text-align: center; width: 200px;">
				주문하기</h1>
			<div>
				<h2>배송정보</h2>
				이름 : ${member.name} <br /> 배송주소 : ${member.address}<br /> 연락처 :
				${member.tel} <input type="hidden" name="memberCash"
					value="${member.cash}" />
			</div>

			<h2>주문상품</h2>
			<table class="table">
				<tr>

					<th>상품 이미지</th>
					<th class="table-info" colspan="3">상품정보</th>
					<th class="table-price">상품가격</th>
					<th class="table-total">상품총가격</th>
				</tr>
				<c:set var="total" value="0" />
				<c:forEach items="${list}" var="payment">

					<tr>
						<td style="width:180px; height:100px;"><a href='shopDetail?productId=${payment.productId}'>
						<c:set var="imgNewName" value="${payment.imgNewName}" />
							<img class="img" src="/photo/${imgNewName}"
								style="float: left; height: 100px; width: 180px; border-radius: 10px; margin: 15px;" />
						</a> <input name="pId" type="hidden" value="${payment.productId}" />
						</td>
						<td class='info' colspan="3">
							<div>
								<div>
									<a href='shopDetail?productId=${payment.productId}'>
									<input type="hidden" name="pName" value="${payment.productName}" />${payment.productName}
									</a></div>
								<hr />
								<div>
									<input type="hidden" name="pCount"
										value="${payment.productCount}" />${payment.productCount}개</div>
							</div>
						<td><input type="hidden" name="price"
							value="${payment.price}" />${payment.price}원</td>
						<td>${payment.totalPrice}원</td>

					</tr>
					<c:set var="total" value="${total + payment.totalPrice}" />
				</c:forEach>
			</table>

			<div class="table-right">
				<fmt:formatNumber var="total_sum" type="number"
					maxFractionDigits="0" groupingUsed="false" value="${total}" />
				<fmt:formatNumber var="result_price" type="number"
					maxFractionDigits="0" groupingUsed="false"
					value="${total-total*member.discount/100}" />
				<fmt:formatNumber var="discount" type="number" maxFractionDigits="0"
					groupingUsed="false" value="${total*member.discount/100}" />

				<h4>결제 예정금액</h4>
				<div class="cartprice">상품 금액</div>
				<b>${total_sum}원</b><br>

				<div class="cartprice">할인 금액</div>
				<b>-${discount}원 </b><br>

				<div class="cartprice">
					<small>등급 할인</small>
				</div>
				<small id="dis">${member.discount}</small><small>% 할인</small> <br>

				<div class="cartprice">합계</div>
				<b>${result_price}원</b> <br> <br>
				<button onclick="cancel()">취소</button>
				<button onclick="order()">주문</button>
			</div>
		</main>
		<footer></footer>
	</div>
</body>
<script>
	function cancel() {
		isCancel = confirm("주문을 취소하시겠습니까?");
		if (isCancel) {
			location.href = './';
		}
	}
	function order() {
		var $product = $("input[name='pId']");
		var $pCount = $("input[name='pCount']");
		var $price = $("input[name='price']");
		var $memberCash = $("input[name='memberCash']").val();
		console.log($memberCash);

		var $pppp = $product.length;
		var proArr = [];

		var param = {};
		$product.each(function(idx, item) {//item 은 자바스크립트 객체
			//console.log(item);
			//console.log($(item));
			//console.log(item.value);
			//console.log(productid);
			console.log($(this).val());
			proArr.push($(this).val());

			//param.productId+"idx" = $(this).val();
		});
		$pCount.each(function(idx, item) {//item 은 자바스크립트 객체
			//console.log(item);
			//console.log($(item));
			//console.log(item.value);
			//console.log(productid);
			console.log($(this).val());
			proArr.push($(this).val());

			//param.productId+"idx" = $(this).val();
		});
		$price.each(function(idx, item) {//item 은 자바스크립트 객체
			//console.log(item);
			//console.log($(item));
			//console.log(item.value);
			//console.log(productid);
			console.log($(this).val());
			proArr.push($(this).val());

			//param.productId+"idx" = $(this).val();
		});
		console.log("-----------------------------");
		var $resultPrice = ${result_price};
		var $orderPrice = ${total};
		var $discount = ${discount};
		console.log($resultPrice);
		console.log($orderPrice);
		console.log($discount);
		proArr.push($resultPrice);
		proArr.push($orderPrice);
		proArr.push($discount);

		param.resultPrice = $resultPrice;
		param.orderPrice = $orderPrice;
		param.discount = $discount;
		//console.log(proArr);
		console.log(proArr);

		console.log($memberCash);
		if ($memberCash < $resultPrice) {
			isCharge = confirm("캐시가 부족합니다. 충전 페이지로 이동하시겠습니까?");
			if (isCharge) {
				location.href = 'myPage_chargeCash.jsp';
			}

		} else {
			$.ajax({
				type : 'post',
				url : 'payment',
				data : {
					'orderList' : proArr
				},
				dataType : 'JSON',
				success : function(data) {
					if (data.success) {
						if(data.cashChk) {
							alert("주문이 완료 되었습니다.");
							location.href = './';	
						} else {
							isCharge = confirm("캐시가 부족합니다. 충전 페이지로 이동하시겠습니까?");
							if (isCharge) {
								location.href = 'myPage_chargeCash.jsp';
							}
						}
						
					} else {
						alert("주문에 실패 하셨습니다.");
						location.href ="./";
					}
				},
				error : function(e) {
					console.log("주문실패");
				}
			});

		}
	}
</script>
</html>