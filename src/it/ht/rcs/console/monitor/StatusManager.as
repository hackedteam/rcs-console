package it.ht.rcs.console.monitor
{
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.core.FlexGlobals;

  public class StatusManager
  {
    
    [Bindable]
    public var statuses:Array = [{title: 'uno', status:'OK', address: '1.2.3.4', desc: 'status for component...', time: new Date().time, cpu:15, cput:30, df:10},
                                 {title: 'due', status:'WARN', address: '1.2.3.4', desc: 'pay attention', time: new Date().time, cpu:15, cput:70, df:20},
                                 {title: 'tre', status:'KO', address: '1.2.3.4', desc: 'huston we have a problem!', time: new Date().time, cpu:70, cput:90, df:70},
                                ];
    
    public var counters:Object = {ok: 1, warn:1, ko:1};
    
    /* singleton */
    private static var _instance:StatusManager = new StatusManager();
    public static function get instance():StatusManager { return _instance; } 
    
    public function StatusManager()
    {
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
    private function onRefresh(e:Event):void
    {
      trace('StatusManager -- Refresh');
      
    }
    
  }
}