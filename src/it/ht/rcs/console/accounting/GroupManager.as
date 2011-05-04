package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.accounting.Group;
  
  import mx.collections.ArrayCollection;
  import mx.core.FlexGlobals;
  
  public class GroupManager
  {                                                     
    [Bindable]
    public var groups:ArrayCollection = new ArrayCollection();
    
    /* singleton */
    private static var _instance:GroupManager = new GroupManager();
    public static function get instance():GroupManager { return _instance; } 
    
    public function GroupManager()
    {
    }
  
    public function start():void
    {
      trace('Start GroupManager');
      
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
      /* first time */
      onRefresh(null);
    }
    
    public function stop():void
    {
      trace('Stop GroupManager');
      
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
    private function onRefresh(e:Event):void
    {
      trace('GroupManager -- Refresh');
      
      groups.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        addGroup(new Group({name: 'demo', users:[1,2,3]}));
        addGroup(new Group({name: 'developers', users:[2,3,4,5,6,7,8,9]}));
        addGroup(new Group({name: 'test', users:[10]}));
      }
      
      //TODO: get the users from db
    }
    
    public function newGroup(data:Object=null):Group
    {
      // TODO: create the user in the db
      var g:Group = new Group(data);
      groups.addItem(g);
      return g;
    }
    
    public function addGroup(e:Group):void
    { 
      groups.addItem(e);
    }
    
    public function removeGroup(e:Group):void
    {
      if (e == null)
        return;
      
      var idx : int = groups.getItemIndex(e);
      if (idx >= 0) 
        groups.removeItemAt(idx);
      
      // TODO: remove from db
    }
  }
}