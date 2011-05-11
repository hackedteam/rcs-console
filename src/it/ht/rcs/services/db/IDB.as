package it.ht.rcs.services.db
{
  import it.ht.rcs.console.model.User;

  public interface IDB
  {
    function login(params:Object, onResult:Function, onFault:Function):void;
    function logout():void;
    
    function user_index(onResult:Function = null, onFault:Function = null):void;
    function user_create(user:User, onResult:Function = null, onFault:Function = null):void;
    function user_update(user:User, onResult:Function = null, onFault:Function = null):void;
    function user_destroy(user:User, onResult:Function = null, onFault:Function = null):void;
    
    function group_index(onResult:Function = null, onFault:Function = null):void;
  }
}
