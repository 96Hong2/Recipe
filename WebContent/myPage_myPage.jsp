<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 마이페이지</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/myPage.css" media="all" />
</head>
<script>
if("${sessionScope.userId}"==""){
	alert("로그인이 필요한 서비스입니다.");
	location.href = "./";
}
</script>
<script>
	function popUp()
	{ window.open("popUp.jsp", "회원 탈퇴", "width=600, height=200, left=100, top=50"); }
</script>
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>

<body>
	<div class="body_wrap">
		<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지" width='100px'
			height='100px' />
		
		<h3>${sessionScope.nickName} 님의 마이페이지</h3>
		<a href='index.jsp' id='main'>MAIN PAGE로 돌아가기</a>
		
		<div id="info">
			<c:import url="./myPage_info.jsp"/>
		</div>
		
		<div id="myMenu">
			<div id="myMenu_info">
				<img src="./staticImg/catIcon.png" alt="내정보아이콘" width=50px; height=50px;/>
				<button type='button' onclick="location.href='./clientInfo'">내 정보 수정/보기</button>
			</div>
			<div id="myMenu_order">
				<img src="./staticImg/catIcon.png" alt="주문아이콘" width=50px; height=50px;/>
				<button type='button' onclick="location.href='index.jsp'">주문조회</button>
			</div>
			<div id="myMenu_cart">
				<img src="./staticImg/catIcon.png" alt="장바구니아이콘" width=50px; height=50px;/>
				<button type='button' onclick="location.href='cart.jsp'">장바구니</button>
			</div>
			<div id="myMenu_cash">
				<img src="./staticImg/catIcon.png" alt="캐시아이콘" width=50px; height=50px;/>
				<button type='button' onclick='location.href="./cashHistory"'>마이캐시</button>
			</div>
			<div id="myMenu_honor">
				<img src="./staticImg/catIcon.png" alt="명예아이콘" width=50px; height=50px;/>
				<button type='button' onclick="location.href='index.jsp'">명예조회</button>
			</div>
		</div>
		
		<div id="like">
		<h4>♥ 좋아요한 레시피</h4>
		<table>
			<tr>
				<th>썸네일</th><th>좋아요</th><th>제목</th><th>조회수</th><th>재료</th><th>예산</th><th>작성자</th>
			</tr>
			<c:if test="${myPage_Like eq null || myPage_Like eq ''}">
					<tr><td colspan='7'>좋아요한 레시피가 없습니다.</td></tr>
			</c:if>
			<c:forEach items='${myPage_Like}' var='likeItem'>
				<tr>
					<td>썸네일</td>
					<td>${likeItem.like}</td>
					<td><a href='#?postid=${likeItem.postId}'>${likeItem.title}</a></td>
					<td>${likeItem.hits}</td>
					<td>${likeItem.item}</td>
					<td>${likeItem.recipePrice}</td>
					<td>${likeItem.nickName}</td>
				</tr>
			</c:forEach>
		</table>
		<button onclick="location.href='myLike.jsp'">좋아요한 레시피 더보기</button>
		</div>
		
		<div id="myRecipe">
		<h4>♥ 내 레시피</h4>
		<table>
			<tr>
				<th>썸네일</th><th>좋아요</th><th>제목</th><th>조회수</th><th>재료</th><th>예산</th><th>작성자</th>
			</tr>
			<c:if test="${myPage_Post eq null || myPage_Post eq ''}">
					<tr><td colspan='7'>작성한 레시피가 없습니다.</td></tr>
			</c:if>
			<c:forEach items='${myPage_Post}' var='postItem'>
				<tr>
					<td>썸네일</td>
					<td>${postItem.like}</td>
					<td><a href='#?postid=${postItem.postId}'>${postItem.title}</a></td>
					<td>${postItem.hits}</td>
					<td>${postItem.item}</td>
					<td>${postItem.recipePrice}</td>
					<td>${postItem.nickName}</td>
				</tr>
			</c:forEach>
		</table>
		<button onclick="location.href='./myWrite'">내가 작성한 레시피 더보기</button>
		</div>
		
		<div id="myComment">
		<h4>♥ 내가 쓴 댓글</h4>
		<table>
			<tr>
				<th>레시피제목</th><th>댓글내용</th><th>작성날짜</th>
			</tr>
			<c:if test="${myPage_Comment eq null || myPage_Comment eq ''}">
					<tr><td colspan='7'>작성한 댓글이 없습니다.</td></tr>
			</c:if>
			<c:forEach items='${myPage_Comment}' var='commentItem'>
				<tr>
					<td><a href='#?postid=${commentItem.postId}'>${commentItem.title}</a></td>
					<td><a href='#?postid=${commentItem.postId}'>${commentItem.comment_content}</a></td>
					<td>${commentItem.comment_date}</td>
				</tr>
			</c:forEach>
		</table>
		<button onclick="location.href='./myComment'">내가 작성한 댓글 더보기</button>
		</div>
		
		<button id='delAccount' onclick="href.location='index.jsp'">회원 탈퇴</button>
	</div>

</body>
<footer> </footer>
<script>
/* var nickName = "${sessionScope.nickName}";
console.log("세션에 저장된 nickName : "+nickName);
$.ajax({
	type:'post',
	url:'info',
	data:{'userId' : nickName},
	dataType:'JSON',
	success:function(data){
		console.log("ajax data : "+data);
		if(data.info != null){
			drawInfo(data.info);
		}
	},
	error:function(e){
		console.log("ajax e : "+e);
	}
});

function drawInfo(){
	console.log("drawInfo 들어옴");
} */

</script>
</html>