<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

#load{
	text-decoration: none;
	color: white;
	background-color: lightblue;
}
</style>
</head>
<header>
	<c:import url="./header_afterLogin.jsp"/>
</header>
<body>
	<h3>
		<a href="./susMemberList.jsp" id="memberView">정지 회원 목록</a>
	</h3>
	<div id="wrap">
		<select name="searchOpt" id="searchOpt" style="width:100px; height:30px;">
			<option value='userId'>회원 ID</option>
			<option value='nickname'>회원 닉네임</option>
			<option value='name'>회원 이름</option>
			<option value='admin'>관리자</option>
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
				<th>정지사유</th>
				<th>정지날짜</th>
				<th>처리한 관리자</th>
				<th>상세사유</th>
				<th>정지 해제</th>
			</tr>
		</thead>
		<tbody></tbody>
		<tfoot>
			<tr>
				<td colspan="7" id="loading"><a href="#" id="load">더 보기</a></td>
			</tr>
		</tfoot>
	</table>
</body>
<script>
	listCall();
	function listCall() {
		$.ajax({
			type : 'get',
			url : 'susMemberList',
			data : {},
			dataType : 'JSON',
			success : function(data) {
				//console.log(data);
				drawList(data.list);
			},
			error : function(e) {
				console.log(e);
			}
		});
	}
	
	function susNot(userId){
	 if(!confirm("해당 회원의 정지 상태를 해제하시겠습니까?")){
		 //console.log("취소를 눌렀습니다.");
	 }else{
		 //console.log("확인을 눌렀습니다.");
	 $.ajax({
			type : 'get',
			url : './memberSusNot',
			data : {
				"userId" : userId,
			},
			dataType : 'JSON',
			success : function(data) {
				console.log(data.msg);
				alert(userId+" 님이 정지해제되었습니다!");
				reloadPage();
			    },     
			error : function(e) {
				console.log(e);
			}
		});
	 
	 }
	}
	
	function toggleBtn(idx){
		console.log("상세사유 보기 버튼 클릭"+idx);
		if(!$("#detailToggle"+idx).is(":visible")){
			$(".toggleBox").hide();
			$(".toggleBtn").attr("value", "보기");
			$(".toggleBtn").css({"background-color":"","color":""});
		}
		$("#detailToggle"+idx).toggle(function(){
			if($("#toggleBtn"+idx).attr("value") == "보기"){
				$("#toggleBtn"+idx).attr("value", "접기");
				$("#toggleBtn"+idx).css({"background-color":"grey","color":"white"});
			}else{
				$("#toggleBtn"+idx).attr("value", "보기");
				$("#toggleBtn"+idx).css({"background-color":"","color":""});
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
				url : 'susMemberSearch',
				data : {
					"searchOpt" : searchOpt,
					"cnt" : cnt
				},
				dataType : 'JSON',
				success : function(data) {
					console.log(data);
					searchOption(data.searchList);
				},
				error : function(e) {
					console.log(e);
				}
			});
		} else {
			alert("1글자 이상 입력해주세요!");
		}
	}
	 
	 function reloadPage(){
		 console.log("새로고침");
		 location.reload();
	 }
	
	function drawList(list) {
		console.log(list);
		var content = "";

		if (list.length == 0) {
			console.log("정지 회원이 없을 때");
			alert("정지 회원이 존재하지 않습니다.");
		} else {
			console.log("정지 회원이 있을 때");

			list.forEach(function(item, idx) {
						console.log(idx, item.userId);
						
						var susCategory = "";
						
						if(item.categoryId == "s1"){
							susCategory = "블라인드 5회이상";
						}else if(item.categoryId == "s2"){
							susCategory = "부적절한 닉네임 반복 사용";
						}else if(item.categoryId == "s3"){
							susCategory = "기타";
						}else{
							susCategory = "";
						}
						
						content += "<tr class='row' style='display:none;'>";
						content += "<td>" + item.userId + "</td>";
						content += "<td>" + item.nickname + "</td>";
						content += "<td>" + item.name + "</td>";
						content += "<td>" + susCategory + "</td>";
						content += "<td>" + item.suspendDate + "</td>";
						content += '<td>' + item.managerId + '</td>';
						content += '<td><input type="button" id="toggleBtn'+idx+'" class="toggleBtn" value="보기" onclick="toggleBtn('+idx+')"/></td>';
						content += '<td><input type="button" value="해제" onclick="susNot(\''+item.userId+'\')"/></td>';
						content += "</tr>";
						content += "<tr>";
						content += "<td colspan='8' class='toggleBox' id='detailToggle"+idx+"' style='background-color: gray; color:white; padding:8px; text-align: left; display:none;'> 상세사유 : "+item.suspendReason+"</td>";
						content += "</tr>";
						
			$("tbody").empty();
			$("tbody").append(content);
	});
			$(".row").slice(0,10).show();
			if($(".row:hidden").length == 0){
				$("#load").css("background-color","grey");
			}
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
						
						var susCategory = "";
						
						if(item.categoryId == "s1"){
							susCategory = "블라인드 5회이상";
						}else if(item.categoryId == "s2"){
							susCategory = "부적절한 닉네임 반복 사용";
						}else if(item.categoryId == "s3"){
							susCategory = "기타";
						}else{
							susCategory = "";
						}

						content += "<tr class='row' style='display:none;'>";
						content += "<td>" + item.userId + "</td>";
						content += "<td>" + item.nickname + "</td>";
						content += "<td>" + item.name + "</td>";
						content += "<td>" + susCategory + "</td>";
						content += "<td>" + item.suspendDate + "</td>";
						content += '<td>' + item.managerId + '</td>';
						content += '<td><input type="button" id="toggleBtn'+idx+'" class="toggleBtn" value="보기" onclick="toggleBtn('+idx+')"/></td>';
						content += '<td><input type="button" value="해제" onclick="susNot(\''+item.userId+'\')"/></td>';
						content += "</tr>";
						content += "<tr>";
						content += "<td colspan='8' class='toggleBox' id='detailToggle"+idx+"' style='background-color: gray; color:white; padding:8px; text-align: left; display:none;'> 상세사유 : "+item.suspendReason+"</td>";
						content += "</tr>";
			$("tbody").empty();
			$("tbody").append(content);
					});
			$(".row").slice(0,10).show();
			if($(".row:hidden").length == 0){
				$("#load").css("background-color","grey");
			}
		}
	}
	
	$("#load").click(function(e){
		e.preventDefault();
		$(".row:hidden").slice(0,10).show();
		if($(".row:hidden").length == 0){
			$("#load").css("background-color","grey");
		}
	});
</script>
</html>