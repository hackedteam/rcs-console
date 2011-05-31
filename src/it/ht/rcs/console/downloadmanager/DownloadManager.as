package it.ht.rcs.console.downloadmanager
{
  import flash.desktop.NativeApplication;
  import flash.events.Event;
  
  import it.ht.rcs.console.events.RefreshEvent;
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.model.Task;
  
  import mx.collections.ArrayCollection;
  import mx.core.FlexGlobals;
  import mx.rpc.events.ResultEvent;
  
  public class DownloadManager extends Manager
  {
    [Bindable]
    public var active:Boolean = false;
    
    //private var timer:Timer = new Timer(250, 1);
    
    public function DownloadManager()
    {
      trace('Init Download Manager...');
      
      //FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
      NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
      
      console.currentDB.task_index(onTaskIndexResult);
      
//      timer.addEventListener(TimerEvent.TIMER, periodicUpdate);
//      timer.start();
    }
    
    private function onExiting(event:Event):void {
      //event.preventDefault();
    }
    
//    private function periodicUpdate(e: TimerEvent):void
//    {
//      if (console.currentDB) console.currentDB.task_index(onTaskIndexResult);
//    }
    
//    override protected function onRefresh(e: RefreshEvent):void
//    {
//      trace('DownloadManager -- Refresh');
//     
//      super.onRefresh(e);
//      
//      //console.currentDB.task_index(onTaskIndexResult);
//    }
    
    public function onTaskIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      items.source.forEach(function itemToTask(element:*, index:int, arr:Array):void {
        var task:Task = new Task(element);
        addTask(task);
        task.start_update();
      });
    }
    
    public function addTask(t:Task):void
    { 
      // add to the active list
      addItem(t);
      active = true;
    }
    
    public function removeTask(t:Task):void
    {
      // remove the task
      _items.removeItem(t);

      // no more active tasks
      if (_items.length == 0)
        active = false;
    }
    
  }
}