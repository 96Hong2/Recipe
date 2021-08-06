<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 - 마이페이지</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/myPage.css" media="all" />
</head>
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>

<body>
	<div class="body_wrap">
		<img src="./staticImg/user.jpeg" id='userImg' alt="유저이미지" width='100px'
			height='100px' />
		
		<h3>${sessionScope.nickName} 님</h3>
		
		<div id="info">
			<c:import url="./myPage_info.jsp"/>
		</div>
		
		<h4>캐시 충전</h4>
		<p>현재 보유 캐시 : </p><p id='showCash2'></p><p> 원</p>
		
		<form action="./chargeCash" method="post">
		<div id='charge_option'>
        	<input list='amount' name='amount' placeholder='금액을 입력하세요' autocomplete='off'/>
			<datalist id='amount'>
            	<option value='5000'></option>
            	<option value='10000'></option>
            	<option value='20000'></option>
            	<option value='30000'></option>
            	<option value='50000'></option>
        	</datalist>
        	<p>원</p>
		</div>
		<button type='button' id='cancel' onclick='location.href="./cashHistory"'>취소</button>
        <button id='charge'>충전하기</button>
        </form>
		
	</div>
</body>
<script>
$.ajax({
	type:'post',
	url:'./showCash',
	dataType:'JSON',
	success:function(currCash){
		console.log("(myPage_chargeCash.jsp)ajax currCash :"+currCash);
		$('#showCash2').html(currCash.currentCash);
	},
	error:function(e){
		console.log("ajax 에러발생 :"+e);
	}
});
var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>
<footer>
</footer>
</html>