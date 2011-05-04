package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  import it.ht.rcs.console.accounting.Group;
  import it.ht.rcs.console.accounting.User;
  
  public class EditEvent extends Event
  {
    public static const USER:String = "user";
    public static const GROUP:String = "group";
    public var user:User;
    public var group:Group;
    
    public function EditEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}