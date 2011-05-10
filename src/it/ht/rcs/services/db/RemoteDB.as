  package it.ht.rcs.services.db
{
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
    
    public function login(params:Object, onResult:Function, onFault:Function):void
    {
      /* set up the responder */
      var resp:CallResponder = new CallResponder();
      resp.addEventListener(ResultEvent.RESULT, onResult);
      resp.addEventListener(FaultEvent.FAULT, onFault);
      
      /* perform the async request */
      resp.token = _delegate.login(JSON.encode(params));
    }
    
    public function logout():void
    {
      _delegate.logout();
    }
    
    public function user_index(onResult:Function = null, onFault:Function = null):void
    {
      /* set up the responder */
      var resp:CallResponder = new CallResponder();
      resp.addEventListener(ResultEvent.RESULT, onResult);
      if (onFault != null) resp.addEventListener(FaultEvent.FAULT, onFault);
      
      /* perform the async request */
      resp.token = _delegate.user_index(); 
    }
    
    public function group_index(onResult:Function = null, onFault:Function = null):void
    {
      
    }
  }
}