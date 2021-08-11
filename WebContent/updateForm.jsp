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
	<header>
		<%@include file="header_afterLogin.jsp"%>
	</header>
</head>
<body>
<h2>${sessionScope.nickName} 님의회원정보 수정</h2>
<!-- <button onclick = "location.href = './myPage_myPage.jsp'">MY PAGE로 돌아가기</button> -->
<a href='./myPage' id='backToMyPage'><h4 style="border:2px solid #bbb; border-radius:10px; text-align:center; width:230px;"> ← MY PAGE로 돌아가기</h4></a>
<form action = "update" method = "POST"> 
	<table>
		<tr>
			<td>아이디(ID)</td>
			<td><input type = "hidden" name = "userId" value = "${member.userId}" readonly/>${member.userId}</td>
		</tr>
		<tr>
			<td>비밀번호(PW)</td>
			<td><input type = "password" name = "pw" value = "${member.pw}" /></td>
		</tr>
		<tr>
			<td>이름(NAME)</td>
			<td><input type = "hidden" name = "name" value = "${member.name}" readonly/>${member.name}</td>
		</tr>
		<tr>
			<td>닉네임(NICKNAME)</td>
			<td><input type = "text" name = "nickName" value = "${member.nickName}" />
			<input type = "button" id = "overlay1" value = "중복확인"/>
			</td>
		</tr>
		<tr>
			<td>연락처(TEL)</td>
			<td><input type = "text" name = "tel" value = "${member.tel}" /></td>
		</tr>
		<tr>
			<td>주소(ADDRESS)</td>
			<td><input type = "text" name = "address" value = "${member.address}" /></td>
		</tr>
		<tr>
			<td>등급(RANK)</td>
			<td><input type = "hidden" name = "rankId" value = "${member.rankId}" readonly/>${member.rankId}</td>
		</tr>
		<tr>
			<td>블라인드(BLINDCOUNT)</td>
			<td><input type = "hidden" name = "blindCount" value = "${member.blindCount}" readonly/>${member.blindCount}</td>
		</tr>
		<tr>
			<td>가입날짜(REGDATE)</td>
			<td><input type = "hidden" name = "regDate" value = "${member.regDate}" readonly/>${member.regDate}</td>
		</tr>
	</table>
	<input type="submit" value="저장" style="margin: 5px;"/>
</form>
</body>
<script>
var overChk = false;
var nickChk = false;

$("#overlay1").click(function(){
   var nickName = $("input[name='nickName']").val();
   console.log(nickName);
   $.ajax({
      type:'get',
      url:'overlay1',
      data:{'nickName':nickName},
      dataType:'JSON',
      success:function(data){
         console.log(data);
         if(!data.success){
            alert("처리중 문제가 발생 했습니다. 다시 시도해 주세요!");
         }else{
            if(data.overlay1){
               alert("중복된 닉네임입니다.");
                $("input[name='nickName']").val("");
            }else{
               alert("닉네임을 사용할 수 있습니다.");
               nickChk = true;
            }
         }            
      },
      error:function(e){
         console.log(e);
      }         
   });
});
</script>
</html>