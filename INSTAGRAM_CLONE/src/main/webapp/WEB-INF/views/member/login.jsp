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
	
	<!-- start :: plain login -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
	<script type="text/javascript">
	
	$(function(){
		$("#loginchk").hide();
	})
	
	function login(){
		var member_email = $("#member_email").val().trim();
		var member_password = $("#member_password").val().trim();
		
		if(member_email == null || member_email == "" 
				|| member_password == null || member_password == ""){
			alert("입력한 사용자 이름을 사용하는 계정을 찾을 수 없습니다. 사용자 이름을 확인하고 다시 시도하세요.")
		}else{
			
			$.ajax({
				type: "post",
				url: "/member/login",
				data: JSON.stringify({
					"member_email" : member_email,
					"member_password" : member_password
				}),
				contentType: "application/json",
				dataType: "json",
				
				success: function(msg){
					
					if (msg.check == true) {
						location.href="/feed/feed";
					} else {
						$("#loginchk").show().html("입력한 사용자 이름을 사용하는 계정을 찾을 수 없습니다. 사용자 이름을 확인하고 다시 시도하세요.").css("color","red")
					}
	
				},
				
				error: function(){
					alert("통신실패");
				}
			})
		}
		
	}
	</script>
	
	<!-- end :: plain login -->
</head>


<body>

	<section class="container w-50">
	 	
		
		<div class="card p-4 my-3">
			<h1 class="card-title text-center">
				instagram
			</h1>
			
			<div class="card-body">		
					
				<!-- <label for="email">이메일</label> -->
				<div class="input-group mb-3">
					<input id="member_email" class="form-control" type="text" name="member_email" required="required" placeholder="전화번호, 사용자 이름 또는 이메일">
				</div>	
				
				<!-- <label for="password">비밀번호</label> -->
				<div class="input-group mb-3">
					<input id="member_password" class="form-control" type="password" name="member_password" required="required" placeholder="비밀번호">
				</div>				
				
				<div class="input-group mb-3">
					<input class="btn btn-block btn-lg btn-primary" type="button" value="로그인" onclick="login();">
				</div>


			</div>
			
			<div>
				<hr>
			</div>
			
			<div>
				<span>
					<a id="custom-login-btn" href="javascript:loginWithKakaoRest()">
						<img src="/resources/images/social/kakaolink_btn_medium.png" width="100px;"/>
					</a>
				</span>
				<span>
					<a id="naver_id_login"></a>
				</span>
				
				<div id="loginchk">
					
				</div>
				
				<div class="text-center">
					<a class="card-link" href="#">비밀번호를 잊으셨나요?</a>
				</div>
			</div>			
			
		</div>

	 
	 	<div class="card p-4 my-3">
 			<div class="text-center">
				계정이 없으신가요?
				<a class="card-link" href="/member/join">&nbsp;가입하기 </a>
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
<!-- 	<script type="text/javascript">
	var naver_id_login = new naver_id_login("irD1NHw9tD2Loycjai2X", "http://qclass.iptime.org:8787/DEVCA/views/member/navercallback.jsp");
	  	var state = naver_id_login.getUniqState();
	  	naver_id_login.setButton("green", 1, 100);
	    naver_id_login.setDomain("http://qclass.iptime.org:8787/DEVCA");
	  	naver_id_login.setState(state);
	  	naver_id_login.setPopup();
	  	naver_id_login.init_naver_id_login();
	</script> -->
	<!-- END :: NAVER LOGIN -->
	


</html>
