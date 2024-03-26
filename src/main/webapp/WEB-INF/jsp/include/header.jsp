<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex justify-content-between align-items-center">
	<!-- 로고 -->
	<div class="logo ml-3">
		<h2 class="text-light mt-3">나의 산책 일지</h2>
	</div>
	
	<div class="col-6 mt-5">
		<nav>
			<ul class="nav nav-fill">
				<li class="nav-item"><a href="/log/board-view" class="nav-link text-white">메인 화면</a></li>
				<li class="nav-item"><a href="#" class="nav-link text-white">우리 동네 명소</a></li>
				<li class="nav-item"><a href="#" class="nav-link text-white">나의 기록</a></li>
				<li class="nav-item"><a href="/user/edit-view" class="nav-link text-white">환경설정</a></li>
			</ul>
		</nav>
	</div>
	
	<!-- 유저 정보, 로그아웃 버튼 -->
	<div class="login-info d-flex align-items-center">
		<!-- 로그인 상태일 때 -->
		<c:if test="${not empty userId}">
			<div class="mr-3 mt-5">
				<span class="text-white fnt-12 mr-3">${nickname}님 어서오세요!</span>
				<a href="/user/sign-out" class="btn btn-dark btn-sm">로그아웃</a>
			</div>
		</c:if>
		<!-- 로그아웃 상태일 때 -->
		<c:if test="${empty userId}">
			<a href="/user/sign-in-view" class="btn btn-dark btn-sm mr-3 mt-5">로그인</a>
		</c:if>
	</div>
		
</div>