<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrap">
				<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>
		<main id="body">
			<div style="margin: auto; width: 740px;">
				<button onclick="location.href='postWriteForm.jsp'">레시피작성</button>
				<form action="category" id="frm" method="get">
					<div>
						<input type="radio" id="all" name="categoryId" value="0"
							onclick="location.href='./postList'"
							<c:if test="${categoryId == 0}" >checked="checked"</c:if> />전체
						&nbsp; <input type="radio" id="chinaFood" name="categoryId"
							value="2" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 2}" >checked="checked"</c:if> />한식
						&nbsp; <input type="radio" id="koreanFood" name="categoryId"
							value="3" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 3}" >checked="checked"</c:if> />중식
						&nbsp; <input type="radio" id="japaneseFood" name="categoryId"
							value="4" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 4}" >checked="checked"</c:if> />일식
						&nbsp; <input type="radio" id="westernFood" name="categoryId"
							value="5" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 5}" >checked="checked"</c:if> />양식
						&nbsp; <input type="radio" id="snackFood" name="categoryId"
							value="6" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 6}" >checked="checked"</c:if> />분식
						&nbsp; <input type="radio" id="vegetarian" name="categoryId"
							value="7" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 7}" >checked="checked"</c:if> />채식
						&nbsp; <input type="radio" id="babyFood" name="categoryId"
							value="8" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 8}" >checked="checked"</c:if> />이유식
						&nbsp; <input type="radio" id="dessert" name="categoryId"
							value="9" onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 9}" >checked="checked"</c:if> />디저트
						&nbsp; <input type="radio" id="etc" name="categoryId" value="1"
							onclick="document.getElementById('frm').submit();"
							<c:if test="${categoryId == 1}" >checked="checked"</c:if> />기타
					</div>
				</form>
				
				<form action="postSearch" method="get" id="postSearch" name="postSearch">
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
						<input type="number" id="recipePriceSearchMax" name="keywordMax" placeholder="최대 예산" />￦
					</span> 
					<span hidden="hidden" id="option3">
						<input type="text" id="nickNameSearch" name="keywordNickName" placeholder="닉네임 입력" />
					</span>
					<span hidden="hidden" id="option4"><input type="text"
						id="itemSearch" name="keywordItem" placeholder="재료 입력" /></span>
					<input type="hidden" name="categoryId" value="${categoryId }" />
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
														style="font-weight: bold; float: left;  width: 122px; margin: 0 4px 0 4px; text-align: left;">
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
				
			<c:choose>
				<c:when test="${totalPage < end}">	
					<c:forEach var="i" begin="${start }" end="${totalPage}" step="1">
						<span class="postPage"> 
							<c:if test="${i ne currPage && postList.equals(postList)}"><a href="./postList?postPage=${i}">${i}</a></c:if> 
							<c:if test="${i ne currPage && categoryPage.equals(categoryPage)}"><a href="./category?categoryId=${list[0].categoryId}&postPage=${i}">${i}</a></c:if>
							<c:if test="${i ne currPage && searchPage.equals(searchPage)}"><a href="./postSearch?postSearchOpt=${postSearchOpt}&keyword=${keyword }&keywordMin=${keywordMin }&keywordMax=${keywordMax }&keywordNickName=${keywordNickName }&keywordItem=${keywordItem }&categoryId=${categoryId }&postPage=${i}">${i}</a></c:if>
							<c:if test="${i eq currPage }"><b>${i}</b></c:if>               
						</span>
					</c:forEach>
				</c:when>
					
				<c:otherwise>
					<c:forEach var="i" begin="${start }" end="${end}" step="1">
						<span class="postPage"> 
							<c:if test="${i ne currPage && postList.equals(postList)}"><a href="./postList?postPage=${i}">${i}</a></c:if> 
							<c:if test="${i ne currPage && categoryPage.equals(categoryPage)}"><a href="./category?categoryId=${list[0].categoryId}&postPage=${i}">${i}</a></c:if>
							<c:if test="${i ne currPage && searchPage.equals(searchPage)}"><a href="./postSearch?postSearchOpt=${postSearchOpt}&keyword=${keyword }&keywordMin=${keywordMin }&keywordMax=${keywordMax }&keywordNickName=${keywordNickName }&keywordItem=${keywordItem }&categoryId=${categoryId }&postPage=${i}">${i}</a></c:if>
							<c:if test="${i eq currPage }"><b>${i}</b></c:if>               
						</span>
					</c:forEach>
				</c:otherwise>	
			</c:choose>
					
				<c:if test="${i ne currPage && postList.equals(postList)}"><button type="button" onclick="location.href='./postList?postPage=${end}&button=2'">다음</button></c:if> 
				<c:if test="${i ne currPage && categoryPage.equals(categoryPage)}"><button type="button" onclick="location.href='./category?categoryId=${list[0].categoryId}&postPage=${end}&button=2'">다음</button></c:if> 
				<c:if test="${i ne currPage && searchPage.equals(searchPage)}"><button type="button" onclick="location.href='./postSearch?postSearchOpt=${postSearchOpt}&keyword=${keyword}&keywordMin=${keywordMin}&keywordMax=${keywordMax}&categoryId=${categoryId}&postPage=${end}&button=2'">다음</button></c:if> 
			</div>
	
	</main>
	<footer>
			<%@include file="footer.jsp"%>
		</footer>
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
				 document.getElementById("recipePriceSearch").value ='';
				 document.getElementById("recipePriceSearchMax").value ='';
				 document.getElementById("nickNameSearch").value ='';
				 document.getElementById("itemSearch").value ='';
			} else if ($("#postSearchOpt").val() == "recipePriceSearch") {
				$("#option2").show();
				$("#option1").hide();
				$("#option3").hide();
				$("#option4").hide();
				 document.getElementById("title_contentsSearch").value ='';
				 document.getElementById("nickNameSearch").value ='';
				 document.getElementById("itemSearch").value ='';
			} else if ($("#postSearchOpt").val() == "nickNameSearch") {
				$("#option3").show();
				$("#option1").hide();
				$("#option2").hide();
				$("#option4").hide();
				 document.getElementById("recipePriceSearch").value ='';
			 	 document.getElementById("title_contentsSearch").value ='';
				 document.getElementById("itemSearch").value ='';
				 document.getElementById("recipePriceSearchMax").value ='';
			} else if ($("#postSearchOpt").val() == "itemSearch") {
				$("#option4").show();
				$("#option1").hide();
				$("#option2").hide();
				$("#option3").hide();
				 document.getElementById("recipePriceSearch").value ='';
				 document.getElementById("nickNameSearch").value ='';
				 document.getElementById("title_contentsSearch").value ='';
				 document.getElementById("recipePriceSearchMax").value ='';
			}

		});

	});
	

</script>
</html>