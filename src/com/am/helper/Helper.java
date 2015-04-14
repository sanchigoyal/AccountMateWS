package com.am.helper;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

public class Helper {
	
	public static Map<String,String> getDateRange() {
	    Map<String,String> dates = new HashMap<String,String>();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    Date begining, end;
	    //Calendar calendar = getCalendarForNow();
	    //Date lastDate = calendar.getTime();
        //SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        //String lastDateofNextMonth = sdf.format(lastDate);

	    {
	        Calendar calendar = getCalendarForNow();
	        calendar.set(Calendar.DAY_OF_MONTH,
	                calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
	        setTimeToBeginningOfDay(calendar);
	        begining = calendar.getTime();
	    }

	    {
	        Calendar calendar = getCalendarForNow();
	        calendar.set(Calendar.DAY_OF_MONTH,
	                calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
	        setTimeToEndofDay(calendar);
	        end = calendar.getTime();
	    }
	    dates.put("startdate", sdf.format(begining));
	    dates.put("enddate", sdf.format(end));
	    return dates;
	}

	private static Calendar getCalendarForNow() {
	    Calendar calendar = GregorianCalendar.getInstance();
	    calendar.setTime(new Date());
	    return calendar;
	}

	private static void setTimeToBeginningOfDay(Calendar calendar) {
	    calendar.set(Calendar.HOUR_OF_DAY, 0);
	    calendar.set(Calendar.MINUTE, 0);
	    calendar.set(Calendar.SECOND, 0);
	    calendar.set(Calendar.MILLISECOND, 0);
	}

	private static void setTimeToEndofDay(Calendar calendar) {
	    calendar.set(Calendar.HOUR_OF_DAY, 23);
	    calendar.set(Calendar.MINUTE, 59);
	    calendar.set(Calendar.SECOND, 59);
	    calendar.set(Calendar.MILLISECOND, 999);
	}


}
