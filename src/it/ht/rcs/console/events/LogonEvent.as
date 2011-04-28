package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  public class LogonEvent extends Event
  {
    public static const LOGGING_IN:String = "login";
    public static const LOGGING_OUT:String = "logout";
    
    public function LogonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}