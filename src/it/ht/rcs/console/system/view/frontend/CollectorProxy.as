package it.ht.rcs.console.system.view.frontend
{
  import it.ht.rcs.console.network.model.Collector;
  
  import mx.collections.ArrayCollection;

  public class CollectorProxy
  {
    public var collector:Collector;
    public var next:ArrayCollection;
    public var prev:ArrayCollection;
    
    public function CollectorProxy(collector:Collector)
    {    
      this.collector=collector;
      this.prev=new ArrayCollection();
      this.next=new ArrayCollection();
      
      var i:int;
      for(i=0;i<collector.prev.length;i++)
      {
        this.prev.addItem(collector.prev.getItemAt(i))
      }
      
      for(i=0;i<collector.next.length;i++)
      {
        this.next.addItem(collector.next.getItemAt(i));     
      }
      
    }
  }
}