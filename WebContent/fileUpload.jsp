<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>fileUpload.jsp</title>
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
				<th colspan='2' style='text-align : center; padding:10px;'>이미지 첨부</th> 
			</tr>
			<tr>
				<th>썸네일</th>
				<td><input id='thumbnail' class='uploadInputBox' type="file" name="thumbnail" /><td>
			</tr>
			<tr>
				<th>첨부 이미지</th>
				<td><input id='content_image' class='uploadInputBox' type="file" name="content_image" /></td>
			</tr>
			<tr>
				<td colspan='2'>
					<div id='preview_wrap'>
						&nbsp;<b>▶ 미리보기</b>
						<div id='th_preview'>
							<p style='font-size : 13px;'>썸네일 미리보기</p><img id="th_img"/>
							<p id='th_preview_p'></p>
						</div>
						<div id='con_preview'>
							<p style='font-size : 13px;'>첨부이미지 미리보기</p><img id="con_img"/>
							<p id='preview_p'></p>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan='2' style='text-align : center;'>
					<div id='buttonArea'></div>
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

	//submit - 파일업로드 후 form을 제출한다
	function submit(){
		
		var form = new FormData();
		form.append("thumbnail", $("#thumbnail")[0].files[0]);
		form.append("content_image", $("#content_image")[0].files[0]);
		var field = "${param.field}";
		form.append("field", field); //post or product
		
		$.ajax({
			url : "./fileUpload",
			type : "POST",
			processData : false,
			contentType : false,
			data : form,
			success:function(result){
				var data = JSON.parse(result);
				if(data.success > 0)
					console.log("ajax fileupload - 이미지 업로드 성공");
				
				//form에 썸네일PK, 이미지PK 데이터 넣어주기
				console.log("ajax data.th_imgId : "+data.th_imgId);
				console.log("ajax data.imgId : "+data.imgId);
				$("#thImg").attr("value", data.th_imgId);
				$("#img").attr("value", data.imgId);
				
				//form 전송
				$("form").submit();
			},
			error:function(e){
				console.log("ajax fileupload error : "+e);
			}
		});
	}
	
	//미리보기
	$(document).ready(function(){ 
		$("#thumbnail").on("change", th_preview);
		$("#content_image").on("change", preview);
	});
	
	function th_preview(e){ //썸네일 미리보기
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
	}
	
	function preview(e){ //첨부이미지 미리보기
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
	}
	
	function del_th(){
		console.log("썸네일 삭제");
		$("#thumbnail").val('');
		$("#th_img").attr("src", '');
		$("#th_img").attr("height", "0px;");
		$("#th_img").attr("width", "0px;");
		$("#th_preview_p").empty();
	}
	
	function del_img(){
		console.log("첨부이미지 삭제");
		$("#content_image").val('');
		$("#con_img").attr("src", '');
		$("#con_img").attr("height", "0px;");
		$("#con_img").attr("width", "0px;");
		$("#preview_p").empty();
	}
	
</script>

</html>