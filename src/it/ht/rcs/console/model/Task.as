package it.ht.rcs.console.model
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.geom.PerspectiveProjection;
  import flash.net.FileReference;
  import flash.net.URLRequest;
  import flash.net.URLStream;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.notifications.NotificationPopup;
  import it.ht.rcs.console.utils.FileDownloader;
  
  import mx.controls.Alert;
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
    
    private var creation_timer:Timer;
    
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
    
    public function start_update():void {
      creation_timer = new Timer(500);
      creation_timer.addEventListener(TimerEvent.TIMER, update);
      creation_timer.start();
    }
    
    private function update(event:TimerEvent):void {
      console.currentDB.task_show(_id, updateResult);
    }
    
    private function updateResult(event:ResultEvent):void {
      update_creation(event.result.current);
    }

//    public function set_creation_size(total:Number):void 
//    {
//      //creation_percentage.bytesTotal = total;
//      creation_undefined = false;
//    }
    
    public function set_download_size(total:Number):void 
    {
      ///download_percentage.bytesTotal = total;
    }
    
    public function update_creation(cur:Number):void 
    {
      creation_percentage.bytesTotal = total;
      creation_percentage.bytesLoaded = cur;
      current = cur;
      if (current > total && creation_timer) {
        creation_timer.stop();
        creation_timer = null;
        console.showNotification();
        var path:String = File.desktopDirectory.nativePath;
        var fd:FileDownloader = new FileDownloader("http://www.noao.edu/education/astrogram/news_12_03_03.pdf", path + '/test.pdf');
        fd.onProgress = onDLProgress;
        fd.onComplete = complete;
        fd.load();
//        var asd:FileReference = new FileReference();
//        asd.download(new URLRequest('http://www.google.it/images/logos/ps_logo2.png'));
        
      }
      dispatchEvent(new Event("percentageChanged"));
    }
    
    public function onDLProgress(cur:Number):void {
      download_percentage.bytesTotal = 10000000;
      download_percentage.bytesLoaded = cur;
      dispatchEvent(new Event("percentageChanged"));
    }
    
    public function update_download(cur:Number):void 
    {
      //download_percentage.bytesLoaded = cur;
      dispatchEvent(new Event("percentageChanged"));
    }
    
    public function complete():void 
    {
      console.showNotification();
    }
    
    public function cancel():void 
    {
      if (creation_timer) {
        creation_timer.stop();
        creation_timer = null;
      }
      //stream.close();
      //stream.dispatchEvent(new Event("closed"));
      console.downloadManager.removeTask(this);
    }
    
  }
}