package it.ht.rcs.console.downloadmanager
{
  import com.adobe.serialization.json.JSON;
  
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.events.SessionEvent;
  import it.ht.rcs.console.model.ItemManager;
  import it.ht.rcs.console.task.model.Task;
  
  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;
  
  public class DownloadManager extends ItemManager
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
    
    override protected function onLoggingIn(e:SessionEvent):void
    {
      trace(_classname + ' (instance) -- Logging In');
      // get all available tasks
      console.currentDB.task.all(onTaskIndexResult);
    }
    
    private function onTaskIndexResult(e:ResultEvent):void
    {
      trace(_classname + ' (onTaskIndexResult) e.result = ' + e.result);
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      
      if (active = items.length > 0)
        items.source.forEach(itemToDownloadTask);
    }
    
    private function itemToDownloadTask(task:Object, index:int, arr:Array):void
    {
      trace(_classname + ' (itemToDownloadTask) e.result = ' + task);
      var downloadTask:DownloadTask = new DownloadTask(task, console.currentDB);
      addTask(downloadTask);
      downloadTask.start_update();
    }
    
    override protected function onLoggingOut(e:SessionEvent):void
    {
      trace(_classname + ' (instance) -- Logging Out');
      for each(var t:DownloadTask in _items)
      if (t.state != DownloadTask.STATE_FINISHED) {
        e.preventDefault();
        return;
      }
    }
    
    override protected function onForceLogOut(e:SessionEvent):void
    {
      trace(_classname + ' (instance) -- Force Log Out');
      clearFinished();
      for each(var t:DownloadTask in _items)
        t.cleanup();
      super.onForceLogOut(e);
    }
    
    public function clearFinished():void
    {
      for (var i:int = _items.length-1; i >= 0; i--)
      {
        if (_items.source[i].isFinished())
          removeTask(_items.getItemAt(i) as DownloadTask);
      }
    }
    
    public function createTask(type:String, fileName:String):void
    {
      console.currentDB.task.create({type: type, file_name: fileName}, onTaskCreateResult);
    }
    
    public function onTaskCreateResult(e:ResultEvent):void
    {
      itemToDownloadTask(e.result as Task, 0, null);
    }
    
    override protected function onItemRemove(t:*):void
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