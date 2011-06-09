  package it.ht.rcs.services.db
{
  import com.adobe.serialization.json.JSONParseError;
  
  import it.ht.rcs.console.model.Account;
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.User;
  
  import mx.controls.Alert;
  import mx.resources.ResourceManager;
    
  public class RemoteDB implements IDB
  {
    import com.adobe.serialization.json.JSON;
    
    import it.ht.rcs.services.db.DB;
    
    import mx.rpc.CallResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    private var _delegate:DB;
    
    public function RemoteDB(baseURL:String)
    {
      _delegate = new DB;
      _delegate.baseURL = baseURL;
      _delegate.showBusyCursor = false;
    }
    
    public function setBusyCursor(value:Boolean):void
    {
      _delegate.showBusyCursor = value;
    }
    
//    private function onFatalError(event:*):void
//    {
//      /* back to the login screen */ 
//      FlexGlobals.topLevelApplication.currentState = "LoggedOut";
//    }
    
    /* default Fault handler */
    private function onDeFault(e:FaultEvent):void
    {
      var message:String = "ERROR";
      
      /* avoid multiple messages, by checking if the currentSession is valid */
      if (console.currentSession == null) {
        return;
      }
      
      /* http code 403 means our session is not valid */
      if (e.statusCode == 403) {
        Alert.show(ResourceManager.getInstance().getString('localized_db_messages', 'INVALID_SESSION'), ResourceManager.getInstance().getString('localized_main', 'ERROR'));
        //new Account().logout(onFatalError, onFatalError);
        Account.instance.logout();
        return; 
      }
            
      /* server error (cannot connect) */
      if (e.statusCode == 0) {
        Alert.show(ResourceManager.getInstance().getString('localized_db_messages', 'SERVER_ERROR'), ResourceManager.getInstance().getString('localized_main', 'ERROR'));
        //new Account().logout(onFatalError, onFatalError);
        Account.instance.logout();
        return;
      }
      
      /* decode the message from the server */
      var decoded:*;
      try {
        decoded = JSON.decode(e.fault.content as String);
      } catch (e:JSONParseError) {
        decoded = "";
      }
        
      /* guess which error it is */
      if (decoded is Array)
        message = decoded[0];
      else if (decoded is String)
        message = decoded;
      else
        message = decoded.toString();
      
      var localized_error:String = ResourceManager.getInstance().getString('localized_db_messages', message);
      
      if (localized_error == null)
        localized_error = message;
      
      Alert.show(localized_error, ResourceManager.getInstance().getString('localized_main', 'ERROR'));
    }
    
    private function getCallResponder(onResult:Function, onFault:Function):CallResponder
    {
      /* set up the responder */
      var resp:CallResponder = new CallResponder();
      
      if (onResult != null) 
        resp.addEventListener(ResultEvent.RESULT, onResult);
      
      /* 
        if the Fault handler is provided, use it.
        otherwise use the default one.
      */
      if (onFault != null) 
        resp.addEventListener(FaultEvent.FAULT, onFault);
      else
        resp.addEventListener(FaultEvent.FAULT, onDeFault);
      
      return resp;
    }
    
    /***** METHODS ******/
    
    /* AUTH */
    
    public function login(params:Object, onResult:Function, onFault:Function):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.login(JSON.encode(params));
    }
    
    public function logout(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.logout();
    }

    /* SESSION */
    
    public function session_index(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.session_index(); 
    }    
    
    public function session_destroy(cookie:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.session_destroy(JSON.encode({session: cookie}));
    }
    
    /* AUDIT */
    public function audit_index(filter: Object, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.audit_index(JSON.encode(filter));
    }
    
    public function audit_filters(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.audit_filters();
    }
    
    /* LICENSE */
    
    public function license_limit(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.license_limit(); 
    }

    public function license_count(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.license_count(); 
    }

    /* STATUS */

    public function status_index(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.status_index();       
    }
    
    public function status_counters(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.status_counters();
    }
    
    public function status_destroy(id:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.status_destroy(JSON.encode({status: id}));
    }
    
    /* USERS */
    
    public function user_index(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.user_index(); 
    }

    public function user_show(id:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.user_show(id); 
    }
    
    public function user_create(user:User, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.user_create(JSON.encode(user.toHash()));
    }
    
    public function user_update(user:User, property:Object, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      property['user'] = user._id;
      resp.token = _delegate.user_update(JSON.encode(property));
    }
    
    public function user_destroy(user:User, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.user_destroy(JSON.encode({user: user._id}));
    }
    
    /* GROUPS */
    
    public function group_index(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.group_index(); 
    }
    
    public function group_show(id:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.group_show(id); 
    }
    
    public function group_create(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.group_create(JSON.encode(group.toHash()));
    }
    
    public function group_update(group:Group, property:Object, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      property['group'] = group._id;
      resp.token = _delegate.group_update(JSON.encode(property));
    }
    
    public function group_destroy(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.group_destroy(JSON.encode({group: group._id}));
    }
    
    public function group_add_user(group:Group, user:User, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.group_add_user(JSON.encode( {group: group._id, user: user._id} ));      
    }
    
    public function group_del_user(group:Group, user:User, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.group_del_user(JSON.encode( {group: group._id, user: user._id} ));         
    }
    
    public function group_alert(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      if (group != null) 
        resp.token = _delegate.group_alert(JSON.encode( {group: group._id} ));
      else
        resp.token = _delegate.group_alert(JSON.encode( {group: null} ));
    }
    
    public function task_index(onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.task_index();
    }
    
    public function task_show(id:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.task_show(id); 
    }
    
    public function task_create(type:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.task_create(JSON.encode( {type: type} ));
    }
    
    public function task_destroy(id:String, onResult:Function = null, onFault:Function = null):void
    {
      var resp:CallResponder = getCallResponder(onResult, onFault);
      resp.token = _delegate.task_destroy(JSON.encode({task: id}));
    }
  }
}