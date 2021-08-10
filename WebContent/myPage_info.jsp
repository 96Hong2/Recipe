<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myPage_info.jsp</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
</head>
<body>
	<div id="info">
		<ul>
			<li><p>RANK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;</p><p id='rankArea'></p></li>
			<li><p>명예 점수&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p id='pointArea'></p><p>점</p></li>
			<li><p>보유 캐시&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p id='cashArea'></p><p>원</p></li>
		</ul>
	</div>
</body>
<script>
$.ajax({
	type:'post',
	url:'./info',
	dataType:'JSON',
	success:function(info){
		console.log("(myPage_info.jsp)ajax info :"+info);
		$('#rankArea').html(info.rank);
		$('#pointArea').html(info.point);
		$('#cashArea').html(info.cash);
	},
	error:function(e){
		console.log("ajax 에러발생 :"+e);
	}
});
</script>
</html>