package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.Sort;
  import mx.collections.SortField;
  import mx.collections.ArrayCollection;
  import mx.core.FlexGlobals;
  import mx.events.CollectionEvent;
  
  public class UserManager
  {
    [Bindable]
    public var connected_users:ArrayCollection = new ArrayCollection();
                                                                    
    [Bindable]
    public var users:ArrayCollection = new ArrayCollection();
    
    /* singleton */
    private static var _instance:UserManager = new UserManager();
    public static function get instance():UserManager { return _instance; } 
    
    public function UserManager()
    {
    }
  
    public function start():void
    {
      trace('Start UserManager');
      
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);

      /* first time */
      onRefresh(null);
    }
    
    public function stop():void
    {
      trace('Stop UserManager');
      
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
    private function onRefresh(e:Event):void
    {
      trace('UserManager -- Refresh');
      
      users.removeAll();
      connected_users.removeAll();
      
      /* DEMO MOCK */
      if (console.currentSession.fake) {
        addUser(console.currentSession.user);
        addUser(new User({id: 2, username: 'alor', locale:'en_US', groups:[1,2], enabled:true, privs:['ADMIN', 'TECH', 'VIEW']}));
        addUser(new User({id: 3, username: 'daniel', locale:'it_IT', groups:[1,2], enabled:true, privs:['ADMIN', 'TECH', 'VIEW']}));
        addUser(new User({id: 4, username: 'naga', groups:[2], enabled:true, privs:['VIEW']}));
        addUser(new User({id: 5, username: 'que', groups:[2], enabled:false}));
        addUser(new User({id: 6, username: 'zeno', groups:[2], enabled:true, privs:['TECH', 'VIEW']}));
        addUser(new User({id: 7, username: 'rev', groups:[2], enabled:false}));
        addUser(new User({id: 8, username: 'kiodo', groups:[2], enabled:false}));
        addUser(new User({id: 9, username: 'fabio', groups:[2], enabled:false}));
        addUser(new User({id: 10, username: 'br1', groups:[3], enabled:false}));
        
        connected_users = new ArrayCollection([{user:"alor", address:"1.1.2.3", logon:new Date().time, privs: "A T V"},
                                               {user:"demo", address:"demo", logon:new Date().time, privs: "V"},
                                               {user:"daniel", address:"5.6.7.8", logon:new Date().time, privs: "T V"}]);
      }

      var sort:Sort = new Sort();
      sort.fields = [new SortField('username', true, false, false)];
      users.sort = sort;
      users.refresh();
      
      //TODO: get the users from db
    }
    
    public function newUser(data:Object=null):User
    {
      // TODO: create the user in the db
      var u:User = new User(data);
      users.addItem(u);
      return u;
    }
    
    public function addUser(e:User):void
    { 
      users.addItem(e);
    }
    
    public function removeUser(e:User):void
    {
      if (e == null)
        return;
      
      var idx : int = users.getItemIndex(e);
      if (idx >= 0) 
        users.removeItemAt(idx);
      
      // TODO: remove from db
    }
    
    public function disconnectUser(u:Object):void
    {
      var idx : int = connected_users.getItemIndex(u);
      if (idx >= 0) 
        connected_users.removeItemAt(idx);
      
      // TODO: disconnect call to db
    }
    
    public function usersFromIds(ids:Array):ArrayCollection
    {
      var us:ArrayCollection = new ArrayCollection(users.source);
      
      us.filterFunction = function filter(o:Object):Boolean {
        if (ids.indexOf(o.id) != -1)
          return true;
        
        return false;
      };
      
      us.refresh();
      
      return us;
    }
  }
}