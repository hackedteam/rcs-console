package it.ht.rcs.console.downloadmanager
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.model.Clock;
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.collections.ArrayCollection;
  import mx.core.FlexGlobals;
  
  public class DownloadManager
  {
   
    [Bindable]
    public var active:Boolean;
    
    [Bindable]
    public var tasks:ArrayCollection = new ArrayCollection();
    
    /* singleton */
    private static var _instance:DownloadManager = new DownloadManager();
    public static function get instance():DownloadManager { return _instance; } 
    
    public function DownloadManager()
    {
      trace('Init Download Manager...');
      active = false;

      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
    }
   
    private function onRefresh(e:Event):void
    {
      trace('DownloadManager -- Refresh');
      
      tasks.removeAll();
      
      /* DEMO MOCK */
      //if (console.currentSession.fake) {
      if (true) {
        var p:int = 1000;
        var t:Task = new Task();
        
        t.title = "Blotter";
        t.time = Clock.instance.currentConsoleTime;
        t.set_creation_size(1000000);
        t.set_download_size(500000);
        
        var t2:Task = new Task();
        
        t2.title = "Offline CD ";
        t2.time = Clock.instance.currentConsoleTime;
        t2.set_creation_size(500000);
        t2.set_download_size(500000);
        
        
        addTask(t);
        addTask(t2);      
        
        var tc:Timer = new Timer(100);
        tc.addEventListener(TimerEvent.TIMER, function updateProgress(evt:TimerEvent):void {
          p += 1000;
          t.update_creation(p);
          t2.update_creation(p);
        });
        
        tc.start();
      }
    }
    
    public function addTask(t:Task):void
    { 
      /* add to the active list */
      tasks.addItem(t);
      active = true;
    }
    
    public function removeTask(t:Task):void
    {
      /* remove the task */
      var idx : int = tasks.getItemIndex(t);
      if (idx >= 0) 
        tasks.removeItemAt(idx);
      
      /* no more active tasks */
      if (tasks.length == 0)
        active = false;
    }
    
  }
}