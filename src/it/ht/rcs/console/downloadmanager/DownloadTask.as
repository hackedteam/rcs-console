package it.ht.rcs.console.downloadmanager
{
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.notifications.NotificationPopup;
  import it.ht.rcs.console.task.model.Task;
  import it.ht.rcs.console.utils.FileDownloader;
  
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  
  public class DownloadTask
  {
    public static const STATE_IDLE:String = 'idle';
    public static const STATE_CREATING:String = 'creating';
    public static const STATE_DOWNLOADING:String = 'downloading';
    public static const STATE_FINISHED:String = 'finished';
    
    private var creationTimer: Timer;
    private var fileDownloader: FileDownloader;
    
    [Bindable]
    private var db:DB;
    
    [Bindable]
    public var task: Task;
    [Bindable]
    public var state:String = STATE_IDLE;
    [Bindable]
    public var creation_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    [Bindable]
    public var download_percentage:Object = {bytesLoaded:0, bytesTotal:0};
    
    public function get desc():String
    {
      return this.task.desc;
    }
    
    public function DownloadTask(task: Object, db: DB)
    {
      trace("Creating DownloadTask " + task._id);
      this.task = new Task(task);
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
      trace("Deleting task " + task._id);
      db.task.destroy(task);    
    }
    
    public function start_update():void
    {
      if (state != STATE_IDLE) return;
      creationTimer = new Timer(1000);
      creationTimer.addEventListener(TimerEvent.TIMER, function ():void {
        db.task.show(task._id, onUpdate, onUpdateFailure);
      });
      creationTimer.start();
    }
    
    public function isFinished():Boolean
    {
      return (state == DownloadTask.STATE_FINISHED);
    }
    
    public function isCreating(): Boolean
    {
      return (state == DownloadTask.STATE_CREATING);
    }
    
    public function isDownloading(): Boolean
    {
      return (state == DownloadTask.STATE_DOWNLOADING);
    }
    
    public function onUpdateFailure(event:FaultEvent):void
    {
      trace("Update failure!!! " + event);
    }
    
    private function onUpdate(event:ResultEvent):void
    {
      // update description, progress and resource
      task.desc = event.result.desc;
      task.current = event.result.current;
      task.resource = event.result.resource;
      trace ("Updating task " + event.result._id + "[current: " + task.current + " | total: " + task.total + "]");
      
      // update creation progress bar
      creation_percentage.bytesTotal = task.total;
      creation_percentage.bytesLoaded = task.current;
      
      // if creation is complete, start the download
      if (task.current == task.total) {  
        creationTimer.stop();
        creationTimer = null;
        
        trace("Task " + task._id +" creation complete.");
        
        //NotificationPopup.showNotification(ResourceManager.getInstance().getString('localized_main', 'TASK_COMPLETE', [desc]));
        
        if (event.result.resource._id) {
          trace("Downloading file " + event.result.resource._id);
          
          // downloads are stored into /Desktop/RCS Downloads 
          var path:String = File.desktopDirectory.nativePath + '/RCS Downloads';
          new File(path).createDirectory();
          
          // start the downloader
          var remote_uri:String = task.resource.type + '/' + task.resource._id;
          var local_path:String = path + '/' + task.file_name;
          fileDownloader = new FileDownloader(remote_uri, local_path);
          fileDownloader.onProgress = onDownloadUpdate;
          fileDownloader.onComplete = onDownloadComplete;
          fileDownloader.download();
          
          state = STATE_DOWNLOADING;
          
        } else {
          state = STATE_FINISHED;
        }
        
      } else {
        state = STATE_CREATING;
      }
      
    }
    
    public function onDownloadUpdate(cur:Number, total:Number):void
    {
      // update download progress bar
      download_percentage.bytesLoaded = cur;
      download_percentage.bytesTotal = total;
    }
    
    public function onDownloadComplete():void
    {
      state = STATE_FINISHED;
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