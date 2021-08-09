<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
</head>
<body>
	<div class="wrap">
		<header>
			<div id="header">

				<a href="./"> <img src="logo.png" alt="로고" width="150px"
					height="50px" /></a>

				<div id="top_menu">
					<ul>
						<li><a href="./login.jsp">로그인</a></li>
						<li><a href="./logout">로그아웃</a></li>
						<li><a href="./cart.jsp">장바구니</a></li>
						<li><a href="./myPage">마이페이지</a></li>
					</ul>
				</div>

			</div>

			<div class="search">
				<form action="#" method="get" id="search">
					<input type="text" id="keyword" placeholder="검색어입력" />
					<button>검색</button>
				</form>
			</div>

			<div id="menu">
				<ul>
					<li><a href="#">알다시피란?</a></li>
					<li><a href="#">베스트레시피</a></li>
					<li><a href="#">레시피게시판</a></li>
					<li><a href="./shop">쇼핑몰</a></li>
				</ul>
			</div>
		</header>
		<main id="body">
			<div style="margin: auto; width: 740px;">
				<button onclick="location.href='postWriteForm.jsp'">레시피작성</button>
				<form action="category" id="frm" method="get">
					<div>
						<%-- <c:if test="${list[0].categoryId != null}">checked="checked"</c:if> --%>
						<input type="radio" id="all" name="categoryId" value=""
							onclick="location.href='./postList'" checked="checked" />전체
						&nbsp; <input type="radio" id="chinaFood" name="categoryId"
							value="2" onclick="document.getElementById('frm').submit();" />한식
						&nbsp; <input type="radio" id="koreanFood" name="categoryId"
							value="3" onclick="document.getElementById('frm').submit();" />중식
						&nbsp; <input type="radio" id="japaneseFood" name="categoryId"
							value="4" onclick="document.getElementById('frm').submit();" />일식
						&nbsp; <input type="radio" id="westernFood" name="categoryId"
							value="5" onclick="document.getElementById('frm').submit();" />양식
						&nbsp; <input type="radio" id="snackFood" name="categoryId"
							value="6" onclick="document.getElementById('frm').submit();" />분식
						&nbsp; <input type="radio" id="vegetarian" name="categoryId"
							value="7" onclick="document.getElementById('frm').submit();" />채식
						&nbsp; <input type="radio" id="babyFood" name="categoryId"
							value="8" onclick="document.getElementById('frm').submit();" />이유식
						&nbsp; <input type="radio" id="dessert" name="categoryId"
							value="9" onclick="document.getElementById('frm').submit();" />디저트
						&nbsp; <input type="radio" id="etc" name="categoryId" value="1"
							onclick="document.getElementById('frm').submit();" />기타
					</div>
				</form>

				<form action="postSearch" method="get" id="postSearch">
					<select name="postSearchOpt" id="postSearchOpt">
						<option value='title_contentsSearch' selected="selected">제목
							+ 내용</option>
						<option value='recipePriceSearch'>예산</option>
					</select> <span id="option1"><input type="text"
						id="title_contentsSearch" name="keyword" placeholder="검색어입력" /></span> <span
						hidden="hidden" id="option2"><input type="number"
						id="recipePriceSearch" name="keywordMin" placeholder="최소 예산" /> ~
						<input type="number" name="keywordMax" placeholder="최대 예산" />￦</span>
					<button>검색</button>
				</form>
			</div>

			<div class="recipeContainer">
				<c:if test="${list eq null || list eq '' || list eq '[]'}">
					게시글이 없습니다.
				</c:if>
				<c:forEach items="${list}" var="post">
					<div style="width: 280px; height: 232px;">
						<a href="postDetail?postId=${post.postId}">
							<figure class="recipeFigure">
								<c:if test="${imgNewName eq null }">
									<img class="img" src="img/defaultThum.png"
										style="height: 100px; width: 180px; margin: 10px;"
										onclick="location.href='postDetail?postId=${post.postId}'" />
								</c:if>
								<c:if test="${imgNewName ne null }">
									<img class="img" src="/photo/${post.imgNewName}"
										style="height: 100px; width: 180px; margin: 10px;"
										onclick="location.href='postDetail?postId=${post.postId}'" />


								</c:if>
								<figcaption>
									<div style="margin: 0 5px 5px 5px;">
										<div>
											<div style="font-size: 0.5em; float:left; width:30px;">좋아요<br/>${post.likes}</div>
											<div style="float:left; width:122px; margin:0 4px 0 4px;"><small>${post.title}</small></div>
											<div style="font-size: 0.5em; float:left; width:30px;">조회수<br/>${post.hits}</div>
										</div>
										<div>
											<div>
												<div style="text-align:left;">
													<small>${post.item}</small>
												</div>
												<div style="text-align:left;">
													<small>${post.recipePrice}\</small>
												</div>
												<div style="text-align:right;"><small>${post.nickName}</small></div>
											</div>


										</div>
									</div>
								</figcaption>

							</figure>
						</a>
					</div>

				</c:forEach>


			</div>
			<div class="pageArea" style="text-align:center; margin: auto;">
				<c:forEach var="i" begin="1" end="${totalPage}" step="1">
					<span class="postPage"> <c:if test="${i ne currPage}">
							<a href="./postList?postPage=${i}">${i}</a>
						</c:if> <c:if test="${i eq currPage}">
							<b>${i}</b>
						</c:if>
					</span>
				</c:forEach>
			</div>
		</main>
		<footer></footer>
	</div>
</body>
<script>
	//$('[name=categoryId]:radio[value="'+'${list[0].categoryId}'+'"]').prop('checked', true );
	/* $(document).ready(function(){
	 $("input:radio[id=koreanFood]").click(function(){
	 $('[name=categoryId]:radio[value="'+'${list[0].categoryId}'+'"]').prop('checked', true );
	 })
	 });  */

	$(document).ready(function() {
		$(document).on('change', function() {
			if ($("#postSearchOpt").val() == "title_contentsSearch") {
				$("#option1").show();
				$("#option2").hide();
				$("#recipePriceSearch").empty();
			} else if ($("#postSearchOpt").val() == "recipePriceSearch") {
				$("#option2").show();
				$("#option1").hide();
				$("#title_contentsSearch").empty();
			}
		});

	});
</script>
</html>