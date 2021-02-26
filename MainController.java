package spring.hobby.space;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;


/**
 * Handles requests for the application home page.
 */
@Controller
public class MainController {

	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	@Autowired
	Main main;
	
	@Autowired
	Zzim zzim;
	
	ModelAndView mv = null;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView Main(@ModelAttribute MainBean mb) {
		return main.entrance(mb);
		
	}
	
	@RequestMapping(value = "/MoreReview", method = RequestMethod.GET)
	public ModelAndView MoreReview(@ModelAttribute MainBean mb) {
		return main.entrance(mb);
		
	}
	
	@RequestMapping(value = "/Zzim", method = RequestMethod.GET)
	public ModelAndView Zzim(@ModelAttribute MainBean mb) {
		return zzim.entrance(mb);
		
	}
	
	@RequestMapping(value = "/DeleteZzim", method = RequestMethod.GET)
	public ModelAndView DeleteZzim(@ModelAttribute MainBean mb) {
		return zzim.entrance(mb);
		
	}
	

	
}
