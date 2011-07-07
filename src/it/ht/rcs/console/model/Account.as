package it.ht.rcs.console.model
{
  
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.DBFaultNotifier;
  import it.ht.rcs.console.I18N;
  import it.ht.rcs.console.accounting.model.User;
  import it.ht.rcs.console.events.AccountEvent;
  
  import mx.controls.Alert;
  import mx.core.FlexGlobals;
  import mx.events.CloseEvent;
  import mx.resources.ResourceManager;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  
  public class Account
  {
    
    /* singleton */
    private static var _instance:Account = new Account();
    public static function get instance():Account { return _instance; } 
    
    [Bindable]
    public var lastUsername:String;
    [Bindable]
    public var lastServer:String;
    
    private var _errback:Function;
    private var _callback:Function;
    
    public function Account()
    {
      load_previous();
    }
    
    public function logout(exitApplication:Boolean = false):void {
    
      trace('Account.logout');
      
      var event:AccountEvent = new AccountEvent(AccountEvent.LOGGING_OUT, false, true);
      FlexGlobals.topLevelApplication.dispatchEvent(event);
      if (event.isDefaultPrevented())
        Alert.show(ResourceManager.getInstance().getString('localized_main', 'CONFIRM_LOGOUT'),
                   ResourceManager.getInstance().getString('localized_main', 'CONFIRM'),
                   Alert.OK | Alert.CANCEL, null, function(event:CloseEvent):void {
                                                    if(event.detail == Alert.OK)
                                                      forceLogout(exitApplication);
                                                  }
                   );
      else
        forceLogout(exitApplication);
    }
    
    public function forceLogout(exitApplication:Boolean = false):void {
      
      trace('Account.forceLogout');
      
      var event:AccountEvent = new AccountEvent(AccountEvent.FORCE_LOG_OUT, false, true);
      FlexGlobals.topLevelApplication.dispatchEvent(event);
      
      /* destroy the current session */
      console.currentSession.destroy();
      console.currentSession = null;
      /* request to the DB, ignoring the results */
      console.currentDB.session.logout();
      exitApplication ? FlexGlobals.topLevelApplication.exit() : FlexGlobals.topLevelApplication.currentState = console.LOGGED_OUT_STATE;
      
    }
    
    public function login(user:String, pass:String, server:String, callback:Function, errback:Function):void
    {
      trace('Account.login');
      
      this.lastUsername = user;
      this.lastServer = server;
      
      var notifier:DBFaultNotifier = new DBFaultNotifier();
      
      /* this is for DEMO purpose only, no database will be contacted, all the data are fake */
      if (user == 'demo' && pass == '' && server == 'demo') {
        console.currentDB = new DB(server, notifier, new I18N());
        trace('Account.login -- DEMO MODE');
      } else {
        console.currentDB = new DB(server, notifier, new I18N());
      }
      
      /* remember the function for the async handlers */
      _callback = callback;
      _errback = errback;
      
      console.currentDB.session.login({user:user, pass:pass}, onResult, onFault);
      
    }
    
    private function onResult(e:ResultEvent):void
    {
      /* save the info for the next login */
      save_previous();
      
      var u:User = e.result.user as User;
      
      /* create the current session */
      console.currentSession = new Session(u, lastServer, e.result.cookie);
      
      /* invoke the callback */
      _callback();
    }
    
    private function onFault(e:FaultEvent):void
    {
      /* HTTP 403 is "not authorized" */
      if (e.statusCode == 403) {
        _errback('Incorrect Username or Password...');
        return;
      }
      
      _errback('Cannot connect to server');
    }
    
    private function load_previous():void
    {
      try {
        var s:FileStream = new FileStream();
        var f:File = File.applicationStorageDirectory.resolvePath("login.info");
        s.open(f, FileMode.READ);
        var lastLogon:Object = s.readObject();
        this.lastUsername = lastLogon.username;
        this.lastServer = lastLogon.server;
        s.close();
      } catch(e:*) {
        /* in case the file does not exist */
      }
    }
    
    private function save_previous():void
    {
      try {
        var s:FileStream = new FileStream();
        var f:File = File.applicationStorageDirectory.resolvePath("login.info");
        s.open(f, FileMode.WRITE);
        var lastLogon:Object = new Object();
        lastLogon.username = this.lastUsername;
        lastLogon.server = this.lastServer;
        s.writeObject(lastLogon);
        s.close();
      } catch(e:*) {        
      }
    }
    
  }
  
}