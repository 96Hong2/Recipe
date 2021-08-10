<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	<h3>상품관리</h3>
	<table>
		<div class="adminProductSearch">
			<form action="adminProductSearch" method="get" id="searchProduct">			
				상품 검색 : <input type="text" name="keyword" id="keyword"
					placeholder="상품을 입력해주세요." />
				<button>검색</button>
			</form>	
			<c:forEach items="${adminProductList}" var="product">
				<tr>
		<c:set var="imgNewName" value="${product.imgNewName}" />
		<c:if test="${imgNewName eq null }"><td colspan="3"><img src="./defaultThum.png" onclick="location.href='productDetail?productId=${product.productId}'"/></td></c:if>
		<c:if test="${imgNewName ne null }"><td colspan="3"><img src="/photo/${product.imgNewName}" width="250px" height="150px" onclick="location.href='productDetail?productId=${product.productId}'"/></td></c:if>
		</tr>				
				<tr>
					<td>${product.productName}</td>
				</tr>				
			</c:forEach>
			<tr>
			<td><button onclick="location.href='./adminProductRegister.jsp'">상품 추가하기</button></td>
			</tr>
		</div>
	</table>
			
			<div class="pageArea">
		<c:forEach var="i" begin="1" end="${totalPage}" step="1">
			<span class="page">
				<c:if test="${i ne currPage }"><a href="./adminProductList?page=${i}">${i}</a></c:if>
				<c:if test="${i eq currPage }"><b>${i}</b></c:if>
			</span>		
		</c:forEach>		
		</div>
	
</body>
<script>
</script>
</html>