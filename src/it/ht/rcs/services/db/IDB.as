package it.ht.rcs.services.db
{
  public interface IDB
  {
    function login(params:Object, onResult:Function, onFault:Function):void;
    function logout():void;
    
    function users(onResult:Function = null, onFault:Function = null):void;
    function groups(onResult:Function = null, onFault:Function = null):void;
  }
}
