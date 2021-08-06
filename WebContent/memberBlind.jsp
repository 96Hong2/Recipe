<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
		color: red;
		padding: 5px;
		border: none;
		
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
	String userId = request.getParameter("userId");
	String nickname = request.getParameter("nickname");
%>
<form action="./memberBlind" method="get">
<table>
<caption>블라인드 - 알다시피-</caption>
		<tr>
			<th>글번호</th>
			<td><input type="hidden" name="userId" value="<%=userId %>"><%=userId %></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><input type="hidden" name="nickname" value="<%=nickname %>"><%=nickname %></td>
		</tr>
		<tr>
			<th>관리자</th>
			<td><input type="hidden" name="adminName" value="임시">임시!!!!!!!!!!!!!!!!!!</td>
		</tr>
		<tr>
			<td style="color:#aaa;" id="counter" colspan="2">0/100</td>
		</tr>
		<tr>
			<td colspan="2" id="textarea"><textarea placeholder="블라인드 사유를 100자 이내로 작성해 주세요." maxlength="100" id="textArea" name="textArea"></textarea></td>
		</tr>
		<tr>
			<td class="btn"><input type="button" value="닫기" onclick="window.close()"></td>
			<td class="btn" id="submit"><input type="button" value="블라인드" id="submitBtn"></td>
		</tr>
</table>
</form>
</body>
<script>
$('#textArea').keyup(function (e){
	var content = $(this).val();
	$('#counter').html(content.length+"/100");
	
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
		alert("블라인드 사유를 입력해주세요!");
		$('#textarea').focus();
		return false;
	}
		$("form").submit()			 
		
		return false;
	});

	
	var msg = "${msg}";
	
	if(msg != ""){
		alert(msg);
		window.opener.reloadPage();
		window.close();
	}
	
</script>
</html>