package it.ht.rcs.console.utils {
	
	public class DateUtils {

		public static function addWeeks(date:Date, weeks:Number):Date {
			return addDays(date, weeks * 7);
		}
		
		public static function addDays(date:Date, days:Number):Date {
			return addHours(date, days * 24);
		}
		
		public static function addHours(date:Date, hrs:Number):Date {
			return addMinutes(date, hrs * 60);
		}
		
		public static function addMinutes(date:Date, mins:Number):Date {
			return addSeconds(date, mins * 60);
		}
		
		public static function addSeconds(date:Date, secs:Number):Date {
			var mSecs:Number = secs * 1000;			
			var sum:Number = mSecs + date.time;
			return new Date(sum);
		}
		
    public static function parseDateTimeString(x:String):Date
    {
      var s:String = x.split("-").join("/");
      return new Date(Date.parse(s));
    }
    
	}
  
}