<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>
<body>
	 <h3>관리자 페이지</h3>
            <button onclick="location.href='./memberList.jsp'">회원 조회</button>
            <button onclick="location.href='./report/reportList.jsp'">신고 관리</button>
            <button onclick="location.href='./blindList.jsp'">블라인드 관리</button>
            <button onclick="location.href='./susMemberList.jsp'">정지 관리</button>
             <button onclick="location.href='./adminList.jsp'">관리자 관리</button>
            <button onclick="location.href='./adminProductList'">상품 관리</button>
</body>
</html>