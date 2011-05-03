package it.ht.rcs.console.accounting
{
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.ArrayCollection;
  import mx.core.FlexGlobals;
  
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
        addUser(new User({username: 'alor'}));
        addUser(new User({username: 'demo'}));
        addUser(new User({username: 'daniel'}));
        addUser(new User({username: 'naga'}));
        addUser(new User({username: 'que'}));
        addUser(new User({username: 'zeno'}));
        addUser(new User({username: 'rev'}));
        addUser(new User({username: 'kiodo'}));
        addUser(new User({username: 'fabio'}));
        addUser(new User({username: 'br1'}));
        
        connected_users = new ArrayCollection([{user:"alor", address:"1.1.2.3", logon:new Date(), privs: "A T V"},
                                               {user:"demo", address:"demo", logon:new Date(), privs: "V"},
                                               {user:"daniel", address:"5.6.7.8", logon:new Date(), privs: "T V"}]);
      }
      
      //TODO: get the users from db
    }
    
    public function newUser():User
    {
      // TODO: create the user in the db
      var u:User = new User();
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
  }
}