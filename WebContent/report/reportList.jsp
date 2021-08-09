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
   location.href = "../login.jsp";
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

#reportView {
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
<body>
	<h3>
		<a href="./reportList.jsp" id="reportView">신고 관리</a>
	</h3>
	<div id="wrap">
		<select name="searchOpt" id="searchOpt" onchange="reportStatusNot()" style="width:100px; height:30px;">
			<option value='신고자'>신고자 ID</option>
			<option value='관리자'>관리자</option>
			<option value='미처리'>미처리</option>
		</select> <input type="text" id="searchCnt" size=50 style="height: 25px;"/>
		<button onclick="searchCall()" style="width: 50px; height:30px; font-size: 15px; padding: 3px;">검색</button>
	</div>
	<br />
	<table>
		<thead>
			<tr id="head">
				<th>신고번호</th>
				<th>신고자 ID</th>
				<th>글번호</th>
				<th>신고사유</th>
				<th>날짜</th>
				<th>상세사유</th>
				<th>처리상태</th>
				<th>관리자</th>
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
	//var textchange = false;
	
	function listCall() {
		$.ajax({
			type : 'get',
			url : 'reportList',
			data : {},
			dataType : 'JSON',
			success : function(data) {
				//console.log(data);
				drawList(data.reportList);
				$('.statBtnY').attr('value','처리');
				$('.statBtnN').attr('value','미처리');

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
				url : 'reportSearch',
				data : {
					"searchOpt" : searchOpt,
					"cnt" : cnt
				},
				dataType : 'JSON',
				success : function(data) {
					//console.log(data);
					searchOption(data.searchList);
					$('.statBtnY').attr('value','처리');
					$('.statBtnN').attr('value','미처리');
				},
				error : function(e) {
					console.log(e);
				}
			});
		}else if(searchOpt == "미처리"){
			
			$.ajax({
				type : 'get',
				url : 'reportNotYet',
				data : {},
				dataType : 'JSON',
				success : function(data) {
					//console.log(data);
					searchOption(data.searchList);
					$('.statBtnY').attr('value','처리');
					$('.statBtnN').attr('value','미처리');
				},
				error : function(e) {
					console.log(e);
				}
			});
		}else{
			alert("1글자 이상 입력해주세요!");
		}
	}
	
	function reportStatusNot(){
		if($("#searchOpt option:selected").val() == "미처리"){
			//$("#searchCnt").attr("value","");
			$("#searchCnt").attr("type","hidden");
		}else{
			//$("#searchCnt").attr("value","");
			$("#searchCnt").attr("type","text");
		}
	}
	
		
	function toggleBtn(idx){
		//console.log("상세사유 보기 버튼 클릭"+idx);
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
		 //console.log("새로고침");
		 location.reload();
	 }
	 
	 function reportChk(reportid){
		 //console.log("신고 처리상태 변경 요청");
		 if($("#statBtn"+reportid).attr('value') == "미처리"){
		 	if(confirm("해당 신고를 처리하시겠습니까?")){
		 		
		 		var adminWho = "${sessionScope.nickName}";
		 		
			 		$.ajax({
					type : 'get',
					url : 'reportChk',
					data : {"reportId" : reportid, "adminWho" : adminWho},
					dataType : 'JSON',
					success : function(data) {
						//console.log(data);
						$("#statBtn"+reportid).attr('value','처리');
					},
					error : function(e) {
						console.log(e);
					}
					});
			 		reloadPage();
			 }
		 }else{
			 alert("이미 처리된 신고입니다!");
		 }
		 
	 }
		 
	
	function drawList(reportList) {
		//console.log(reportList);
		var content = "";

		if (reportList.length == 0) {
			//console.log("들어온 신고가 없을 때");
			alert("신고가 존재하지 않습니다.");
		} else {
			//console.log("들어온 신고가 있을 때");

			reportList.forEach(function(item, idx) {
						console.log(idx, item);
						
						var reportReason = item.categoryId;
						if(reportReason == "r1"){
							reportReason = "부적절한 글";
						}else if(reportReason == "r2"){
							reportReason = "광고성 글";
						}else if(reportReason == "r3"){
							reportReason = "욕설";
						}else if(reportReason == "r4"){
							reportReason = "도배 글";
						}else if(reportReason == "r5"){
							reportReason = "무의미한 글";
						}else if(reportReason == "r6"){
							reportReason = "기타";
						}
						
						var admin = item.managerId;
						var reportIdx = item.reportId;
						//해당 글 또는 댓글로 이동 - 되는지 확인하기!!
						//'<td style="color: blue;" onclick="location.href=\'../postDetail?postId='+item.fieldId+'\'">' 
						
						content += "<tr class='row' style='display:none;'>";
						content += "<td>" + reportIdx + "</td>";
						content += "<td>" + item.userId + "</td>";
						content += '<td><a href="../postDetail?postId='+item.fieldId+'" target="_blank">' + item.classification + item.fieldId + '</a></td>';
						content += "<td>" + reportReason + "</td>";
						content += "<td>" + item.reportDate + "</td>";			
						content += '<td><input type="button" id="toggleBtn'+idx+'" class="toggleBtn" value="보기" onclick="toggleBtn('+idx+')"/></td>';
						content += '<td><input type="button" value="공백" class="statBtn'+item.reportStatus+'" id="statBtn'+reportIdx+'" onclick="reportChk('+reportIdx+')"/></td>';
						content += '<td>' + admin + '</td>';
						content += "</tr>";
						content += "<tr>";
						content += "<td colspan='8' class='toggleBox' id='detailToggle"+idx+"' style='background-color: gray; color:white; padding:8px; text-align: left; display:none;'> 상세사유 : "+item.details+"</td>";
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
			//console.log("검색 결과가 없을 때");
			content += "<tr>";
			content += "<td colspan='8'><p>검색 결과가 없습니다.</p></td>";
			content += "</tr>";

			$("tbody").empty();
			$("tbody").append(content);
		} else {
			//console.log("값이 있을 때");
			//console.log("searchList : " + searchList);
			searchList.forEach(function(item, idx) {
						console.log(idx, item);
						
						var reportReason = item.categoryId;
						if(reportReason == "r1"){
							reportReason = "부적절한 글";
						}else if(reportReason == "r2"){
							reportReason = "광고성 글";
						}else if(reportReason == "r3"){
							reportReason = "욕설";
						}else if(reportReason == "r4"){
							reportReason = "도배 글";
						}else if(reportReason == "r5"){
							reportReason = "무의미한 글";
						}else if(reportReason == "r6"){
							reportReason = "기타";
						}
						
						var admin = item.managerId;
						var reportIdx = item.reportId;					

						content += "<tr class='row' style='display:none;'>";
						content += "<td>" + reportIdx + "</td>";
						content += "<td>" + item.userId + "</td>";
						content += '<td><a href="../postDetail?postId='+item.fieldId+'" target="_blank">' + item.classification + item.fieldId + '</a></td>';
						content += "<td>" + reportReason + "</td>";
						content += "<td>" + item.reportDate + "</td>";
						content += '<td><input type="button" id="toggleBtn'+idx+'" class="toggleBtn" value="보기" onclick="toggleBtn('+idx+')"/></td>';
						content += '<td><input type="button" value="공백" class="statBtn'+item.reportStatus+'" id="statBtn'+reportIdx+'" onclick="reportChk('+reportIdx+')"/></td>';
						content += '<td>' + admin + '</td>';
						content += "</tr>";
						content += "<tr>";
						content += "<td colspan='8' class='toggleBox' id='detailToggle"+idx+"' style='background-color: gray; color:white; padding:8px; text-align: left; display:none;'> 상세사유 : "+item.details+"</td>";
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