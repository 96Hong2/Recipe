<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.postDel{
	 margin: 0 auto 70px;
	 width: 200px;
	 
}

</style>
</head>
<header>
         <c:import url="./header_afterLogin.jsp" />
      </header>
<body>

<div class="postDel">삭제된 게시물 입니다.<input type="button" name="return" onclick="history.back();" value="돌아가기"/></div>

</body>
</html>