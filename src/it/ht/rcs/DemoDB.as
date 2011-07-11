package it.ht.rcs
{
  import com.adobe.serialization.json.JSON;
  
  import flash.events.TimerEvent;
  
  import it.ht.rcs.console.model.Collector;
  import it.ht.rcs.console.model.Group;
  import it.ht.rcs.console.model.Task;
  import it.ht.rcs.console.model.User;
  
  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;
  
  public class DemoDB implements IDB
  {
    
    private var demo_user:Object = {_id: '1', name: 'demo', contact:'demo@hackingteam.it', privs:new ArrayCollection(['ADMIN', 'TECH', 'VIEW']), locale:'en_US', group_ids:new ArrayCollection(['1']), timezone:0, enabled:true};

    public function DemoDB()
    {
    }
    
    public function setBusyCursor(value: Boolean):void
    {
      /* do nothing */
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
      var i:int = parseInt("0");
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
    
    /* AUDIT */
    
    public function audit_index(filter: Object, onResult:Function = null, onFault:Function = null):void
    {
      var items:ArrayCollection = new ArrayCollection();
      var time:int = (new Date().time) / 1000;
      items.addItem({_id: "4dd1312b963d351900000003", action: "user.update", actor: "admin", desc: "Updated 'privs' to '[\"ADMIN\", \"TECH\", \"VIEW\"]' for user 'test'", time: time, user: "test" });
      items.addItem({_id: "4dd133ef963d351a90000004", action: "user.update", actor: "admin", desc: "Updated 'desc' to 'This is a test user' for user 'test'", time: time, user: "test"});
      items.addItem({_id: "4dd134b9963d351af6000003", action: "user.update", actor: "admin", desc: "Updated 'desc' to 'This is a test user ' for user 'test'", time: time, user:"test"});
      items.addItem({_id: "4dd134b9963d351af6000004", action: "user.update", actor: "admin", desc: "Updated 'contact' to 'bla bla bla' for user 'test'", time: time, user:"test"});
      items.addItem({_id: "4dd134ec963d351af6000007", action: "user.update", actor: "admin", desc: "Changed password for user 'New User'", time: time, user:"test"});
      items.addItem({_id: "4dd134f5963d351af6000008", action: "user.update", actor: "admin", desc: "Updated 'privs' to '[\"ADMIN\", \"TECH\"]' for user 'finochky'", time: time, user:"test"});
      var event:ResultEvent = new ResultEvent("audit.index", false, true, items);
      if (onResult != null) 
        onResult(event);
    }
    
    public function audit_filters(onResult:Function = null, onFault:Function = null):void
    {
      var filters:Object = new Object;
      /*
      "{"_id":"4dd4e801963d350598000003","actions":["login","user.update","user.create","logout"],"actors":["admin"],"users":["admin","test","New User","finochky"]}"
      */
      filters["_id"] = "4dd4e801963d350598000003";
      filters["actions"] = ["login","user.update","user.create","logout"];
      filters["actors"] = ["admin"];
      filters["users"] = ["admin","test","New User","finochky"];
      var event:ResultEvent = new ResultEvent("audit.filters", false, true, filters);
      if (onResult != null)
        onResult(event);
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
      var event:ResultEvent = new ResultEvent("license.count", false, true, JSON.encode(counters));
      if (onResult != null) 
        onResult(event);     
    }
    
    /* STATUS */
    
    public function status_index(onResult:Function = null, onFault:Function = null):void
    {
      var items:ArrayCollection = new ArrayCollection();
      items.addItem({_id: '1', name: 'Collector', status:'0', address: '1.2.3.4', info: 'status for component...', time: new Date().time / 1000, pcpu:15, cpu:30, disk:10});
      items.addItem({_id: '2', name: 'Database', status:'1', address: '127.0.0.1', info: 'pay attention', time: new Date().time / 1000, pcpu:15, cpu:70, disk:20});
      items.addItem({_id: '3', name: 'Collector', status:'2', address: '5.6.7.8', info: 'houston we have a problem!', time: new Date().time / 1000, pcpu:70, cpu:90, disk:70});
      var event:ResultEvent = new ResultEvent("monitor.index", false, true, items);
      if (onResult != null) 
        onResult(event);
    }
    
    public function status_counters(onResult:Function = null, onFault:Function = null):void
    {
      var counters:Object = {"ok":1, "warn":1, "error":1};
        var event:ResultEvent = new ResultEvent("monitor.counters", false, true, JSON.encode(counters));
        if (onResult != null) 
          onResult(event);    
    }
    
    public function status_destroy(id:String, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
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
      items.addItem({_id: '1', name: 'demo', user_ids:new ArrayCollection(['1','2','3']), alert: false});
      items.addItem({_id: '2', name: 'developers', user_ids:new ArrayCollection(['2','3','4','5','6','7','8','9']), alert: false});
      items.addItem({_id: '3', name: 'test', user_ids:new ArrayCollection(['10']), alert: true});
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
    
    public function group_alert(group:Group, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    
    /* TASKS */
    
    //private dummyFile:String = 'http://www.google.it/images/logos/ps_logo2.png';
    private var dummyFile:String = 'http://www.birdlife.org/action/science/species/seabirds/tracking_ocean_wanderers.pdf';
    private var dummyFileSize:Number = 4993536;
    private var tasks:Object = {
      '5f58925c-2e86-9cff-5816-95fe5cbdd246': { _id: '5f58925c-2e86-9cff-5816-95fe5cbdd246',
                                                type: 'blotter',
                                                total: 1000,
                                                current: 0,
                                                desc: 'Blotter creation',
                                                grid_id: dummyFile,
                                                file_name: 'test.pdf'
                                              } 
      //'afa9abb1-7de2-b720-98a4-cb6c5185f693' : {_id: 'afa9abb1-7de2-b720-98a4-cb6c5185f693', type: 'file', total:10000, current: 0, desc: 'File download', grid_id: ''}
    };
    
    public function task_index(onResult:Function = null, onFault:Function = null):void
    {
      var task_list:ArrayCollection = new ArrayCollection();
      //for each (var item:Object in tasks) task_list.addItem(item);
      var event:ResultEvent = new ResultEvent("task.index", false, true, task_list);
      if (onResult != null)
        onResult(event);
    }
    
    public function task_show(id:String, onResult:Function = null, onFault:Function = null):void
    {
      var show:Object = {};
      show._id = tasks[id];
      show.grid_id = tasks[id].grid_id;
      show.current = tasks[id].current += 50;
      show.file_size = dummyFileSize;
      var event:ResultEvent = new ResultEvent("task.show", false, true, show);
      if (onResult != null)
        onResult(event);
    }
    
    public function task_create(task:Task, onResult:Function = null, onFault:Function = null):void
    {
      var newTask:Object = { _id: '__' + Math.round(Math.random() * 1000),
                             type: 'blotter',
                             total: 1000,
                             current: 0,
                             desc: new Date().time + " " + task.type,
                             grid_id: dummyFile,
                             file_name: task.file_name
                           }
      tasks[newTask._id] = newTask;
      var event:ResultEvent = new ResultEvent("task.create", false, true, newTask);
      if (onResult != null)
        onResult(event);
    }
    
    public function task_destroy(id:String, onResult:Function = null, onFault:Function = null):void
    {
      delete(tasks[id]);
      var event:ResultEvent = new ResultEvent("task.destroy", false, true, id);
      if (onResult != null)
        onResult(event);
    }
    
    /* COLLECTORS */
    
    public function collector_index(onResult:Function = null, onFault:Function = null):void
    {
      var items:ArrayCollection;

//      items = new ArrayCollection();
//      items.addItem({_id: '1', name:    'Main Collector', desc: 'uber collector...', address: '1.1.1.1', poll: false, port: 4444, configured: true, type:  'local'});
//      items.addItem({_id: '2', name: 'Backdup Collector', desc: 'uber collector...', address: '2.2.2.2', poll: false, port: 4444, configured: true, type:  'local'});
//      items.addItem({_id: '3', name:  'First Anonymizer', desc:   'nobody knows...', address: '3.3.3.3', poll: false, port: 4444, configured: true, type: 'remote'});
//      items.addItem({_id: '4', name: 'Second Anonymizer', desc:   'nobody knows...', address: '4.4.4.4', poll: false, port: 4444, configured: true, type: 'remote'});
//      items.addItem({_id: '5', name:  'Third Anonymizer', desc:   'nobody knows...', address: '5.5.5.5', poll: false, port: 4444, configured: true, type: 'remote'});

      var a:Array = [new Collector({_id: '4e020a65963d353c65000cef', _mid:  1, address: '192.168.1.100', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.100', instance: '525C4E89CDE6244A444EA4D23F482ED3RSS', name:      'Collector node', next: '4e020a65963d353c65000cf6', poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf0', _mid:  3, address: '192.168.1.172', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.172', instance:                                    '', name: 'Prod Public Address', next: '4e020a65963d353c65000cf7', poll: false, port: 4444, prev: '4e020a65963d353c65000cf2', type: 'remote', updated_at: '2011-06-22T17:29:41+02:00', version: 2010073101}),
                     new Collector({_id: '4e020a65963d353c65000cf1', _mid:  9, address: '192.168.1.172', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.172', instance: 'dbca550f1174f3028308344c4d58545dRSS', name:      'Collector node', next:                       null, poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf2', _mid: 15, address: '192.168.1.161', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.161', instance: '0C84BF20AA9B0C54F3AA2CB87AC8C6BARSS', name:      'Collector node', next: '4e020a65963d353c65000cf0', poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf3', _mid: 16, address: '192.168.1.189', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.189', instance: 'b943f1f6151bda08b82adfb0b0d21ce6RSS', name:      'Collector node', next:                       null, poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf4', _mid: 17, address: '192.168.1.189', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.189', instance: 'c02acdd7e9432d784e867a17f6a5f13cRSS', name:      'Collector node', next: '4e020a65963d353c65000cfa', poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf5', _mid: 18, address: '192.168.1.154', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.154', instance: '1252deed693ce0559eaf525558410f3dRSS', name:      'Collector node', next:                       null, poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf6', _mid: 19, address: '192.168.1.172', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.172', instance:                                    '', name:            'Anon EEE', next: '4e020a65963d353c65000cf8', poll: false, port: 4444, prev: '4e020a65963d353c65000cef', type: 'remote', updated_at: '2011-06-22T17:29:41+02:00', version: 2011011101}),
                     new Collector({_id: '4e020a65963d353c65000cf7', _mid: 20, address: '192.168.1.172', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.172', instance:                                    '', name:              'Test 1', next:                       null, poll: false, port: 4444, prev: '4e020a65963d353c65000cf0', type: 'remote', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf8', _mid: 21, address: '192.168.1.172', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.172', instance:                                    '', name:              'Test 2', next:                       null, poll: false, port: 4444, prev: '4e020a65963d353c65000cf6', type: 'remote', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cf9', _mid: 22, address: '192.168.1.189', configured:  true, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.189', instance: '6ad98ea6cb3338e48ed5778c6bf8f97fRSS', name:      'Collector node', next:                       null, poll: false, port:    0, prev:                       null, type:  'local', updated_at: '2011-06-22T17:29:41+02:00', version:          0}),
                     new Collector({_id: '4e020a65963d353c65000cfa', _mid: 23, address: '192.168.1.172', configured: false, created_at: '2011-06-22T17:29:41+02:00', desc: '192.168.1.172', instance:                                    '', name:                 'Asd', next:                       null, poll: false, port: 4444, prev: '4e020a65963d353c65000cf4', type: 'remote', updated_at: '2011-06-22T17:29:41+02:00', version:          0})];
      items = new ArrayCollection(a);
      
      var event:ResultEvent = new ResultEvent("collector.index", false, true, items);
      if (onResult != null)
        onResult(event);
    }
    
    public function collector_show(id:String, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    public function collector_create(coll:Collector, onResult:Function = null, onFault:Function = null):void
    {
      var c:Object = coll.toHash();
      c._id = new Date().getTime().toString();
      var event:ResultEvent = new ResultEvent("collector.create", false, true, c);
      onResult(event);
    }
    public function collector_update(coll:Collector, property:Object, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    public function collector_destroy(coll:Collector, onResult:Function = null, onFault:Function = null):void
    {
      /* do nothing */
    }
    
  }
}