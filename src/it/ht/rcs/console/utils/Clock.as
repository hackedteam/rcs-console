package it.ht.rcs.console.utils
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.core.FlexGlobals;
  import mx.formatters.DateFormatter;

  public class Clock
  {
    [Bindable]
    public var currentUTCTime:String;
    [Bindable]
    public var currentLocalTime:String;
    [Bindable]
    public var currentConsoleTime:String;
    [Bindable]
    public var now:Date;
    [Bindable]
    public var now_utc:Date;
    [Bindable]
    public var now_console:Date;
    [Bindable]
    public var consoleOffset:int = 0;
    
    [Bindable]
    public var consoleTimeZoneOffset:int = 0;
    
    /* everyone can listen to this for events every second */
    public var timer:Timer = new Timer(1000);
    
    /* singleton */
    private static var _instance:Clock = new Clock();
    public static function get instance():Clock { return _instance; } 
    
    public function Clock()
    {
      trace('UTC clock initialization...');
      /* initialize to UTC, the profile value will be set on currentSession creation */
      consoleOffset = 0;
      
      /* initialize the first time */
      setConsoleTimezone(consoleOffset);
      
      /* every second update the UTC clock */
      timer.addEventListener(TimerEvent.TIMER, updateClock);
      timer.start();
    }
    
    private function updateClock(evt:TimerEvent):void 
    {
      now = new Date();
      now_utc = new Date(now.fullYearUTC, now.monthUTC, now.dateUTC, now.hoursUTC, now.minutesUTC, now.secondsUTC);
      now_console = new Date(now_utc.getTime() + consoleTimeZoneOffset);
      
      var clockFormatter:DateFormatter = new DateFormatter();
      clockFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
      currentUTCTime = clockFormatter.format(now_utc);
      currentLocalTime = clockFormatter.format(now);
      currentConsoleTime = clockFormatter.format(now_console);
    }
    
    public function setConsoleTimezone(offset:int):void
    {
      consoleOffset = offset;
      consoleTimeZoneOffset = offset * 3600 * 1000;
      updateClock(null);
      FlexGlobals.topLevelApplication.dispatchEvent(new RefreshEvent(RefreshEvent.REFRESH));
    }
    
    public function toConsoleDate(localDate:Date):Date {
      var newTime:Number = localDate.time + consoleTimeZoneOffset + (localDate.timezoneOffset * 60 * 1000);
      return new Date(newTime);
    }
    
    public function toUTCTime(consoleDate:Date):Number {
      var newTime:Number = consoleDate.time - consoleTimeZoneOffset - (consoleDate.timezoneOffset * 60 * 1000);
      return newTime;
    }
    
  }
}