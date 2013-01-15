package it.ht.rcs.console.events
{
  import flash.events.Event;
  
  public class TreeEvent extends Event
  {


    public var data:Object;
    
    public function TreeEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      this.data=data;
      super(type, bubbles, cancelable);
    }
    
  }
  
}