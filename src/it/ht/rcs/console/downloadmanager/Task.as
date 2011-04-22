package it.ht.rcs.console.downloadmanager
{
  import flash.net.URLStream;
  
  public class Task 
  {
    public function Task() 
    {

    }
    
    [Bindable]
    public var title:String;
    [Bindable]
    public var time:String;
    [Bindable]
    public var creation_undefined:Boolean = true;
    // FIXME: this is a dirty hack to fire the bindable event so the renderer knows that the two Objects below changed their internal values 
    [Bindable]
    public var change:Number;
    
    [Bindable]
    public var creation_percentage:Object = new Object();
    [Bindable]
    public var download_percentage:Object = new Object();
    
    
    //public var stream : URLStream;

    public function set_creation_size(total:Number):void 
    {
      creation_percentage.bytesTotal = total;
      creation_undefined = false;
    }

    public function set_download_size(total:Number):void 
    {
      download_percentage.bytesTotal = total;
    }
    
    public function update_creation(cur:Number):void 
    {
      creation_percentage.bytesLoaded = cur;
      change = cur;
    }
    
    public function update_download(cur:Number):void 
    {
      download_percentage.bytesLoaded = cur;
      change = cur;
    }
    
    public function complete():void 
    {
    }
    
    public function cancel():void 
    {
      //stream.close();
      //stream.dispatchEvent(new Event("closed"));
      DownloadManager.instance.removeTask(this);
    }
    
  }
}