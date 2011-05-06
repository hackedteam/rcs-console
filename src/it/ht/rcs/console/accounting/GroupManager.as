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
  
  public class GroupManager extends Manager
  {                                                     
    /* singleton */
    private static var _instance:GroupManager = new GroupManager();
    public static function get instance():GroupManager { return _instance; } 
    
    public function GroupManager()
    {
      super();
    }

    override protected function onItemAdd():void
    {
    }
    
    override protected function onItemRemove():void
    { 
    }
    
    override protected function onItemUpdate():void
    { 
    }
    
    override protected function onReset():void
    {
    }

    override protected function onRefresh(e:RefreshEvent):void
    {
      super.onRefresh(e);
      
      _items.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        addItem(new Group({id:1, name: 'demo', users:[1,2,3]}));
        addItem(new Group({id:2, name: 'developers', users:[2,3,4,5,6,7,8,9]}));
        addItem(new Group({id:3, name: 'test', users:[10]}));
      }
     
      //TODO: get the users from db
    }
    
    public function newGroup(data:Object=null):Group
    {
      var g:Group = new Group(data);
      addItem(g);
      return g;
    }
    
  }
}