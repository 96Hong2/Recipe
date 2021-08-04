package com.mvc.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.mvc.dto.MainDTO;
import com.mvc.service.MemberService;
import com.mvc.service.UploadService;

import sun.reflect.ReflectionFactory.GetReflectionFactoryAction;

@WebServlet({"/myPage","/myCash", "/info","/showCash", "/cashHistory", "/chargeCash", "/write", "/fileUpload", "/fileUpdate", "/test"})
public class MemberController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dual(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		dual(req, resp);
	}

	private void dual(HttpServletRequest req, HttpServletResponse resp) {
		String uri = req.getRequestURI();
		String context = req.getContextPath();
		String addr = uri.substring(context.length());
		System.out.println("-----------------------------");
		System.out.println("URI : " + addr);

		MemberService service = new MemberService(req, resp);
		MainDTO dto = null;
		RequestDispatcher dis = null;
		String page = "";
		String msg = "";
		boolean success = false;
		int result = 0;

		switch (addr) {
		
		//XXX
		case "/test":
			System.out.println("파일업로드 테스트 - form넘어옴");
			System.out.println("업로드한 썸네일번호 : "+req.getParameter("thImg"));
			System.out.println("업로드한 이미지번호 : "+req.getParameter("img"));
		break;
		
		case "/fileUpload": //은홍 - 파일업로드 ajax모듈
			System.out.println("파일업로드 또는 수정 요청 - ajax");
			try {
				HashMap<String, Object> map = service.fileUpload();
				//map에는 업로드한 썸네일PK, 이미지PK, 성공여부success 데이터가 들어있다.
				Gson gson = new Gson();
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
			} catch (Exception e) {
				System.out.println("**에러 : MemberController /fileUpload");
				e.printStackTrace();
			}
		break;
	
		case "/info": // 은홍
			//마이페이지에서 RANK, 명예점수, 보유캐시 정보를 가져오는 케이스
			System.out.println("마이페이지 info 보기 요청");
			try {
				dto = service.info();
				
				Gson gson = new Gson();
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("rank", dto.getRankName());
				map.put("cash", dto.getCash());
				map.put("point", dto.getTotalPoint());
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
			} catch (Exception e) {
				System.out.println("**에러 : MemberController /info");
				e.printStackTrace();
			}
		break;
		
		case "/showCash": //은홍
			System.out.println("현재 보유 캐시값 가져오기 요청");
			try {
				int currCash = service.showCash();
				
				Gson gson = new Gson();
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("currentCash", currCash);
				String obj = gson.toJson(map);
				resp.getWriter().println(obj);
				
			} catch (Exception e) {
				System.out.println("**에러 : MemberController /showCash");
				e.printStackTrace();
			}
		break;
		
		case "/myPage": //은홍
			System.out.println("마이페이지 조회 요청");
			try {
				//myPageList에 좋아요글, 내글, 댓글이 각각 4개씩 들어있는 리스트가 요소로 들어감.
				HashMap<String ,ArrayList<MainDTO>> myPageMap = new HashMap<String, ArrayList<MainDTO>>();
				myPageMap = service.myPage();
				req.setAttribute("myPage_Like", myPageMap.get("likeList"));
				req.setAttribute("myPage_Post", myPageMap.get("postList"));
				req.setAttribute("myPage_Comment", myPageMap.get("commentList"));
				dis = req.getRequestDispatcher("myPage_myPage.jsp");
				dis.forward(req, resp);
			} catch (Exception e) {
				System.out.println("**에러 : MemberController /myPage");
				e.printStackTrace();
			}
		break;

		case "/cashHistory": //은홍
			System.out.println("캐시 내역 조회 요청");
			ArrayList<MainDTO> list = new ArrayList<MainDTO>();
			try {
				list = service.cashHistory();
				req.setAttribute("cashList", list);
				
				msg = req.getParameter("msg");
				if(msg != null && msg != "") {
					req.setAttribute("msg", msg);
				}
				
				dis = req.getRequestDispatcher("myPage_myCash.jsp");
				dis.forward(req, resp);
			} catch (Exception e) {
				System.out.println("**에러 : MemberController /cashHistory");
				e.printStackTrace();
			}
			break;
		
		case "/chargeCash": //은홍
			System.out.println("캐시 충전 요청");
			try {
				result = service.chargeCash();
				if(result > 0) {
					msg = "캐시 충전이 완료되었습니다.";
					page = "cashHistory";
				}else {
					msg = "캐시 충전이 실패하였습니다.";
					page = "myPage_chargeCash.jsp";
				}
				req.setAttribute("msg", msg);
				dis = req.getRequestDispatcher(page);
				dis.forward(req, resp);
			} catch (Exception e) {
				System.out.println("**에러 : MemberController /chargeCash");
				e.printStackTrace();
			}
		break;
		
		} //end switch-case		
	}//end dual()
	
}
