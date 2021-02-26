package spring.hobby.space;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;


import spring.hobby.space.MapperIF;

public class Main {

	ModelAndView mav = null;
	
	@Autowired
	private MapperIF mapper;
	@Autowired
	private PlatformTransactionManager tran;
	@Autowired
	private Gson gson;
	
	

	public ModelAndView entrance(MainBean mb) {
		ModelAndView mav = null; 
		 switch(1) {
		 case 1:
			 mav = mainCtl();
			 break;
		 case 2:
			 mav = moreReviewCtl();
			 break;
		 default:
				break;
		 }
		
		return mav;
	}



	public ModelAndView mainCtl() {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("");
		return mav;
	}
	
	public ModelAndView moreReviewCtl() {
		ModelAndView mav = new ModelAndView();

		mav.setViewName("");
		return mav;
	}
	
	public ArrayList<MainBean> loadReview(MainBean mb) {
		return null;
		
	}

	public ArrayList<MainBean> moreReview(MainBean mb) {
		return null;
		
	}
	
	private MainBean loadStarSpace(MainBean mb) {
		return null;
	}




	private MainBean loadReserveSpace(MainBean mb) {
		return null;
	}
	
	private MainBean loadZzimSpace(MainBean mb) {
		return null;
	}


}
