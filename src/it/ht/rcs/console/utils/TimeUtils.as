package it.ht.rcs.console.utils
{
  import it.ht.rcs.console.model.Clock;
  
  import mx.formatters.DateFormatter;

  public class TimeUtils
  {
    public function TimeUtils()
    {
    }
    
    public static function diffTimeString(timestamp:Number):String
    {
      var diff:Number = Clock.instance.now.time - timestamp;
      var days:int = diff / 1000 / 60 / 60 / 24;
      
      /* prevent negative differences */
      if (diff < 0) 
        diff = 0;
      
      var time:Date = new Date();
      /* reset the time to 1 jan 1970 (to avoid DST) */
      time.setTime(0);
      /* calculate the difference (without the timezone) */
      time.setTime(diff + time.timezoneOffset*60*1000);
      
      var clockFormatter:DateFormatter = new DateFormatter();
      clockFormatter.formatString = "JJ:NN:SS";
      
      if (days > 0)
        return days.toString() + ' ' + clockFormatter.format(time);
      else
        return clockFormatter.format(time);
      
    }
  }
}