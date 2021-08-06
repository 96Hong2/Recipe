<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<% //테스트용 세션 저장
session.setAttribute("nickName", "슈퍼관리자");
session.setAttribute("userId", "admin"); 
session.setAttribute("isAdmin","Y");
%>
<script>
if("${sessionScope.isAdmin}"!="Y"){
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
	<h3>
		<a href="./memberList.jsp" id="memberView">회원 조회</a>
	</h3>
	<div id="wrap">
		<select name="searchOpt" id="searchOpt" style="width:100px; height:30px;">
			<option value='userId'>회원 ID</option>
			<option value='nickname'>회원 닉네임</option>
			<option value='rankId'>회원 등급</option>
		</select> <input type="text" id="searchCnt" size=50 style="height: 25px;" /> 
		<button onclick="searchCall()" style="width: 50px; height:30px; font-size: 15px; padding: 3px;">검색</button>
	</div>
	<!-- 검색기능은 ajax 사용하기 -->
	<br />
	<table>
		<thead>
			<tr id="head">
				<th>ID</th>
				<th>닉네임</th>
				<th>이름</th>
				<th>등급</th>
				<th>정지여부</th>
				<th>상세보기</th>
				<th>정지/해제</th>
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
			url : 'memberList',
			data : {},
			dataType : 'JSON',
			success : function(data) {
				//console.log(data);
				drawList(data.list);
				$('.susBtnY').attr('value','해제');
				$('.susBtnN').attr('value','정지');
			},
			error : function(e) {
				console.log(e);
			}
		});
	}

	function searchCall() {

		var searchOpt = $("#searchOpt option:selected").val();
		//console.log("선택한 검색 옵션 : " + searchOpt);
		var cnt = $("#searchCnt").val();
		//console.log("검색창에 입력한 내용 : " + cnt);

		if (cnt != "") {
			$.ajax({
				type : 'get',
				url : './memberSearch',
				data : {
					"searchOpt" : searchOpt,
					"cnt" : cnt
				},
				dataType : 'JSON',
				success : function(data) {
					console.log(data);
					searchOption(data.searchList);
					$('.susBtnY').attr('value','해제');
					$('.susBtnN').attr('value','정지');
				},
				error : function(e) {
					console.log(e);
				}
			});
		} else {
			alert("1글자 이상 입력해주세요!");
		}
	}

	 function moveDetail(userId){
		console.log("아이디 : " + userId);
		location.href = "./memberInfo?userId="+userId;
	} 
	 
	 function reloadPage(){
		 console.log("새로고침");
		 location.reload();
	 }

	 function susPopUp(userId, nickname, userDel){
		 //console.log("아이디 : "+userId);
		 //console.log("닉네임 : "+nickname);
		 //console.log("정지여부 : "+userDel);
		 
		 if(userDel == "N"){
		 	var url = "./memberSusPopUp?userId="+userId+"&&nickname="+nickname;
		 	var option = "width=650, height=500, top=500, location = no, resizable = no";
		 	window.open(url, "memberSus", option);
		 	
		 }else{
			 if(!confirm("해당 회원의 정지 상태를 해제하시겠습니까?")){
				 //console.log("취소를 눌렀습니다.");
			 }else{
				 //console.log("확인을 눌렀습니다.");
			 $.ajax({
					type : 'get',
					url : './memberSusNot',
					data : {
						"userId" : userId,
						"userDel" : userDel
					},
					dataType : 'JSON',
					success : function(data) {
						
						reloadPage();
					    },     
					error : function(e) {
						console.log(e);
					}
				});
			 }
		 }
	 }
		 
	
	function drawList(list) {
		console.log(list);
		var content = "";

		if (list.length == 0) {
			console.log("회원이 없을 때");
			alert("회원이 존재하지 않습니다.");
		} else {
			console.log("회원이 있을 때");

			list.forEach(function(item, idx) {
						console.log(idx, item.userId);
						
						var rank = item.rankId;
						if(rank == "1"){
							rank = "브론즈";
						}else if(rank == "2"){
							rank = "실버";
						}else if(rank == "3"){
							rank = "골드";
						}else if(rank == "4"){
							rank = "VIP";
						}

						
						content += "<tr>";
						content += "<td>" + item.userId + "</td>";
						content += "<td>" + item.nickname + "</td>";
						content += "<td>" + item.name + "</td>";
						content += "<td id='ranks'>" + rank + "</td>";
						content += '<td id="del_'+idx+'">' + item.userSus + '</td>';
						content += '<td><input type="button" value="상세보기" onclick="moveDetail(\''+item.userId+'\')"/></td>';
						content += '<td><input type="button" value="공백" class="susBtn'+item.userSus+'" onclick="susPopUp(\''+item.userId+'\', \''+item.nickname+'\',\''+item.userSus+'\')"/></td>';
						content += "</tr>";
						
						//console.log("Y버튼 값 : "+$('.susBtnY').val());
						//console.log("N버튼 값 : "+$('.susBtnN').val());
						
			$("tbody").empty();
			$("tbody").append(content);
	});
		}
	}
	
	function searchOption(searchList) {

		var content = "";

		if (searchList.length == 0) {
			console.log("검색 결과가 없을 때");
			content += "<tr>";
			content += "<td><p>검색 결과가 없습니다.</p></td>";
			content += "</tr>";

			$("tbody").empty();
			$("tbody").append(content);
		} else {
			console.log("값이 있을 때");
			console.log("searchList : " + searchList);
			searchList.forEach(function(item, idx) {
						console.log(idx, item);
						
						var rank = item.rankId;
						if(rank == "1"){
							rank = "브론즈";
						}else if(rank == "2"){
							rank = "실버";
						}else if(rank == "3"){
							rank = "골드";
						}else if(rank == "4"){
							rank = "VIP";
						}

						content += "<tr>";
						content += "<td>" + item.userId + "</td>";
						content += "<td>" + item.nickname + "</td>";
						content += "<td>" + item.name + "</td>";
						content += "<td>" + rank + "</td>";
						content += "<td>" + item.userSus + "</td>";
						content += '<td><input type="button" value="상세보기" onclick="moveDetail(\''+item.userId+'\')"/></td>';
						content += '<td><input type="button" value="공백" class="susBtn'+item.userSus+'" onclick="susPopUp(\''+item.userId+'\', \''+item.nickname+'\',\''+item.userSus+'\')"/></td>';
						content += "</tr>";

					});
			$("tbody").empty();
			$("tbody").append(content);
		}
	}
</script>
</html>