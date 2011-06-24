package it.ht.rcs.console.model
{
  import mx.collections.ArrayCollection;
  import mx.controls.Alert;
  import mx.resources.ResourceManager;
  import mx.rpc.events.ResultEvent;
  
  public class Collector
  {
    [Bindable]
    public var _id:String;
    [Bindable]
    public var name:String;
    [Bindable]
    public var desc:String;
    [Bindable]
    public var address:String;
    [Bindable]
    public var type:String;
    [Bindable]
    public var port:int;
    [Bindable]
    public var instance:String;
    [Bindable]
    public var version:String;
    [Bindable]
    public var poll:Boolean;
    [Bindable]
    public var configured:Boolean;
    [Bindable]
    public var next:String;
    [Bindable]
    public var prev:String;

    
    public function Collector(data:Object = null)
    {
      /* default user (when creating new collector) */
      if (data == null) {
        _id = '';
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_COLLECTOR');
        desc = '';
        poll = false;
        address = '';
        type = 'remote';
        port = 4444;
        configured = true;
      } else {
        /* existing collector */
        _id = data._id;
        name = data.name;
        desc = data.desc;
        poll = data.poll;
        address = data.address;
        type = data.type;
        port = data.port;
        prev = data.prev;
        next = data.next;
      }
    }
    
    public function toHash():Object
    {
      return {name: name, desc: desc, poll: poll, address: address, type: type, port: port, prev: prev, next: next};
    }

    public function reload():void
    {
      /* reload data from db */      
      console.currentDB.collector_show(_id, onReload);
    }
    
    private function onReload(e:ResultEvent):void
    {
      var u:Object = e.result;
      
      name = u.name;
      desc = u.desc;
    }
    
    public function save():void
    {
      console.currentDB.collector_update(this, this.toHash());
    }
  }
}