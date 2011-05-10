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
  import mx.rpc.events.ResultEvent;
  import mx.rpc.events.FaultEvent;
  
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
      
      connected_users.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        connected_users = new ArrayCollection([{user:"alor", address:"1.1.2.3", logon:new Date().time, privs: "A T V"},
                                               {user:"demo", address:"demo", logon:new Date().time, privs: "V"},
                                               {user:"daniel", address:"5.6.7.8", logon:new Date().time, privs: "T V"}]);
      }
      
      console.currentDB.user_index(onResult, onFault);
    }
    
    public function onResult(e:ResultEvent):void
    {
      var items:Array = e.result as Array;
      _items.source = new Array();
      items.forEach(function toUserArray(element:*, index:int, arr:Array):void {
        _items.source.push(new User(element));
      });
    }
    
    public function onFault(e:FaultEvent):void
    {
      trace(e.toString);
    }
    
    public function newUser(data:Object=null):User
    {
      var u:User = new User(data);
      addItem(u);
      return u;
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