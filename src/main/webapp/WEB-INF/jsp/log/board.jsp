<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="loca-mid h-60-per w-100-per d-flex">
	<!-- 왼쪽 영역 -->
	<div class="col-8 bg-info">
	</div>
	<!-- 오른쪽 영역 -->
	<div class="col-3">
		<!-- 오른쪽 위 -->
		<div class="h-60-per bg-info">
			<!-- 날씨 정보 -->
			<div id="dailyInfoBox" class="d-flex mx-2">
				<div class="col-8 bg-light">
					<div id = "today" class="h6 pt-3 pl-2"></div>
					<div class="fnt-12">
						<span id="currWeatherInfo"></span><br>
						<span id="currDustInfo">미세먼지 정보</span>
					</div>
				</div>
				<div class="col-4 bg-primary">a</div>
			</div>
			<!-- 목표 -->
			<div>
			</div>
		</div>
		<!-- 오른쪽 아래 -->
		<div class="h-40-per bg-light">
			<div class="h6 pt-3 pl-2">오늘의 산책</div>
			<hr class="my-2 mx-2">
			<form id="dailyLogRecord" method="post" action="/log/do-record">
				<div class="d-flex fnt-12 mx-3 align-bottom">
					<input type="text" name="distance" class="form-control form-control-sm col-2">
					<span class="form-text m-1">km</span>
					<input type="text" name="steps" class="form-control form-control-sm col-3">
					<span class="form-text m-1">걸음</span>
					<input type="text" name="duration" class="form-control form-control-sm col-3">
					<span class="form-text ml-1">분</span>
				</div>
				<div class="ml-3 mt-2 form-group d-flex ">
					<input type="text" id="comment" name="comment" class="form-control form-control-sm col-8">
					<button type="submit" class="btn btn-sm btn-dark fnt-12 ml-3">기록하기</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		
		// 날짜
		var date = new Date();
		var mm = date.getMonth() + 1; // 0~11을 리턴하므로 +1을 해준다
		var dd = date.getDate();
		var day = date.getDay();
		switch(day) {
		case 0:
			day = "일";
			break;
		case 1:
			day = "월";
			break;
		case 2:
			day = "화";
			break;
		case 3:
			day = "수";
			break;
		case 4:
			day = "목";
			break;
		case 5:
			day = "금";
			break;
		case 6:
			day = "토";
			break;
		}
		
		var today = mm + "월 " + dd + "일 " + day + "요일";
		$("#today").text(today);
		
		// 날씨 업데이트
		$.updateWeather = function() {
			$.ajax({
				// request
				type:"get"
				, url:"/weather/forecast"
				, data:{"x":60, "y":127} // 우선은 서울시로 설정
			
				// response
				, success:function(data) {
					var temperature = data.temperature;
					var weather = data.weather;
					$("#currWeatherInfo").replaceWith(temperature, "°C / ", weather);
				}
				, error:function(request, status, error) {
					alert("날씨 정보를 불러올 수 없습니다.");
				}
			});
				
		
		}
		
		
		$.updateWeather();
		setInterval(function() {
			$.updateWeather();
		}, 90000); // 90초에 한번씩 업데이트
		
		
		// 오늘의 산책 기록
		$("#dailyLogRecord").on('submit', function(e) {
			// submit 자동 수행 중단
			e.preventDefault();
			
			let comment = $("#comment").val().trim();
			
			// form submit
			let url = $(this).attr("action");
			let data = $(this).serialize();
			
			alert(data);
			
			$.post(url, data)
			.done(function(data) {
				if (data.result == "성공") {
					location.href="/log/board-view";
				} else {
					alert("일지 기록에 실패했습니다.");
				}
				
			});
		});
		
	});
</script>