package it.ht.rcs.console.model
{
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.notifications.NotificationPopup;
  import it.ht.rcs.console.utils.FileDownloader;
  
  import mx.rpc.events.ResultEvent;
  
  public class Task extends EventDispatcher
  {
    
    public static const STATE_IDLE:String = 'idle';
    public static const STATE_CREATING:String = 'creating';
    public static const STATE_DOWNLOADING:String = 'downloading';
    public static const STATE_FINISHED:String = 'finished';
    
    [Bindable]
    public var _id:String;
    [Bindable]
    public var type:String;
    [Bindable]
    public var current:int;
    [Bindable]
    public var total:int;
    [Bindalbe]
    public var desc:String;
    [Bindable]
    public var grid_id:String;
    [Bindable]
    public var time:String;
    [Bindable]
    public var state:String = Task.STATE_IDLE;
    [Bindable]
    public var creation_undefined:Boolean = true;
    
    private var creationTimer:Timer;
    private var fileDownloader:FileDownloader; 
    
    [Bindable(event="percentageChanged")]
    public var creation_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    [Bindable(event="percentageChanged")]
    public var download_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    
    public function Task(data:Object = null)
    {
      _id = data._id;
      type = data.type;
      current = data.current;
      total = data.total;
      desc = data.desc;
      grid_id = data.grid_id;
      
      if(current >= total) {
        
      }
      
    }
    
    public function start_update():void
    {
      creationTimer = new Timer(500);
      creationTimer.addEventListener(TimerEvent.TIMER, update);
      creationTimer.start();
    }
    
    private function update(event:TimerEvent):void
    {
      console.currentDB.task_show(_id, update_creation);
    }
    
//    public function set_creation_size(total:Number):void 
//    {
//      //creation_percentage.bytesTotal = total;
//      creation_undefined = false;
//    }
    
//    public function set_download_size(total:Number):void
//    {
//      ///download_percentage.bytesTotal = total;
//    }
    
    public function update_creation(event:ResultEvent):void
    {
      
      state = Task.STATE_CREATING;
      
      current = event.result.current;
      
      creation_percentage.bytesTotal = total;
      creation_percentage.bytesLoaded = current;
      dispatchEvent(new Event("percentageChanged"));
      
      if (current > total && creationTimer) {
        
        creationTimer.stop();
        creationTimer = null;
        
        NotificationPopup.showNotification("Task <b>'" + desc + "'</b> completed.<br/>The file you requested is now downloading...");
        
        if (event.result.grid_id) {
          
          grid_id = event.result.grid_id;
          
          var path:String = File.desktopDirectory.nativePath;
          fileDownloader = new FileDownloader(grid_id, path + '/' + _id + '.pdf');
          fileDownloader.onProgress = update_download;
          fileDownloader.onComplete = complete;
          fileDownloader.download();
          
          state = STATE_DOWNLOADING;
        
        } else {
          state = STATE_FINISHED;
        }
        
      }
      
    }
    
    public function update_download(cur:Number):void
    {
      download_percentage.bytesTotal = 4993536;
      download_percentage.bytesLoaded = cur;
      dispatchEvent(new Event("percentageChanged"));
    }
    
    public function complete():void
    {
      state = Task.STATE_FINISHED;
      NotificationPopup.showNotification("Download complete...");
    }
    
    public function cancel():void
    {
      
      if (creationTimer) {
        creationTimer.stop();
        creationTimer = null;
      }
      
      if (fileDownloader) {
        fileDownloader.cancelDownload();
        fileDownloader = null;
      }
      
      console.downloadManager.destroyTask(this);
      
    }
    
  }
  
}