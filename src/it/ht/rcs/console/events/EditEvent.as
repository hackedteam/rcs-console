package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  import it.ht.rcs.console.accounting.User;
  
  public class EditEvent extends Event
  {
    public static const USER:String = "user";
    public var user:User;
    
    public function EditEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}