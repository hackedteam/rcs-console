package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.Event;
  
  public class ConnectionEvent extends Event
  {
    
    public static const START_CONNECTION:String = 'startConnection';
    public static const END_CONNECTION:String = 'endConnection';
    public static const DELETE_CONNECTION:String = 'deleteConnection';
    
    public var startPin:Pin;
    public var endPin:Pin;
    
    public function ConnectionEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}