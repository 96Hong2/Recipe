<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.userId}"==""){
   alert("로그인이 필요한 서비스입니다.");
   location.href = "./";
}
</script>
</head>
<body>
	<header>
		<%@include file="header_afterLogin.jsp"%>
	</header>
	<div class ="wrap">
	<div>
	<h2>${sessionScope.nickName} 님의회원정보 보기</h2>
	</div>
	<div>
	<!-- <button onclick = "location.href = './myPage'">MY PAGE로 돌아가기</button> -->
	<a href='./myPage' id='backToMyPage'><h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MY PAGE로 돌아가기</h4></a>
	</div>
	<div>
	<table border = "1px solid black">
		<tr style = "height : 40px;">
			<td style = "width : 200px" >항목</td>
			<td style = "width : 200px" >값</td>
		</tr>
		<tr style = "height : 40px;">
			<td style = "width : 200px" >아이디(ID)</td>
			<td style = "width : 200px" >${member.userId}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>이름(NAME)</td>
			<td>${member.name}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>닉네임(NICKNAME)</td>
			<td>${member.nickName}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>연락처(TEL)</td>
			<td>${member.tel}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>주소(ADDRESS)</td>
			<td>${member.address}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>등급(RANK)</td>
			<td>${member.rankName}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>블라인드횟수(BLINDCount)</td>
			<td>${member.blindCount}</td>
		</tr>
		<tr style = "height : 40px;">
			<td>가입날짜(REGDATE)</td>
			<td>${member.regDate}</td>
		</tr>
		
		<tr>
			<td colspan = "2">
				<button onclick= "location.href= './updateForm?userId=${member.userId}'">수정하기</button>
			</td>
		</tr>
	</table>
	</div>
	</div>
</body>
<script>
   var msg = "${msg}";
   if(msg != ""){
   alert(msg);
   }
</script>
</html>