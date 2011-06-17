package it.ht.rcs.console.utils {
  
  import flash.events.Event;
  import flash.events.ProgressEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.net.URLRequest;
  import flash.net.URLStream;
  import flash.utils.ByteArray;
  
  public class FileDownloader {
    
    private var remotePath:String;
    private var localPath:String; 
    
    private var remoteStream:URLStream;
    private var localStream:FileStream;
    
    private var bytes:ByteArray;
    
    private var localFile:File;
    
    public var onProgress:Function;
    public var onComplete:Function;
    
    private var currentPosition:uint = 0;
    
    public function FileDownloader(remotePath:String, localPath:String) {
      this.remotePath = remotePath;
      this.localPath = localPath;
    }
    
    public function download():void {
      
      if (!remoteStream) {

        remoteStream = new URLStream();
        localStream = new FileStream();
        bytes = new ByteArray();

        var request:URLRequest = new URLRequest("https://localhost:4444/grid/"+remotePath);
       
        localFile = new File(localPath);
        localStream.openAsync(localFile, FileMode.WRITE);
        
        remoteStream.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent):void {
          
          // trace('bytes available: ' + remoteStream.bytesAvailable + ' current position: ' + currentPosition + ' bytesLoaded: ' + e.bytesLoaded + ' bytesTotal: ' + e.bytesTotal);
          
          var bytesAvailable:uint = remoteStream.bytesAvailable;
          currentPosition += bytesAvailable;

          remoteStream.readBytes(bytes, 0, bytesAvailable);
          localStream.writeBytes(bytes, 0, bytesAvailable);
          
          bytes.clear();
          
          if (onProgress != null)
            onProgress(currentPosition);

        });
        
        remoteStream.addEventListener(Event.COMPLETE, function():void {
          
          closeStreams();
          
          if (onComplete != null)
            onComplete();
          
        });
        
        remoteStream.load(request);
        
      } else {
        trace("Download already started");
      }
      
    }
    
    public function cancelDownload():void {
      closeStreams();
      if (localFile)
        localFile.deleteFile();
    }
    
    private function closeStreams():void {
      if (remoteStream) {
        remoteStream.close();
        remoteStream = null;
      }
      if (localStream) {
        localStream.close();
        localStream = null;
      }
      if (bytes) {
        bytes.clear();
        bytes = null;
      }
    }
    
  }

}