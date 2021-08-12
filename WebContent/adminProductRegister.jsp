<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지 - 상품 등록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="css/common.css" type="text/css">
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
<style>
h1{ text-align:center;}
.wrapper { 
position: relative;
  left:10%;
  top:10%;
  text-align:center;
  line-height:200%; 
</style>
</head>
<body>
<div class="wrap">
	<header>
         <c:import url="./header_afterLogin.jsp" />
      </header>
	<form action="addProduct" method="post">
		<input type='hidden' id='thImg' name='thImg' /> <input type='hidden'
			id='img' name='img' />

		<h1>상품 추가</h1>
<div class="wrapper">
		<table>
			<tr>
				<td><input type="text" name="productName" id="Name" maxlength="20"
					placeholder="상품 이름을 입력해주세요."></td>
			</tr>
			<tr>
				<td><c:import url="./fileUpload.jsp" charEncoding="utf-8">
						<c:param name="field" value="product" />
					</c:import></td>
			</tr>
			<tr>
				<td>개당 가격: <input type="text" name="price" id="Price" maxlength="8">원
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재고 수량:<input type="text"
					name="stock" id="Stock" maxlength="5">개
				</td>
			</tr>
			<tr>
				<td><textarea name='productDetail' cols=85 rows=40 id="Detail"
						maxlength=2000 placeholder="상품 상세내용을 입력해주세요."></textarea></td>
			</tr>
			<tr>
				<td colspan="2"><input type="button" onclick="history.back();" value="취소하기">
				<button id='submitBtn' type='button' onclick='javascript:f1()'>상품 추가하기</button>
				</td>
			</tr>
		</table>
		</div>
	</form>		
</div>	
</body>
	<script>
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
	
	function f1(){
		if($("#Name").val().length==0){alert("상품이름을 입력하세요."); $("#Name").focus(); return;}
	      if($("#Price").val().length==0){alert("가격을 입력하세요."); $("#Price").focus(); return;}
	      if($("#Stock").val().length==0){alert("수량을 입력하세요."); $("#Stock").focus(); return;}
	      if($("#Detail").val().length==0){alert("상품내용을 입력하세요."); $("#Detail").focus(); return;}
		
		save();
	}
	</script>
</html>