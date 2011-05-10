package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.Manager;
  
  import mx.collections.ArrayList;
  import mx.collections.ArrayCollection;
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

    override protected function onItemAdd(o: Object):void
    {
    }
    
    override protected function onItemRemove(o: Object):void
    { 
    }
    
    override protected function onItemUpdate(o: Object):void
    { 
    }
    
    override protected function onReset():void
    {
    }

    override protected function onRefresh(e:RefreshEvent):void
    {
      super.onRefresh(e);
	    console.currentDB.group_index(onResult);
    }
    
    private function onResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      items.source.forEach(function toGroupArray(element:*, index:int, arr:Array):void {
        addItem(new Group(element));
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