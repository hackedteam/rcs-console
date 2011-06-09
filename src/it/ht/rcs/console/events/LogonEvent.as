package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  public class LogonEvent extends Event
  {
    public static const LOGGING_IN:String = "loggingIn";
    public static const LOGGING_OUT:String = "loggingOut";
    public static const FORCE_LOG_OUT:String = "forceLogout";
    
    public function LogonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}