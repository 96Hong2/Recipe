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
<header>
  <c:import url="./header_afterLogin.jsp" />
</header>
<div class="postUpdate">
	<form action="postUpdate" method="post" name="postUpdate">
	<input type='hidden' id='thImg' name='thImg'/>
	<input type='hidden' id='img' name='img'/>
	<input type="hidden" name="userId" value="${sessionScope.userId}" readonly="readonly"/>
	<input type="hidden" name="postId" value="${post.postId}"/>
	
	
	<table style="position:relative; left: 565px;">
	<tr>
	<td colspan="2"><h2>레시피 수정</h2></td>
	</tr>
		<tr>
			<th>제목</th>
			<td><input style="float: left; margin:8px 10px 10px 30px;" type="text" id="postTitle" name="title" maxlength="20" placeholder="제목을 입력하세요." value="${post.title}" /></td>
		</tr>
		<tr>
			<td colspan="2">
				<c:import url="./fileUpdate.jsp" charEncoding="utf-8">
  					 <c:param name="field" value="post"/>
  					 <c:param name="fieldId" value="${post.postId }"/>
  					 <c:param name="ex_thumbnail" value="${post.th_imgid }"/>
  					 <c:param name="ex_contentImg" value="${post.imgid }"/>
 					 <c:param name="ex_thumbnail_Name" value="${post.th_imgNewName }"/>
 					 <c:param name="ex_contentImg_Name" value="${post.imgNewName }"/>
				</c:import>
			</td>
		</tr>
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
			<td style="float: left; margin:8px 10px 10px 30px;"><input type="number" id="recipePrice" name="recipePrice" min="100" max="10000000" placeholder="예산을 입력하세요." value="${post.recipePrice}" />￦</td>
		</tr>
		<tr>
			<th>재료</th>
			<td><textarea style="resize: none;" rows="2" cols="80" name="item" id="postItem" maxlength="1000" placeholder="재료는 쉼표(,)로 구분하여 입력하세요." >${post.item}</textarea></td>
		</tr>	
		<tr>
			<th>Recipe</th>
			<td><textarea style="resize: none; white-space: pre-line;" rows="30" cols="80" name="contents" id="postContents"  maxlength="2000" autofocus="autofocus" placeholder="내용을 입력하세요.">${post.contents}</textarea></td>
		</tr>
		<tr>
			<td colspan="2" style="float: left; margin:8px 5px 10px 30px;">
				<input type="button" onclick="location.href='./postDetail?postId=${post.postId}'" value="취소"/> 
			</td>
			<td colspan="2"  style=" position: relative; left:280px; right: 10px;">
				<button id='submitBtn' type='button' onclick='javascript:checkfield()'>저장</button>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
<script>
$('[name=categoryId]:radio[value="'+'${post.categoryId}'+'"]').prop('checked', true );


function checkfield(){
	if(document.postUpdate.postTitle.value ==""){
		alert("제목을 입력하세요.");
		document.postUpdate.postTitle.focus();
		return;
	}else if(document.postUpdate.recipePrice.value ==""){
		alert("예산을 입력하세요.");
		document.postUpdate.recipePrice.focus();
		return;
	}else if(document.postUpdate.postItem.value ==""){
		alert("재료를 입력하세요.");
		document.postUpdate.postItem.focus();
		return;
    }else if(document.postUpdate.postContents.value ==""){
		alert("Recipe를 작성하세요.");
		document.postUpdate.postContents.focus();
		return;
    }
	save();
}	
</script>
</html>