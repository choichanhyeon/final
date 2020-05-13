<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<!DOCTYPE html>

<html>
<head>
	<meta charset="EUC-KR">

	<title>Home</title>
	
	<!-- start :: bootstrap -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
	<!-- end :: bootstrap -->
	
	<!-- start :: css -->
	<link href="/resources/css/master.css" rel="stylesheet" type="text/css">
	<style type="text/css">
	
	</style>
	<!-- end :: css -->
	
	<!-- start :: plain join -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript">
	$(function(){
		$("#joinchk").hide();
		
		$("#member_email").keyup(function(){
			var member_email = $("#member_email").val().trim();
			console.log(member_email)
			var joinVal = {
				"member_email" : member_email
			}
			
			$.ajax({
				type: "post",
				url: "/member/ajaxemailcheck",
				data: JSON.stringify(joinVal),
				contentType: "application/json",
				dataType: "json",
				
				success: function(msg){
					
					if (msg.check == true) {
						$("#joinchk").show().html("이미 존재하는 EMAIL 입니다.").css("color","red")
					} else {
						$("#joinchk").show().html("사용가능한 EMAIL 입니다.").css("color","green")
					}

				},
				
				error: function(){
					alert("통신실패");
				}
			})
		})
		
		
		$("#member_id").keyup(function(){
			var member_id = $("#member_id").val().trim();
			var joinVal = {
				"member_id" : member_id
			}
			
			$.ajax({
				type: "post",
				url: "/member/ajaxidcheck",
				data: JSON.stringify(joinVal),
				contentType: "application/json",
				dataType: "json",
				
				success: function(msg){
					
					if (msg.check == true) {
						$("#joinchk").show().html("이미 존재하는 ID 입니다.").css("color","red")
					} else {
						$("#joinchk").show().html("사용가능한 ID 입니다.").css("color","green")
					}

				},
				
				error: function(){
					alert("통신실패");
				}
			})
		})
	})

	function join(){
		var member_email = $("#member_email").val().trim();
		var member_name = $("#member_name").val().trim();
		var member_id = $("#member_id").val().trim();
		var member_password = $("#member_password").val().trim();
		
		if(member_email == null || member_email == "" 
				|| member_name == null || member_name == "" 
				|| member_id == null || member_id == "" 
				|| member_password == null || member_password == ""){
			
			alert("EMAIL, NAME, ID, PASSWORD 를 모두 입력해주세요!")
			
		} else if ($("#joinchk").html() == "이미 존재하는 ID 입니다."){
			
			alert("이미 존재하는 ID 입니다!!");
			$("#member_id").val("");
			$("#member_id").focus();
		
		} else if ($("#joinchk").html() == "이미 존재하는 EMAIL 입니다."){
		
			alert("이미 존재하는 EMAIL 입니다!!");
			$("#member_email").val("");
			$("#member_email").focus();
		
		} else {
		
			$("#joinForm").submit();
		
		}
	}
	
	</script>
	
	<!-- end :: plain join -->
</head>


<body>

	<section class="container w-50">
	 	
		
		<div class="card p-4 my-3">
			<h1 class="card-title text-center">
				instagram
			</h1>
			<h3>
				친구들의 사진과 동영상을 보려면 가입하세요.
			</h3>
			
			<div>
				<span>
					<a id="custom-login-btn" href="javascript:loginWithKakao()">
						<img src="../resources/images/social/kakaolink_btn_medium.png" width="100px;"/>
					</a>
				</span>
				<span>
					<a id="naver_id_login"></a>
				</span>
			</div>	
			
			<div>
				<hr>
			</div>
			
			<div class="card-body">		
				<form id="joinForm" action="/member/join" method="post">
					<!-- <label for="email">이메일</label> -->
					<div class="input-group mb-3">
						<input id="member_email" class="form-control" type="text" name="member_email" required="required" placeholder="휴대폰 번호 또는 이메일 주소">
					</div>	
					
					<!-- <label for="name">성명</label> -->
					<div class="input-group mb-3">
						<input id="member_name" class="form-control" type="text" name="member_name" required="required" placeholder="성명">
					</div>
					
					<!-- <label for="id">사용자 이름</label> -->
					<div class="input-group mb-3">
						<input id="member_id" class="form-control" type="text" name="member_id" required="required" placeholder="사용자 이름">
					</div>
					
					<!-- <label for="password">비밀번호</label> -->
					<div class="input-group mb-3">
						<input id="member_password" class="form-control" type="password" name="member_password" required="required" placeholder="비밀번호">
					</div>
					
					
					
					<div class="input-group mb-3">
						<input class="btn btn-block btn-lg btn-primary" type="button" value="회원가입" onclick="join();">
					</div>
					
					<div id="joinchk">
					
					</div>
				</form>

			</div>		
			
		</div>

	 
	 	<div class="card p-4 my-3">
 			<div class="text-center">
				계정이 있으신가요?
				<a class="card-link" href="/member/login">&nbsp;로그인 </a>
			</div>
		</div>
	</section>
	
	
	<!-- 실제 서버로 전송되는 FORM -->
	<form id=hiddenForm action="/DEVCA/member/login.do" method="post">
		<input type="hidden" name="MEMBER_EMAIL" /> 
		<input type="hidden" name="MEMBER_PASSWORD" />
	</form>		
		
	<!-- START :: SNSJOIN 팝업창으로 전송되는 form -->
	<form id="snsHiddenForm" action="" method="post">
		<input type="hidden" name="snsType">
		<input type="hidden" name="SNS_ID" /> 
		<input type="hidden" name="SNS_NICKNAME" /> 			
		<input type="hidden" name="SNS_EMAIL" />
		<input type="hidden" name="access_token" />
	</form>
	<!-- END :: SNSJOIN 팝업창으로 전송되는 form -->
	
	<!-- START :: SNSJOIN 시 실제 서버로 전송되는 form -->
	<form id="snsJoinHiddenForm" action="/DEVCA/member/snsjoin.do" method="post">
		<input type="hidden" name="snsType">
		
		<input type="hidden" name="MEMBER_NAME">
		<input type="hidden" name="MEMBER_EMAIL">
		<input type="hidden" name="MEMBER_PHONE">
			
		<input type="hidden" name="SNS_ID" /> 
		<input type="hidden" name="SNS_NICKNAME" /> 	
		<input type="hidden" name="access_token" />
	</form>
	<!-- END :: SNSJOIN 시 실제 서버로 전송되는 form -->
	
	<!-- START :: SNSLOGIN 시 실제 서버로 전송되는 form -->
	<form id="snsLoginHiddenForm" action="/DEVCA/member/loginsns.do" method="post">
		<input type="hidden" name="snsType">
	
		<input type="hidden" name="SNS_ID">
		<input type="hidden" name="access_token">
	</form>
	<!-- END :: SNSLOGIN 시 실제 서버로 전송되는 form -->
</body>

	<!-- START :: KAKAO LOGIN -->
	<script type="text/javascript">
	function loginWithKakaoRest(){	
		location.href='${kakaoLoginLink}'
	}
	</script>
	<!-- END :: KAKAO LOGIN -->

	<!-- START :: NAVER LOGIN -->
	<script type="text/javascript">
	var naver_id_login = new naver_id_login("irD1NHw9tD2Loycjai2X", "http://qclass.iptime.org:8787/DEVCA/views/member/navercallback.jsp");
	  	var state = naver_id_login.getUniqState();
	  	naver_id_login.setButton("green", 1, 100);
	    naver_id_login.setDomain("http://qclass.iptime.org:8787/DEVCA");
	  	naver_id_login.setState(state);
	  	naver_id_login.setPopup();
	  	naver_id_login.init_naver_id_login();
	</script>
	<!-- END :: NAVER LOGIN -->

</html>
