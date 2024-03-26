<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div>
	<div class="login-box h-60-per loca-mid bg-light col-3">
		<p class="mt-3 h5">신규 회원 가입</p>
		<br>
		<form id="signUpForm" method="post" action="/user/sign-up">
			<div class="form-group">
				<div class="input-group d-flex justify-content-center">
					<input type="text" id="nickname" name="nickname" class="form-control col-5" placeholder="닉네임">
					<button type="button" id="nicknameCheckBtn" class="btn btn-dark form-control col-3">확인</button>
				</div>
				<div id="nicknameDuplicated" class="mt-1 fnt-12 text-danger text-right d-none">중복된 닉네임 입니다.</div>
				<div id="nicknameAvailable" class="mt-1 fnt-12 text-success text-right d-none">사용 가능한 닉네임 입니다.</div>
			</div>
			<div class="form-group d-flex justify-content-center">
				<input type="text" id="email" name="email" class="form-control col-8" placeholder="이메일 주소">
			</div>
			<div class="form-group d-flex justify-content-center">
				<input type="text" id="password" name="password" class="form-control col-8" placeholder="비밀번호">
			</div>
			<div class="form-group">
				<div class="d-flex justify-content-center">
					<input type="text" id="passwordCheck" name="passwordCheck" class="form-control col-8" placeholder="비밀번호 확인">
				</div>
				<div id="passwordNotSame" class="mt-1 fnt-12 text-danger text-right d-none">비밀번호가 일치하지 않습니다.</div>
			</div>
			<div class="d-flex justify-content-center">
				<button type="submit" id="signUpBtn" class="btn btn-dark col-8">회원 가입</button>
			</div>
			<br>
			<div class="d-flex justify-content-between">
				<span>기존 회원이신가요?</span>
				<a href="/user/sign-in-view">로그인</a>
			</div>
		</form>
	</div>
</div>

<script>
	$(document).ready(function() {
		
		// 닉네임 중복 확인
		$("#nicknameCheckBtn").on('click', function() {
			// 확인 문구 초기화
			$("#nicknameDuplicated").addClass('d-none');
			$("#nicknameAvailable").addClass('d-none');
			
			let nickname = $("#nickname").val().trim();
			// alert(nickname);
			
			$.ajax({
				// request
				url: "/user/is-duplicated-nickname"
				, data: {"nickname":nickname}
				// response
				, success: function(data){
					if (data.is_duplicated_nickname) {
						$("#nicknameDuplicated").removeClass('d-none');
					} else {
						// 사용 가능 (중복x)
						$("#nicknameAvailable").removeClass('d-none');
					}
				}
				, error: function(request, status, error) {
					alert("닉네임 중복 확인에 실패했습니다.")
				}
			});
			
		});
		
		// 비밀번호 일치 확인
		$("#passwordCheck").on('keyup', function() {
			// 문구 초기화
			//$("#passwordNotSame").removeClass('d-none');
			
			let origPw = $("#password").val().trim();
			let currPw = $("#passwordCheck").val().trim();
			
			$.ajax({
				// request
				url: "/user/is-matching-password"
				, data: {"origPw":origPw, "currPw":currPw}
				// response
				, success: function(data) {
					if (data.is_matching_password) {
						$("#passwordNotSame").addClass('d-none');
						// alert("비밀번호 일치");
					} else {
						$("#passwordNotSame").removeClass('d-none');
					}
				}
				, error:function(request, status, error) {
					alert("비밀번호 비교에 실패했습니다.");
				}
			});
		});
		
		// 회원 가입 버튼 클릭
		$("#signUpForm").on('submit', function(e) {
			// submit 자동 수행 중단
			e.preventDefault();
			
			let nickname = $("#nickname").val().trim();
			let email = $("#email").val().trim();
			let origPw = $("#password").val().trim();
			let currPw = $("#passwordCheck").val().trim();
			
			if (nickname == '') {
				alert("닉네임을 입력 해 주세요.");
				return false;
			}
			if (email == '') {
				alert("이메일을 입력 해 주세요.");
				return false;
			}
			if (origPw == '') {
				alert("비밀번호를 입력 해 주세요.");
				return false;
			}
			if (currPw == '') {
				alert("비밀번호 확인을 진행 해 주세요.");
				return false;
			} else if (!($("#passwordNotSame").hasClass("d-none"))) {
				alert("비밀번호가 일치하지 않습니다.");
				return false;
			}
			
			
			// form submit
			let url = $(this).attr("action");
			let data = $(this).serialize();
			
			//**********************
			//alert(data);
			
			$.post(url, data)
			.done(function(data) {
				if (data.result == "성공") {
					location.href="/log/board-view";
				} else {
					alert("회원가입 진행에 실패 했습니다. 다시 시도 해 주세요.");
				}
				
			});
		});
		
	});
</script>