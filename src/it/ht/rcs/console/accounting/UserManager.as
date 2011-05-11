package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.model.User;
  
  import mx.collections.ArrayCollection;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  
  public class UserManager extends Manager
  {
    [Bindable]
    public var connected_users:ArrayCollection = new ArrayCollection();
                                                                    
    /* singleton */
    private static var _instance:UserManager = new UserManager();
    public static function get instance():UserManager { return _instance; } 
    
    public function UserManager()
    {
      super();
    }
    
    override protected function onItemRemove(o:*):void
    { 
      //console.currentDB.user_destroy(o);
    }
    
    override protected function onItemUpdate(e:*):void
    { 
      // e.source.save();
      //console.currentDB.user_update(e.source);
    }
    
    override protected function onRefresh(e:RefreshEvent):void
    {
      super.onRefresh(e);
      
      connected_users.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        connected_users = new ArrayCollection([{user:"alor", address:"1.1.2.3", logon:new Date().time, privs: "A T V"},
                                               {user:"demo", address:"demo", logon:new Date().time, privs: "V"},
                                               {user:"daniel", address:"5.6.7.8", logon:new Date().time, privs: "T V"}]);
      }
      
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
    
    public function newUser(callback:Function):void
    {
      console.currentDB.user_create(new User(), function _(e:ResultEvent):void {
        var u:User = new User(e.result);
        addItem(u);
        callback(u);
      });
    }
    
    public function disconnectUser(u:Object):void
    {
      var idx : int = connected_users.getItemIndex(u);
      if (idx >= 0) 
        connected_users.removeItemAt(idx);
      
      // TODO: disconnect call to db
    }
    
  }
}