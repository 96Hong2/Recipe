<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<h2>회원정보 보기</h2>
	<button onclick = "location.href = './myPage'">MY PAGE로 돌아가기</button>
	<table>
		<tr>
			<td>항목</td>
			<td>값</td>
		</tr>
		<tr>
			<td>아이디(ID)</td>
			<td>${member.userId}</td>
		</tr>
		<tr>
			<td>비밀번호(PW)</td>
			<td>${member.pw}</td>
		</tr>
		<tr>
			<td>이름(NAME)</td>
			<td>${member.name}</td>
		</tr>
		<tr>
			<td>닉네임(NICKNAME)</td>
			<td>${member.nickName}</td>
		</tr>
		<tr>
			<td>연락처(TEL)</td>
			<td>${member.tel}</td>
		</tr>
		<tr>
			<td>주소(ADDRESS)</td>
			<td>${member.address}</td>
		</tr>
		<tr>
			<td>등급(RANK)</td>
			<td>${member.rankId}</td>
		</tr>
		<tr>
			<td>블라인드(BLIND)</td>
			<td>${member.blindCount}</td>
		</tr>
		<tr>
			<td>가입날짜(REGDATE)</td>
			<td>${member.regDate}</td>
		</tr>
		
		<tr>
			<td colspan = "2">
				<button onclick= "location.href= './updateForm?userId=${member.userId}'">수정하기</button>
			</td>
		</tr>
	</table>
</body>
<script>
   var msg = "${msg}";
   if(msg != ""){
   alert(msg);
   }
</script>
</html>