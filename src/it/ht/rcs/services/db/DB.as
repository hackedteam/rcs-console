/**
 * This is a generated sub-class of _DB.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 **/
 
package it.ht.rcs.services.db
{
  import mx.rpc.http.HTTPMultiService;
  import mx.rpc.http.Operation;
  
  public class DB extends _Super_DB
  {
               
    public function DB()
    {
      if (console.currentSession != null && console.currentSession.server != null)
        this.baseURL = console.currentSession.server;
    }
    
    public function set baseURL(url:String):void
    {
      //trace('Initialize the DB.baseURL to: ' + url);
      _serviceControl.baseURL = "https://" + url + ":4444/";      
    }
  
  }

}
