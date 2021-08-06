<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>fileUpdate.jsp</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
</head>
<style>
div .fileUpload_wrap {
	margin : 10px;
}
#uploadInput {
	border: 2px solid skyblue;
	align: center;
	margin: 10px;
	width : 700px;
}
#preview_wrap, #th_preview, #con_preview {
	border: 1px solid #ccc;
	align: center;
	margin: 10px;
	padding : 5px;
}
</style>
<body>
	<div class='fileUpload_wrap'>
		<table id='uploadInput'>
			<tr>
				<th colspan='3' style='text-align : center; padding:10px;'>이미지 수정</th> 
			</tr>
			<tr>
				<th>썸네일</th>
				<td>
					<input id='thumbnail' class='uploadInputBox' type="file" name="thumbnail"/>
				</td>
			</tr>
			<tr>
				<th>첨부 이미지</th>
				<td>
					<input id='content_image' class='uploadInputBox' type="file" name="content_image" />
				</td>
			</tr>
			<tr>
				<td colspan='3'>
					<div id='preview_wrap'>
						&nbsp;<b>▶ 미리보기</b>
						<div id='th_preview'>
							<p style='font-size : 13px;'>썸네일 미리보기</p>
							<img id="th_img" src="/photo/${param.ex_thumbnail_Name}" width='150px' height='150px'/>
							<p id='th_preview_p'><button type='button' onclick='del_ex_th()'>삭제</button></p>
						</div>
						<div id='con_preview'>
							<p style='font-size : 13px;'>첨부이미지 미리보기</p>
							<img id='con_img' src='/photo/${param.ex_contentImg_Name}' width='150px' height='150px'/>
							<p id='preview_p'><button type='button' onclick='del_ex_img()'>삭제</button></p>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan='3' style='text-align : center;'>
					<div id='cancelBtnArea'>
					<button type='button' onclick='img_cancel()'>변경취소</button>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- 기존 form이나 ajax에 전송한 이미지의 imgId를 추가해서 전달 -->
	
	<form action="./test" method="POST">
		<p>썸네일 PK : <input type='text' id='thImg' name='thImg'/></p>
		<p>첨부이미지 PK : <input type='text' id='img' name='img'/></p>
	</form>
	<button id='submitBtn' type='button' onclick='javascript:submit()'>저장</button>
	
</body>
<script>
var flag = false; //true일 때 ajax요청을 보낸다.
	
//submit - 파일업로드 후 form을 제출한다
function submit(){
	if(flag){
		var form = new FormData();
		form.append("thumbnail", $("#thumbnail")[0].files[0]);
		form.append("content_image", $("#content_image")[0].files[0]);
		form.append("fieldId", "${param.fieldId}");
		form.append("field", "${param.field}");
		form.append("del_thumbnail", $("input[name='thImg']").val());
		form.append("del_content_image", $("input[name='img']").val());
		
		$.ajax({
			url : "./fileUpload",
			type : "POST",
			processData : false,
			contentType : false,
			data : form,
			success:function(result){
				var data = JSON.parse(result);
				if(data.success > 0)
				//form에 썸네일PK, 이미지PK 데이터 넣어주기
				$("#thImg").attr("value", data.th_imgId);
				$("#img").attr("value", data.imgId);
				
				//form 전송
				$("form").submit();
			},
			error:function(e){
				console.log("ajax fileupdate error : "+e);
			}
		});
	}else{ //flag=false일 경우 ajax통신을 하지 않고 form만 전송한다.
		$("form").submit();
	}
} //end submit()
	
$(document).ready(function(){ 
	$("#cancelBtnArea").hide();
	$("#thumbnail").on("change", th_preview);
	$("#content_image").on("change", preview);
});
	
function th_preview(e){ //썸네일 미리보기
	flag=true; //새로 파일이 업로드되었으므로 ajax통신 필요 
	//지울 썸네일에 기존썸네일imgId 넣기
	$("#thImg").val('${param.ex_thumbnail}');

	var files = e.target.files;
	var filesArr = Array.prototype.slice.call(files);
	
	var reg = /(.*?)\/(jpg|jpeg|png|bmp)$/;
	
	filesArr.forEach(function(f){
		if(!f.type.match(reg)){
			alert("jpg, jpeg, png, bmp 확장자의 이미지파일만 가능합니다.");
			return;
		}
		var reader = new FileReader();
		reader.onload = function(e){
			$("#th_img").attr("src", e.target.result);
			$("#th_img").attr("width", "150px;");
			$("#th_img").attr("height", "150px;");
			$("#th_preview_p").html("<button type='button' onclick='del_th()'>삭제</button>");
		}
		reader.readAsDataURL(f);
	});
	//변경취소 버튼 보이게 하기
	$("#cancelBtnArea").show();
}
	
function preview(e){ //첨부이미지 미리보기
	flag=true; //새로 파일이 업로드되었으므로 ajax통신 필요
	//지울 이미지에 기존이미지imgId 넣기
	$("#img").val('${param.ex_contentImg}');
	
	var files = e.target.files;
	var filesArr = Array.prototype.slice.call(files);
	
	var reg = /(.*?)\/(jpg|jpeg|png|bmp)$/;
	
	filesArr.forEach(function(f){
		if(!f.type.match(reg)){
			alert("jpg, jpeg, png, bmp 확장자의 이미지파일만 가능합니다.");
			return;
		}
		
		var reader = new FileReader();
		reader.onload = function(e){
			$("#con_img").attr("src", e.target.result);
			$("#con_img").attr("width", "150px;");
			$("#con_img").attr("height", "150px;");
			$("#preview_p").html("<button type='button' onclick='del_img()'>삭제</button>");
		}
		reader.readAsDataURL(f);
	});
	//변경취소 버튼 보이게 하기
	$("#cancelBtnArea").show();
}

function del_th(){ //미리보기에서 썸네일이 삭제될 경우
	console.log("썸네일 삭제");
	$("#thumbnail").val('');
	$("#th_img").attr("src", '');
	$("#th_img").attr("height", "0px;");
	$("#th_img").attr("width", "0px;");
	$("#th_preview_p").empty();
}

function del_img(){ //미리보기에서 이미지가 삭제될 경우
	console.log("첨부이미지 삭제");
	$("#content_image").val('');
	$("#con_img").attr("src", '');
	$("#con_img").attr("height", "0px;");
	$("#con_img").attr("width", "0px;");
	$("#preview_p").empty();
}

function del_ex_th(){ //기존 썸네일이 삭제될 경우
	flag=true;
	$("#thImg").val('${param.ex_thumbnail}');
	
	$("#th_img").attr("src", '');
	$("#th_img").attr("height", "0px;");
	$("#th_img").attr("width", "0px;");
	$("#th_preview_p").empty();
	//변경취소 버튼 보이게 하기
	$("#cancelBtnArea").show();
}

function del_ex_img(){ //기존 이미지가 삭제될 경우
	flag=true;
	$("#img").val('${param.ex_contentImg}');
	
	$("#con_img").attr("src", '');
	$("#con_img").attr("height", "0px;");
	$("#con_img").attr("width", "0px;");
	$("#preview_p").empty();
	//변경취소 버튼 보이게 하기
	$("#cancelBtnArea").show();
}

function img_cancel(){ //이미지 변경이 취소될 경우
	//초기 상태로 되돌아간다
	flag=false;
	//지울 이미지 없던걸로 초기화
	$("#thImg").val('');
	$("#img").val('');
	//file input초기화
	$("#thumbnail").val('');
	$("#content_image").val('');
	
	//미리보기 초기화
	$("#th_preview").empty();
	$("#th_preview").html(
	"<p style='font-size : 13px;'>썸네일 미리보기</p><img id='th_img' src='/photo/${param.ex_thumbnail_Name}' width='150px' height='150px'/><p id='th_preview_p'><button type='button' onclick='del_ex_th()'>삭제</button></p>"
	);
	$("#con_preview").empty();
	$("#con_preview").html(
	"<p style='font-size : 13px;'>첨부이미지 미리보기</p><img id='con_img' src='/photo/${param.ex_contentImg_Name}' width='150px' height='150px'/><p id='preview_p'><button type='button' onclick='del_ex_img()'>삭제</button></p>"
	);
	
	$("#cancelBtnArea").hide();
}
</script>

</html>