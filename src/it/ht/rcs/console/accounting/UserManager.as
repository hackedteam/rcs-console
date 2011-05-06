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

    override public function start():void
    {
      trace('Start UserManager');
      super.start();  
    }
    
    override public function stop():void
    {
      trace('Stop UserManager');
      super.stop();
    }
    
    override protected function onItemsChange(event:CollectionEvent):void 
    { 
      trace(event.toString());
      
      // TODO : all the logic to the db !!!
    }

    override protected function onRefresh(e:RefreshEvent):void
    {
      trace('UserManager -- Refresh');
      
      _items.removeAll();
      connected_users.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        addItem(console.currentSession.user);
        addItem(new User({id: 2, name: 'alor', locale:'en_US', groups:[1,2], enabled:true, privs:['ADMIN', 'TECH', 'VIEW']}));
        addItem(new User({id: 3, name: 'daniel', locale:'it_IT', groups:[1,2], enabled:true, privs:['ADMIN', 'TECH', 'VIEW']}));
        addItem(new User({id: 4, name: 'naga', groups:[2], enabled:true, privs:['VIEW']}));
        addItem(new User({id: 5, name: 'que', groups:[2], enabled:false}));
        addItem(new User({id: 6, name: 'zeno', groups:[2], enabled:true, privs:['TECH', 'VIEW']}));
        addItem(new User({id: 7, name: 'rev', groups:[2], enabled:false}));
        addItem(new User({id: 8, name: 'kiodo', groups:[2], enabled:false}));
        addItem(new User({id: 9, name: 'fabio', groups:[2], enabled:false}));
        addItem(new User({id: 10, name: 'br1', groups:[3], enabled:false}));
        
        connected_users = new ArrayCollection([{user:"alor", address:"1.1.2.3", logon:new Date().time, privs: "A T V"},
                                               {user:"demo", address:"demo", logon:new Date().time, privs: "V"},
                                               {user:"daniel", address:"5.6.7.8", logon:new Date().time, privs: "T V"}]);
      }

     
      //TODO: get the users from db
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