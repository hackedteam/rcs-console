package it.ht.rcs.services.db
{
  import mx.rpc.events.ResultEvent;
  
  import valueObjects.DBSession;

  public class DemoDB implements IDB
  {
    
    private var demo_user:Object = {id:1, name: 'demo', contact:'demo@hackingteam.it', privs:['ADMIN', 'TECH', 'VIEW'], locale:'en_US', groups:[1], time_offset:0, enabled:true};

    public function DemoDB()
    {
      
    }
    
    public function login(params:Object, onResult:Function, onFault:Function):void
    {
      var result:Object = {cookie: 0, time: 0, user: demo_user};
      var event:ResultEvent = new ResultEvent("login", false, true, result);
      onResult(event);
    }
    
    public function logout():void
    {
      
    }
    
    public function users(onResult:Function = null, onFault:Function = null):void
    {
      var items:Array = new Array();
      items.push(demo_user);
      items.push({id: 2, name: 'alor', locale:'en_US', groups:[1,2], enabled:true, privs:['ADMIN', 'TECH', 'VIEW']});
      items.push({id: 3, name: 'daniel', locale:'it_IT', groups:[1,2], enabled:true, privs:['ADMIN', 'TECH', 'VIEW']});
      items.push({id: 4, name: 'naga', groups:[2], enabled:true, privs:['VIEW']});
      items.push({id: 5, name: 'que', groups:[2], enabled:false});
      items.push({id: 6, name: 'zeno', groups:[2], enabled:true, privs:['TECH', 'VIEW']});
      items.push({id: 7, name: 'rev', groups:[2], enabled:false});
      items.push({id: 8, name: 'kiodo', groups:[2], enabled:false});
      items.push({id: 9, name: 'fabio', groups:[2], enabled:false});
      items.push({id: 10, name: 'br1', groups:[3], enabled:false});
      var event:ResultEvent = new ResultEvent("users", false, true, items);
      onResult(event);
    }
    
    public function groups(onResult:Function = null, onFault:Function = null):void
    {
      var items:Array = new Array();
      items.push({id:1, name: 'demo', users:[1,2,3]});
      items.push({id:2, name: 'developers', users:[2,3,4,5,6,7,8,9]});
      items.push({id:3, name: 'test', users:[10]});
      var event:ResultEvent = new ResultEvent("groups", false, true, items);
      onResult(event);
    }
  }
}