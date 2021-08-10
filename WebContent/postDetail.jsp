<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>레시피 게시글 상세보기</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
#board, #board th, #board td {
	border: 1px solid;
	border-collapse: collapse;
	padding: 5px 10px;
}

#board td {
	text-align: center;
}

.container {
	margin-left: 20%;
	background-color: ligthgrey;
}

.tableArea {
	display: inline-block;
	width: 70%;
	left: 50%;
}

#slideBarParent {
	width: 160px;
	height: 460px;
	background-color: grey;
	display: inline-block;
	position: fixed;
	margin-left: 50px;
	
}

#slideBar{
	width: 160px;
	height: 390px;
	background-color: grey;
	/* overflow: hidden;  */
	margin-top: 10px;
}

.cont {
	width: 140px;
	height: 120px;
	background-color: white;
	margin-left: 10px;
	margin-top: 7px;
}

.commentArea {
	display: inline-block;
	margin-left: 18%;
	width: 60%;
}

.itemFigure {
	text-align: center;
	font-size: x-small;
	width: 138px;
	height: 118px;
	background-color: #D5D5D5;
	border-radius: 10px;
	margin-left: 10px;
}

.image_item {
	margin-top: 1px;
	width: 110px;
	height: 80px;
}

.itemNoDiv {
	font-size: x-small;
	color: white;
}

.addBtn{
	background-color: white;
	width: 57px;
	height: 20px;
	font-size: xx-small;
}

.btn_wrap{
	clear: both;
	text-align: center;
}

.btn_wrap a{
	font-weight: bolder;
	font-size: 25px;
	text-decoration: none;
	color: white;
}
</style>
</head>
<script>
	if ("${sessionScope.userId}" == "") {
		location.href = "./postList";
		alert("로그인이 필요한 서비스입니다.");
	}
</script>
<body>

	<div class="container">
		<h2>게시글 상세보기</h2>
		<div class="tableArea">
			<table id="board">
				<tr>
					<th>글번호</th>
					<td>${post.postId}</td>
					<th>작성자</th>
					<td>${post.nickName}</td>
					<th>등급</th>
					<td>${post.rankName}</td>
					<th>제목</th>
					<td>${post.title}</td>
					<th>작성날짜</th>
					<td>${post.postDate}</td>
					<th>좋아요</th>
					<td>${post.likes}</td>
					<th>조회수</th>
					<td>${post.hits}</td>
				</tr>
				<tr>
					<th>카테고리</th>
					<td>${post.categoryName}</td>
					<th>예상금액</th>
					<td>${post.recipePrice}￦</td>
					<th>재료</th>
					<td colspan="9">${post.item}</td>
				</tr>
				<tr>
					<th>첨부 이미지</th>
					<td colspan="14"><c:if test="${post.imgNewName ne null }">
							<img src="/photo/${post.imgNewName}" width="500px" height="500px" />
						</c:if></td>
				</tr>
				<tr>
					<th>Recipe</th>
					<td colspan="14">${post.contents}</td>
				</tr>
				<tr>
					<td colspan="14">
						<c:if test="${sessionScope.userId ne null && sessionScope.userId ne post.userId}"><button onclick="reportPopUp(${post.postId},'${post.nickName}')">신고</button></c:if> 
						<c:if test="${sessionScope.isAdmin eq 'Y' || sessionScope.userId eq admin}"><button onclick="blindPopUp(${post.postId},'${post.nickName}')">블라인드</button></c:if> 
						<c:if test="${sessionScope.userId eq post.userId}"><button onclick="location.href='./postUpdateForm?postId=${post.postId}'">수정</button></c:if> 
						<c:if test="${sessionScope.userId eq post.userId}"><input type="button" value="삭제" onclick="button_evert()"/></c:if>
						<button onclick="location.href='./category?categoryId=${post.categoryId }'">리스트</button>
						<button onclick="location.href='./postList'">전체 목록</button>
						<button type="button" onclick="postLike();"><img id="likeImg" class="img" src="./likeButton.png"></button>
					</td>
				</tr>
			</table>
		</div>
		<div id="slideBarParent">
			<div id="slideBar">
			<!-- 아이템리스트 -->
			</div>
			<p class='btn_wrap'>
				<a href='#' id='before_btn'>&lt;</a> <a href='#' id='next_btn'>&gt;</a>
			</p>
		</div>
	</div>

	<!-- 댓글창 -->
	<div class="commentArea">
		<c:import url="./postComment.jsp" charEncoding="utf-8">
			<c:param name="postId" value="${post.postId}" />
		</c:import>
	</div>

</body>
<script>
	itemCall("${post.item}", "${post.postId}");

	function itemCall(item, postId) {
		console.log("item / postId : " + item + "/" + postId);
		if (item != "") {
			$.ajax({
				type : 'get',
				url : './itemListCall',
				data : {
					"item" : item,
					"postId" : postId
				},
				dataType : 'JSON',
				success : function(data) {
					drawItemList(data.list);
				},
				error : function(e) {
					console.log(e);
				}
			});
		}
	}

	function cartAdd(productId, productName, price) {
		console.log(productId + "/" + productName + "/" + price);
		if (confirm("해당 상품을 장바구니에 담으시겠습니까?")) {
			console.log("장바구니에 담기 함수 실행");
			$.ajax({
				type : 'get',
				url : 'cartAdd',
				data : {
					"pId" : productId,
					"pName" : productName,
					"pPrice" : price,
					"pCnt" : 1,
					"tPrice" : price
				},
				dataType : 'JSON',
				success : function(data) {
					alert("장바구니에 담겼습니다!");
				},
				error : function(e) {
					console.log(e);
				}
			});
		}
	}

	function drawItemList(list) {
		console.log("상품리스트 출력");
		var content = "";
		var btnArea = "";

		if (list.length == 0) {
			console.log("상품 없음");
			//content += "<div class='itemNoDiv'>";
			//content += "검색된 상품이 없습니다.";
			//content += "</div>";

		} else {
			list.forEach(function(item, idx) {
						console.log("상품있음");
						console.log("리스트 뿌리기" + idx, item);

						//content += "<div class='cont' id='cont"+idx+"'>";
						content += "<figure class='itemFigure' id='fig_"+idx+"'>";
						content += "<a href='./shopDetail?productId="+item.productId+ "'><img class='image_item' src='/photo/"+item.imgNewName+"'></a>";
						content += "<figcaption>" + item.productName + "<br/>"+ item.price +"원";
						content += '<button class="addBtn" onclick="cartAdd(\''+item.productId+'\', \''+ item.productName+ '\', '+item.price+')">장바구니</button>';
						content +=  "</figcaption>";
						content += "</figure>";
						//content += "</div>";
					});
		}
		$("#slideBar").append(content);
		
	}

	function button_evert() {
		var result = confirm("정말 삭제하시겠습니까?");
		if (result) {
			location.href = './postDel?postId=${post.postId}';
		} else {
			return;
		}
	}

	function reportPopUp(postId, nickName) {
		var url = "./memberReport?classification=P&&postId=" + postId
				+ "&&nickName=" + nickName;
		var option = "width=650, height=500, top=500, location = no, resizable = no";
		window.open(url, "reportPopUp", option);

	}
	function blindPopUp(postId, nickName) {
		var url = "./memberBlind?classification=P&&postId=" + postId
				+ "&&nickName=" + nickName;
		var option = "width=650, height=500, top=500, location = no, resizable = no";
		window.open(url, "blindPopUp", option);
	}
	function reloadPage() {
		console.log("새로고침");
		location.reload();
	}
	
	$(document).ready(function(){
		postLikeCheck();
	});	
	
	function postLike(){
		console.log("좋아요");
		console.log("${param.postId}");
		console.log("${sessionScope.userId}");
		
		 $.ajax({
			type : "post",
			url : "./postLike",
			data : {
				postId : "${param.postId}"
			},
			dataType : 'JSON',
			success : function(data){
				console.log(data.success);
				if(data.success){ 
					document.getElementById("likeImg").src = './likeOnClick.png'
				}
			}	
		})

			
	} 
		
	function postLikeCheck(){
		console.log("좋아요");
		console.log("${param.postId}");
		console.log("${sessionScope.userId}");
		
		 $.ajax({
			type : "post",
			url : "./postLikeCheck",
			data : {
				postId : "${param.postId}"
			},
			dataType : 'JSON',
			success : function(data){
				console.log(data.success);
				if(data.success){
					document.getElementById("likeImg").src = './likeOnClick.png'
					$("#likeImg").removeAttr("onclick");
				}
			}	
			})	
		} 
	
</script>
</html>