package it.ht.rcs.console.model
{
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  
  import it.ht.rcs.console.accounting.User;

  public class Account
  {
   
    [Bindable]
    public var username:String;
    [Bindable]
    public var server:String;
    
    public function Account()
    {
      load_previous();
    }
    
    
    public function login(user:String, pass:String, server:String, callback:Function, errback:Function):void
    {
      // FIXME: remove the mock
      if (server != 'demo') {
        errback('Cannot connect to server (not yet)');
        return;
      }
      
      // FIXME: remove the mock
      if (user == 'demo' && pass == '') {  
        /* save the info for the next login */
        save_previous(user, server);
        /* instantiate the global currentSession object for the logged in user */
        var u:User = new User();
        // FIXME: remove the fake
        console.currentSession = new Session(u, true);
        /* invoke the callback */
        callback();
        return;
      } 
        
      errback('Incorrect Username or Password...');
    }
    
    private function load_previous():void
    {
      try {
        var s:FileStream = new FileStream();
        var f:File = File.applicationStorageDirectory.resolvePath("login.info");
        s.open(f, FileMode.READ);
        var lastLogon:Object = s.readObject();
        username = lastLogon.username;
        server = lastLogon.server;
        s.close();
      } catch(e:*) {
        /* in case the file does not exist */
      }      
    }
    
    private function save_previous(user:String, server:String):void
    {
      try {
        var s:FileStream = new FileStream();
        var f:File = File.applicationStorageDirectory.resolvePath("login.info");
        s.open(f, FileMode.WRITE);
        var lastLogon:Object = new Object();
        lastLogon.username = user;
        lastLogon.server = server;
        s.writeObject(lastLogon);
        s.close();
      } catch(e:*) {        
      }
    }
  }
}