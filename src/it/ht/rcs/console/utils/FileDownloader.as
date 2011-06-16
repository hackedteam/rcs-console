package it.ht.rcs.console.utils {
  
  import flash.events.Event;
  import flash.events.OutputProgressEvent;
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
    
    private var localFile:File;
    
    public var onProgress:Function;
    public var onComplete:Function;
    
    private var downloadCompletedFlag:Boolean = false;
    
    public function FileDownloader(remotePath:String, localPath:String) {
      this.remotePath = remotePath;
      this.localPath = localPath;
    }
    
    public function download():void {
      
      if (!remoteStream) {

        remoteStream = new URLStream();
        localStream = new FileStream();

        var request:URLRequest = new URLRequest("http://rcs-prod:4444/grid/"+remotePath+"?session="+console.currentSession.cookie);
        var currentPosition:uint = 0;

        localStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, function(event:OutputProgressEvent):void {

          if (downloadCompletedFlag && event.bytesPending == 0) {
            
            closeStreams();
            
            if (onComplete != null)
              onComplete();
            
          }
          
        });

        localFile = new File(localPath);
        localStream.openAsync(localFile, FileMode.WRITE);
        
        remoteStream.addEventListener(ProgressEvent.PROGRESS, function():void {
          
          var bytes:ByteArray = new ByteArray();
          var thisStart:uint = currentPosition;
          currentPosition += remoteStream.bytesAvailable;
          
          remoteStream.readBytes(bytes, thisStart);
          localStream.writeBytes(bytes, thisStart);
          
          if (onProgress != null)
            onProgress(currentPosition);

        });
        
        remoteStream.addEventListener(Event.COMPLETE, function():void {
          downloadCompletedFlag = true;
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
    }
    
  }

}