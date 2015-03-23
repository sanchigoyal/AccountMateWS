package com.am.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ReportController {
		
		@RequestMapping("/reports")
		   public String getReportPage(){
		      return "reports";
		   }

}
