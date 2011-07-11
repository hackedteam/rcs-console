package it.ht.rcs.console.downloadmanager
{
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.notifications.NotificationPopup;
  import it.ht.rcs.console.task.model.Task;
  import it.ht.rcs.console.utils.FileDownloader;
  
  import mx.rpc.events.ResultEvent;

  public class DownloadTask
  {
    public static const STATE_IDLE:String = 'idle';
    public static const STATE_CREATING:String = 'creating';
    public static const STATE_DOWNLOADING:String = 'downloading';
    public static const STATE_FINISHED:String = 'finished';
    
    private var creationTimer:Timer;
    private var fileDownloader:FileDownloader;
    private var task: it.ht.rcs.console.task.model.Task;
    
    [Bindable]
    private var db:DB;
    [Bindable]
    public var state:String = STATE_IDLE;
    [Bindable]
    public var creation_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    [Bindable]
    public var download_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    
    public function DownloadTask(task: Task, db: DB)
    {
      this.task = task;
      this.db = db;
    }
    
    public function factory(type:String, fileName:String):DownloadTask
    {
      var task: Task;
      console.currentDB.task.create({type: type, file_name: fileName}, function(e:ResultEvent):void {
        task = e.result as Task;
      });
      
      return new DownloadTask(task, db);
    }
    
    public function destroy():void
    {
      db.task.destroy(task._id);     
    }
    
    public function start_update():void
    {
      if (state != STATE_IDLE) return;
      creationTimer = new Timer(1000);
      creationTimer.addEventListener(TimerEvent.TIMER, update);
      creationTimer.start();
    }
    
    private function update(event:TimerEvent):void
    {
      db.task.show(task._id, update_creation);
    }
    
    private function update_creation(event:ResultEvent):void
    {
      task.desc = event.result.desc;
      task.current = event.result.current;
      
      creation_percentage.bytesTotal = task.total;
      creation_percentage.bytesLoaded = task.current;
      
      if (task.current == task.total) {
        
        creationTimer.stop();
        creationTimer = null;
        
        //NotificationPopup.showNotification(ResourceManager.getInstance().getString('localized_main', 'TASK_COMPLETE', [desc]));
        
        if (event.result.grid_id) {
          
          task.resource = event.result.resource;
          download_percentage.bytesTotal = event.result.file_size;
          
          var path:String = File.desktopDirectory.nativePath + '/RCS Downloads';
          new File(path).createDirectory();
          fileDownloader = new FileDownloader(task.resource._id, path + '/' + task.file_name);
          fileDownloader.onProgress = update_download;
          fileDownloader.onComplete = complete;
          fileDownloader.download();
          
          state = STATE_DOWNLOADING;
          
        } else {
          state = STATE_FINISHED;
        }
        
      } else {
        state = STATE_CREATING;
      }
      
    }
    
    public function update_download(cur:Number, total:Number):void
    {
      download_percentage.bytesLoaded = cur;
      download_percentage.bytesTotal = total;
    }
    
    public function complete():void
    {
      state = STATE_FINISHED;
      db.task.destroy(task._id);
      //NotificationPopup.showNotification(ResourceManager.getInstance().getString('localized_main', 'DOWNLOAD_COMPLETE'));
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