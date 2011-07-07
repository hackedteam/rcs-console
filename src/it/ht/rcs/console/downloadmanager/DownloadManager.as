package it.ht.rcs.console.downloadmanager
{
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.events.AccountEvent;
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.task.model.Task;
  
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
      //console.currentDB.task.all(onTaskIndexResult);
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
      var task:DownloadTask = new DownloadTask(element, console.currentDB);
      addTask(task);
      task.start_update();
    }
    
    override protected function onLoggingOut(e:AccountEvent):void
    {
      trace(_classname + ' (instance) -- Logging Out');
      for each(var t:DownloadTask in _items)
      if (t.state != DownloadTask.STATE_FINISHED) {
        e.preventDefault();
        return;
      }
    }
    
    override protected function onForceLogOut(e:AccountEvent):void
    {
      trace(_classname + ' (instance) -- Force Log Out');
      for each(var t:DownloadTask in _items)
        t.cleanup();
      super.onForceLogOut(e);
    }
    
    public function createTask(type:String, fileName:String):void
    {
      console.currentDB.task.create({type: type, file_name: fileName}, onTaskCreateResult);
    }
    
    public function onTaskCreateResult(e:ResultEvent):void
    {
      itemToTask(e.result, 0, null);
    }
    
    public function destroyTask(t:DownloadTask):void
    {
      t.cleanup();
      removeTask(t);
      t.destroy();
    }
        
    public function addTask(t:DownloadTask):void
    {
      addItem(t);
      active = _items.length > 0;
    }
    
    public function removeTask(t:DownloadTask):void
    {
      removeItem(t);
      active = _items.length > 0;
    }
    
  }
  
}