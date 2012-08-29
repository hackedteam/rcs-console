package it.ht.rcs.console.operations.view.filesystem
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  import it.ht.rcs.console.agent.model.Agent;
  import it.ht.rcs.console.evidence.model.Evidence;
  
  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;

  public class FileSystemItem extends EventDispatcher
  {
    public var name:String;
    public var agent:Agent;
    public var parent:FileSystemItem;
    public var children:Array;
    public var attr:int;
    public var scanned:Boolean;
    public var scanning:Boolean;
    public var path:String;
    public var size:int;
    public var date:int;
    public var evidence:Evidence;
    
    private function getName(path:String):String
    {
      path = path.replace('\\\\', '\\');
      var separator:String = path.indexOf('/') == -1 ? '\\' : '/';
      var tokens:Array = path.split(separator);
      var name:String=tokens[tokens.length-1]
        return name;
    }
    
    public function update(event:ResultEvent):void
    {
      scanned=true;
      children=new Array();
      var result:ArrayCollection=event.result as ArrayCollection;
      
      for(var i:int=0;i<event.result.length;i++)
      {
        var evidence:Evidence=event.result.getItemAt(i);
        var child:FileSystemItem=new FileSystemItem();
        //check if is a Folder
        child.name=getName(evidence.data.path)//+" ("+evidence.data.attr+")";
        child.path=evidence.data.path;
        child.attr=evidence.data.attr;//TODO
        child.size=evidence.data.size;
        child.date=evidence.da;
        child.parent=this;
        child.evidence=evidence;
        child.agent=this.agent;
        if(child.attr!=0 && child.attr!=3)
          child.children = [{name:"retrieving data...", scanning:true}]
        children.push(child);
        
      }
      dispatchEvent(new Event("updated"));
    }
  }
}