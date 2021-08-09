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
						<input type="radio" id="all" name="categoryId" value="0"
							onclick="location.href='./postList'"
							<c:if test="${all != null || list[0].categoryId == null ||all.equals(all) }">checked="checked"</c:if> />전체
						&nbsp; <input type="radio" id="chinaFood" name="categoryId"
							value="2" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 2 && category.equals(category) && notAll.equals(notAll)}">checked="checked"</c:if> />한식
						&nbsp; <input type="radio" id="koreanFood" name="categoryId"
							value="3" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 3 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />중식
						&nbsp; <input type="radio" id="japaneseFood" name="categoryId"
							value="4" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 4 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />일식
						&nbsp; <input type="radio" id="westernFood" name="categoryId"
							value="5" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 5 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />양식
						&nbsp; <input type="radio" id="snackFood" name="categoryId"
							value="6" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 6 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />분식
						&nbsp; <input type="radio" id="vegetarian" name="categoryId"
							value="7" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 7 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />채식
						&nbsp; <input type="radio" id="babyFood" name="categoryId"
							value="8" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 8 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />이유식
						&nbsp; <input type="radio" id="dessert" name="categoryId"
							value="9" onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 9 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />디저트
						&nbsp; <input type="radio" id="etc" name="categoryId" value="1"
							onclick="document.getElementById('frm').submit();"
							<c:if test="${list[0].categoryId == 1 && category.equals(category)&& notAll.equals(notAll)}">checked="checked"</c:if> />기타
					</div>
				</form>


				<form action="postSearch" method="get" id="postSearch">
					<select name="postSearchOpt" id="postSearchOpt">
						<option value='title_contentsSearch' selected="selected">제목 + 내용</option>
						<option value='recipePriceSearch'>예산</option>
						<option value='nickNameSearch'>닉네임</option>
						<option value='itemSearch'>재료</option>
					</select> 
					<span id="option1">
						<input type="text" id="title_contentsSearch" name="keyword" placeholder="제목 + 내용 입력" />
					</span>
					<span hidden="hidden" id="option2">
						<input type="number" id="recipePriceSearch" name="keywordMin" placeholder="최소 예산" /> ~
						<input type="number" name="keywordMax" placeholder="최대 예산" />￦
					</span> 
					<span hidden="hidden" id="option3">
						<input type="text" id="nickNameSearch" name="keywordNickName" placeholder="닉네임 입력" />
					</span>
					<span hidden="hidden" id="option4"><input type="text"
						id="itemSearch" name="keywordItem" placeholder="재료 입력" /></span>
					<c:if test="${category.equals(category) && total != 0 && notAll.equals(notAll)}">
						<input type="hidden" name="categoryId" value="${list[0].categoryId}" />
					</c:if>
					<c:if test="${all.equals(all) || total == 0}">
						<input type="hidden" name="categoryId" value="0" />
					</c:if>
					<button>검색</button>
				</form>
			</div>
			<div class="recipeContainer">
				<c:choose>
					<c:when test="${list[0].postId ne null}">
						<c:forEach items="${list}" var="post">
							<div style="width: 280px; height: 252px;">
								<a href="postDetail?postId=${post.postId}">
									<figure class="recipeFigure">
										<c:set var="imgNewName" value="${post.imgNewName}" />
										<c:if test="${imgNewName eq null }">
											<img class="img" src="./defaultThum.png"
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
													<div style="font-size: 0.5em; float: left; width: 30px;">
														좋아요<br />${post.likes}</div>
													<div
														style="float: left; width: 122px; margin: 0 4px 0 4px;">
														<small>${post.title}</small>
													</div>
													<div style="font-size: 0.5em; float: left; width: 30px;">
														조회수<br />${post.hits}</div>
												</div>
												<div>
													<div>
														<div style="text-align: left;">
															<small>${post.item}</small>
														</div>
														<div style="text-align: left;">
															<small>${post.recipePrice}\</small>
														</div>
														<div style="text-align: right;">
															<small>${post.nickName}</small>
														</div>
													</div>


												</div>
											</div>
										</figcaption>

									</figure>
								</a>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div>검색된 결과가 없습니다.</div>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="pageArea" style="width:740px; margin:auto; text-align:center;">
				<c:if test="${i ne currPage && postList.equals(postList)}"><button type="button" onclick="location.href='./postList?postPage=${start}&button=1'">이전</button></c:if>
				<c:if test="${i ne currPage && categoryPage.equals(categoryPage)}"><button type="button" onclick="location.href='./category?categoryId=${list[0].categoryId}&postPage=${start}&button=1'">이전</button></c:if>
				<c:if test="${i ne currPage && searchPage.equals(searchPage)}"><button type="button" onclick="location.href='./postSearch?postSearchOpt=${postSearchOpt}&keyword=${keyword}&keywordMin=${keywordMin}&keywordMax=${keywordMax}&categoryId=${categoryId}&postPage=${start}&button=1'">이전</button></c:if>
			<c:forEach var="i" begin="${start }" end="${end}" step="1">
			<span class="postPage"> 
				<c:if test="${i ne currPage && postList.equals(postList)}"><a href="./postList?postPage=${i}">${i}</a></c:if> 
				<c:if test="${i ne currPage && categoryPage.equals(categoryPage)}"><a href="./category?categoryId=${list[0].categoryId}&postPage=${i}">${i}</a></c:if>
				<c:if test="${i ne currPage && searchPage.equals(searchPage)}"><a href="./postSearch?postSearchOpt=${postSearchOpt}&keyword=${keyword}&keywordMin=${keywordMin}&keywordMax=${keywordMax}&keywordNickName=${keywordNickName}&keywordItem=${keywordItem}categoryId=${categoryId}&postPage=${i}">${i}</a></c:if>
				<c:if test="${i eq currPage }"><b>${i}</b></c:if>
			</span>
				</c:forEach>
				<c:if test="${i ne currPage && postList.equals(postList)}"><button type="button" onclick="location.href='./postList?postPage=${end}&button=2'">다음</button></c:if> 
				<c:if test="${i ne currPage && categoryPage.equals(categoryPage)}"><button type="button" onclick="location.href='./category?categoryId=${list[0].categoryId}&postPage=${end}&button=2'">다음</button></c:if> 
				<c:if test="${i ne currPage && searchPage.equals(searchPage)}"><button type="button" onclick="location.href='./postSearch?postSearchOpt=${postSearchOpt}&keyword=${keyword}&keywordMin=${keywordMin}&keywordMax=${keywordMax}&categoryId=${categoryId}&postPage=${end}&button=2'">다음</button></c:if> 
			</div>
	
	</main>
	<footer></footer>
	</div>
</body>
<script>
	$(document).ready(function() {
		$(document).on('change', function() {
			if ($("#postSearchOpt").val() == "title_contentsSearch") {
				$("#option1").show();
				$("#option2").hide();
				$("#option3").hide();
				$("#option4").hide();
				$("#recipePriceSearch").claer();
				$("#nickNameSearch").claer();
				$("#itemSearch").claer();
			} else if ($("#postSearchOpt").val() == "recipePriceSearch") {
				$("#option2").show();
				$("#option1").hide();
				$("#option3").hide();
				$("#option4").hide();
				$("#title_contentsSearch").clear();
				$("#nickNameSearch").clear();
				$("#itemSearch").clear();
			} else if ($("#postSearchOpt").val() == "nickNameSearch") {
				$("#option3").show();
				$("#option1").hide();
				$("#option2").hide();
				$("#option4").hide();
				$("#title_contentsSearch").clear();
				$("#recipePriceSearch").clear();
				$("#itemSearch").clear();
			} else if ($("#postSearchOpt").val() == "itemSearch") {
				$("#option4").show();
				$("#option1").hide();
				$("#option2").hide();
				$("#option3").hide();
				$("#title_contentsSearch").clear();
				$("#recipePriceSearch").clear();
				$("#nickNameSearch").clear();
			}

		});

	});
</script>
</html>