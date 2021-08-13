<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<style>
table {
  width :60%;
  margin:auto;
  text-align:center;
  line-height:200%;   
  }
td {
   text-align: center;
   padding: 5px 10px;
}
th{ padding: 5px 10px;}
h1{ text-align:center;}
</style>
</head>
<body>
   <h1>회원가입</h1>
   <table>
      <tr>
         <th>아이디</th>
      </tr>
      <tr>
        <td> &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
        <input type="text" name="userId" id="userId" maxlength="30" style="width:300px;"  placeholder="이메일을 입력해주세요." /> &nbsp;
         <input type="button" id="overlay" value="중복 확인" />
         <div class="email regex"></div></td>
      </tr>
      
      <tr>
         <th>비밀번호</th>
      </tr>
      <tr>
         <td><input type="text" name="pw" maxlength="20" id="pw" style="width:300px;"  placeholder="6~20 글자를 입력해주세요" /></td>
      </tr>
      <tr>
         <th>이름</th>
      </tr>
      <tr>
         <td><input type="text" name="name" maxlength="10" id="name" style="width:300px;" placeholder="이름을 입력해주세요." /></td>
      </tr>
      <tr>
         <th>닉네임</th>
      </tr>
      <tr>
         <td>&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
         <input type="text" name="nickName" id="nickName" maxlength="10" style="width:300px;" placeholder="1~10 글자를 입력해주세요." /> &nbsp;
         <input type="button" id="overlay1" value="중복 확인" /></td>
      </tr>
      <tr>
         <th>주소</th>
      </tr>
      <tr>
         <td><input type="text" name="address" id="address" maxlength="50" style="width:300px;" placeholder="주소를 입력해주세요." /></td>
      </tr>
      <tr>
      <tr>
         <th>연락처</th>
      </tr>
      <tr>
         <td><input type="text" name="tel" id="tel" maxlength="11" style="width:300px;" placeholder="-제외 폰번호를 입력해주세요." /></td>
      </tr>
      <tr>
         <td colspan="2">
         <div class="button">
            <button onclick="location.href='./index.jsp'">돌아가기</button>&nbsp; &nbsp;<button onclick="join()">가입하기</button>
         </div>
         </td>
      </tr>
   </table>

</body>
<script>
var overChk = false;
var nickChk = false;

$("#userId").on("input",function(){
    var regex = /.+@[a-z]+(\.[a-z]+){1,2}$/;
    var result = regex.exec($("#userId").val());
   
   if(result != null){
      $(".email.regex").html("");  
   }else{
       $(".email.regex").html("이메일 형식이 아닙니다.");
   }
})
   
   function join(){
      var $userId = $("input[name='userId']");
      var $pw = $("input[name='pw']");
      var $name = $("input[name='name']");
      var $nickName = $("input[name='nickName']");
      var $address = $("input[name='address']");
      var $tel = $("input[name='tel']");
      
    //아이디 이메일 형식
      var emailChk = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;//이메일 정규식
      if(!emailChk.test($("input[id='userId']").val())) {            
                  alert("아이디를 이메일 형식으로 적어주세요");
                  return;
      }
      //전화 숫자만
      var telChk = /^\d{10,11}$/;
      if(!telChk.test($("input[id='tel']").val())) {            
          alert("전화번호를 숫자로 정확하게 적어주세요");
          return;
      }
      	
      if($userId.val() == ""||$pw.val()==""||$name.val() == ""||$nickName.val() == ""||$address.val() == ""||$tel.val() == ""){         
      alert("빈칸을 입력해 주세요.");   
      }if($pw.val().length < 6 ){    	  
    	  alert("비밀번호는 6글자 이상이어야 합니다.")
      }else if(nickChk==true && overChk==true){
         console.log('save!!')
         var param = {};
         param.userId = $userId.val();
         param.pw = $pw.val();
         param.name = $name.val();
         param.nickName = $nickName.val();
         param.address = $address.val();
         param.tel = $tel.val();
         
         $.ajax({
            type:'POST',
            url:'join',
            data:param,
            dataType:'JSON',
            success:function(data){
               console.log(data);
               if(data.success > 0){
                  alert('가입이 완료되었습니다.');
                  location.href='index.jsp';
               }else{              
              	alert('가입에 실패했습니다.')
            }
         },
           error:function(e){
               console.log(e);
            }
         });
      }else if(nickChk==true && overChk==false){
    	  alert('아이디 중복체크를 진행해주세요.');
    	  return;
      }else if(overChk==true && nickChk==false){
    	  alert('닉네임 중복체크를 진행해주세요.');
    	  return;
       }else if(overChk==false && nickChk==false){
     	  alert('아이디와 닉네임 중복체크를 진행해주세요.');
     	  return;
       }         
   }



$("#overlay").click(function(){
   var userId = $("input[name='userId']").val();
   console.log(userId);
   $.ajax({
      type:'get',
      url:'overlay',
      data:{'userId':userId},
      dataType:'JSON',
      success:function(data){
         console.log(data);
         if(!data.success){
            alert("처리중 문제가 발생 했습니다. 다시 시도해 주세요!");
         }else{
            if(data.overlay){
               alert("중복된 아이디입니다.");
                $("input[name='userId']").val("");
            }else{
               alert("아이디를 사용할 수 있습니다.");
               overChk = true;
            }
         }            
      },
      error:function(e){
         console.log(e);
      }         
   });
});

$("#overlay1").click(function(){
   var nickName = $("input[name='nickName']").val();
   console.log(nickName);
   $.ajax({
      type:'get',
      url:'overlay1',
      data:{'nickName':nickName},
      dataType:'JSON',
      success:function(data){
         console.log(data);
         if(!data.success){
            alert("처리중 문제가 발생 했습니다. 다시 시도해 주세요!");
         }else{
            if(data.overlay1){
               alert("중복된 닉네임입니다.");
                $("input[name='nickName']").val("");
            }else{
               alert("닉네임을 사용할 수 있습니다.");
               nickChk = true;
            }
         }            
      },
      error:function(e){
         console.log(e);
      }         
   });
});

$("#nickName").on("change keyup paste", function(){
	nickChk = false;
});

$("#userId").on("change keyup paste", function(){
	overChk = false;
});
   </script>
</html>