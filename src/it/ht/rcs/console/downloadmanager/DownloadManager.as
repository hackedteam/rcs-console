package it.ht.rcs.console.downloadmanager
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Clock;
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.model.Task;
  
  import mx.collections.ArrayCollection;
  import mx.collections.ListCollectionView;
  import mx.core.FlexGlobals;
  import mx.rpc.events.ResultEvent;
  
  public class DownloadManager extends Manager
  {
    [Bindable]
    public var active:Boolean;
    
    private var timer:Timer = new Timer(250);
    
    /* singleton */
    private static var _instance:DownloadManager = new DownloadManager();
    public static function get instance():DownloadManager { return _instance; } 
    
    public function DownloadManager()
    {
      trace('Init Download Manager...');
      active = false;
      
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
      
      timer.addEventListener(TimerEvent.TIMER, periodicUpdate);
      timer.start();
    }
    
    private function periodicUpdate(e: TimerEvent):void
    {
      if (console.currentDB) console.currentDB.task_index(onTaskIndexResult);
    }
    
    override protected function onRefresh(e: RefreshEvent):void
    {
      trace('DownloadManager -- Refresh');
     
      super.onRefresh(e);
      
      console.currentDB.task_index(onTaskIndexResult);
    }
    
    public function onTaskIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      items.source.forEach(function itemToTask(element:*, index:int, arr:Array):void { addTask(new Task(element)); });
    }
    
    public function addTask(t:Task):void
    { 
      /* add to the active list */
      addItem(t);
      active = true;
    }
    
    public function removeTask(t:Task):void
    {
      /*
      // remove the task
      var idx : int = tasks.getItemIndex(t);
      if (idx >= 0) 
        tasks.removeItemAt(idx);
      
      // no more active tasks
      if (tasks.length == 0)
        active = false;
      */
    }
    
  }
}