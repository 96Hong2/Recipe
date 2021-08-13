<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>header_afterLogin.jsp</title>
<script src=https://code.jquery.com/jquery-3.6.0.min.js></script>
<link rel="stylesheet" type="text/css" href="css/common.css" media="all" />
<script>
window.onkeydown  = function(e){
    var ua = navigator.userAgent;
      if ( e.keyCode == 123 /* F12 */) {
        alert("보안상의 이유로 F12버튼이 금지되어 있습니다.");
        e.preventDefault();
        e.returnValue = false;
      }
      if(ua.indexOf("Macintosh") > -1){
        if(e.keyCode == 91 /*Ctrl*/){
          alert("보안상의 이유로 Command 버튼이 금지되어 있습니다.");
        }
      }else{
        if(e.keyCode == 17 /*Ctrl*/){
          alert("보안상의 이유로 Ctrl 버튼이 금지되어 있습니다.");
        }
      }
  }
  document.oncontextmenu = function (e) {
    alert("보안상의 이유로 우클릭이 금지되어 있습니다.");
    return false;
  }

  !function() {
    function detectDevTool(allow) {
      if(isNaN(+allow)) allow = 100;
      var start = +new Date(); // Validation of built-in Object tamper prevention.
      debugger;
      var end = +new Date(); // Validates too.
      if(isNaN(start) || isNaN(end) || end - start > allow) {
        alert('개발자모드 창이 감지되었습니다.\r\n 개발자모드창이 열린상태에서는 사이트 이용이 불가합니다.');
        sleep(20000);
      }
    }
    if(window.attachEvent) {
      if (document.readyState === "complete" || document.readyState === "interactive") {
        detectDevTool();
        window.attachEvent('onresize', detectDevTool);
        window.attachEvent('onmousemove', detectDevTool);
        window.attachEvent('onfocus', detectDevTool);
        window.attachEvent('onblur', detectDevTool);
      } else {
        setTimeout(argument.callee, 0);
      }
    } else {
      window.addEventListener('load', detectDevTool);
      window.addEventListener('resize', detectDevTool);
      window.addEventListener('mousemove', detectDevTool);
      window.addEventListener('focus', detectDevTool);
      window.addEventListener('blur', detectDevTool);
    }

    function sleep(ms) {
      const wakeUpTime = Date.now() + ms;
      while (Date.now() < wakeUpTime) {}
    }
  }();
</script>
</head>
<body>
	<c:choose>
		<c:when test="${not empty sessionScope.isAdmin}">
			<div class="wrap">
				<div id="header" style="height: 100px; display: flex;">
					<div style="width:300px;">
						<a href="./"> <img src="hlogo.png" alt="로고"
							style="margin-left:20px; width:100px; height:100px;" /></a>
					</div>
					<div id="center_img" style="text-align:center; width: 300px; height:100px; line-height:100px;">
						<a href="./"><img src="center.png" alt="센터" style="width:250px; height:100px;"></a>
					</div>
					<div id="top_menu" style="width: 300px; text-align:right; ">
						<div>
							<ul>
								<li>${sessionScope.nickName} 님,
								<a href="./cashHistory">&nbsp;보유캐시 :&nbsp; &nbsp; <b id="showCash"></b> 원
								</a>
								</li>
							</ul>
						</div>
						<div>
							<ul>
								<li><a href="adminMain.jsp">관리자페이지</a></li>
								<li><a href="./myPage">마이페이지</a></li>
								<li><a href="./logout">로그아웃</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="search">
					<form action="postSearch" method="get" id="search" name="postSearch">
						<input type="text" id="keyword"  name="keyword" placeholder="검색어입력" />
						<input type="hidden" name="postSearchOpt" value='title_contentsSearch'/>
						<input type="hidden" name="categoryId" value="0" />
						<button>검색</button>
					</form>
				</div>
				<div id="menu">
					<ul>
						<li><a href="#">알다시피란?</a></li>
						<li><a href="./bestPost">베스트레시피</a></li>
						<li><a href="./postList">레시피게시판</a></li>
						<li><a href="./shop">쇼핑몰</a></li>
					</ul>
				</div>
			</div>
		</c:when>
		<c:when test="${not empty sessionScope.userId}">
			<div class="wrap">
				<div id="header" style="height: 100px; display: flex;">
					<div style="width:300px;">
						<a href="./"> <img src="hlogo.png" alt="로고"
							style="margin-left:20px; width:100px; height:100px;" /></a>
					</div>
					<div id="center_img" style="text-align:center; width: 300px; height:100px; line-height:100px;">
						<a href="./"><img src="center.png" alt="센터" style="width:250px; height:100px;"></a>
					</div>
					<div id="top_menu" style="width: 300px; text-align:right; ">
						<div>
							<ul>
								<li>${sessionScope.nickName} 님,
								<a href="./cashHistory">&nbsp;보유캐시 :&nbsp; &nbsp; <b id="showCash"></b> 원
								</a>
								</li>
							</ul>
						</div>
						<div>
							<ul>
								<li><a href="./myPage">마이페이지</a></li>
								<li><a href="cart.jsp">장바구니</a></li>
								<li><a href="myPage_chargeCash.jsp">캐시충전</a></li>
								<li><a href="./logout">로그아웃</a></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="search">
					<form action="postSearch" method="get" id="search" name="postSearch">
						<input type="text" id="keyword"  name="keyword" placeholder="검색어입력" />
						<input type="hidden" name="postSearchOpt" value='title_contentsSearch'/>
						<input type="hidden" name="categoryId" value="0" />
						<button>검색</button>
					</form>
				</div>
				<div id="menu">
					<ul>
						<li><a href="#">알다시피란?</a></li>
						<li><a href="./bestPost">베스트레시피</a></li>
						<li><a href="./postList">레시피게시판</a></li>
						<li><a href="./shop">쇼핑몰</a></li>
					</ul>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="wrap">
			<div id="header" style="height: 100px; display: flex;">
					<div style="width:300px;">
						<a href="./"> <img src="hlogo.png" alt="로고"
							style="margin-left:20px; width:100px; height:100px;" /></a>
					</div>
					<div id="center_img" style="text-align:center; width: 300px; height:100px; line-height:100px;">
						<a href="./"><img src="center.png" alt="센터" style="width:250px; height:100px;"></a>
					</div>
					<div id="top_menu" style="width: 300px; text-align:right; ">
						<div>
							<ul>
								<li>안녕하세요! 로그인 해주세요</li>
							</ul>
						</div>
						<div>
							<ul>
								<li><a href="./login.jsp">로그인</a></li>
								<li><a href="./joinForm.jsp">회원가입</a></li>
								<li><a href="./cart.jsp">장바구니</a></li>
								<li><a href="./myPage">마이페이지</a></li>
							</ul>
						</div>
					</div>
				</div>
				
				<div class="search">
					<form action="postSearch" method="get" id="search" name="postSearch">
						<input type="text" id="keyword"  name="keyword" placeholder="검색어입력" />
						<input type="hidden" name="postSearchOpt" value='title_contentsSearch'/>
						<input type="hidden" name="categoryId" value="0" />
						<button>검색</button>
					</form>
				</div>
				<div id="menu">
					<ul>
						<li><a href="#">알다시피란?</a></li>
						<li><a href="./bestPost">베스트레시피</a></li>
						<li><a href="./postList">레시피게시판</a></li>
						<li><a href="./shop">쇼핑몰</a></li>
					</ul>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
</body>
<script>
	$.ajax({
		type : 'post',
		url : './showCash',
		dataType : 'JSON',
		success : function(currCash) {
			console.log("(header_afterLogin.jsp)ajax currCash :" + currCash);
			$('#showCash').html(currCash.currentCash);
		},
		error : function(e) {
			console.log("ajax 에러발생 :" + e);
		}
	});
</script>
</html>