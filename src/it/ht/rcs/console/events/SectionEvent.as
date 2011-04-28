package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  public class SectionEvent extends Event
  {
    public static const ACCOUNTING:String = "accounting";
    public static const CONSOLE:String = "console";
    public static const DASHBOARD:String = "dashboard";
    public static const ALERTING:String = "alerting";
    public static const CORRELATION:String = "correlation";
    public static const NETWORK:String = "network";
    public static const AUDIT:String = "audit";
    public static const MONITOR:String = "monitor";
    
    public function SectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}