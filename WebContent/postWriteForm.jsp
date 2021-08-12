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
 <div class="postWrite">
	<form action="postWrite" name="postWrite" method="post">
	<input type='hidden' id='thImg' name='thImg'/>
	<input type='hidden' id='img' name='img'/>
	
	<input type="hidden" name="userId" value="${sessionScope.userId}" readonly="readonly"/>
	<table style="margin: 0 auto 70px; width: 800px;">
	<tr>
	<td colspan="2"><h2>레시피 작성</h2></td>
	</tr>
		<tr>
			<th>제목</th>
			<td style="float: left; margin:8px 10px 10px 30px;"><input type="text" id="postTitle" name="title" autofocus="autofocus" maxlength="20" placeholder="제목을 입력하세요." size="75"/></td>
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
			<td style="float: left; margin:8px 10px 10px 50px;"><input type="number" id="postRecipePrice" name="recipePrice" placeholder="예산 입력"/>￦</td>
		</tr>
		<tr>
			<th>재료</th>
			<td><textarea style="resize: none;" rows="2" cols="80" name="item" maxlength="900" id="postItem"  placeholder="재료는 쉼표(,)로 구분하여 입력하세요."></textarea></td>
		</tr>	
		<tr>
			<th>Recipe</th>
			<td><textarea wrap="hard" style="resize: none; white-space: pre-line;" rows="30" cols="80" name="contents" maxlength="1900"  id="postContents"  placeholder="내용을 입력하세요."></textarea></td>
		</tr>
		<tr>
			<td colspan="2" style="float: left; margin:8px 5px 10px 30px;" >
				<input type="button" onclick="history.back();" value="취소"/>  
			</td>
			<td colspan="2"  >
				 <button style="float: right; margin-right: 7%;" id='submitBtn' type='button' onclick='javascript:checkfield();'>저장</button>
			</td>
		</tr>
	</table>
	</form>
</div>	
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
    }else if(document.postWrite.postRecipePrice.value < 0){
    	alert("예산을 다시 입력해 주세요 (마이너스금액)");
		document.postWrite.postRecipePrice.focus();
		return;
    }else if(document.postWrite.postRecipePrice.value > 10000000){
    	alert("예산을 다시 입력해 주세요 (1000만원 초과)");
    	document.postWrite.postRecipePrice.focus();
		return;
    }
	save();
}	
</script>
</html>