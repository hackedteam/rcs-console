package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  public class RefreshEvent extends Event
  {
    public static const REFRESH:String = "refresh";
    
    public function RefreshEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}