<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일업로드 실험</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
</head>
<body>
<!-- 파일 업로드 import-->
<c:import url="./fileUpload.jsp" charEncoding="utf-8">
	<c:param name="field" value="post or product"/>
</c:import>
</body>
</html>