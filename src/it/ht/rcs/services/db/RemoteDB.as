  package it.ht.rcs.services.db
{
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.User;
  
  import mx.controls.Alert;
  import mx.resources.ResourceManager;
    
  public class RemoteDB implements IDB
  {
    import com.adobe.serialization.json.JSON;
    
    import it.ht.rcs.services.db.ServiceDB;
    
    import mx.rpc.CallResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    private var _delegate:ServiceDB;
    
    public function RemoteDB(baseURL:String)
    {
      _delegate = new ServiceDB;
      _delegate.baseURL = baseURL;
      _delegate.showBusyCursor = true;
    }

    /* default Fault handler */
    private function onDeFault(e:FaultEvent):void
    {
      var message:String = "ERROR";
      var decoded:* = JSON.decode(e.fault.content as String);
      
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

    public function user_update(user:User, onResult:Function = null, onFault:Function = null):void
    {
      // FIXME: how fucking ??!?!?
      //var resp:CallResponder = getCallResponder(onResult, onFault);
      //resp.token = _delegate.user_update(user._id, JSON.encode(user.toHash()));
    }

    public function user_destroy(user:User, onResult:Function = null, onFault:Function = null):void
    {
      // FIXME: how fucking ??!?!?
      //var resp:CallResponder = getCallResponder(onResult, onFault);
      //resp.token = _delegate.user_destroy(user._id, null);
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
    
    public function group_update(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      
    }
    
    public function group_destroy(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      
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
  }
}