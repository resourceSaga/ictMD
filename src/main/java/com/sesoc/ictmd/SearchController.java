package com.sesoc.ictmd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sesoc.ictmd.Interface.AnalysisDAO;
import com.sesoc.ictmd.Interface.ModelDetailDAO;
import com.sesoc.ictmd.api.SearchAPI;
import com.sesoc.ictmd.function.CreateImg;
import com.sesoc.ictmd.vo.BasicAnalysisData;
import com.sesoc.ictmd.vo.ComplexPhoto;
import com.sesoc.ictmd.vo.ModelDetail;
import com.sesoc.ictmd.vo.SimplePhoto;

/**
 * Handles requests for the application home page.
 */
@Controller
public class SearchController {
	@Autowired
	SqlSession session;
	
	SearchAPI api;

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	// 검색어를 문자열 배열로 입력받아 검색 후 결과를 반환하는 메소드
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> list(String[] tags, HttpSession ss) {
		api = new SearchAPI();
		Map<String, Object> result = new HashMap<String, Object>();
		
		ss.removeAttribute("tags");
		ss.setAttribute("tags", tags);

		ArrayList<SimplePhoto> list = api.search(tags);
		if (list != null) {
			result.put("list", list);
		}
		
		HashMap<String, String[]> tagsMap = new HashMap<>();
		tagsMap.put("tags", tags);
		ModelDetailDAO mdDAO = session.getMapper(ModelDetailDAO.class);
		ModelDetail modelInfo = mdDAO.searchModelDetail(tagsMap);
		if (modelInfo != null) {
			result.put("model", modelInfo);
		}

		return result;
	}

	// 임의의 사진 하나를 클릭했을 때 해당 사진에 대한 모든 정보를 가져오는 메소드
	@RequestMapping(value = "/detail", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> detail(String id, HttpServletRequest request, HttpSession ss) {
		api = new SearchAPI();
		Map<String, Object> result = new HashMap<String, Object>();

		ComplexPhoto photo = api.getInfo(id);
		HashMap<String, String> exif = api.getExif(id);
		
		String[] tags = (String[]) ss.getAttribute("tags");
		String make = "";
		String model = "";
		if (exif.containsKey("Make")) {
			make = exif.get("Make");
		}
		if (exif.containsKey("Model")) {
			model = exif.get("Model");
		}
		CreateImg creatimg = new CreateImg(photo.getUrl(), request, tags, make, model, session);
		creatimg.start();
		
		result.put("photo", photo);
		result.put("exif", exif);
		
		return result;
	}
	
	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public void test() {
		AnalysisDAO dao = session.getMapper(AnalysisDAO.class);
		ArrayList<BasicAnalysisData> l = dao.readAll();
		System.out.println("list : " + l);
		for (BasicAnalysisData asdf : l) {
			System.out.println(asdf);
			String[] aa = asdf.getTags().split(",");
			for (String bb : aa) {
				System.out.println("tag : " + bb);
			}
			System.out.println("");
		}
	}
}