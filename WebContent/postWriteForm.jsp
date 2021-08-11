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
}
</script>
<body>
<header>
         <c:import url="./header_afterLogin.jsp" />
      </header>
	<form action="postWrite" name="postWrite" method="post">
	<input type='hidden' id='thImg' name='thImg'/>
	<input type='hidden' id='img' name='img'/>
	
	<input type="hidden" name="userId" value="${sessionScope.userId}" readonly="readonly"/>
	<table>
		<tr>
			<th>제목</th>
			<td><input type="text" id="postTitle" name="title" autofocus="autofocus" maxlength="20" placeholder="제목을 입력하세요." /></td>
		</tr>
		<tr>
			<td colspan="2">
				<c:import url="./fileUpload.jsp" charEncoding="utf-8">
   				<c:param name="field" value="post"/>
				</c:import>
			</td>
		</tr> 
		<tr>
			<th>카테고리 설정</th>
			<td>
				<input type="radio" name="categoryId" value="2"/>한식
				&nbsp;
				<input type="radio" name="categoryId" value="3"/>중식
				&nbsp;
				<input type="radio" name="categoryId" value="4"/>일식
				&nbsp;
				<input type="radio" name="categoryId" value="5"/>양식
				&nbsp;
				<input type="radio" name="categoryId" value="6"/>분식
				&nbsp;
				<input type="radio" name="categoryId" value="7"/>채식
				&nbsp;
				<input type="radio" name="categoryId" value="8"/>이유식
				&nbsp;
				<input type="radio" name="categoryId" value="9"/>디저트
				&nbsp;
				<input type="radio" name="categoryId" value="1" checked="checked"/>기타
			</td>
			</tr>
		<tr>
			<th>예산</th>
			<td><input type="number" id="postRecipePrice" name="recipePrice"  min="100" max="10000000" placeholder="예산을 입력하세요."/>￦</td>
		</tr>
		<tr>
			<th>재료</th>
			<td><textarea name="item" maxlength="1000" id="postItem"  placeholder="재료는 쉼표(,)로 구분하여 입력하세요."></textarea></td>
		</tr>	
		<tr>
			<th>Recipe</th>
			<td><textarea name="contents" maxlength="2000"  id="postContents"  placeholder="내용을 입력하세요."></textarea></td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="button" onclick="history.back();" value="취소"/> 
				 <button id='submitBtn' type='button' onclick='javascript:checkfield()'>저장</button>
				
			</td>
		</tr>
	</table>
	</form>
</body>
<script>
function checkfield(){
	if(document.postWrite.postTitle.value ==""){
		alert("제목을 입력하세요.");
		document.postWrite.postTitle.focus();
		return;
	}else if(document.postWrite.postRecipePrice.value ==""){
		alert("예산을 입력하세요.");
		document.postWrite.postRecipePrice.focus();
		return;
	}else if(document.postWrite.postItem.value ==""){
		alert("재료를 입력하세요.");
		document.postWrite.postItem.focus();
		return;
    }else if(document.postWrite.postContents.value ==""){
		alert("Recipe를 작성하세요.");
		document.postWrite.postContents.focus();
		return;
    }
	save();
}	
</script>
</html>