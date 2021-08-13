<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 마이페이지</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
</head>
<script>
	if ("${sessionScope.userId}" == "") {
		alert("로그인이 필요한 서비스입니다.");
		location.href = "./";
	}
</script>
<script>
	function popUp()
	{ window.open("popUp.jsp", "회원 탈퇴", "width=600, height=200, left=100, top=50"); }
</script>
<body>
	<div class="wrap">
	
		<header>
			<c:import url="./header_afterLogin.jsp" />
		</header>
		<main id="body" style="padding: 20px;">
		<a href='index.jsp' id='main'>
		<h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MAIN PAGE로 돌아가기</h4>
		</a>
			<div>
				<div style="width: 900px; display: flex; margin-bottom: 20px;">
					<div style="width: 660px;">
						<img src="./staticImg/user.png" id='userImg' alt="유저이미지"
							width='100px' height='100px' />

						<h3>${sessionScope.nickName} 님의 마이페이지</h3>
						
					</div>
					<div id="info" style="width: 200px;">
						<c:import url="./myPage_info.jsp" />
					</div>
				</div>

				<div id="myMenu" style="width: 780px; display: flex; padding: 0 40px;">
					<div class="myMenu" style="width:20%;">
				
						<img src="./staticImg/catIcon.png" alt="내정보아이콘" width=50px;
							height=50px; /><br />
						<button type='button' onclick="location.href='./clientInfo'">내
							정보 수정/보기</button>
						<div style='margin:3px'>&nbsp;</div>
					</div>
					<div class="myMenu" style="width:20%;">
						<img src="./staticImg/catIcon.png" alt="주문아이콘" width=50px;
							height=50px; /><br />
						<button type='button' onclick="location.href='./myOrder'">주문조회</button>
						<div style='margin:3px'>&nbsp;</div>
					</div>
					<div class="myMenu" style="width:20%;">
						<img src="./staticImg/catIcon.png" alt="장바구니아이콘" width=50px;
							height=50px; /><br />
						<button type='button' onclick="location.href='cart.jsp'">장바구니</button>
						<div style='margin:3px'>&nbsp;</div>
					</div>
					<div class="myMenu" style="width:20%;">
						<img src="./staticImg/catIcon.png" alt="캐시아이콘" width=50px;
							height=50px; /><br />
						<button type='button' onclick='location.href="./cashHistory"'>마이캐시</button>
						<div style='margin:3px'>&nbsp;</div>
					</div>
					<div class="myMenu" style="width:20%;">
						<img src="./staticImg/catIcon.png" alt="명예아이콘" width=50px;
							height=50px; /><br />
						<button type='button' onclick="location.href='./pointHistory'">명예조회</button>
						<div style='margin:3px'>&nbsp;</div>
					</div>
				</div>
				
				<div style='margin:10px'>&nbsp;</div>
				<div id="like">
					<h4>♥ 좋아요한 레시피</h4>
					<div class="recipeContainer">
						<c:if test="${myPage_Like eq '[]'}">
							<div style='height:100px'>좋아요한 레시피가 없습니다.</div>
						</c:if>
						<c:forEach items='${myPage_Like}' var='likeItem'>
							<div style="width: 280px; height: 252px;">
								<a href="./postDetail?postId=${likeItem.postId}">
									<figure class="recipeFigure">
										<c:set var="imgNewName" value="${likeItem.imgNewName}" />
										<c:if test="${imgNewName eq null }">
											<img class="img" src="./defaultThum.png"
												style="height: 100px; width: 180px; margin: 10px;"
												onclick="location.href='./postDetail?postId=${likeItem.postId}'" />
										</c:if>
										<c:if test="${imgNewName ne null}">
											<img class="img" src="/photo/${likeItem.imgNewName}"
												style="height: 100px; width: 180px; margin: 10px;"
												onclick="location.href='./postDetail?postId=${likeItem.postId}'" />
										</c:if>
										<figcaption>
											<div style="margin: 0 5px 5px 5px;">
												<div>
													<div style="font-size: 0.5em; float: left; width: 30px;">
														좋아요<br />${likeItem.like}</div>
													<div
														style="float: left; width: 122px; margin: 0 4px 0 4px;">
														<small>${likeItem.title}</small>
													</div>
													<div style="font-size: 0.5em; float: left; width: 30px;">
														조회수<br />${likeItem.hits}</div>
												</div>
												<div>
													<div>
														<div style="text-align: left;">
															<small>${likeItem.item}</small>
														</div>
														<div style="text-align: left;">
															<small>${likeItem.recipePrice}\</small>
														</div>
														<div style="text-align: right;">
															<small>${likeItem.nickName}</small>
														</div>
													</div>


												</div>
											</div>
										</figcaption>

									</figure>
								</a>
							</div>
						</c:forEach>
					</div>

					<button style="margin-bottom: 10px;"
						onclick="location.href='./myLike'">좋아요한 레시피 더보기</button>
				</div>

				<div style='margin:10px'>&nbsp;</div>
				<div id="myRecipe">
					<h4>♥ 내 레시피</h4>
					<div class="recipeContainer">
						<c:if test="${myPage_Post eq '[]'}">
							<div style='height:100px'>작성한 레시피가 없습니다.</div>
						</c:if>
						<c:forEach items='${myPage_Post}' var='postItem'>
							<div style="width: 280px; height: 252px;">
								<a href="./postDetail?postId=${postItem.postId}">
									<figure class="recipeFigure">
										<c:set var="imgNewName" value="${postItem.imgNewName}" />
										<c:if test="${imgNewName eq null }">
											<img class="img" src="./defaultThum.png"
												style="height: 100px; width: 180px; margin: 10px;"
												onclick="location.href='./postDetail?postId=${postItem.postId}'" />
										</c:if>
										<c:if test="${imgNewName ne null }">
											<img class="img" src="/photo/${postItem.imgNewName}"
												style="height: 100px; width: 180px; margin: 10px;"
												onclick="location.href='./postDetail?postId=${postItem.postId}'" />
										</c:if>
										<figcaption>
											<div style="margin: 0 5px 5px 5px;">
												<div>
													<div style="font-size: 0.5em; float: left; width: 30px;">
														좋아요<br />${postItem.like}</div>
													<div
														style="float: left; width: 122px; margin: 0 4px 0 4px;">
														<small>${postItem.title}</small>
													</div>
													<div style="font-size: 0.5em; float: left; width: 30px;">
														조회수<br />${postItem.hits}</div>
												</div>
												<div>
													<div>
														<div style="text-align: left;">
															<small>${postItem.item}</small>
														</div>
														<div style="text-align: left;">
															<small>${postItem.recipePrice}\</small>
														</div>
														<div style="text-align: right;">
															<small>${postItem.nickName}</small>
														</div>
													</div>


												</div>
											</div>
										</figcaption>

									</figure>
								</a>
							</div>
						</c:forEach>
					</div>
					<button style="margin-bottom: 10px;" onclick="location.href='./myWrite'">내가 작성한 레시피 더보기</button>
				</div>

				<div style='margin:10px'>&nbsp;</div>
				<div id="myComment">
					<h4>♥ 내가 쓴 댓글</h4>
					<table id="commentTable">
						<tr>
							<th>레시피제목</th>
							<th style="width:600px;">댓글내용</th>
							<th>작성날짜</th>
						</tr>
						<c:if test="${myPage_Comment eq '[]'}">
							<tr>
								<td colspan='7'><br>작성한 댓글이 없습니다.<br>&nbsp;</td>
							</tr>
						</c:if>
						<c:forEach items='${myPage_Comment}' var='commentItem'>
							<tr>
								<td><a href='./postDetail?postId=${commentItem.postId}'>${commentItem.title}</a></td>
								<td><a href='./postDetail?postId=${commentItem.postId}'>${commentItem.comment_content}</a></td>
								<td>${commentItem.comment_date}</td>
							</tr>
						</c:forEach>
					</table>
					<button style="margin-bottom: 10px;"
						onclick="location.href='./myComment'">내가 작성한 댓글 더보기</button>
				</div>

				<div style='margin:10px'>&nbsp;</div>
				<!-- <button style="margin-top: 10px;" id='delAccount' onclick="location.href='./userDel'">회원 탈퇴</button> -->
				<input type="button" value="회원 탈퇴" style="margin-top: 10px;" id='delAccount' onclick="popUp();" />
			</div>
		</main>
		<footer>
			<%@include file="footer.jsp"%>
		</footer>
	</div>
</body>
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