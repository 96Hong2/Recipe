<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>알다시피</title>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>

</script>
</head>
<body>
	<div class="wrap">
		<header>
			<%@include file="header_afterLogin.jsp"%>
		</header>

		<main id="body">
			<div id="banner"><img src="banner.png"></div>
			<p id="week">
				<a href="#">이 주의 레시피</a>
			</p>
			<div id="weeklyBest"></div>
			<p id="month">
				<a href="#">이 달의 레시피</a>
			</p>
			<div id="monthlyBest"></div>
		</main>
		<footer>푸터</footer>
	</div>
</body>
<script>
	var msg = "${msg}";
	if(msg != ""){
		alert(msg);
	}
</script>
</html>