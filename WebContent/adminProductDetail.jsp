<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지 - 상품 상세보기</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>
	if ("${sessionScope.isAdmin}" != "Y") {
		alert("해당 서비스 접근 권한이 없습니다.");
		location.href = "../";
	}
</script>
<style>
h1{ text-align:center;}
img {
  width: 200px;
  height: 170px;
  object-fit: fill;
}
.wrapper { 
position: relative;
  left:35%;
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
      
	<h1>상품 상세보기</h1>
<div class="wrapper">
	<table>
		<tr>
			<td>${product.productName}</td>
		</tr>
		<tr>
			<td>썸네일 이미지</td>
		<tr>
			<td><c:if test="${product.th_imgNewName ne null }">
					<img src="/photo/${product.th_imgNewName}"/>
				</c:if></td>
			<c:if test="${product.th_imgNewName eq null }">
				<td><img src="./defaultThum.png"
					onclick="location.href='productDetail?productId=${product.productId}'" /></td></c:if>
		</tr>
		<tr>
			<td>첨부 이미지</td>
		</tr>
		<tr>
			<td><c:if test="${product.imgNewName ne null }">
					<img src="/photo/${product.imgNewName}"/>
				</c:if></td>
			<c:if test="${product.imgNewName eq null }">
				<td><img src="./defaultThum.png"
					onclick="location.href='productDetail?productId=${product.productId}'" /></td>
			</c:if>
		</tr>
		<tr>
			<td>개당 가격: ${product.price} 원
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재고 수량: ${product.stock} 개</td>
		</tr>
		<tr>
			<td style="text-align: left; white-space:pre-line;">${product.productDetail } </td>
		</tr>
		<tr>
			<td>삭제 여부 : ${product.isDel }</td>
		</tr>
		<tr>
			<td><input type="button"
				onclick="location.href='./adminProductList'" value="상품 리스트" />
				<button
					onclick="location.href='./productUpdateForm?productId=${product.productId}'">상품
					수정</button>
				<button
					onclick="location.href='./productDel?productId=${product.productId}'">상품
					삭제</button></td>
		</tr>
	</table>
	</div>	
	</div>
</body>
<script>
	var msg = "${msg}";
	if (msg != "") {
		alert(msg);
	}
</script>
</html>