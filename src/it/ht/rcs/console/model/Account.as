package it.ht.rcs.console.model
{
  
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  
  import it.ht.rcs.console.events.AccountEvent;
  import it.ht.rcs.services.db.DemoDB;
  import it.ht.rcs.services.db.RemoteDB;
  
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
    
      var event:AccountEvent = new AccountEvent(AccountEvent.LOGGING_OUT, false, true);
      trace(event.isDefaultPrevented() as String);
      FlexGlobals.topLevelApplication.dispatchEvent(event);
      trace(event.isDefaultPrevented() as String);
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
      
      var event:AccountEvent = new AccountEvent(AccountEvent.FORCE_LOG_OUT, false, true);
      FlexGlobals.topLevelApplication.dispatchEvent(event);
      
      trace('Account.logout');
      /* destroy the current session */
      console.currentSession.destroy();
      console.currentSession = null;
      /* request to the DB, ignoring the results */
      console.currentDB.logout();
      exitApplication ? FlexGlobals.topLevelApplication.exit() : FlexGlobals.topLevelApplication.currentState = console.LOGGED_OUT_STATE;
      
    }
    
    public function login(user:String, pass:String, server:String, callback:Function, errback:Function):void
    {
      trace('Account.login');
      
      this.lastUsername = user;
      this.lastServer = server;
      
      /* this is for DEMO purpose only, no database will be contacted, all the data are fake */
      if (user == 'demo' && pass == '' && server == 'demo') {
        console.currentDB = new DemoDB();
        trace('Account.login -- DEMO MODE');
      } else {
        console.currentDB = new RemoteDB(server);
      }
      
      /* remember the function for the async handlers */
      _callback = callback;
      _errback = errback;
      
      console.currentDB.login({user:user, pass:pass}, onResult, onFault);
      
    }
    
    private function onResult(e:ResultEvent):void
    {
      trace('Account.login -- result');
      /* save the info for the next login */
      save_previous();
      
      var u:User = new User(e.result.user);
      
      /* create the current session */
      console.currentSession = new Session(u, lastServer);
      
      /* invoke the callback */
      _callback();
    }
    
    private function onFault(e:FaultEvent):void
    {
      trace('Account.login -- fault');

      /* HTTP 403 is "not authorized" */
      if (e.statusCode == 403) {
        _errback('Incorrect Username or Password...');
        return;
      }
      
      _errback('Cannot connect to server');
    }
    
//    public function logout(callback:Function = null, errback:Function = null):void
//    {
//      trace('Account.logout');
//      /* dispatch the event for all */
//      FlexGlobals.topLevelApplication.dispatchEvent(new LogonEvent(LogonEvent.LOGGING_OUT));
//      /* destroy the current session */
//      console.currentSession.destroy();
//      console.currentSession = null;
//      /* request to the DB, ignoring the results */
//      console.currentDB.logout(callback, errback);
//    }
    
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