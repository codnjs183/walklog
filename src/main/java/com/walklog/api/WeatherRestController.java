package com.walklog.api;

import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

@RestController
@RequestMapping("/weather")
public class WeatherRestController {

	// 보안을 위해 yml 파일에 넣는게 나을 것 같다.
	@Value("${api.key.weather}")
	private String weatherKey;

	@GetMapping("/forecast")
	public Map<String, Object> weatherInfoApi(@RequestParam("x") int x, @RequestParam("y") int y) {
		
		// 1. 현재 시각을 불러온다.
		// 2. 기상청 초단기예보는 30분 단위이므로, 현재 시각에서 30분을 빼준다.
		LocalDateTime dateTime = LocalDateTime.now().minusMinutes(30);
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			// API 요청 url 생성
			URL url = new URL(
					"http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"
					+ "?ServiceKey=" + weatherKey
					+ "&pageNo=1"
					+ "&numOfRows=60"
					+ "&dataType=" + "XML" // XML 혹은 JSON
					+ "&base_date=" + dateTime.format(DateTimeFormatter.ofPattern("yyyyMMdd"))
					+ "&base_time=" + dateTime.format(DateTimeFormatter.ofPattern("HHmm"))
					+ "&nx=" + x
					+ "&ny=" + y
					);
			
			// 만들어진 url로 접속
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			
			// api에서 주는 정보가 XML 형태이므로 필요한 정보를 처리하기 위한 과정
			// DocumentBuilderFactory를 통해 XML 문서에서 DOM 오브젝트 트리를 생성하는 parser를 얻을 수 있다
			Document doc = DocumentBuilderFactory.newInstance()
					.newDocumentBuilder().parse(con.getInputStream());
			
			NodeList ns = doc.getElementsByTagName("item");
			Element e;
			
			String closestDate = null;
			String closestTime = null;
			
			String pty = null;
			String sky = null;
			
			for (int i = 0; i < ns.getLength(); i++) {
				e = (Element)ns.item(i);
				
				if (closestTime == null) {
					closestDate = e.getElementsByTagName("fcstDate").item(0).getTextContent(); // 예보 날짜
					closestTime = e.getElementsByTagName("fcstTime").item(0).getTextContent(); // 예보 시각
				} else if (!closestDate.equals(e.getElementsByTagName("fcstDate").item(0).getTextContent()) 
						|| !closestTime.equals(e.getElementsByTagName("fcstTime").item(0).getTextContent())) {
					continue; // 선택된 날짜/시간과 같은 날짜/시간의 데이터만 조회한다
				}
				
				String category = e.getElementsByTagName("category").item(0).getTextContent();
				String value = e.getElementsByTagName("fcstValue").item(0).getTextContent();

				if (category.equals("T1H")) {
					result.put("temperature", value);
				} else if (category.equals("PTY")) {
					pty = value;
				} else if (category.equals("SKY")) {
					sky = value;
				}
			}
			
			switch(pty) {
			case "0":
				if (sky.equals("1")) {
					result.put("weather", "맑음");
				} else if (sky.equals("3")) {
					result.put("weather", "구름 많음");
				} else if (sky.equals("4")) {
					result.put("weather", "흐림");
				}
				break;
			case "1":
				result.put("weather", "비");
				break;
			case "2":
				result.put("weather", "비/눈");
				break;
			case "3":
				result.put("weather", "눈");
				break;
			case "5":
				result.put("weather", "빗방울");
				break;
			case "6":
				result.put("weather", "빗방울/눈날림");
				break;
			case "7":
				result.put("weather", "눈날림");
				break;
			}
			con.disconnect();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
