package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.model.User;
  
  import mx.collections.ArrayCollection;
  import mx.collections.ArrayList;
  import mx.collections.ListCollectionView;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  
  public class UserManager extends Manager
  {
    [Bindable]
    public var _sessions:ArrayList = new ArrayList();
                                                                    
    /* singleton */
    private static var _instance:UserManager = new UserManager();
    public static function get instance():UserManager { return _instance; } 
    
    public function UserManager()
    {
      super();
    }
    
    override protected function onItemRemove(o:*):void
    { 
      console.currentDB.user_destroy(o);
    }
    
    override protected function onItemUpdate(e:*):void
    { 
      var o:Object = new Object;
      if (e.newValue is ArrayCollection)
        o[e.property] = e.newValue.source;
      else
        o[e.property] = e.newValue;
      console.currentDB.user_update(e.source, o);
    }
    
    override protected function onRefresh(e:RefreshEvent):void
    {
      super.onRefresh(e);
      
      _sessions.removeAll();

      /* retrieve the connected users */
      console.currentDB.session_index(onSessionIndexResult);
      
      /* system users */
      console.currentDB.user_index(onUserIndexResult);
    }
    
    public function onUserIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      items.source.forEach(function toUserArray(element:*, index:int, arr:Array):void {
        addItem(new User(element));
      });
    }

    public function onSessionIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _sessions.removeAll();
      items.source.forEach(function toUserArray(element:*, index:int, arr:Array):void {
        _sessions.addItem(element);
      });
    }
    
    public function newUser(callback:Function):void
    {
      console.currentDB.user_create(new User(), function _(e:ResultEvent):void {
        var u:User = new User(e.result);
        addItem(u);
        callback(u);
      });
    }
    
    public function getSessionsView():ListCollectionView
    {
      /* create the view for the caller */
      var lcv:ListCollectionView = new ListCollectionView();
      lcv.list = _sessions;
      
      /* default sorting is alphabetical */
      var sort:Sort = new Sort();
      sort.fields = [new SortField('time', true, false, true)];
      lcv.sort = sort;
      lcv.refresh();
      
      return lcv;
    }
    
    public function disconnectUser(u:Object):void
    {
      var idx : int = _sessions.getItemIndex(u);
      if (idx >= 0) 
        _sessions.removeItemAt(idx);
      
      /* disconnect call to db */
      console.currentDB.session_destroy(u['cookie']);
    }

  }
}