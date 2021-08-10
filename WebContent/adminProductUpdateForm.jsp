<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link rel="stylesheet" href="css/common.css" type="text/css">
</head>
<body>
<form action="productUpdate" method="POST">
	<table>
		<tr>
			<td>
				<input type="hidden" name="productId" value="${product.productId}"/>
			</td>
		</tr>
		<tr>
			<td><input type="text" name="productName" value="${product.productName}"/></td>
		</tr>
		<tr>
			<td>
		<c:import url="./fileUpdate.jsp" charEncoding="utf-8">
         <c:param name="field" value="product"/>
         <c:param name="fieldId" value="${product.productId }"/>
         <c:param name="ex_thumbnail" value="${product.th_imgid}"/>
         <c:param name="ex_contentImg" value="${product.imgid}"/>
        <c:param name="ex_thumbnail_Name" value="${product.th_imgNewName}"/>
        <c:param name="ex_contentImg_Name" value="${product.imgNewName}"/>
      </c:import>
      </td>				
		</tr>
		<tr>
		<td>개당 가격:<input type="text" name="price" maxlength="8" value="${product.price}"> 원
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재고 수량:<input type="text" name="stock" maxlength="5" value="${product.stock}">개</td> 
	</tr>
		<tr>			
			<td><textarea name='productDetail'  cols=85 rows=40 maxlength=2000>${product.productDetail}</textarea></td>
		</tr>
		<tr>
			<td colspan="2">
			<input type="button" onclick="location.href='./adminProductList'" value="상품 리스트"/>
			<button id='submitBtn' type='button' onclick='javascript:save()'>상품 수정하기</button>
			</td>
		</tr>
	</table>
</form>
</body>
<script>
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
</script>
</html>