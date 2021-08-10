<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
</head>
<body>
<h2>상품 상세보기</h2>	
	<table>
	<tr>			
		<td>${product.productName}</td>
	</tr>
	<tr>
		<th>첨부 이미지</th>
		<td colspan="14"><c:if test="${product.imgNewName ne null }"><img src="/photo/${product.imgNewName}" width="500px" height="500px"/></c:if></td>
	</tr>
	<tr>
		<td>개당 가격: ${product.price}원
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재고 수량:${product.stock}개</td> 
	</tr>
	<tr>		
		<td>${product.productDetail }</td>
	</tr>
	<tr>
		<td>삭제 여부 : ${product.isDel }</td>
	</tr>
	<tr>
		<td>
		<input type="button" onclick="location.href='./adminProductList'" value="상품 리스트"/>
		<button onclick="location.href='./productUpdateForm?productId=${product.productId}'">상품 수정</button>
		<button onclick="location.href='./productDel?productId=${product.productId}'">상품 삭제</button>
		</td>
	</tr>
	</table>
</body>
<script>
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
</script>
</html>