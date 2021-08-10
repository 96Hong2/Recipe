<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 작성</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<script>
if("${sessionScope.userId}"==""){
	   alert("로그인이 필요한 서비스입니다.");
	   location.href = "./";
	};
	if("${sessionScope.userId}" != "${post.userId}"){
		alert("자신의 글만 수정할 수 있습니다.");
		   location.href = "./postDetail?postId=${post.postId}";
	}
</script>
<body>	
	<form action="postUpdate" method="post">
	<input type="hidden" name="userId" value="${sessionScope.userId}" readonly="readonly"/>
	<input type="hidden" name="postId" value="${post.postId}"/>
	<table>
		<tr>
			<th>제목</th>
			<td><input type="text" name="title"  min="2" maxlength="20" value="${post.title}" /></td>
		</tr>
		<c:import url="./fileUpdate.jsp" charEncoding="utf-8">
  		 <c:param name="field" value="post"/>
  		 <c:param name="fieldId" value="${post.postId }"/>
  		 <c:param name="ex_thumbnail" value="${post.th_imgid }"/>
  		 <c:param name="ex_contentImg" value="${post.imgid }"/>
 		 <c:param name="ex_thumbnail_Name" value="${post.th_imgNewName }"/>
 		 <c:param name="ex_contentImg_Name" value="${post.imgNewName }"/>
		</c:import>
			<tr>
			<th>카테고리 설정</th>
			<td>
				<input type="radio" name="categoryId" value="2" />한식
				&nbsp;
				<input type="radio" name="categoryId" value="3"/>중식
				&nbsp;
				<input type="radio" name="categoryId" value="4" />일식
				&nbsp;
				<input type="radio" name="categoryId" value="5" />양식
				&nbsp;
				<input type="radio" name="categoryId" value="6" />분식
				&nbsp;
				<input type="radio" name="categoryId" value="7" />채식
				&nbsp;
				<input type="radio" name="categoryId" value="8" />이유식
				&nbsp;
				<input type="radio" name="categoryId" value="9" />디저트
				&nbsp;
				<input type="radio" name="categoryId" value="1" />기타
			</td>
			</tr>
		<tr>
			<th>예산</th>
			<td><input type="number" name="recipePrice"  max="10000000" value="${post.recipePrice}"/>￦</td>
		</tr>
		<tr>
			<th>재료</th>
			<td><textarea name="item" >${post.item}</textarea></td>
		</tr>	
		<tr>
			<th>Recipe</th>
			<td><textarea name="contents" autofocus="autofocus">${post.contents}</textarea></td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="button" onclick="location.href='./postDetail?postId=${post.postId}'" value="취소"/> 
				<button id='submitBtn' type='button' onclick='javascript:save()'>저장</button>
			</td>
		</tr>
	</table>
	</form>
	
</body>
<script>
$('[name=categoryId]:radio[value="'+'${post.categoryId}'+'"]').prop('checked', true );
</script>
</html>