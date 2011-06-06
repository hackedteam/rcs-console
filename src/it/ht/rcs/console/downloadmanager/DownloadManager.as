package it.ht.rcs.console.downloadmanager
{
  
  import flash.desktop.NativeApplication;
  import flash.events.Event;
  
  import it.ht.rcs.console.model.Manager;
  import it.ht.rcs.console.model.Task;
  
  import mx.collections.ArrayCollection;
  import mx.rpc.events.ResultEvent;
  
  public class DownloadManager extends Manager
  {
    
    [Bindable]
    public var active:Boolean = false;
    
    public function DownloadManager()
    {
      trace('Init Download Manager...');
      NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
      console.currentDB.task_index(onTaskIndexResult);
    }
    
    private function onTaskIndexResult(e:ResultEvent):void
    {
      var items:ArrayCollection = e.result as ArrayCollection;
      _items.removeAll();
      
      if (active = items.length > 0)
        items.source.forEach(itemToTask);
    }
    
    private function itemToTask(element:*, index:int, arr:Array):void {
      var task:Task = new Task(element);
      addTask(task);
      task.start_update();
    }
    
    public function createTask(type:String):void {
      console.currentDB.task_create(type, onTaskCreateResult);
    }
    
    public function onTaskCreateResult(e:ResultEvent):void {
      itemToTask(e.result, 0, null);
    }
    
    public function destroyTask(t:Task):void {
      console.currentDB.task_destroy(t._id, onTaskDestroyResult);
      removeTask(t);
    }
    
    public function onTaskDestroyResult(e:ResultEvent):void {
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
    
    private function onExiting(event:Event):void
    {
    }
    
  }
  
}