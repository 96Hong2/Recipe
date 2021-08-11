<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지 - 상품 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
<style>
.adminProductSearch, h1{
 text-align:center;
}
img {
  width: 200px;
  height: 150px;
  object-fit: fill;
}
.wrapper { 
  left:50%;
  top:100%;
  text-align:center;
  line-height:200%;  
</style>
</head>
<body>
<div class="wrap">
	<header>
         <c:import url="./header_afterLogin.jsp" />
      </header>
	<h1>상품관리</h1>
	<main id="body">
		<div class="adminProductSearch">
			<form action="adminProductSearch" method="get" id="searchProduct">			
				상품 검색 : <input type="text" name="keyword" id="keyword"	placeholder="상품을 입력해주세요." />
				<button>검색</button>
			</form>	
			</div>
			
		<div class="container">
			<c:forEach items="${adminProductList}" var="product">
			<div style="width: 280px; height: 232px;">
			<figure class="figure">
		<c:set var="imgNewName" value="${product.imgNewName}" />
		<c:if test="${imgNewName eq null }"><td colspan="3"><img src="./defaultThum.png" onclick="location.href='productDetail?productId=${product.productId}'" /></td></c:if>
		<c:if test="${imgNewName ne null }"><td colspan="3"><img src="/photo/${product.imgNewName}"  onclick="location.href='productDetail?productId=${product.productId}'"/></td></c:if>
						
				<figcaption>
					<td>${product.productName}</td>
				</figcaption>	
				</figure>
				</div>			
			</c:forEach>
		</div>
		<div class="wrapper">
			<tr>
			<td><button onclick="location.href='./adminProductRegister.jsp'">상품 추가하기</button></td>
			</tr>
			
			<div class="pageArea">
		<c:forEach var="i" begin="1" end="${totalPage}" step="1">
			<span class="page">
				<c:if test="${i ne currPage }"><a href="./adminProductList?page=${i}">${i}</a></c:if>
				<c:if test="${i eq currPage }"><b>${i}</b></c:if>
			</span>		
		</c:forEach>		
		</div>
		</div>
		</main>
	</div>
</body>
</html>