<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<h3>알다시피</h3>	
		<table>
			<tr>
				<td>아이디</td>
				<td><input type="text" name="userId"/></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pw"/></td>
			</tr>
			<tr>
				<td colspan="2">
					<button>로그인</button>					
				</td>
			</tr>
		</table>	
</body>
<script>
var msg = "${msg}";
if(msg != ""){
	alert(msg);
}

$("button").click(function(){
	var param = {};
	param.userId = $("input[name='userId']").val();
	param.pw = $("input[name='pw']").val();
	console.log("**param :"+param);
	
	$.ajax({
		type:'POST',
		url:'login',
		data:param,
		dataType:'JSON',
		success:function(data){
			//console.log("**success : "+data.success);
			if(data.success){		
				alert('로그인에 성공했습니다.');
				location.href='./';
			}else{
				if(data.suspend){
					alert('회원님은 아래 사유로 회원 정지 되었습니다.'
							+'\n정지 사유 : '+data.suspendReason+'\n정지 날짜 : '+data.suspendDate+
							'\n문의사항이 있으시면 아래 이메일로 문의해주시기 바랍니다.'
							+'\nAldasipy@aldasipy.com');
					location.href='login.jsp';
				}else{
					alert('아이디/패스워드가 틀렸습니다.');
					location.href='login.jsp';					
				}
			}
			
		},
		error:function(e){
			console.log("ajax 실패 : "+e);
		}
	});				
});
</script>
</html>