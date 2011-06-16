package it.ht.rcs.console.model
{
  
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.net.URLRequest;
  import flash.net.navigateToURL;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.downloadmanager.DownloadManager;
  import it.ht.rcs.console.notifications.NotificationPopup;
  import it.ht.rcs.console.utils.FileDownloader;
  
  import mx.resources.ResourceManager;
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
    [Bindalbe]
    public var grid_id:String;
    [Bindable]
    public var file_name:String;
    [Bindable]
    public var time:String;
    [Bindable]
    public var state:String = Task.STATE_IDLE;
    [Bindable]
    public var creation_undefined:Boolean = true;
    
    private var creationTimer:Timer;
    private var fileDownloader:FileDownloader; 
    
    [Bindable]
    public var creation_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    [Bindable]
    public var download_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    
    public function Task(data:Object = null)
    {
      if (data != null) {
        _id = data._id;
        type = data.type;
        current = data.current;
        total = data.total;
        desc = data.desc;
        grid_id = data.grid_id;
        file_name = data.file_name;
      }
    }
    
    public function start_update():void
    {
      if (state != Task.STATE_IDLE) return;
      creationTimer = new Timer(500);
      creationTimer.addEventListener(TimerEvent.TIMER, update);
      creationTimer.start();
    }
    
    private function update(event:TimerEvent):void
    {
      console.currentDB.task_show(_id, update_creation);
    }
    
    private function update_creation(event:ResultEvent):void
    {
      
      current = event.result.current;
      
      creation_percentage.bytesTotal = total;
      creation_percentage.bytesLoaded = current;
      
      if (current == total) {
        
        creationTimer.stop();
        creationTimer = null;
        
        NotificationPopup.showNotification(ResourceManager.getInstance().getString('localized_main', 'TASK_COMPLETE', [desc]));
        
        if (event.result.grid_id) {
          
          grid_id = event.result.grid_id;
          download_percentage.bytesTotal = event.result.file_size;
          
          var path:String = File.desktopDirectory.nativePath + '/RCS Downloads';
          new File(path).createDirectory();
          fileDownloader = new FileDownloader(grid_id, path + '/' + file_name);
          fileDownloader.onProgress = update_download;
          fileDownloader.onComplete = complete;
          fileDownloader.download();

          state = STATE_DOWNLOADING;
        
        } else {
          state = STATE_FINISHED;
        }
        
      } else {
        state = Task.STATE_CREATING;
      }
    
    }
    
    public function update_download(cur:Number):void
    {
      download_percentage.bytesLoaded = cur;
    }
    
    public function complete():void
    {
      state = Task.STATE_FINISHED;
      console.currentDB.task_destroy(_id);
      NotificationPopup.showNotification(ResourceManager.getInstance().getString('localized_main', 'DOWNLOAD_COMPLETE'));
    }
    
    public function cleanup():void
    {
      
      if (creationTimer) {
        creationTimer.stop();
        creationTimer = null;
      }
      
      if (fileDownloader) {
        fileDownloader.cancelDownload();
        fileDownloader = null;
      }
      
    }
    
  }
  
}