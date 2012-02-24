package it.ht.rcs.console.system.view.frontend.graph
{
  import flash.events.Event;
  
  import it.ht.rcs.console.network.model.Collector;
  
  public class NodeEvent extends Event
  {
    
    public static const SELECTED:String = "nodeSelected";
    
    public var collector:Collector;
    
    public function NodeEvent(type:String, collector:Collector, bubbles:Boolean=true, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
      this.collector = collector;
    }
    
  }
  
}