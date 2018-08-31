<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Home</title>
</head>
<body>
	<h1>메인 화면</h1>
	<c:if test="${userId == null}">
		<a href="loginPage">로그인</a>
		<span> / </span>
		<a href="registerPage">회원가입</a>
	</c:if>
	<c:if test="${userId != null}">
		<a href="fixPage">회원 정보 수정</a>
		<span> / </span>
		<a href="secesionPage">회원 탈퇴</a>
		<span> / </span>
		<a href="logout">로그아웃</a>
	</c:if>
	<br>
	<a href="search">사진 검색 페이지로 이동</a>
	<br>
	<a href="analysis">트렌드 분석 페이지로 이동</a>
	<br>
	<a href="weatherNshopping">날씨 및 가격 정보 페이지로 이동</a>
</body>
</html>
