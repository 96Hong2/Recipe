<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일수정 실험</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
</head>
<body>
<!-- 파일 업데이트 import - 예시로 넣어둔 값 지우고 자기꺼 EL태그 넣기 -->
<c:import url="./fileUpdate.jsp" charEncoding="utf-8">
	<c:param name="field" value="product"/>
	<c:param name="fieldId" value="20"/>
	<c:param name="ex_thumbnail" value="143"/>
	<c:param name="ex_contentImg" value="142"/>
	<c:param name="ex_thumbnail_Name" value="1628042619428.jpeg"/>
	<c:param name="ex_contentImg_Name" value="1628042619437.jpg"/>
</c:import>
</body>
</html>