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
	if ("${sessionScope.userId}" == "") {
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
				장바구니</h1>
			<div class="divtable">
				<table class="table">
					<thead>
						<tr>
							<th class="table-chk"><input type="checkbox"
								name="selectall" id="checkAll" /></th>
							<th class="table-select" style="width: 180px;">전체 선택/해제</th>
							<th colspan="3" class="table-info" style="width: 280px;">상품정보</th>
							<th class="table-price">상품가격</th>
							<th class="table-total">상품총가격</th>
						</tr>
					</thead>

					<tbody></tbody>
				</table>
			</div>
			<div class="table-right" id="table-right">
				<h4>결제 예정금액</h4>

				<div class="cartprice">상품 금액</div>
				<b id="total_sum">0</b>원 <input name="total_sum" type="hidden"
					readonly /> <br>
				<div class="cartprice">할인 금액</div>
				<b id="discount">0</b>원 <input name="discount" type="hidden"
					readonly /> <br>
				<div class="cartprice">
					<small>등급 할인</small>
				</div>
				<small id="dis">0</small><small>% 할인</small> <br>
				<div class="cartprice">합계</div>
				<b id="result_price">0</b>원 <input name="result_price" type="hidden"
					readonly /> <br> <br>

				<button onclick="del()">선택삭제</button>
				<button onclick="order()">주문하기</button>
			</div>

		</main>
		
		<footer>
			<%@include file="footer.jsp"%>
		</footer>
	</div>
</body>
<script>
	listCall();
	var $dis = 0;

	function listCall() {
		console.log("리스트");
		$.ajax({
			type : 'get',
			url : 'cart',
			data : {},
			dataType : 'JSON',
			success : function(data) {
				console.log(data.cartList);
				if (data.cartList.length == 0) {
					drawEmptyList();
					console.log("빈거");
					$dis = data.member;
					$("#dis").text($dis);

				} else {
					drawList(data.cartList)
					console.log("!!!!!!!");
					$dis = data.member;
					$("#dis").text($dis);
				}
			},
			error : function(e) {
				console.log("실패");
			}
		});
	}

	$('#checkAll').click(function() {
		var chk = $(this).is(':checked');
		if (chk) {
			$("input[name='chkBox']").each(function() {
				var disabled = $(this).prop("disabled");
				if (!disabled) {
					$(this).prop('checked', true);
				}
			});
		} else {
			$("input[name='chkBox']").prop('checked', false);
		}

		var $chk = $("input[name='chkBox']:checked");
		var $sum = 0;
		$chk.each(function(idx, item) {//item 은 자바스크립트 객체
			var $strTok = item.value.split(',');
			$sum += new Number($strTok[1]);
		});
		var $discount = $sum * ($dis / 100);
		$("input[name='total_sum']").val($sum);
		$("#total_sum").text($sum);
		$("input[name='discount']").val($discount);
		$("#discount").text('-' + $discount);
		$("input[name='result_price']").val($sum - $discount);
		$("#result_price").text($sum - $discount);
		console.log($("input[name='discount']").val());
	});

	$(document).on('click', '.del-chk', function() {
		if ($('input[class=del-chk]:checked').length == $('.del-chk').length) {
			$('#checkAll').prop('checked', true);
		} else {
			$('#checkAll').prop('checked', false);
		}

		var $chk = $("input[name='chkBox']:checked");
		var $sum = 0;
		$chk.each(function(idx, item) {//item 은 자바스크립트 객체
			var $strTok = item.value.split(',');
			$sum += new Number($strTok[1]);
		});
		var $discount = $sum * ($dis / 100);
		$("input[name='total_sum']").val($sum);
		$("#total_sum").text($sum);
		$("input[name='discount']").val($discount);
		$("#discount").text('-' + $discount);
		$("input[name='result_price']").val($sum - $discount);
		$("#result_price").text($sum - $discount);
		console.log($("input[name='discount']").val());
	});

	function modify(clicked) {

		last_char = clicked.substr(clicked.length - 1, 1);
		var $pCnt_m = "cntModify" + last_char;
		var $pId_m = "productId" + last_char;

		console.log($("input[name='" + $pCnt_m + "']").val());
		console.log($("input[name='" + $pId_m + "']").val());
		var $pId = $("input[name='" + $pId_m + "']").val();
		var $pCnt = $("input[name='" + $pCnt_m + "']").val();

		var param = {};
		param.pId = $pId;
		param.pCnt = $pCnt;

		console.log(param);
		if ($pCnt <= 0) {
			alert('수량을 다시 선택해주세요');
		} else {

			$.ajax({
				type : 'get',
				url : 'cartModify',
				data : param,
				dataType : 'JSON',
				success : function(data) {
					console.log(data);
					if (data.success) {
						if (data.success == -1) {
							alert("재고수량보다 많습니다. \r\n다시 선택해주세요.");
							listCall();
						} else {
							console.log(data);
							alert("수정했습니다.");
							window.location.reload();
							listCall();
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

	function deldel(clicked) {

		last_char = clicked.substr(clicked.length - 1, 1);
		var $pId_m = "productId" + last_char;
		var $pId = $("input[name='" + $pId_m + "']").val();

		var chkArr = [];
		chkArr.push($pId);
		isDel = confirm("품절된 상품을 삭제하시겠습니까?");
		if (isDel) {
			$.ajax({
				type : 'get',
				url : './cartDel',
				data : {
					'delList' : chkArr
				},
				dataType : 'JSON',
				success : function(data) {

					if (data.cnt > 0) {
						alert('삭제에 성공 했습니다.');
						//location.href='main.jsp';
						listCall();
					} else {
						alert('삭제에 실패 했습니다.');
					}
				},
				error : function(e) {
					console.log(e);
				}
			});
		}
	}

	function del() {
		var $chk = $("input[name='chkBox']:checked");
		if ($chk.length > 0) {
			console.log("삭제");

			var chkArr = [];

			$chk.each(function(idx, item) {//item 은 자바스크립트 객체
				var $strTok = item.value.split(',');
				console.log($strTok[0]);
				console.log(item);
				console.log($(item));
				console.log(item.value);

				chkArr.push($strTok[0]);
			});
			isDel = confirm("선택하신 상품을 장바구니에서 삭제하시겠습니까?");
			if (isDel) {
				$.ajax({
					type : 'get',
					url : './cartDel',
					data : {
						'delList' : chkArr
					},
					dataType : 'JSON',
					success : function(data) {

						if (data.cnt > 0) {
							alert(data.cnt + '건 삭제에 성공 했습니다.');
							window.location.reload();
							//location.href='main.jsp';
							listCall();
						} else {
							alert('삭제에 실패 했습니다.');
						}

					},
					error : function(e) {
						console.log(e);
					}
				});
			}
		} else {
			alert("삭제할 상품을 선택해 주세요.");
		}
		window.location.reload();
	}
	function order() {
		var $chk = $("input[name='chkBox']:checked");

		if ($chk.length > 0) {
			console.log("주문");
			var chkArr = [];

			$chk.each(function(idx, item) {//item 은 자바스크립트 객체
				var $strTok = item.value.split(',');
				console.log($strTok[0]);
				console.log(item);
				console.log($(item));
				console.log(item.value);

				chkArr.push($strTok[0]);
			});
			console.log("??????????");
			console.log(chkArr);

			isOrder = confirm("선택하신 상품을 주문하시겠습니까?");
			if (isOrder) {
				console.log(chkArr);
				console.log("----------");
				$.ajax({
					type : 'get',
					url : './order',
					data : {
						'orderList' : chkArr
					},
					dataType : 'JSON',
					success : function(data) {

						if (data.cnt > 0) {
							console.log("여기는 왜..?");
							//alert(data.cnt + '건 주문.');
							//console.log(data.orderList);
							location.href = './orderList';
							//console.log(list);
							//list 파라미터로 보내서
							//orderList(list);
							//다른 함수호출
						} else {

							alert('주문에 실패 했습니다.');
						}

					},
					error : function(e) {
						console.log(e);
					}
				});
			}
		} else {
			alert("주문할 상품을 선택해 주세요.");
		}
	}
	function orderList(list) {
		console.log("오더리스트");
		console.log(list);

		$.ajax({
			type : 'get',
			url : './orderList',
			data : {
				'orderList' : list
			},
			dataType : 'JSON',
			success : function(data) {
				console.log("성공");
			},
			error : function(e) {
				console.log(e);
			}
		});

	}
	function drawEmptyList() {
		var content = "";
		content += "<tr><td colspan='7'>" + "　" + "</td></tr>";
		content += "<tr>";
		content += "<td colspan='7'>장바구니가 비었습니다.</td>";
		content += "</tr>";

		$("tbody").empty();
		$("tbody").append(content);
	}

	function drawList(list) {
		var content = "";

		var tPrice = 0;
		var id = 1;
		list
				.forEach(function(item, idx) {

					content += "<tr>";

					if (item.stock == 0) {
						content += "<td><input class='del-chk' name='chkBox' type='checkbox' disabled  value='"+ item.productId+","+ item.totalPrice +"'/></td>";
						content += "<td><label style='color: white !important; position: absolute; background: red; '>품절</label>";
						content += "<a href='shopDetail?productId="
								+ item.productId
								+ "'><img src='/photo/" + item.imgNewName + "' style='width: 180px; height: 100px;' /></a></td>";
						content += "<td class='info' colspan='3'><div><div><a href='shopDetail?productId="
								+ item.productId
								+ "'>"
								+ item.productName
								+ "</a></div><div><hr/><div><input name='cntModify" + id +"' style='width:40px' type='number' min='0' style='width:20px; text-align:center;' value= '"  + item.productCount + "' /><input name='stock" + id +"' type='hidden' style='width:20px; text-align:center;' value= '"  + item.stock + "' /><input onclick='modify(this.id)' id='btn"
								+ id
								+ "'type='button' value='수정'/><input onclick='deldel(this.id)' id='btn"
								+ id
								+ "'type='button' value='삭제'/></div></div></div><input name='productId" + id +"' type='hidden' value='"+ item.productId+"'/></td>";
					} else if (item.stock < item.productCount) {
						content += "<td><input class='del-chk' name='chkBox' type='checkbox' disabled  value='"+ item.productId+","+ item.totalPrice +"'/></td>";
						content += "<td><label style='color: white !important; position: absolute; background: red; '>수량 수정 필요</label>";
						content += "<a href='shopDetail?productId="
								+ item.productId
								+ "'><img src='/photo/" + item.imgNewName + "' style='width: 180px; height: 100px;' /></a></td>";
						content += "<td class='info' colspan='3'><div><div><a href='shopDetail?productId="
								+ item.productId
								+ "'>"
								+ item.productName
								+ "</a></div><div><hr/><div><input name='cntModify" + id +"' style='width:40px' type='number' min='0' style='width:20px; text-align:center;' value= '"  + item.productCount + "' /><input name='stock" + id +"' type='hidden' style='width:20px; text-align:center;' value= '"  + item.stock + "' /><input onclick='modify(this.id)' id='btn"
								+ id
								+ "'type='button' value='수정'/> "
								+ "남은 개수 : "
								+ item.stock
								+ "</div></div></div><input name='productId" + id +"' type='hidden' value='"+ item.productId+"'/></td>";
					} else {
						content += "<td><input class='del-chk' name='chkBox' type='checkbox' value='"+ item.productId+","+ item.totalPrice +"'/></td>";
						content += "<td><a href='shopDetail?productId="
								+ item.productId
								+ "'><img src='/photo/" + item.imgNewName + "' style='width: 180px; height: 100px;' /></a></td>";
						content += "<td class='info' colspan='3'><div><div><a href='shopDetail?productId="
								+ item.productId
								+ "'>"
								+ item.productName
								+ "</a></div><div><hr/><div><input name='cntModify" + id +"' style='width:40px' type='number' min='0' style='width:20px; text-align:center;' value= '"  + item.productCount + "' /><input name='stock" + id +"' type='hidden' style='width:20px; text-align:center;' value= '"  + item.stock + "' /><input onclick='modify(this.id)' id='btn"
								+ id
								+ "'type='button' value='수정'/></div></div></div><input name='productId" + id +"' type='hidden' value='"+ item.productId+"'/></td>";
					}
					//content += "<td>" + item.productName + "</td>";
					content += "<td>" + item.price + " 원</td>";
					//content += "<td><input name='cntModify" + id +"' type='text' style='width:20px; text-align:center;' value= '"  + item.productCount + "' /><input onclick='modify(this.id)' id='btn" + id +"'type='button' value='수정'/></td>";
					content += "<td>" + item.totalPrice + " 원</td>";
					content += "</div></tr>";
					content += "<tr><td colspan='7'><hr></td></div></tr>"
					id++;
				});

		$("tbody").empty();
		$("tbody").append(content);
	}
</script>
</html>