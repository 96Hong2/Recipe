<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>알다시피</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />

</head>
<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>
		<main id="body">
			<div style="height: 700px;">
				<button onclick="location.href='./shop'">뒤로가기</button>
				<div style="height: 660px; border-radius:10px;">
					<div style="border-radius:10px; height: 210px; margin: 15px; background-color: #D5D5D5; color:white;">
						<img src="logo.png"
							style="float: left;  height: 150px; width: 150px; border-radius:10px; margin: 15px; height: 150px; width: 150px;">
					
						<input type="hidden" name="productId" value="${product.productId}" />
						<div style="margin-left:180px;">
						<br/>
							상품 이름 : ${product.productName}
							<br/>
							상품 가격 : ${product.price}원
							<br/>
							<c:if test="${product.stock eq 0}">
							품절
						</c:if>
							<c:if test="${product.stock ne 0}">
							남은 수량 : ${product.stock}개
							<br/>
							선택 수량 : <input type='text' name='productCnt' value="0" />
								<input type="button" id="stockSelect" value="선택" />
								<br/>
							총 가격 : <input type="text" name="totalPrice" value="0원" readonly>
								<br/><br/>
								<button onclick="cart()">장바구니</button>
								<button onclick="order()">바로주문</button>
							</c:if>

						</div>
					</div>
					<div style="border-radius:10px; height: 300px; margin: 15px; background-color: #D5D5D5; color: white;">
						  <div style="padding:15px;">
						  ${product.productDetail}
						  </div>
					</div>
				</div>
			</div>
		</main>
		<footer></footer>
	</div>
</body>
<script>
	var $pCnt = "";

	function cartChk() {
		$pCnt = $("input[name='productCnt']").val();

	}

	$("#stockSelect").click(function() {
		$pCnt = $("input[name='productCnt']").val();
		var $stock = ${product.stock};
		var $price = ${product.price};
		var $totalPrice = $pCnt * $price;
		console.log($stock);
		console.log($pCnt);
		if ($pCnt > $stock) {
			alert("재고보다 많이 선택할 수 없습니다.\r\n 다시 선택해주세요");
			$("input[name='productCnt']").val("0")
			$("input[name='totalPrice']").val("0원");

		} else {
			$("input[name='totalPrice']").val($totalPrice + "원");
		}
	});

	function cart() {
		if ("${sessionScope.userId}" == "") {
			alert("로그인이 필요한 서비스입니다.");
			location.href = "login.jsp";
		} else {
			var $pId = new String("${product.productId}");
			//var $pId = ${product.productId};
			var $pName = new String("${product.productName}");
			var $pPrice = ${product.price};
			var $pCnt = $("input[name='productCnt']").val();
			var $tPrice = $pCnt * $pPrice;
			var $stock = ${product.stock};
			console.log("id_" + $pId);
			console.log("name_" + $pName);
			console.log("price_" + $pPrice);
			console.log("cnt_" + $pCnt);
			console.log("tprice_" + $tPrice);

			var param = {};
			param.pId = $pId;
			param.pName = $pName;
			param.pPrice = $pPrice;
			param.pCnt = $pCnt;
			param.tPrice = $tPrice;

			console.log(param);

			if ($tPrice == 0 || $("input[name='totalPrice']").val() == "0원") {
				alert("수량 선택을 먼저 해주세요.");
			} else {
				console.log("왜지왜지왜지" + $tPrice);

				$.ajax({
					type : 'get',
					url : 'cartAdd',
					data : param,
					dataType : 'JSON',
					success : function(data) {
						console.log(data);
						if (data.success) {
							if (data.success == -1) {
								alert("이미 담긴 수량과 새로 담으려는 수량이 재고수량보다 많습니다. \r\n장바구니를 확인해주세요.");
							} else {
								console.log(data);
								isAdd = confirm("장바구니에 담았습니다. 장바구니를 확인하시겠습니까?");
								if (isAdd) {
									location.href = 'cart.jsp';
								}

							}
						} else {
							alert("장바구니에 담지 못했습니다.\r\n 다시 시도해주세요.")
						}

					},
					error : function(e) {
						console.log(e);
					}
				});
			}
		}
	}

	function order() {
		if ("${sessionScope.userId}" == "") {
			alert("로그인이 필요한 서비스입니다.");
			location.href = "login.jsp";
		} else {
			var $pId = new String("${product.productId}");
			//var $pId = ${product.productId};
			var $pName = new String("${product.productName}");
			var $pPrice = ${product.price};
			var $pCnt = $("input[name='productCnt']").val();
			var $tPrice = $pCnt * $pPrice;
			var $stock = ${product.stock};

			console.log("id_" + $pId);
			console.log("name_" + $pName);
			console.log("price_" + $pPrice);
			console.log("cnt_" + $pCnt);
			console.log("tprice_" + $tPrice);

			var param = {};
			param.pId = $pId;
			param.pName = $pName;
			param.pPrice = $pPrice;
			param.pCnt = $pCnt;
			param.tPrice = $tPrice;

			console.log("??????????");
			console.log(param);

			if ($tPrice == 0 || $("input[name='totalPrice']").val() == "0원") {
				alert("수량 선택을 먼저 해주세요.");
			} else {
				isOrder = confirm("상품을 주문하시겠습니까?");
				if (isOrder) {

					$.ajax({
						type : 'get',
						url : './order',
						data : param,
						dataType : 'JSON',
						success : function(data) {
							location.href = './orderList';

						},
						error : function(e) {
							console.log(e);
						}
					});
				}
			}
		}
	}
</script>
</html>