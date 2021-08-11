<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지 - 관리자 정보</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="css/common.css" type="text/css">
<script>
if("${sessionScope.isAdmin}"!="Y" && "${sessionScope.userId}"!="admin"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
</head>
<body>
<h2>관리자 ${member.nickname} 님의 회원정보 보기</h2>
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
			<td>${member.nickname}</td>
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
			<td colspan = "2">
				<button onclick= "location.href='./adminList.jsp'">돌아가기</button>
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