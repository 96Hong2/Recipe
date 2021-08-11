<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 관리자 페이지 - 관리자 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
if("${sessionScope.isAdmin}"!="Y" && "${sessionScope.userId}"!="admin"){
   alert("해당 서비스 접근 권한이 없습니다.");
   location.href = "../";
}
</script>
<style>
table {
	text-align: center;
	width: 70%;
	height: 100px;
	margin-left: auto;
	margin-right: auto;
}

th {
	padding: 5px;
}

h3 {
	text-align: center;
	text-emphasis: bold;
}

#memberView {
	text-decoration: none;
	color: black;
}

p {
	color: gray;
	font-style: italic;
}

#wrap {
	padding: 5px;
	margin:auto;
	text-align:center;
}

#head {
	background-color: lightblue;
}
</style>
</head>
<body>
	<header>
         <c:import url="./header_afterLogin.jsp" />
      </header>
	<h3>
		<a href="./adminList.jsp" id="memberView">관리자 관리</a>
	</h3>
	<div id="wrap">
		<input type="text" id="adminSet" size=50 style="height: 25px;" placeholder= "지정할 관리자 아이디를 적어주세요." /> 
		<button onclick="adminSet()" style="width: 100px; height:30px; font-size: 15px; padding: 3px;">관리자 지정</button>
	</div>
	<br />
	<table>
		<thead>
			<tr id="head">
				<th>ID</th>
				<th>닉네임</th>
				<th>이름</th>
				<th>정보</th>
				<th>관리자 해제</th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</body>
<script>
	listCall();
	function listCall() {
		$.ajax({
			type : 'get',
			url : 'adminList',
			data : {},
			dataType : 'JSON',
			success : function(data) {
				console.log(data);
				drawList(data.list);
			},
			error : function(e) {
				console.log(e);
			}
		});
	}


		function adminSet() {

		var cnt = $("#adminSet").val();
		//console.log("검색창에 입력한 내용 : " + cnt);

		if (cnt != "") {
			$.ajax({
				type : 'get',
				url : 'adminSet',
				data : {"cnt" : cnt},
				dataType : 'JSON',
				success : function(data) {
					console.log(data);
					alert("해당 회원의 관리자 지정이 완료되었습니다!");
					
					
				},
				error : function(e) {
					console.log(e);
				}
			});
			reloadPage();
		} else {
			alert("1글자 이상 입력해주세요!");
		}
	}
	
	 
	 function reloadPage(){
		 console.log("새로고침");
		 location.reload();
	 }
	
	 function adminInfo(userId){
		 console.log("아이디 : " + userId);
			location.href = "./adminInfo?userId="+userId;
	 }
	 
	 function adminNot(userId){
		 $.ajax({
			 type : 'get',
		 	url : 'adminNot',
		 	data : {
		 		"userId" : userId
		 	},
		 	dataType : 'JSON',
		 	success : function(data) {
				alert("관리자가 해제되었습니다.")
				reloadPage();
			    },     
			error : function(e) {
				console.log(e);
			}
		 });
	 }
	 
	 
	function drawList(list) {
		console.log("리스트 불러오기");
		var content = "";

		if (list.length == 0) {
			console.log("관리자가 없을 때");
			alert("관리자가 존재하지 않습니다.");
		} else {
			console.log("관리자가 있을 때");

			list.forEach(function(item, idx) {
						console.log(idx, item.userId);
						
						content += "<tr>";
						content += "<td>" + item.userId + "</td>";
						content += "<td>" + item.nickName + "</td>";
						content += "<td>" + item.name + "</td>";
						content += '<td><input type="button" value="보기" onclick="adminInfo(\''+item.userId+'\')"/></td>';
						content += '<td><input type="button" value="해제" onclick="adminNot(\''+item.userId+'\')"/></td>';
						content += "</tr>";
						
			$("tbody").empty();
			$("tbody").append(content);
	});
		}
	}

//1. 관리자 여부가 Y인 사람들만 컨트롤러에 case "/adminList" 이거 추가해서 select 아이디, 이름, 닉네임 where 관리자여부=y
//2. 관리자 지정 : 컨트롤러에 /adminSet 에서 관리자 여부만 바꿔주면 됨
</script>
</html>