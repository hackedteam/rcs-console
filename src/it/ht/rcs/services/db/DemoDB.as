package it.ht.rcs.services.db
{
  import com.adobe.serialization.json.JSON;
  
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.User;
  
  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;
  
  public class DemoDB implements IDB
  {
    
    private var demo_user:Object = {_id: '1', name: 'demo', contact:'demo@hackingteam.it', privs:new ArrayCollection(['ADMIN', 'TECH', 'VIEW']), locale:'en_US', group_ids:new ArrayCollection(['1']), timezone:0, enabled:true};

    public function DemoDB()
    {
      
    }
    
    /***** METHODS ******/
    
    /* AUTH */
    
    public function login(params:Object, onResult:Function, onFault:Function):void
    {
      var result:Object = {cookie: 0, time: 0, user: demo_user};
      var event:ResultEvent = new ResultEvent("login", false, true, result);
      onResult(event);
    }
    
    public function logout(onResult:Function = null, onFault:Function = null):void
    {
      var event:ResultEvent = new ResultEvent("logout", false, true, null);
      if (onResult != null) 
        onResult(event);
    }
    
    /* SESSION */
    
    public function session_index(onResult:Function = null, onFault:Function = null):void
    {
      var items:ArrayCollection = new ArrayCollection();
      items.addItem({user:{name:"alor"}, address:"1.1.2.3", time:(new Date().time - 20000) / 1000, level: new ArrayCollection(['admin', 'tech', 'view'])});
      items.addItem({user:{name:"demo"}, address:"demo", time:new Date().time / 1000, level: new ArrayCollection(['view'])});
      items.addItem({user:{name:"daniel"}, address:"5.6.7.8", time:(new Date().time - 5000) / 1000, level: new ArrayCollection(['tech', 'view'])});
      items.addItem({user:{name:"admin"}, address:"10.11.12.13", time:(new Date().time - 2000) / 1000, level: new ArrayCollection(['admin'])});
      var event:ResultEvent = new ResultEvent("session.index", false, true, items);
      if (onResult != null) 
        onResult(event);
    }
    
    public function session_destroy(cookie:String, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    
    /* LICENSE */
    
    public function license_limit(onResult:Function = null, onFault:Function = null):void
    {
      var limits:Object = {"type":"reusable",
                           "serial":1234567890,
                           "users":15,
                           "backdoors":{"total":Infinity,"desktop":15,"mobile":15,"windows":true,"macos":true,"linux":false,"winmo":false,"iphone":false,"blackberry":true,"symbian":false,"android":true},
                           "alerting":true,
                           "correlation":false,
                           "rmi":true,
                           "ipa":5,
                           "collectors":{"collectors":Infinity,"anonymizers":5}};
      
      var event:ResultEvent = new ResultEvent("license.limit", false, true, JSON.encode(limits));
      if (onResult != null) 
        onResult(event);      
    }

    public function license_count(onResult:Function = null, onFault:Function = null):void
    {
      var counters:Object = {"users":10,
                             "backdoors":{"total":5,"desktop":3,"mobile":2},
                             "collectors":{"collectors":1,"anonymizers":1},
                             "ipa":2};
      var event:ResultEvent = new ResultEvent("license.limit", false, true, JSON.encode(counters));
      if (onResult != null) 
        onResult(event);     
    }
    
    /* USERS */
    
    public function user_index(onResult:Function = null, onFault:Function = null):void
    {
      var items:ArrayCollection = new ArrayCollection();
      items.addItem(demo_user);
      items.addItem({_id: '2', name: 'alor', locale:'en_US', group_ids:new ArrayCollection(['1','2']), enabled:true, privs:new ArrayCollection(['ADMIN', 'TECH', 'VIEW'])});
      items.addItem({_id: '3', name: 'daniel', locale:'it_IT', group_ids:new ArrayCollection(['1','2']), enabled:true, privs:new ArrayCollection(['ADMIN', 'TECH', 'VIEW'])});
      items.addItem({_id: '4', name: 'naga', group_ids:new ArrayCollection(['2']), enabled:true, privs:new ArrayCollection(['VIEW'])});
      items.addItem({_id: '5', name: 'que', group_ids:new ArrayCollection(['2']), enabled:false});
      items.addItem({_id: '6', name: 'zeno', group_ids:new ArrayCollection(['2']), enabled:true, privs:new ArrayCollection(['TECH', 'VIEW'])});
      items.addItem({_id: '7', name: 'rev', group_ids:new ArrayCollection(['2']), enabled:false});
      items.addItem({_id: '8', name: 'kiodo', group_ids:new ArrayCollection(['2']), enabled:false});
      items.addItem({_id: '9', name: 'fabio', group_ids:new ArrayCollection(['2']), enabled:false});
      items.addItem({_id: '10', name: 'br1', group_ids:new ArrayCollection(['3']), enabled:false});
      var event:ResultEvent = new ResultEvent("user.index", false, true, items);
      if (onResult != null) 
        onResult(event);
    }
    
    public function user_show(id:String, onResult:Function = null, onFault:Function = null):void
    {  
      /* do nothing */
    }
    
    public function user_create(user:User, onResult:Function = null, onFault:Function = null):void
    {
      var u:Object = user.toHash();
      u._id = new Date().getTime().toString();
      u.privs = new ArrayCollection(u.privs);
      u.group_ids = new ArrayCollection(u.group_ids);
      var event:ResultEvent = new ResultEvent("user.create", false, true, u);
      onResult(event);
    }

    public function user_update(user:User, property:Object, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }

    public function user_destroy(user:User, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    
    /* GROUPS */
    
    public function group_index(onResult:Function = null, onFault:Function = null):void
    {
      var items:ArrayCollection = new ArrayCollection();
      items.addItem({_id: '1', name: 'demo', user_ids:new ArrayCollection(['1','2','3'])});
      items.addItem({_id: '2', name: 'developers', user_ids:new ArrayCollection(['2','3','4','5','6','7','8','9'])});
      items.addItem({_id: '3', name: 'test', user_ids:new ArrayCollection(['10'])});
      var event:ResultEvent = new ResultEvent("group.index", false, true, items);
      if (onResult != null) 
        onResult(event);
    }
    
    public function group_show(id:String, onResult:Function = null, onFault:Function = null):void
    {  
      /* do nothing */
    }

    public function group_create(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      var g:Object = group.toHash();
      g._id = new Date().getTime().toString();
      g.user_ids = new ArrayCollection(g.user_ids);
      var event:ResultEvent = new ResultEvent("user.create", false, true, g);
      if (onResult != null) 
        onResult(event);
    }
    
    public function group_update(group:Group, property:Object, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    
    public function group_destroy(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    
    public function group_add_user(group:Group, user:User, onResult:Function = null, onFault:Function = null):void
    {
      group.user_ids.addItem(user._id);
      user.group_ids.addItem(group._id);
      var event:ResultEvent = new ResultEvent("group.add_user", false, true, group);
      if (onResult != null) 
        onResult(event);
    }
    
    public function group_del_user(group:Group, user:User, onResult:Function = null, onFault:Function = null):void
    {
      var idx:int = group.user_ids.getItemIndex(user._id);
      if (idx >= 0)
        group.user_ids.source.splice(idx, 1);
      
      var idy:int = user.group_ids.getItemIndex(group._id);
      if (idy >= 0)
        user.group_ids.source.splice(idy, 1);
      
      var event:ResultEvent = new ResultEvent("group.del_user", false, true, group);
      if (onResult != null) 
        onResult(event);
    }
  }
}
