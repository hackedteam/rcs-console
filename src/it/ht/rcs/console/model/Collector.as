package it.ht.rcs.console.model
{
  import it.ht.rcs.console.network.renderers.CollectorRenderer;
  
  import mx.collections.ArrayCollection;
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
    public var poll:Boolean;
    [Bindable]
    public var configured:Boolean;
    [Bindable]
    public var instance:String;
    [Bindable]
    public var version:String;
    [Bindable]
    public var next:String;
    [Bindable]
    public var prev:String;

    public var renderer:CollectorRenderer;

    public function Collector(data:Object = null)
    {
      /* default values (when creating new collector) */
      if (data == null) {
        _id = '';
        name = ResourceManager.getInstance().getString('localized_main', 'NEW_COLLECTOR');
        desc = '';
        address = '';
        type = 'remote';
        port = 4444;
        poll = false;
        configured = true;
      } else {
        /* existing collector */
        _id = data._id;
        name = data.name;
        desc = data.desc;
        address = data.address;
        type = data.type;
        port = data.port;
        poll = data.poll;
        next = data.next is ArrayCollection ? data.next[0] : data.next;
        prev = data.prev is ArrayCollection ? data.prev[0] : data.prev;
      }
      renderer = new CollectorRenderer(this);
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private var _nextHop:Collector;
    private var _prevHop:Collector;
    
    public function get nextHop():Collector
    {
      return _nextHop;
    }
    
    public function set nextHop(newNextHop:Collector):void
    {
      _nextHop = newNextHop;
    }
    
    public function get prevHop():Collector
    {
      return _prevHop;
    }
    
    public function set prevHop(newPrevHop:Collector):void
    {
      _prevHop = newPrevHop;
    }
    
    public function moveAfter(destination:Collector):void
    {
      if (_prevHop === destination)
        return;
      
      _prevHop._nextHop = _nextHop;
      if (_nextHop != null)
        _nextHop._prevHop = _prevHop;
      
      if (destination._nextHop != null)
        destination._nextHop._prevHop = this;
      _nextHop = destination._nextHop;
      _prevHop = destination;
      destination._nextHop = this;
    }
    
    public function detach():void
    {
      if (_nextHop != null)
        _nextHop._prevHop = _prevHop;
      _prevHop._nextHop = _nextHop;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  }
}