package it.ht.rcs.console.monitor
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.ArrayCollection;
  import mx.core.FlexGlobals;
  import mx.graphics.shaderClasses.SaturationShader;

  public class StatusManager
  {
    
    [Bindable]
    public var statuses:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var counters:Object = {ok: 1, warn:1, ko:1};
    
    private var _counterBaloon:MonitorCounter = new MonitorCounter();
    
    /* for the auto refresh every 15 seconds */
    private var _autorefresh:Timer = new Timer(15000);
    
    /* singleton */
    private static var _instance:StatusManager = new StatusManager();
    public static function get instance():StatusManager { return _instance; } 
    
    public function StatusManager()
    {
      trace('Init StatusManager');
      
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefreshCounter);
      
      // FIXME: MOCK remove this
      addEntry(new StatusEntry({title: 'uno', status:'OK', address: '1.2.3.4', desc: 'status for component...', time: new Date().time, cpu:15, cput:30, df:10}));
      addEntry(new StatusEntry({title: 'due', status:'WARN', address: '1.2.3.4', desc: 'pay attention', time: new Date().time, cpu:15, cput:70, df:20}));
      addEntry(new StatusEntry({title: 'tre', status:'KO', address: '1.2.3.4', desc: 'huston we have a problem!', time: new Date().time, cpu:70, cput:90, df:70}));
    }
    
    private function onRefresh(e:Event):void
    {
      trace('StatusManager -- Refresh');
      
      // FIXME: MOCK remove this
      statuses.getItemAt(0).time = new Date().time;
      
      // TODO: get from db
    }
   
    public function addEntry(e:StatusEntry):void
    { 
      statuses.addItem(e);
    }
    
    public function removeEntry(e:StatusEntry):void
    {
      var idx : int = statuses.getItemIndex(e);
      if (idx >= 0) 
        statuses.removeItemAt(idx);
      
      // TODO: remove from db
    }
    
    public function autorefresh_start():void
    {
      _autorefresh.addEventListener(TimerEvent.TIMER, onRefresh);
    }
    public function autorefresh_stop():void
    {
      _autorefresh.removeEventListener(TimerEvent.TIMER, onRefresh);
    }

    
    public function add_counters():void
    {
      /* add the baloon to the screen */
      FlexGlobals.topLevelApplication.addElement(_counterBaloon);
      
      /* start the auto refresh when the section is open */
      _autorefresh.addEventListener(TimerEvent.TIMER, onRefreshCounter);
      _autorefresh.start();
      
      /* the first refresh */
      onRefreshCounter(null);
    }

    public function remove_counters():void
    {
      FlexGlobals.topLevelApplication.removeElement(_counterBaloon);
      
      /* stop the auto refresh when going away */
      _autorefresh.removeEventListener(TimerEvent.TIMER, onRefreshCounter);
      _autorefresh.stop();
    }

    private function onRefreshCounter(e:Event):void
    {
      trace('StatusManager -- Refresh Counters');
      /* get the position of the Monitor button */
      var buttons:ArrayCollection = FlexGlobals.topLevelApplication.MainPanel.sectionsButtonBar.dataProvider;
      var len:int = buttons.length;
      var index:int = buttons.toArray().indexOf("Monitor") + 1;
      
      /* find the correct displacement (starting from right) */
      _counterBaloon.right = 3 + ((len - index) * 90);
      _counterBaloon.top = 43;
      _counterBaloon.visible = false;
      
      // FIXME: MOCK remove this
      _counterBaloon.value = (Math.round( Math.random() * 100 ));
      _counterBaloon.style = "alert";
      _counterBaloon.visible = true;
      
      // TODO: get from db
    }
  }
}