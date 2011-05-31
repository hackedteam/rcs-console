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
  
  import mx.controls.Alert;
  
  public class FileDownloader {
    
    private var remotePath:String;
    private var localPath:String; 

    private var remoteStream:URLStream;
    private var localStream:FileStream;
    
    public var onProgress:Function;
    public var onComplete:Function;
    
    public function FileDownloader(remotePath:String, localPath:String) {
      this.remotePath = remotePath;
      this.localPath = localPath;
    }
    
    public function load():void {
      
      if(!remoteStream) {

        remoteStream = new URLStream();
        localStream = new FileStream();

        var request:URLRequest = new URLRequest(remotePath);
        var currentPosition:uint = 0;
        var downloadCompleteFlag:Boolean = false;

        localStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, function(event:OutputProgressEvent):void {
          
          if (event.bytesPending == 0 && downloadCompleteFlag) {
            
            remoteStream.close();
            localStream.close();
            
            if (onComplete != null)
              onComplete();
            
          }
          
        });

        localStream.openAsync(new File(localPath), FileMode.WRITE);
        
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
          downloadCompleteFlag = true;
          //Alert.show("comepleted");
        });
        
        remoteStream.load(request);
        
      } else {
        trace("Download already started");
      }
      
    }
    
  }

}