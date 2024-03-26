<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div>
	<div class="profile-box h-60-per wrap loca-mid bg-light">
		<span class="h5 mt-3 d-flex justify-content-center">회원 정보 수정</span>
		<br>
		<div class="d-flex justify-content-center">
			<div class="col-4 d-flex justify-content-end">
				<div id="profileImgCircle" class="bg-dark">
					<!-- 프로필 이미지 들어갈 곳 -->
					<input type="file" id="changeProfilePic" accept=".jpg, .jpeg, .gif, .png" class="d-none">
					<img id="myProfilePic" class="profile-img" src="https://cdn.pixabay.com/photo/2020/06/20/01/24/frog-5319326_1280.jpg">
				</div>
			</div>
			<div class="col-8">
				<form id="userInfoUpdateForm" method="post" action="/user/edit">
					<div class="form-group">
						<div class="d-flex">
							<input type="text" id="nickname" name="nickname" class="form-control col-8" placeholder="닉네임">
							<button type="button" id="nicknameCheckBtn" class="btn btn-dark form-control col-3 ml-3">중복확인</button>
						</div>
						<div id="nicknameDuplicated" class="mt-1 fnt-12 text-danger d-none">중복된 닉네임 입니다.</div>
						<div id="nicknameAvailable" class="mt-1 fnt-12 text-success d-none">사용 가능한 닉네임 입니다.</div>
					</div>
					<div class="form-group d-flex">
						<input type="text" id="email" name="email" class="form-control col-8" placeholder="이메일 주소">
						<!-- 이메일 인증 버튼 (추가한다면) 들어갈 곳 -->
					</div>
					<div class="form-group">
						<input type="text" id="password" name="password" class="form-control col-8" placeholder="비밀번호">
					</div>
					<div class="form-group">
						<input type="text" id="passwordCheck" name="passwordCheck" class="form-control col-8" placeholder="비밀번호 확인">
						<div id="passwordNotSame" class="mt-1 fnt-12 text-danger d-none">비밀번호가 일치하지 않습니다.</div>
					</div>
					<div class="d-flex">
						<button type="button" id="deleteUser" class="btn btn-dark form-control col-3">회원 탈퇴</button>
						<div class="col-2"></div>
						<button type="submit" id="updateUser" class="btn btn-dark form-control col-3">정보 수정</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		// 닉네임 중복 확인 버튼
		$("#nicknameCheckBtn").on('click', function() {
			// 확인 문구 초기화
			$("#nicknameDuplicated").addClass('d-none');
			$("#nicknameAvailable").addClass('d-none');
			
			let nickname = $("#nickname").val().trim();
			alert(nickname);
			
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
			// $("#passwordNotSame").removeClass('d-none');
			
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
		
		// 프로필 이미지 변경
		$("#myProfilePic").on('click', function() {
			$("#changeProfilePic").click();
			
		});
		
		// 회원 탈퇴 버튼
		$("#deleteUser").on('click', function() {
			if(confirm("정말 탈퇴하시겠습니까?") == true) {
				$.ajax({
					type:"DELETE"
					, url:"/user/delete"
					, success:function(data) {
						if (data.code == 200) {
							alert("회원 탈퇴가 완료되었습니다.")
							location.href = "/user/sign-in-view";
						} else {
							alert(data.error_message);
						}
					}
					, error:function(request, status, error) {
						alert("회원 탈퇴에 실패했습니다. 다시 시도 해 주세요.");
					}
				});
			} else {
				return;
			}
		});
		
	});
</script>