<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="css/common.css" type="text/css">
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
<style>
h1{ text-align:center;}
.button {
  background-color: gray;
  border: none;
  color: white;
  padding: 15px 30px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 25px;
  margin: 4px 2px;
  cursor: pointer;
  width: 250px;
  height: 170px;
}
.wrapper{
position: relative;
  left:7%;
  top:10%;
  text-align:center;
}
</style>
</head>
<body>
<div class="wrap">
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>
	 <h1>관리자 페이지</h1>
	 <div class="wrapper">
	 <table>
<tr>
	 <td>
            <button class="button" onclick="location.href='./memberList.jsp'">회원 조회</button>
            <button class="button" onclick="location.href='./report/reportList.jsp'">신고 관리</button>
            <button class="button" onclick="location.href='./blindList.jsp'">블라인드 관리</button>
     </td>
</tr>
<tr>
     <td>
            <button class="button" onclick="location.href='./susMemberList.jsp'">정지 관리</button>
            <button class="button" onclick="location.href='./adminList.jsp'">관리자 관리</button>
            <button class="button" onclick="location.href='./adminProductList'">상품 관리</button>
     </td>
</tr>
</table>
</div>
</div>
</body>
</html>