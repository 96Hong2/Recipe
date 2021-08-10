<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품 추가</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
</head>
<body>

	<form action="addProduct" method="post">
	<input type='hidden' id='thImg' name='thImg'/>
	<input type='hidden' id='img' name='img'/>
	
	<h2>상품 추가</h2>	
	<table>
	<tr>
		<td><input type="text" name="productName" maxlength="20" placeholder= "상품 이름을 입력해주세요."></td>
	</tr>
	<tr>
		<td>		
			<c:import url="./fileUpload.jsp" charEncoding="utf-8">
   			<c:param name="field" value="product"/></c:import>		
   		</td>		
	</tr>
	<tr>
		<td>개당 가격:  <input type="text" name="price" maxlength="8" >원	
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;재고 수량:<input type="text" name="stock" maxlength="5" >개</td> 
	</tr>
	<tr>		
		<td><textarea name='productDetail'  cols=85 rows=40 maxlength=2000  placeholder="상품 상세내용을 입력해주세요." ></textarea></td>
	</tr>
	<tr>
		<td><button onclick="location.href='./adminProductList'">취소하기</button></td>
		<td><button id='submitBtn' type='button' onclick='javascript:save()'>상품 추가하기</button></td>
	</tr>
	</table>
	</form>
</body>
</html>