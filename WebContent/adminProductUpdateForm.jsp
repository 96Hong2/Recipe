<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지 - 상품 수정</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="css/common.css" type="text/css">
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
<style>
.wrapper {
  position:absolute;
  left:35%;
  top:5%;
  text-align:center;
  line-height:200%;  
}
h1{ text-align:center;}
</style>

</head>
<body>
<div class="wrapper">
<form action="productUpdate" method="POST">
	<h1>상품 수정</h1>
	<table>
		<tr>
			<td>
				<input type="hidden" name="productId" id="Name" value="${product.productId}"/>
			</td>
		</tr>
		<tr>
			<td><input type="text" name="productName" id="Name" value="${product.productName}"/></td>
		</tr>
		<tr>
			<td>
		<c:import url="./fileUpdate.jsp" charEncoding="utf-8">
         <c:param name="field" value="product"/>
         <c:param name="fieldId" value="${product.productId}"/>
         <c:param name="ex_thumbnail" value="${product.th_imgid}"/>
         <c:param name="ex_contentImg" value="${product.imgid}"/>
        <c:param name="ex_thumbnail_Name" value="${product.th_imgNewName}"/>
        <c:param name="ex_contentImg_Name" value="${product.imgNewName}"/>
      </c:import>
      </td>				
		</tr>
		<tr>
		<td>개당 가격:<input type="text" name="price" id="Price" maxlength="8" value="${product.price}"> 원
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재고 수량:<input type="text" id="Stock" name="stock" maxlength="5" value="${product.stock}">개</td> 
	</tr>
		<tr>			
			<td><textarea name='productDetail'  cols=85 rows=40 id="Detail" maxlength=2000>${product.productDetail}</textarea></td>
		</tr>
		<tr>
			<td colspan="2">
			<input type="button" onclick="location.href='./adminProductList'" value="상품 리스트"/>
			<button id='submitBtn' type='button' onclick='javascript:f1()'>상품 수정하기</button>
			</td>
		</tr>
	</table>
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