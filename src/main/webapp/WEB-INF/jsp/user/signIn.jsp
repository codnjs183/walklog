<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div>
	<div class="login-box h-60-per loca-mid bg-light col-3">
		<p class="mt-3 h5">기존 회원 로그인</p>
		<br>
		<form id="loginForm" action="/user/sign-in" method="post">
			<div class="form-group">
				<input type="text" class="form-control" id="email" name="email" placeholder="이메일 주소">
			</div>
			<div class="form-group">
				<input type="text" class="form-control" id="password" name="password" placeholder="비밀번호">
			</div>
			<br>
			<div class="d-flex justify-content-center">
				<button type="submit" class="btn btn-dark btn-block col-8">로그인</button>
			</div>
			<br>
			<div class="d-flex justify-content-between">
				<span>아직 회원이 아니신가요?</span>
				<a href="/user/sign-up-view">회원가입</a>
			</div>
		</form>
	</div>
</div>

<script>
	$(document).ready(function() {
		$("#loginForm").submit(function(e) {
			// submit 자동 수행 중단
			e.preventDefault();
			
			let email = $("#email").val().trim();
			let password = $("#password").val().trim();
			
			if (email == '') {
				alert("이메일을 입력해주세요.");
				return false;
			}
			if (password == '') {
				alert("비밀번호를 입력해주세요.");
				return false;
			}
			
			// login submit
			let url = $(this).attr("action");
			let data = $(this).serialize();
			
			$.post(url, data)
			.done(function(data) {
				if (data.result == "성공") {
					location.href="/log/board-view";
				} else {
					alert(data.errorMessage);
					// alert("로그인에 실패 했습니다. 다시 시도 해 주세요.");
				}
			}); 
		});
		
	});
</script>