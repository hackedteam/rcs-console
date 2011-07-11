package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  import it.ht.rcs.console.model.Collector;
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.User;
  
  public class EditEvent extends Event
  {
    public static const USER:String = "editUser";
    public static const GROUP:String = "editGroup";
    public static const ANONYMIZER:String = "editAnonymizer";
    public var user:User;
    public var group:Group;
    public var collector:Collector;
    
    public function EditEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      trace('EditEvent.' + type.toUpperCase());
    }
    
    public override function clone():Event {
      trace('Clone EditEvent');
      var e:EditEvent = new EditEvent(type, bubbles, cancelable);
      e.group = group;
      e.user = user;
      return e;
    }
  }
}