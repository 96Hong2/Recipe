<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if ("${sessionScope.userId}" == "") {
	location.href = "./postList";
	alert("로그인이 필요한 서비스입니다.");
}
</script>
<style>
	table{
		border: 3px solid lightgrey;
		border-collapse: collapse;
	}
	
	th, td{
		border: 2px solid lightgrey;
		padding: 5px;
	}

	caption {
		margin-left: 0;
		background-color: grey;
		color: white;
		text-align: left;
		padding: 5px;
	}

	textarea{
		width: 600px;
		height: 200px;
		resize: none;
	}
	
	#alert{
		background-color: LightGrey;
		padding: 5px;
		border: none;
		text-align: center;
	}
	
	.btn{
		border: none;
	} 
	
	#counter{
		border-bottom: none;
		text-align: right;
	}

	#textarea{
		border: none;
	}
	
	#submit{
		float: right;
	}
</style>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	String postId = request.getParameter("postId");
	String nickName = request.getParameter("nickName");
	String classification = request.getParameter("classification");
%>
<form action="./reportSth" method="get">
<table>
<caption>신고하기 - 알다시피</caption>
		<tr>
			<th>글번호</th>
			<td><input type="hidden" name="classification" value="<%=classification%>"><input type="hidden" name="postId" value="<%=postId %>"><%=postId %></td>
		</tr>
		<tr>
			<th>신고자</th>
			<td><input type="hidden" name="nickName" value="${sessionScope.nickName}">${sessionScope.nickName}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><input type="hidden" name="writer" value="<%=nickName %>"><%=nickName %></td>
		</tr>
		<tr>
			<th>신고사유</th>
			<td>
				<input type="radio" name="opt" value="r1" checked="checked">부적절한 글
				<input type="radio" name="opt" value="r2">광고성 글
				<input type="radio" name="opt" value="r3">욕설
				<input type="radio" name="opt" value="r4">도배 글
				<input type="radio" name="opt" value="r5">무의미한 글
				<input type="radio" name="opt" value="r6">기타
			</td>
		</tr>
		<tr>
			<td style="color:#aaa;" id="counter" colspan="2">0/500</td>
		</tr>
		<tr>
			<td colspan="2" id="textarea"><textarea placeholder="신고상세사유를 10자 이상 입력해주세요." maxlength="500" id="textArea" name="textArea"></textarea></td>
		</tr>
		<tr>
			<td colspan="2" id="alert">신고 게시물은 삭제될 수 있으며, 해당 작성자는 정지될 수 있습니다. <br>단, 허위신고일 경우, 신고자의 활동이 제한됩니다.</td>
		</tr>
		<tr>
			<td class="btn"><input type="button" value="닫기" onclick="window.close()"></td>
			<td class="btn" id="submit"><input type="button" value="신고하기" id="submitBtn"></td>
		</tr>
	
</table>
</form>
</body>
<script>
$('#textArea').keyup(function (e){
	var content = $(this).val();
	$('#counter').html(content.length+"/500");
	
});

function vali(val){
	
	console.log("입력된 길이"+val.length);
	 
    if (val === null) return true; 
    if (val.length === 0) return true;
    if (typeof val === 'undefined') return true;
    if(val.replace(/(^\s*)|(\s*$)/gi, "").length == 0) return true;
    
    return false;

}

$("#submitBtn").click(function(event){
	
	if(vali($('#textArea').val())){
		alert("신고 사유를 입력해주세요!");
		$('#textarea').focus();
		return false;
	}else if($('#textArea').val().replace(/(^\s*)|(\s*$)/gi, "").length < 10){
		alert("신고 사유를 10자 이상 입력해주세요!");
		$('#textarea').focus();
		return false;
	}else{
		$("form").submit()			 
		
		return false;
	}
	});
	
var msg = "${msg}";

if(msg != ""){
	alert(msg);
	window.opener.reloadPage();
	window.close();
}
	
</script>
</html>