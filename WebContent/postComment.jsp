<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<meta charset="UTF-8">
<title>postComment.jsp</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<style>
div.cmt_wrap {
	background-color: snow;
	width: 1112.360px;
}

div.commentInputBox {
	margin: 10px;
	background-color: lavenderblush;
	padding: 5px;
}

#commentUser {
	display: inline-block;
}

textarea {
	width: 850px;
	height: 80px;
	border: 2px solid #ccc;
	margin: 5px;
	resize: none;
}

#cmtContentUser {
	margin: 10px;
}

div.commentAreaBox {
	margin-left: 50px;
}

#tablediv {
	background-color: gainsboro;
}

.cmtUpdateTbody {
	margin-left: 50px;
}

#cmtCount {
	display: inline;
}

.pageArea{
	margin-top : 20px;
	margin-left : 47%;
}

.page{
	display : inline-block;
	margin : 5px;
	color : rosybrown;
}

.page a{
	color : black;
	text-decoration-line : none;
}

.page a:hover{
	text-decoration-line : underline;
}

button{
	padding: 5px 7px;
	background-color: white;
	color: grey;
	font-size: x-small;
	border: 1px solid;
	margin-left: 4px;
}

button:hover{
	background-color: grey;
	color: white;
}

</style>
<body>

	<div class='cmt_wrap'>
		<div class='cmtCount'>
			&nbsp;
			<p id='cmtCount'></p>
			Comments
		</div>
		<div class='commentInputBox'>
			<div id="emptyComment"></div>
			<b style='color: rosybrown;'>♥ 댓글 작성</b>
			<hr></hr>
			<img src="./staticImg/user.jpeg" id='cmtUser' alt="댓글작성자이미지"
				width=100px height=100px />
			<textarea id='cmtInput' name='cmtInput' placeholder="여기에 댓글을 입력해주세요. ^ㅇ^"></textarea>
			<button id="cmtInputBtn">댓글달기</button>
		</div>

		<div class='commentAreaBox'>
			<table id='commentAreaTable'>
				<tr>
					<td align="center">♡ 댓글을 불러오는 중입니다 ♡</td>
				</tr>
			</table>
		</div>
		
		<div class = "pageArea">
		</div>
	</div>

</body>
<script>
	$(document).ready(function() {
		loadComments(-1,-1);
	});

	function loadComments(page, button) { //댓글 데이터를 불러오는 함수
		console.log("loadComments() 들어옴 page/button : "+page+"/"+button);
		$
				.ajax({
					type : "POST",
					url : "./loadComments", //글번호를 받아 댓글,대댓글 데이터를 반환
					data : {
						postId : "${param.postId}" //글번호를 파라미터로 보낸다
					},
					dataType : 'JSON',
					success : function(data) {
						console.log("ajax로 받아온 data :" + data);
						console.log("ajax로 받아온 data.list :" + data.list);
						console.log("ajax로 받아온 댓글개수 :" + data.cmtNum);
						console.log("ajax로 받아온 totalPage :" + data.totalPage);
						console.log("ajax로 받아온 currPage :" + data.currPage);
						console.log("ajax로 받아온 start :" + data.start);
						console.log("ajax로 받아온 end :" + data.end);
						if (data.list != null) { //DB에서 댓글 데이터를 정상적으로 가져왔다면
							$(".commentAreaBox").show(); //만약 숨겨져있으면 보이게 한다
							$('#cmtCount').html(data.cmtNum);
							drawComments(data.list, data.totalPage, data.currPage, data.start, data.end); //댓글리스트를 브라우저에 그려준다
						} else { //등록된 댓글이 없다면
							$("#emptyComment")
									.html(
											"<b 'color:rosybrown;'>댓글이 없습니다ㅠㅅㅠ 첫 댓글을 등록해보세요!</b>");
							$(".commentAreaBox").hide();
						}
					},
					error : function(e) {
						console.log("ajax loadComments() 에러 : " + e);
					}
				})

	}

		function drawComments(list, totalPage, currPage, start, end) {
		console.log("drawComments() 들어옴");
		var content = "";
		var loginId = "${sessionScope.userId}";
		var loginIdIsAdmin = "${sessionScope.isAdmin}";
		var loginNickName = "${sessionScope.nickName}"

		list.forEach(function(item, idx) {					
			//삭제된 댓글인지, 블라인드된 댓글인지, 댓글인지, 대댓글인지에 따라 처리가 달라진다.
			
			if(item.isDel == "Y"){ //삭제된 댓글이라면?
				content += "<tbody class='cmtTbodyClass' id='cmtTbody"+idx+"'>";
				content += "<tr>";
				content += "<td rowspan='2'><img src=\"./staticImg/user.jpeg\"";
				content +=	" id='cmtContentUser' alt=\"댓글작성자이미지\" width=0px height=0px /></td>";
				content += "<td></td>";
				content += "<td style='color:rosybrown;'><b>삭제된 댓글입니다.</b></td>";
				content += "</tr>";
				content += "</tbody>";
				content += "<tbody>";
				content += "<tr><td colspan='10'><hr/></td></tr>";
				content += "</tbody>";
				
			}else if(item.isBlind == "Y"){ //블라인드된 댓글이라면?
				content += "<tbody class='cmtTbodyClass' id='cmtTbody"+idx+"'>";
				content += "<tr>";
				content += "<td rowspan='2'><img src=\"./staticImg/user.jpeg\"";
				content +=	" id='cmtContentUser' alt=\"댓글작성자이미지\" width=0px height=0px /></td>";
				content += "<td></td>";
				content += "<td style='color:rosybrown;'><b>관리자에 의해 블라인드 처리된 댓글입니다.</b></td>";
				content += "</tr>";
				content += "</tbody>";
				content += "<tbody>";
				content += "<tr><td colspan='10'><hr/></td></tr>";
				content += "</tbody>";
				
			}else if(item.lev == "comment"){ //댓글이라면?
				//댓글 보여주기
				content += "<tbody class='cmtTbodyClass' id='cmtTbody"+idx+"'>";
				content += "<tr>";
				content += "<td rowspan='2'><img src=\"./staticImg/user.jpeg\"";
				content +=	" id='cmtContentUser' alt=\"댓글작성자이미지\" width=80px height=80px /></td>";
				
				//이 댓글의 작성자가 현재 로그인된 유저아이디와 같다면 색깔을 입혀서 보여준다
				if(item.userId == loginId){ 
					content += "<td></td><td style='color:rosybrown;'> <b>작성날짜</b> " + item.comment_date + "</td>";
					content += "<td style='color:rosybrown;'><b>작성자</b> " + item.nickName + "</td>";
					content += "<td style='color:rosybrown;'><b>등급</b> " + item.rankName + "</td>";
				}else{
					content += "<td></td><td> <b>작성날짜</b> " + item.comment_date + "</td>";
					content += "<td><b>작성자</b> " + item.nickName + "</td>";
					content += "<td><b>등급</b> " + item.rankName + "</td>";	
				}
				
				//이 댓글의 작성자가 현재 로그인된 유저아이디와 같다면 수정과 삭제버튼을 보여준다
				if(item.userId == loginId){ 
					content += "<td><button id='cmtUpdateBtn"+idx+"' onclick='cmtUpdateClick("+idx+")'>수정</button></td>";
					content += "<td><button id='cmtDeleteBtn"+idx+"' onclick='cmtDelete("+idx+", \""+item.commentId+"\", \""+item.lev+"\")'>삭제</button></td>";
				}else{
					content += "<td></td><td></td>";
				}
				
				content += "<td><button id='cmtReplyBtn"+idx+"' onclick='cmtReplyClick("+idx+")'>답글</button></td>";
				
				//이 댓글의 작성자가 현재 로그인된 유저아이디와 같지않다면 신고 버튼을 보여준다.
				if(item.userId != loginId){ 
					content += "<td><button id='reportBtn"+idx+"' onclick='cmtReportBtnClick("+idx+", \""+item.commentId+"\", \""+item.lev+"\", \""+item.nickName+"\")'>신고</button></td>";
				}else{
					content += "<td></td>";
				}
				
				//현재로그인아이디가 관리자라면 블라인드 버튼을 보여준다.
				if(loginIdIsAdmin == "Y"){ 
					content += "<td><button id='blindBtn"+idx+"' onclick='cmtBlindBtnClick("+idx+", \""+item.commentId+"\", \""+item.lev+"\", \""+item.nickName+"\")'>블라인드</button></td>";
				}else{
					content += "<td></td>";
				}
				content += "</tr>";
				
				content += "<tr>";
				content += "<td class='cmt_content' colspan='9'>&nbsp;"+ item.comment_content + "</td>";
				content += "</tr>";
				content += "</tbody>";
				
				//댓글 수정하기
				content += "<tbody class='cmtUpdateTbodyClass' id='cmtUpdateTbody"+idx+"'>";
				content += "<tr><td><b style='color:rosybrown;'>&nbsp;♥ 댓글 수정</b></td></tr>";
				content += "<tr>";
				content += "<td rowspan='2'><img src=\"./staticImg/user.jpeg\"";
				content +=		"id='cmtContentUser' alt=\"댓글작성자이미지\" width=80px height=80px /></td>";
				content += "<td></td>";
				content += "<td style='color:rosybrown;'><b>작성날짜</b> "+ item.comment_date + "</td>";
				content += "<td style='color:rosybrown;'><b>작성자</b> "+ item.nickName + "</td>";
				content += "<td style='color:rosybrown;'><b>등급</b> "+ item.rankName + "</td>";
				content += "<td><button id='cmtUpdateSubmitBtn"+idx+"' onclick='javascript:cmtUpdateExecute("+idx+", \""+item.commentId+"\", \""+item.lev+"\")'>저장</button></td>";
				content += "<td><button id='cmtUpdateCancelBtn"+idx+"' onclick='javascript:cmtUpdateCancel("+idx+",\""+item.comment_content+"\")'>취소</button></td>";
				content += "</tr>";
				content += "<tr>";
				content += "<td class='cmt_content"+idx+"' colspan='9'>";
				content += "<textarea id='cmtUpdateInput"+idx+"' name='cmtUpdateInput"+idx+"'";
				content +=	"style='width:500px;'>"+ item.comment_content + "</textarea>";
				content += "</td>";
				content += "</tr>";
				content += "</tbody>";
				
				//대댓글 작성하기
				content += "<tbody class='cmtReplyTbodyClass' id='cmtReplyTbody"+idx+"'>";
				content += "<td rowspan='2' valign='top' align='right'>";
				content +=	"<img src=\"./staticImg/reply1.png\" id='reCmtImg' alt=\"대댓글\" width=30px height=30px />";
				content += "</td>";
				content += "<tr>"
				content += "<td></td><td><b style='color:rosybrown;'>&nbsp;♥ 대댓글 작성</b></td><td></td><td style='color:rosybrown;'><b>작성자</b> "+ loginNickName + "</td>";
				content += "<td><button id='cmtUpdateSubmitBtn"+idx+"' onclick='javascript:cmtReplyExecute("+idx+", \""+item.commentId+"\")'>저장</button></td>";
				content += "<td><button id='cmtUpdateCancelBtn"+idx+"' onclick='javascript:cmtReplyCancel("+idx+",\""+item.comment_content+"\")'>취소</button></td>";				
				content += "</tr>";
				content += "<tr>";
				content += "<td></td>";
				content += "<td></td>";
				content += "<td class='cmt_content"+idx+"' colspan='9'>";
				content += "<textarea id='cmtReplyInput"+idx+"' name='cmtReplyInput"+idx+"'";
				content +=	"style='width:550px;' placeholder='여기에 답글을 입력해주세요. ^ㅇ^'></textarea>";
				content += "</td>";
				content += "</tr>";
				content += "</tbody>";
				
				content += "<tbody>";
				content += "<tr>";
				content += "<td colspan='10'><hr/></td>";
				content += "</tr>";
				content += "</tbody>";
				
			}else{ //대댓글이라면?
				//대댓글 보여주기
				content += "<tbody class='cmtTbodyClass' id='cmtTbody"+idx+"'>";
				content += "<tr>";
				content += "<td rowspan='2' valign='top' align='right'>";
				content +=	"<img src=\"./staticImg/reply1.png\" id='reCmtImg' alt=\"대댓글표시\" width=30px height=30px />"
				content += "&nbsp;&nbsp;</td>";
				
				//이 대댓글의 작성자가 현재 로그인된 유저아이디와 같다면 색깔을 입혀서 보여준다
				if(item.userId == loginId){ 
					content += "<td></td><td style='color:rosybrown;'> <b>작성날짜</b> " + item.comment_date + "</td>";
					content += "<td style='color:rosybrown;'><b>작성자</b> " + item.nickName + "</td>";
					content += "<td style='color:rosybrown;'><b>등급</b> " + item.rankName + "</td>";
				}else{
					content += "<td></td><td> <b>작성날짜</b> " + item.comment_date + "</td>";
					content += "<td><b>작성자</b> " + item.nickName + "</td>";
					content += "<td><b>등급</b> " + item.rankName + "</td>";	
				}
				
				//이 댓글의 작성자가 현재 로그인된 유저아이디와 같다면 수정과 삭제버튼을 보여준다
				if(item.userId == loginId){ 
					content += "<td><button id='cmtUpdateBtn"+idx+"' onclick='cmtUpdateClick("+idx+")'>수정</button></td>";
					content += "<td><button id='cmtDeleteBtn"+idx+"' onclick='cmtDelete("+idx+", \""+item.recomId+"\", \""+item.lev+"\")'>삭제</button></td>";
				}else{
					content += "<td></td><td></td>";
				}
				content += "<td></td>";
					
				//이 대댓글의 작성자가 현재 로그인된 유저아이디와 같지않다면 신고 버튼을 보여준다.
				if(item.userId != loginId){ 
					content += "<td><button id='reportBtn"+idx+"' onclick='cmtReportBtnClick("+idx+", \""+item.recomId+"\", \""+item.lev+"\", \""+item.nickName+"\")'>신고</button></td>";
				}else{
					content += "<td></td>";
				}
				
				//현재 로그인아이디가 관리자라면 블라인드 버튼을 보여준다.
				if(loginIdIsAdmin == "Y"){ 
					content += "<td><button id='blindBtn"+idx+"' onclick='cmtBlindBtnClick("+idx+", \""+item.recomId+"\", \""+item.lev+"\", \""+item.nickName+"\")'>블라인드</button></td>";
				}else{
					content += "<td></td>";
				}
				content += "</tr>";
				
				content += "<tr>";
				content += "<td class='cmt_content' colspan='9'>&nbsp;"+item.comment_content + "</td>";
				content += "</tr>";
				content += "</tbody>";
				
				//대댓글 수정
				content += "<tbody class='cmtUpdateTbodyClass' id='cmtUpdateTbody"+idx+"'>";
				content += "<td rowspan='2' valign='top' align='right'>";
				content +=	"<img src=\"./staticImg/reply1.png\" id='reCmtImg' alt=\"대댓글표시\" width=30px height=30px />";
				content += "</td>";
				content += "<tr><td></td><td><b style='color:rosybrown;'>&nbsp;♥ 대댓글 수정</b></td></tr>";
				content += "<tr>";
				//content += "<td rowspan='2'>";
				//content +=	"<img src=\"./staticImg/user.jpeg\" id='cmtContentUser' alt=\"댓글작성자이미지\" width=70px height=70px />";
				//content += "</td>";
				content += "<td></td>";
				content += "<td></td>";
				content += "<td style='color:rosybrown;'><b>작성날짜</b> "+ item.comment_date + "</td>";
				content += "<td style='color:rosybrown;'><b>작성자</b> "+ item.nickName + "</td>";
				content += "<td style='color:rosybrown;'><b>등급</b> "+ item.rankName + "</td>";
				content += "<td>&nbsp;</td>";
				content += "<td><button id='cmtUpdateSubmitBtn"+idx+"' onclick='javascript:cmtUpdateExecute("+idx+", \""+item.recomId+"\", \""+item.lev+"\")'>저장</button></td>";
				content += "<td><button id='cmtUpdateCancelBtn"+idx+"' onclick='javascript:cmtUpdateCancel("+idx+",\""+item.comment_content+"\")'>취소</button></td>";
				content += "</tr>";
				content += "<tr>";
				content += "<td></td>";
				content += "<td></td>";
				content += "<td class='cmt_content"+idx+"' colspan='9'>";
				content += "<textarea id='cmtUpdateInput"+idx+"' name='cmtUpdateInput"+idx+"'";
				content +=	"style='width:500px;'>"+ item.comment_content + "</textarea>";
				content += "</td>";
				content += "</tr>";
				content += "</tbody>";
				
				content += "<tbody>";
				content += "<tr>";
				content += "<td colspan='10'><hr/></td>";
				content += "</tr>";
				content += "</tbody>";
			}
		});

		$("#commentAreaTable").empty(); //기존 내용을 비우기
		$("#commentAreaTable").append(content);
		
		var i = 0;
		content = "";
		//페이징
		content += "<button type='button' onclick='loadComments("+start+", 1)'>이전</button>"
		console.log("======페이징 시작=====");
		//console.log("typeof(totalPage) : "+typeof(totalPage));
		console.log("start / totalPage : "+start+"/"+totalPage);
		if(totalPage < end){
			for(i=start; i<=totalPage; i++){
				content += "<div class='page'>";
				if(i == currPage){
					content += ("<b>"+i+"</b>");
				}else{
					content += ("<a href='javascript:loadComments("+i+",-1)'>"+i+"</a>");					
				}
				console.log("totalPage<end여서 for문 끝!!");
				content += "</div>";
			}
		}else{
			for(i=start; i<end; i++){
				content += "<div class='page'>";
				if(i == currPage){
					content += ("<b>"+i+"</b>");
				}else{
					content += ("<a href='javascript:loadComments("+i+",-1)'>"+i+"</a>");
				}
				content += "</div>";
			}
		}
		content += "<button type='button' onclick='loadComments("+end+", 2)'>다음</button>";
		content += "<div style='height:50px'>&nbsp;</div>";
		
		$(".pageArea").empty();
		$(".pageArea").append(content);

		//댓글 수정창 숨기기
		$(".cmtUpdateTbodyClass").hide();
		
		//대댓글 작성창 숨기기
		$(".cmtReplyTbodyClass").hide();
	}

	
	//댓글 작성
	$("#cmtInputBtn").click(function() { //댓글 달기 버튼 클릭 시

		if ($("#cmtInput").val() == null || $("#cmtInput").val() == "") {
			alert("댓글 내용을 입력해주세요.");
			return;
		}

		$.ajax({
			url : "./writeComment",
			type : "POST",
			dataType : "JSON",
			data : {
				postId : "${param.postId}",
				content : $("#cmtInput").val()
			},
			success : function(data) {
				if(data.success){
					alert("댓글 등록에 성공했습니다.");
					$("#cmtInput").val('');
					loadComments(-1,-1);
				}else{
					alert("댓글 등록에 실패했습니다.");
					loadComments(-1,-1);
				}
			}
		})
	})
	
	
	//댓글 및 대댓글 수정(공용)
	//댓글 수정 버튼 클릭 시
	function cmtUpdateClick(idx){ 
		console.log("cmtUpdateClick() idx : "+idx);
		$("#cmtTbody"+idx).hide();
		$("#cmtUpdateTbody"+idx).show();
	}
	
	//댓글 수정 취소 버튼 클릭 시
	function cmtUpdateCancel(idx, ex_content){ 
		console.log("cmtUpdateCancel() idx : "+idx);
		$("#cmtUpdateInput"+idx).val(ex_content);
		$("#cmtUpdateTbody"+idx).hide();
		$("#cmtTbody"+idx).show();
	}
	
	//댓글 수정 저장 버튼 클릭 시
	function cmtUpdateExecute(idx, commentId, lev){ 
		console.log("cmtUpdateExecute() idx/commentId/lev : "+idx+"/"+commentId+"/"+lev);
		$("#cmtTbody"+idx).hide();
		$("#cmtUpdateTbody"+idx).show();
		
		console.log("cmtUpdateExecute() 수정내용 : "+idx+"/"+commentId+"/"+lev);
		
		if ($("#cmtUpdateInput"+idx).val() == null || $("#cmtUpdateInput"+idx).val() == "") {
			alert("수정할 댓글 내용을 입력해주세요.");
			return;
		}

		$.ajax({
			url : "./updateComment",
			type : "POST",
			dataType : "JSON",
			data : {
				commentId : commentId,
				lev : lev,
				content : $("#cmtUpdateInput"+idx).val()
			},
			success : function(data) {
				if(data.success){
					alert("댓글 수정에 성공했습니다.");
					loadComments(-1,-1);
				}else{
					alert("댓글 수정에 실패했습니다.");
					loadComments(-1,-1);
				}
			}
		})
	}
	
	//대댓글 작성
	//답글 달기 버튼 클릭 시
	function cmtReplyClick(idx){ 
		console.log("cmtReplyClick() idx : "+idx);
		$("#cmtReplyTbody"+idx).show();
	}
	
	//대댓글 작성 취소 버튼 클릭 시
	function cmtReplyCancel(idx, ex_content){ 
		console.log("cmtReplyCancel() idx : "+idx);
		$("#cmtReplyInput"+idx).val('');
		$("#cmtReplyTbody"+idx).hide();
	}
	
	//대댓글 작성 저장 버튼 클릭 시
	function cmtReplyExecute(idx, commentId){ 
		console.log("cmtReplyExecute() idx/commentId : "+idx+"/"+commentId);
		console.log("cmtReplyExecute() 작성내용 : "+$("#cmtReplyInput"+idx).val());
		
		if ($("#cmtReplyInput"+idx).val() == null || $("#cmtReplyInput"+idx).val() == "") {
			alert("대댓글 내용을 입력해주세요.");
			return;
		}

		$.ajax({
			url : "./writeRecomment",
			type : "POST",
			dataType : "JSON",
			data : {
				commentId : commentId,
				content : $("#cmtReplyInput"+idx).val()
			},
			success : function(data) {
				if(data.success){
					alert("대댓글 작성에 성공했습니다.");
					loadComments(-1,-1);
				}else{
					alert("대댓글 작성에 실패했습니다.");
					loadComments(-1,-1);
				}
			}
		})
	}
	
	//댓글 및 대댓글 삭제(공용)
	//댓글 삭제 버튼 클릭 시
	function cmtDelete(idx, commentId, lev){ 
		console.log("cmtDelete() idx/commentId/lev : "+idx+"/"+commentId+"/"+lev);
		if(confirm("정말 삭제하시겠습니까?") == true){
			console.log("댓글 삭제 진행");
	
			$.ajax({
				url : "./deleteComment",
				type : "POST",
				dataType : "JSON",
				data : {
					commentId : commentId,
					lev : lev
				},
				success : function(data) {
					if(data.success){
						alert("댓글 삭제에 성공했습니다.");
						loadComments(-1,-1);
					}else{
						alert("댓글 삭제에 실패했습니다.");
						loadComments(-1,-1);
					}
				}
			})
		}else{
			console.log("댓글 삭제 취소");
			return;
		}
	}
	
	//신고 버튼 클릭 시
	function cmtReportBtnClick(idx, commentId, lev, nickName){ //idx, (대)댓글번호, 레벨(댓글인지 대댓글인지), 댓쓴이 닉네임
		console.log("cmtReportBtnClick() idx/commentId/lev/nickName : "+idx+"/"+commentId+"/"+lev+"/"+nickName);
		var url = "";
		if(lev == "comment"){
			url = "./memberReport?classification=C&&postId="+commentId+"&&nickName="+nickName;
		}else{
			url = "./memberReport?classification=R&&postId="+commentId+"&&nickName="+nickName;
		}
		console.log("url : "+url);
		var option = "width=650, height=500, top=500, location = no, resizable = no";
        window.open(url, "commentReport", option);
	}
	
	//블라인드 버튼 클릭 시
	function cmtBlindBtnClick(idx, commentId, lev, nickName){ //idx, (대)댓글번호, 레벨(댓글인지 대댓글인지), 댓쓴이 닉네임
		console.log("cmtBlindBtnClick() idx/commentId/lev : "+idx+"/"+commentId+"/"+lev+"/"+nickName);
		var url = "";
		if(lev == "comment"){
			url = "./memberBlind?classification=C&&postId="+commentId+"&&nickName="+nickName;
		}else{
			url = "./memberBlind?classification=R&&postId="+commentId+"&&nickName="+nickName;
		}
        var option = "width=650, height=500, top=500, location = no, resizable = no";
        console.log("url : "+url);
        window.open(url, "commentBlind", option);
	}
	
</script>
</html>








