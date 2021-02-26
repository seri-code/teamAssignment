package spring.hobby.space;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

@Service
public class Zzim {

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
			 mav = deleteZzimCtl();
			 break;
			 
		 default:
				break;
		 }
		
		return mav;
	}

	
	private boolean convertToBoolean(int value) {
		return value == 1 ? true : false;
	}


	private ModelAndView deleteZzimCtl() {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("");
		return mav;
		
	}
	


	private ModelAndView zzimCtl() {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("");
		return mav;
	}
	
	
	private boolean convertToBoolean() {
		// TODO Auto-generated method stub
		return false;
	}




	private MainBean zzim(MainBean mb) {
		return null;
	}
	
	private boolean deleteZzim(MainBean mb) {
		return convertToBoolean();
	}


}
