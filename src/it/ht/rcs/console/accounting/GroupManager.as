package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.Manager;
  
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  import mx.rpc.events.ResultEvent;
  
  public class GroupManager extends Manager
  {                                                     
    /* singleton */
    private static var _instance:GroupManager = new GroupManager();
    public static function get instance():GroupManager { return _instance; } 
    
    public function GroupManager()
    {
      super();
    }
  
    override public function start():void
    {
      trace('Start GroupManager');
      super.start();
    }
    
    override public function stop():void
    {
      trace('Stop GroupManager');
      super.stop();
    }

    override protected function onItemsChange(event:CollectionEvent):void 
    { 
      trace(event.toString());
      
      // TODO : all the logic to the db !!!
    }

    override protected function onRefresh(e:RefreshEvent):void
    {
      trace('GroupManager -- Refresh');
	    console.currentDB.groups(onResult);
    }
    
    private function onResult(e:ResultEvent):void
    {
      var items:Array = e.result as Array;
      _items.source = new Array();
      items.forEach(function toGroupArray(element:*, index:int, arr:Array):void {
        _items.source.push(new Group(element));
      });
    }
    
    public function newGroup(data:Object=null):Group
    {
      var g:Group = new Group(data);
      addItem(g);
      return g;
    }
    
  }
}