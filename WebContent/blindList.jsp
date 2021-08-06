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

#blindView {
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
		<a href="./blindList.jsp" id="blindView">블라인드 관리</a>
	</h3>
	<div id="wrap">
		<select name="searchOpt" id="searchOpt" style="width:100px; height:30px;">
			<option value='회원아이디'>회원 ID</option>
			<option value='관리자'>관리자</option>
			<option value='블라인드사유'>블라인드 사유</option>
		</select> <input type="text" id="searchCnt" size=50 style="height: 25px;"/> 
		<button onclick="searchCall()" style="width: 50px; height:30px; font-size: 15px; padding: 3px;">검색</button>
	</div>
	<br />
	<table>
		<thead>
			<tr id="head">
				<th>블라인드번호</th>
				<th>회원 ID</th>
				<th>글번호</th>
				<th>날짜</th>
				<th>상세사유</th>
				<th>해제</th>
				<th>관리자</th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</body>
<script>
	listCall();
	//var textchange = false;
	
	function listCall() {
		$.ajax({
			type : 'get',
			url : 'blindList',
			data : {},
			dataType : 'JSON',
			success : function(data) {
				console.log(data);
				drawList(data.blindList);
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

		if (cnt != "" && searchOpt != "미처리") {
			$.ajax({
				type : 'get',
				url : 'blindSearch',
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
		}else{
			alert("1글자 이상 입력해주세요!");
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

	 
	 function reloadPage(){
		 console.log("새로고침");
		 location.reload();
	 }
	 
	 function blindNot(blindId){
		 console.log("블라인드 해제 요청");
		 	if(confirm("해당 글/댓글의 블라인드 상태를 해제하시겠습니까?")){
		 		
		 		//var adminWho = "${sessionScope.nickName}";
		 		
			 		$.ajax({
					type : 'get',
					url : 'blindNot',
					data : {"blindId" : blindId},
					dataType : 'JSON',
					success : function(data) {
						if(data.success){
							alert("해당 글/댓글의 블라인드가 해제되었습니다.");
						}else{
							alert("블라인드 상태를 해제하지 못했습니다.");
						}
					},
					error : function(e) {
						console.log(e);
					}
					});
			 		reloadPage();
			 }
		 
		 
	 }
		 
	
	function drawList(blindList) {
		console.log(blindList);
		var content = "";

		if (blindList.length == 0) {
			console.log("블라인드가 없을 때");
			alert("블라인드가 존재하지 않습니다.");
		} else {
			console.log("블라인드가 있을 때");

			blindList.forEach(function(item, idx) {
						console.log(idx, item);
						
						var admin = item.managerId;
						var blindIdx = item.blindId;
						//해당 글 또는 댓글로 이동 - 되는지 확인하기!!
						//'<td style="color: blue;" onclick="location.href=\'../postDetail?postId='+item.fieldId+'\'">' 
						
						content += "<tr>";
						content += "<td>" + blindIdx + "</td>";
						content += "<td>" + item.userid + "</td>";
						content += '<td><a href="../postDetail?postId='+item.fieldId+'\'">' + item.classification + item.fieldId + '</a></td>';
						content += "<td>" + item.blindDate + "</td>";			
						content += '<td><input type="button" id="toggleBtn'+idx+'" class="toggleBtn" value="보기" onclick="toggleBtn('+idx+')"/></td>';
						content += '<td><input type="button" value="해제" id="statBtn'+blindIdx+'" onclick="blindNot('+blindIdx+')"/></td>';
						content += '<td>' + admin + '</td>';
						content += "</tr>";
						content += "<tr>";
						content += "<td colspan='7' class='toggleBox' id='detailToggle"+idx+"' style='background-color: gray; color:white; padding:8px; text-align: left; display:none;'> 상세사유 : "+item.blindReason+"</td>";
						content += "</tr>";
						
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
						
						var admin = item.managerId;
						var blindIdx = item.blindId;
						//해당 글 또는 댓글로 이동 - 되는지 확인하기!!
						//'<td style="color: blue;" onclick="location.href=\'../postDetail?postId='+item.fieldId+'\'">' 
						
						content += "<tr>";
						content += "<td>" + blindIdx + "</td>";
						content += "<td>" + item.userid + "</td>";
						content += '<td><a href="../postDetail?postId='+item.fieldId+'\'">' + item.classification + item.fieldId + '</a></td>';
						content += "<td>" + item.blindDate + "</td>";			
						content += '<td><input type="button" id="toggleBtn'+idx+'" class="toggleBtn" value="보기" onclick="toggleBtn('+idx+')"/></td>';
						content += '<td><input type="button" value="해제" id="statBtn'+blindIdx+'" onclick="blindNot('+blindIdx+')"/></td>';
						content += '<td>' + admin + '</td>';
						content += "</tr>";
						content += "<tr>";
						content += "<td colspan='7' class='toggleBox' id='detailToggle"+idx+"' style='background-color: gray; color:white; padding:8px; text-align: left; display:none;'> 상세사유 : "+item.blindReason+"</td>";
						content += "</tr>";

					});
			$("tbody").empty();
			$("tbody").append(content);
		}
	}
</script>
</html>