package it.ht.rcs.console.model
{
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  
  import it.ht.rcs.services.db.IDB;
  import it.ht.rcs.services.db.RemoteDB;
  import it.ht.rcs.services.db.DemoDB;
  
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  
  import mx.controls.Alert;
  
  public class Account
  {
   
    [Bindable]
    public var username:String;
    [Bindable]
    public var server:String;
    
    private var _errback:Function;
    private var _callback:Function;
    
    public function Account()
    {
      load_previous();
    }
    
    public function login(user:String, pass:String, server:String, callback:Function, errback:Function):void
    {
      trace('Account.login');
      
      this.username = user;
      this.server = server;
      
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
      console.currentSession = new Session(u, server);
      
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
    
    public function logout():void
    {
      trace('Account.logout');
      /* request to the DB, ignoring the results */
      console.currentDB.logout();
    }
    
    private function load_previous():void
    {
      try {
        var s:FileStream = new FileStream();
        var f:File = File.applicationStorageDirectory.resolvePath("login.info");
        s.open(f, FileMode.READ);
        var lastLogon:Object = s.readObject();
        this.username = lastLogon.username;
        this.server = lastLogon.server;
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
        lastLogon.username = this.username;
        lastLogon.server = this.server;
        s.writeObject(lastLogon);
        s.close();
      } catch(e:*) {        
      }
    }
  }
}