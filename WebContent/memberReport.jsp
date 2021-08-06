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
   location.href = "../";
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
%>
<table>
<caption>신고하기 - 알다시피</caption>
		<tr>
			<th>글번호</th>
			<td><input type="hidden" name="userId" value="<%=postId %>"><%=postId %></td>
		</tr>
		<tr>
			<th>신고자</th>
			<td><input type="hidden" name="reporter" value="${sessionScope.nickName}">${sessionScope.nickName}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><input type="hidden" name="writer" value="<%=nickName %>"><%=nickName %></td>
		</tr>
		<tr>
			<th>신고사유</th>
			<td>
				<input type="radio" name="opt" value="inappropriate" checked="checked">부적절한 글
				<input type="radio" name="opt" value="advertisement">광고성 글
				<input type="radio" name="opt" value="curse">욕설
				<input type="radio" name="opt" value="spam">도배 글
				<input type="radio" name="opt" value="contentNull">무의미한 글
				<input type="radio" name="opt" value="else">기타
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
	
</script>
</html>