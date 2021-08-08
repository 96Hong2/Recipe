<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/board.css" media="all" />
</head>
<body>

	<button onclick="location.href='postWriteForm.jsp'">레시피작성</button>
		<form action="category" id="frm" method="get">
			<div>
				<input type="radio" id="all" name="categoryId" value="0" onclick="location.href='./postList'"  <c:if test="${all != null || list[0].categoryId == null }">checked="checked"</c:if> />전체
				&nbsp; 
				<input type="radio" id="chinaFood" name="categoryId" value="2" onclick="document.getElementById('frm').submit();" <c:if test="${list[0].categoryId == 2 && category.equals(category)}">checked="checked"</c:if> />한식
				&nbsp;
				<input type="radio" id="koreanFood" name="categoryId" value="3" onclick="document.getElementById('frm').submit();" <c:if test="${list[0].categoryId == 3 && category.equals(category)}">checked="checked"</c:if>/>중식
				&nbsp;
				<input type="radio" id="japaneseFood" name="categoryId" value="4" onclick="document.getElementById('frm').submit();"<c:if test="${list[0].categoryId == 4 && category.equals(category)}">checked="checked"</c:if> />일식
				&nbsp;
				<input type="radio" id="westernFood" name="categoryId" value="5" onclick="document.getElementById('frm').submit();"<c:if test="${list[0].categoryId == 5 && category.equals(category)}">checked="checked"</c:if> />양식
				&nbsp;
				<input type="radio" id="snackFood" name="categoryId" value="6" onclick="document.getElementById('frm').submit();"<c:if test="${list[0].categoryId == 6 && category.equals(category)}">checked="checked"</c:if>/>분식
				&nbsp;
				<input type="radio" id="vegetarian" name="categoryId" value="7" onclick="document.getElementById('frm').submit();"<c:if test="${list[0].categoryId == 7 && category.equals(category)}">checked="checked"</c:if>/>채식
				&nbsp;
				<input type="radio" id="babyFood" name="categoryId" value="8" onclick="document.getElementById('frm').submit();"<c:if test="${list[0].categoryId == 8 && category.equals(category)}">checked="checked"</c:if>/>이유식
				&nbsp;
				<input type="radio" id="dessert" name="categoryId" value="9" onclick="document.getElementById('frm').submit();" <c:if test="${list[0].categoryId == 9 && category.equals(category)}">checked="checked"</c:if>/>디저트
				&nbsp;
				<input type="radio" id="etc" name="categoryId" value="1" onclick="document.getElementById('frm').submit();" <c:if test="${list[0].categoryId == 1 && category.equals(category)}">checked="checked"</c:if> />기타
			</div>
		</form>
		
			<form action="postSearch" method="get" id="postSearch">
				<select name="postSearchOpt" id="postSearchOpt">
         			<option value='title_contentsSearch' selected="selected">제목 + 내용</option>
         			<option value='recipePriceSearch'>예산</option>
         		</select>
					<span id="option1"><input type="text" id="title_contentsSearch" name="keyword" placeholder="검색어입력" /></span>
					<span hidden="hidden" id="option2"><input type="number" id="recipePriceSearch" name="keywordMin" placeholder="최소 예산"/> ~ <input type="number" name="keywordMax" placeholder="최대 예산"/>￦</span>
         			<c:if test="${category.equals(category) && total != 0}"><input type="text" name="categoryId" value="${list[0].categoryId}"/></c:if>
         			<c:if test="${all.equals(all) || total == 0}"><input type="text" name="categoryId" value="0"/></c:if>
					<button>검색</button>
				</form>
				
	<table>
		<c:choose>
		<c:when test="${list[0].postId ne null}">
		<c:forEach items="${list}" var="post">
		<tr>
		<c:set var="imgNewName" value="${post.imgNewName}" />
		<c:if test="${imgNewName eq null }"><td colspan="3"><img src="./defaultThum.png" onclick="location.href='postDetail?postId=${post.postId}'"/></td></c:if>
		<c:if test="${imgNewName ne null }"><td colspan="3"><img src="/photo/${post.imgNewName}" width="250px" height="150px" onclick="location.href='postDetail?postId=${post.postId}'"/></td></c:if>
		</tr>
		<tr>	
			<th>${post.likes}</th><th><a href="postDetail?postId=${post.postId}">${post.title}</a></th><th>${post.hits}</th>
		</tr>
		<tr>	
			<th colspan="3">${post.item}</th>
		</tr>
		<tr>	
			<th colspan="3">${post.recipePrice}￦</th>
		</tr>
		<tr>	
			<th colspan="3">${post.nickName}</th>
		</tr>
		</c:forEach>
		</c:when>
		<c:otherwise>
		<div>검색된 내용이 없습니다.</div>
		</c:otherwise>
	    </c:choose>
	</table>
	<div class="pageArea">
	<c:forEach var="i" begin="1" end="${totalPage}" step="1">
		<span class="postPage">
			<c:if test="${i ne currPage}"><a href="./postList?postPage=${i}">${i}</a></c:if>
			<c:if test="${i eq currPage}"><b>${i}</b></c:if>
		</span>
	</c:forEach>
	</div>
</body>
<script>
	
$(document).ready(function(){
	$(document).on('change',function(){
		if($("#postSearchOpt").val() == "title_contentsSearch"){
		$("#option1").show();
		$("#option2").hide();
		$("#recipePriceSearch").claer();
	} else if($("#postSearchOpt").val() == "recipePriceSearch"){
		$("#option2").show();
		$("#option1").hide();
		$("#title_contentsSearch").clear();
	}
	
  });

});

</script> 
</html>