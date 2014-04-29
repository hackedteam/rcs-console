package it.ht.rcs.console.history
{
  import it.ht.rcs.console.agent.model.Agent;
  import it.ht.rcs.console.agent.model.Config;
  import it.ht.rcs.console.entities.model.Entity;
  import it.ht.rcs.console.operation.model.Operation;
  import it.ht.rcs.console.target.model.Target;

  public class HistoryItem
  {
    
    public var section:String;
    public var state:String;
    public var subSection:int;
    public var operation:Operation;
    public var entity:Entity;
    public var target:Target;
    public var agent:Agent;
    public var factory:Agent;
    public var config:Config;
    
    public function HistoryItem()
    {
    }
  }
}