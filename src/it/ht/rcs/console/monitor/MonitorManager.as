package it.ht.rcs.console.monitor
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import it.ht.rcs.console.events.RefreshEvent;
	import it.ht.rcs.console.model.Manager;
	import it.ht.rcs.console.model.Status;
	import it.ht.rcs.console.utils.CounterBaloon;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.rpc.events.ResultEvent;

  public class MonitorManager extends Manager
  {
    
    private var _counterBaloon:CounterBaloon = new CounterBaloon();
    
    /* for the auto refresh every 15 seconds */
    private var _autorefresh:Timer = new Timer(15000);
    
    /* singleton */
    private static var _instance:MonitorManager = new MonitorManager();
    public static function get instance():MonitorManager { return _instance; } 
    
    public function MonitorManager()
    {
      super();
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefreshCounter);
    }
    
    override protected function onRefresh(e:RefreshEvent):void
    {
      super.onRefresh(e);
      console.currentDB.status_index(onMonitorIndexResult);
    }
   
    private function onMonitorIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      items.source.forEach(function toMonitorArray(element:*, index:int, arr:Array):void {
        addItem(new Status(element));
      });
    }
    
    override protected function onItemRemove(o:*):void 
    { 
      console.currentDB.status_destroy(o._id);
    }
    
    private function onAutoRefresh(e:Event):void
    {
      onRefresh(null);
    }
    
    override public function start():void
    {
      super.start();
      _autorefresh.addEventListener(TimerEvent.TIMER, onAutoRefresh);
    }
	
    override public function stop():void
    {
      super.stop();
      _autorefresh.removeEventListener(TimerEvent.TIMER, onAutoRefresh);
    }

    
    override public function removeItem(o:Object):void
    {
      super.removeItem(o);
      /* update the couters without waiting for next auto-refresh */
      onRefreshCounter(null);
    }
    
    public function start_counters():void
    {
      /* add the baloon to the screen */
      FlexGlobals.topLevelApplication.addElement(_counterBaloon);
      
      /* start the auto refresh when the section is open */
      _autorefresh.addEventListener(TimerEvent.TIMER, onRefreshCounter);
      _autorefresh.start();
      
      /* the first refresh */
      onRefreshCounter(null);
    }

    public function stop_counters():void
    {
      FlexGlobals.topLevelApplication.removeElement(_counterBaloon);
      
      /* stop the auto refresh when going away */
      _autorefresh.removeEventListener(TimerEvent.TIMER, onRefreshCounter);
      _autorefresh.stop();
    }

    private function onRefreshCounter(e:Event):void
    {
      trace(_classname + ' -- Refresh Counters');
      
      console.currentDB.status_counters(onMonitorCounters);
    }
    
    private function onMonitorCounters(e:ResultEvent):void
    {
      /* get the position of the Monitor button */
      var buttons:ArrayCollection = FlexGlobals.topLevelApplication.mainPanel.sectionsButtonBar.dataProvider;
      var len:int = buttons.length;
      var index:int = buttons.toArray().indexOf("Monitor") + 1;
      
      /* find the correct displacement (starting from right) */
      _counterBaloon.right = 3 + ((len - index) * 90);
      _counterBaloon.top = 43;

      /* default, reset all values */
      _counterBaloon.value = 0;
      
      var counters:Object = JSON.decode(e.result as String);
      
      if (counters['error'] != 0) {
        _counterBaloon.value = counters['error'];
        _counterBaloon.style = 'alert';
      } else if (counters['warn'] != 0) {
        _counterBaloon.value = counters['warn'];
        _counterBaloon.style = 'warn';        
      }
      
      /* display it or not */
      if (_counterBaloon.value > 0)
        _counterBaloon.visible = true;
      else
        _counterBaloon.visible = false;
    }
        
  }
}