package it.ht.rcs.console.downloadmanager
{
  
  import flash.events.Event;
  
  import it.ht.rcs.console.events.AccountEvent;
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.model.Task;
  
  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;
  
  public class DownloadManager extends Manager
  {
    
    /* singleton */
    private static var _instance:DownloadManager = new DownloadManager();
    public static function get instance():DownloadManager { return _instance; } 
    
    [Bindable]
    public var active:Boolean = false;
    
    public function DownloadManager()
    {
      trace(_classname + ' (instance) -- Init');
    }
    
    override protected function onLoggingIn(e:AccountEvent):void
    {
      trace(_classname + ' (instance) -- Logging In');
      console.currentDB.task_index(onTaskIndexResult);
    }
    
    private function onTaskIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      
      if (active = items.length > 0)
        items.source.forEach(itemToTask);
    }
    
    private function itemToTask(element:*, index:int, arr:Array):void
    {
      var task:Task = new Task(element);
      addTask(task);
      task.start_update();
    }
    
    override protected function onLoggingOut(e:AccountEvent):void
    {
      trace(_classname + ' (instance) -- Logging Out');
      for each(var t:Task in _items.source)
      if (t.state != Task.STATE_FINISHED) {
        e.preventDefault();
        return;
      }
    }
    
    override protected function onForceLogOut(e:AccountEvent):void
    {
      trace(_classname + ' (instance) -- Force Log Out');
      for each(var t:Task in _items.source)
      t.cancel();
      super.onForceLogOut(e);
    }
    
    public function createTask(type:String):void
    {
      console.currentDB.task_create(type, onTaskCreateResult);
    }
    
    public function onTaskCreateResult(e:ResultEvent):void
    {
      itemToTask(e.result, 0, null);
    }
    
    public function destroyTask(t:Task):void
    {
      console.currentDB.task_destroy(t._id, onTaskDestroyResult);
      removeTask(t);
    }
    
    public function onTaskDestroyResult(e:ResultEvent):void
    {
      //removeTask(t);
    }
    
    private function addTask(t:Task):void
    {
      addItem(t);
      active = _items.length > 0;
    }
    
    private function removeTask(t:Task):void
    {
      removeItem(t);
      active = _items.length > 0;
    }
    
  }
  
}