package it.ht.rcs.console.model
{
  import com.adobe.serialization.json.JSON;
  
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  
  import it.ht.rcs.services.db.DB;
  
  import mx.controls.Alert;
  import mx.rpc.CallResponder;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  
  import valueObjects.DBSession;
  
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
        trace('Account.login -- DEMO MODE');
        /* save the info for the next login */
        save_previous();
        /* instantiate the global currentSession object for the logged in user */
        var u:User = new User({id:1, name: 'demo', contact:'demo@hackingteam.it', privs:['ADMIN', 'TECH', 'VIEW'], locale:'en_US', groups:[1], time_offset:0, enabled:true});
        /* create a fake session */
        console.currentSession = new Session(u, server, true);
        /* invoke the callback */
        callback();
        return;
      } 
      
      /* real request to the DB */
      var db:DB = new DB();
      
      db.baseURL = server;
      db.showBusyCursor = true;

      /* set up the responder */
      var resp:CallResponder = new CallResponder();
      resp.addEventListener(ResultEvent.RESULT, onResult);
      resp.addEventListener(FaultEvent.FAULT, onFault);

      /* remember the function for the async handlers */
      _callback = callback;
      _errback = errback;
      
      /* perform the async request */
      resp.token = db.login(JSON.encode({user:user, pass:pass}));
    }
    
    private function onResult(e:ResultEvent):void
    {
      trace('Account.login -- result');
      /* save the info for the next login */
      save_previous();
      /* instantiate the global currentSession object for the logged in user */
      // TODO: take the real users
      var u:User = new User({name: 'alor'});
      // TODO: parse the current session
      var sess:DBSession = e.result as DBSession;
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
      new DB().logout();
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