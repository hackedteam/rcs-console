package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.accounting.Group;
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.ArrayCollection;
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  
  public class GroupManager
  {                                                     
    [Bindable]
    private var _groups:ArrayList = new ArrayList();
    
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
      
      _groups.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChanged);
      
      /* first time */
      onRefresh(null);
    }
    
    private function collectionChanged(event:CollectionEvent):void 
    { 
      trace(event.toString());
      
      // TODO : all the logic to the db !!!
    }
    
    public function stop():void
    {
      trace('Stop GroupManager');
      
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
    private function onRefresh(e:Event):void
    {
      trace('GroupManager -- Refresh');
      
      _groups.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        _groups.addItem(new Group({id:1, name: 'demo', users:[1,2,3]}));
        _groups.addItem(new Group({id:2, name: 'developers', users:[2,3,4,5,6,7,8,9]}));
        _groups.addItem(new Group({id:3, name: 'test', users:[10]}));
      }
     
      //TODO: get the users from db
    }
    
    public function getGroupsView():ListCollectionView
    {
      var lcv:ListCollectionView = new ListCollectionView();
      lcv.list = _groups;
      
      /* sorting */
      var sort:Sort = new Sort();
      sort.fields = [new SortField('name', true, false, false)];
      lcv.sort = sort;
      lcv.refresh();
      
      return lcv;
    }
    
    public function newGroup(data:Object=null):Group
    {
      // TODO: create the user in the db
      var g:Group = new Group(data);
      _groups.addItem(g);
      return g;
    }
    
    public function removeGroup(e:Group):void
    {
      if (e == null)
        return;
      
      var idx : int = _groups.getItemIndex(e);
      if (idx >= 0) 
        _groups.removeItemAt(idx);
      
    }
    
    public function groupsFromIds(ids:Array):ArrayCollection
    {
      var gr:ArrayCollection = new ArrayCollection(_groups.source);
      
      gr.filterFunction = function filter(o:Object):Boolean {
        if (ids.indexOf(o.id) != -1)
          return true;
        
        return false;
      };
      
      gr.refresh();
      
      return gr;
    }
  }
}