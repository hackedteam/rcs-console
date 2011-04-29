package it.ht.rcs.console.monitor
{
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
    
    /* singleton */
    private static var _instance:StatusManager = new StatusManager();
    public static function get instance():StatusManager { return _instance; } 
    
    public function StatusManager()
    {
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
    
      // FIXME: MOCK remove this
      addEntry(new StatusEntry({title: 'uno', status:'OK', address: '1.2.3.4', desc: 'status for component...', time: new Date().time, cpu:15, cput:30, df:10}));
      addEntry(new StatusEntry({title: 'due', status:'WARN', address: '1.2.3.4', desc: 'pay attention', time: new Date().time, cpu:15, cput:70, df:20}));
      addEntry(new StatusEntry({title: 'tre', status:'KO', address: '1.2.3.4', desc: 'huston we have a problem!', time: new Date().time, cpu:70, cput:90, df:70}));
    }
    
    public function onRefresh(e:Event):void
    {
      trace('StatusManager -- Refresh');
      
      statuses.getItemAt(0).time = new Date().time;
      
      return;
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
    }
  }
}