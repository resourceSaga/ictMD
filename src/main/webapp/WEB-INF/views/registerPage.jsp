<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<meta charset="UTF-8">
<title>ハンサムLoginPage</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
<link rel="stylesheet" href="./resources/css/registerPage.css">

<script src="http://code.jquery.com/jquery-1.3.2.min.js"></script>


<script>
 $(function (){
	$("#next1").attr("disabled", true); //next버튼 비활성화
	$("#userId").keyup(emailcheck);
	$("#userPwd").keyup(passcheck);
	$("#confirmPassChk").keyup(confirmPassChk);
	function emailcheck(){
		var userId= $(this).val();
		if(userId.indexOf("@")==-1){
			$("#emailcheck").text("골뱅이쳐라");
		}else{
			$("#emailcheck").text("");
			$.ajax({
				type : "get",
				url : "emailCheck",
				data : {
					userId : userId
				},
				success:function(data){
					if(data){
						$("#emailcheck").text("중복된 email입니다.");
						$("#next1").attr("disabled", true);
					}else{
						$("#emailcheck").text("사용가능한 email입니다.");
						$("#next1").attr("disabled", false);
					}
				}
			});
		}
	};
	
	function passcheck(){
		var userPwd=$(this).val();
		if(userPwd.length < 3 || userPwd.length > 16){
			$("#passcheck").text("Password의 길이는 3자~16자 입니다.");
		}else{
			$("#passcheck").text("");
			
			var confirmPassChk=$("#confirmPassChk").val();
			console.log("password : " + userPwd);
			console.log("컨펌 : " + $("#confirmPassChk").val());
			
			if(confirmPassChk != userPwd){
				$("#passcheck").text("password를 정확히 입력하세요");

			}else{
				$("#passcheck").text("");
				
				var confirmPassChk=$("#confirmPassChk").val();
				console.log("password : " + userPwd);
				console.log("컨펌 : " + $("#confirmPassChk").val());
				
				if(confirmPassChk != userPwd){
					$("#passcheck").text("password를 정확히 입력하세요");
				}else{
					$("#passcheck").text("");
					$("#confirmResult").text("");
				}
			}
		}

	}
	
	function confirmPassChk(){
		var confirmPassChk=$(this).val();
		if(confirmPassChk != $("#userPwd").val()){
			$("#confirmResult").text("password를 정확히 입력하세요");
		}else{
			$("#confirmResult").text("");
			
			if($("#passcheck").text() != "") {
				$("#passcheck").text("");
			}
		}
	}
	
	$("#submit").on("click", function(){
		var userId=$("#userId").val();
		var userPwd=$("#userPwd").val();
		var userName=$("#userName").val();
		var birth=$("#birth").val();
		var favorite = "";
		$("input[name=favorite]:checked").each(function(){
			favorite += $(this).val() + " ";
		});
		var model=$("#model").val();
		$.ajax({
			type : "post",
			url : "insertuserBase",
			data : {
				userId : userId,
				userPwd : userPwd,
				userName : userName
			}
		});
		$.ajax({
			type : "post",
			url : "insertuserDetail",
			data :{
				userId : userId,
				birth : birth,
				favorite : favorite,
				model : model
			}, success:function (){
				alert("회원가입 추카드릠돠");
				location.href="/ictmd";
			}
		});
				
	});	
 });

 </script>


</head>

<body>
	<!-- multistep form -->
	<form id="msform" action="submit" method="post">
		<!-- progressbar -->
		<ul id="progressbar">
			<li class="active">회원 기본정보</li>
			<li>회원 상세정보</li>
			<li>회원 정보확인</li>
		</ul>
		<!-- fieldsets -->
		<fieldset>
			<h2 class="fs-title">기본정보 입력</h2>
			<input type="text" id="userId" name="userId" placeholder="Email" />
			<p id="emailcheck" style="font-size: 10px; color: red;" align="left"></p>
			<br> <input type="password" id="userPwd" name="userPwd" placeholder="Password" />
			<p id="passcheck" style="font-size: 10px; color: red;" align="left"></p>
			<br>
			<input type="password" id="confirmPassChk" name="cpass" placeholder="Confirm Password" />
			<p id="confirmResult" style="font-size: 10px; color: red;" align="left"></p>

			<br> <input type="text" id="userName" name="userName" placeHolder="User Name" /><br> 
			<input type="button" id="next1"	name="next" class="next action-button" value="Next"  disabled=""/><br>
		</fieldset>
		<fieldset>
			<h2 class="fs-title">상세정보 입력</h2>
			<table style="width: 100%">
				<tr>
					<td colspan="3">
						<input type="date" id="birth" name="birth" />
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<p style="color: grey;" align="left">[Favorite]</p>
					</td>
				</tr>
				<tr style="height: 50px;">
					<td>
						<div style="width: 100%;">
							<input class="favorite"  name="favorite" type="checkbox" value="풍경" style="width: 30%;"/>
							<span style="width: 50%;">풍경</span>
						</div>
					</td>
					<td>
						<div style="width: 100%;">
							<input class="favorite"  name="favorite" type="checkbox" value="인물" style="width: 30%;"/>
							<span style="width: 50%;">인물</span>
						</div>
					</td>
					<td><div style="width: 100%;">
							<input class="favorite"  name="favorite" type="checkbox" value="사람" style="width: 30%;"/>
							<span style="width: 50%;">사람</span>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3"><input type="text" id="model" name="model" placeholder="Camera Model" /></td>
				</tr>
			</table>
			<input type="button" name="previous" class="previous action-button" value="Previous" /> 
			<input type="button" id="next2" name="next" class="next action-button" value="Next" />
		</fieldset>
		<fieldset>
			<h2 class="fs-title">입력정보확인</h2>
			<table id="usercheck" align="left" style='width: 100%'>
				<!--  js에서 가지고 옴 -->
			</table>
			<input type="button" name="previous" class="previous action-button" value="Previous" />
			<input type="button" id="submit" name="submit" class="submit action-button" value="Submit" />
		</fieldset>
	</form>
	<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
	<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js'></script>
	<script src="./resources/js/registerPage.js"></script>
</body>
</html>