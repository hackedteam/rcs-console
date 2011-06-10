package it.ht.rcs.console.downloadmanager
{
  
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
      for each(var t:Task in _items)
      if (t.state != Task.STATE_FINISHED) {
        e.preventDefault();
        return;
      }
    }
    
    override protected function onForceLogOut(e:AccountEvent):void
    {
      trace(_classname + ' (instance) -- Force Log Out');
      for each(var t:Task in _items)
        t.cleanup();
      super.onForceLogOut(e);
    }
    
    public function createTask(type:String, fileName:String):void
    {
      var task:Task = new Task();
      task.type = type;
      task.file_name = fileName;
      console.currentDB.task_create(task, onTaskCreateResult);
    }
    
    public function onTaskCreateResult(e:ResultEvent):void
    {
      itemToTask(e.result, 0, null);
    }
    
    public function destroyTask(t:Task):void
    {
      //console.currentDB.task_destroy(t._id, onTaskDestroyResult);
      console.currentDB.task_destroy(t._id);
      t.cleanup();
      removeTask(t);
    }
    
//    public function onTaskDestroyResult(e:ResultEvent):void
//    {
//      //removeTask(t);
//    }
    
    public function addTask(t:Task):void
    {
      addItem(t);
      active = _items.length > 0;
    }
    
    public function removeTask(t:Task):void
    {
      removeItem(t);
      active = _items.length > 0;
    }
    
  }
  
}