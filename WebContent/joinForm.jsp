<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<html>
<head>
<meta charset="UTF-8">
<title>알다시피 회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<!--ID 이메일형식해야함!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->

<style>
td {
   text-align: center;
   padding: 5px 10px;
}

th, h3 {
   padding: 5px 10px;
}
</style>
</head>
<body>
   <h3>회원가입</h3>
   <table>
      <tr>
         <th>아이디</th>
      </tr>
      <tr>
         <td><input type="text" name="userId" maxlength="30"   placeholder="이메일을 입력해주세요." /> </td>
         <td><input type="button" id="overlay" value="중복 확인" /></td>

      </tr>
      <tr>

         <th>비밀번호</th>
      </tr>
      <tr>
         <td><input type="text" name="pw" maxlength="20"   placeholder="6~20 글자를 입력해주세요" /></td>
      </tr>
      <tr>
         <th>이름</th>
      </tr>
      <tr>
         <td><input type="text" name="name" maxlength="10" placeholder="이름을 입력해주세요." /></td>
      </tr>
      <tr>

         <th>닉네임</th>
      </tr>
      <tr>
         <td>
         <input type="text" name="nickName" maxlength="10" placeholder="1~10 글자를 입력해주세요." /> </td>
         <td><input type="button" id="overlay1" value="중복 확인" /></td>
         

      </tr>

      <tr>
         <th>주소</th>
      </tr>
      <tr>
         <td><input type="text" name="address" maxlength="50" placeholder="주소를 입력해주세요." /></td>
      </tr>
      <tr>
      <tr>
         <th>연락처</th>
      </tr>
      <tr>
         <td><input type="text" name="tel" maxlength="11" placeholder="-제외 핸드폰 번호를 입력해주세요." /></td>
      </tr>
      <tr>
         <td colspan="2">
            <button onclick="join()">가입하기</button>
         </td>
      </tr>
   </table>

</body>
<script>
var overChk = false;
var nickChk = false;
   
   function join(){
      var $userId = $("input[name='userId']");
      var $pw = $("input[name='pw']");
      var $name = $("input[name='name']");
      var $nickName = $("input[name='nickName']");
      var $address = $("input[name='address']");
      var $tel = $("input[name='tel']");
      
      	
      if($userId.val() == ""||$pw.val()==""||$name.val() == ""||$nickName.val() == ""||$address.val() == ""||$tel.val() == ""){         
      alert("빈칸을 입력해 주세요.");   
      
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
   </script>
</html>