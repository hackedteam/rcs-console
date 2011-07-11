package it.ht.rcs.console.events
{
  
  import flash.events.Event;
  
  public class SessionEvent extends Event
  {
    
    public static const LOGGING_IN:String = "loggingIn";
    public static const LOGGING_OUT:String = "loggingOut";
    public static const FORCE_LOG_OUT:String = "forceLogout";
    
    public function SessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true)
    {
      super(type, bubbles, cancelable);
    }
    
  }
  
}