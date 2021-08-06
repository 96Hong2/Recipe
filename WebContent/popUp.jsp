<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function userDel(){
		window.opener.location.href='./userDel';
		window.close();
	}
</script>
</head>
<body>
<h3>알다시피 회원 탈퇴</h3>
<p>회원 탈퇴 시 보유 캐시와 명예 점수가 모두 사라지며,</p>
<p>알다시피의 모든 서비스를 이용하실 수 없습니다.</p>
<p>정말 탈퇴하시겠습니까?</p>
<button onclick="userDel()">탈퇴 하기</button>
<button onclick="window.close()">취소</button>
</body>
</html>