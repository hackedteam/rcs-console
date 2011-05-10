package it.ht.rcs.services.db
{
  public interface IDB
  {
    function login(params:Object, onResult:Function, onFault:Function):void;
    function logout():void;
    
    function user_index(onResult:Function = null, onFault:Function = null):void;
    function group_index(onResult:Function = null, onFault:Function = null):void;
  }
}
