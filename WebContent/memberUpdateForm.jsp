<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.isAdmin}"!="Y"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "./login.jsp";
}
</script>
</head>
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>
<body>
<h2>${member.nickname} 님의 회원정보 수정</h2>
<form action = "./memberUpdate" method = "POST"> 
	<table>
		<tr>
			<td>아이디(ID)</td>
			<td><input type = "hidden" name = "userId" value = "${member.userId}" readonly/>${member.userId}</td>
		</tr>
		<tr>
			<td>비밀번호(PW)</td>
			<td><input type = "password" name = "pw" value = "${member.pw}" readonly/></td>
		</tr>
		<tr>
			<td>이름(NAME)</td>
			<td><input type = "hidden" name = "name" value = "${member.name}" readonly/>${member.name}</td>
		</tr>
		<tr>
			<td>닉네임(NICKNAME)</td>
			<td><input type = "text" name = "nickname" value = "${member.nickname}" maxlength="10" id="nickArea" />
			<input type = "button" id="overlay" value = "중복체크"/>
			</td>
		</tr>
		<tr>
			<td>연락처(TEL)</td>
			<td><input type = "hidden" name = "tel" value = "${member.tel}" readonly/>${member.tel}</td>
		</tr>
		<tr>
			<td>주소(ADDRESS)</td>
			<td><input type = "hidden" name = "address" value = "${member.address}" readonly/>${member.address}</td>
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
			<td><input type = "hidden" name = "regDate" value = "${member.reg_date}" readonly/>${member.reg_date}</td>
		</tr>		
	</table>
	<input type="button" value="저장" style="margin: 5px;" onclick="Check()"/>
	<input type="button" value="취소" onclick="location.href='./memberInfo?userId=${member.userId}'"/>
</form>
</body>
<script>
var overChk = false;

function Check(){
	if(!overChk){
		alert("닉네임 중복체크를 진행해주세요!");
		$("#nickArea").focus();
		return false;
	}
	$("form").submit();
	return false;

}

$("#overlay").click(function(){
	var nickname = $("input[name='nickname']").val();
	console.log(nickname);
	$.ajax({
		type:'get',
		url:'nickOverlay',
		data:{'nickName':nickname},
		dataType:'JSON',
		success:function(data){
			console.log(data);
			if(!data.success){
				alert("처리중 문제가 발생 했습니다. 다시 시도해 주세요!");
			}else{
				if(data.overlay){
					alert("이미 사용중인 닉네임 입니다.");
					 $("input[name='nickname']").val("");
				}else{
					alert("사용 가능한 닉네임 입니다.");
					overChk = true;
				}
			}				
		},
		error:function(e){
			console.log(e);
		}			
	});
});

$("#nickArea").on("change keyup paste", function(){
	overChk = false;
});


</script>
</html>