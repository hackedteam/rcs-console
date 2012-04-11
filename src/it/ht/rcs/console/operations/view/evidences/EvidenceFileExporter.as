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
    
    private static var file:File;
    private static var extension:String;
    private static var request:URLRequest;
    private static var stream:URLStream;
    private static var currentEvidence:Evidence;
    
    public function EvidenceFileExporter()
    {
      
    }
    
    public static function export(evidences:Vector.<Object>):void
    {
   
      for(var i:int=0;i<evidences.length;i++)
      {
        currentEvidence=evidences[i] as Evidence;
        exportFile(currentEvidence)
      }
    }
    
    private static function exportFile(evidence:Evidence):void
    {
      switch(evidence.type)
      {
        case "screenshot":
          exportText(evidence);
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
          exportText(evidence);
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
    
    private static function onDownloadProgress(e:ProgressEvent):void
    {
      var perc:int=int((e.bytesLoaded/e.bytesTotal)*100)
      trace("downloading file "+perc)
    }
    
    private static function onDownloadError(e:*):void
    {
     trace("Error downloading file")
    }
    
    private static function onFileDownloaded(e:Event):void
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
      
    }
    private static function exportText(evidence:Evidence):void
    {
      trace("export text")
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      extension="txt"
      var fileName:String=evidence._id + encodeURIComponent(target) + "." + extension;
      file=File.documentsDirectory.resolvePath(fileName);
      file.addEventListener(Event.SELECT, onTextSelect);
      stream=new URLStream();
      file.browseForSave("Download " + fileName);
      
      
    }
    
    private static function exportImage(evidence:Evidence):void
    {
      trace("export image")
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="jpg"
      var fileName:String=evidence.data._grid + encodeURIComponent(target) + "." + extension;
      file=File.documentsDirectory.resolvePath(fileName);
      file.addEventListener(Event.SELECT, onMediaSelect);
      request=new URLRequest(url);
      stream=new URLStream();
      file.browseForSave("Download " + fileName);
      
    }
    
    private static function exportSound(evidence:Evidence):void
    {
      trace("export sound")
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="mp3"
      var fileName:String=evidence.data._grid + encodeURIComponent(target) + "." + extension;
      file=File.documentsDirectory.resolvePath(fileName);
      file.addEventListener(Event.SELECT, onMediaSelect);
      request=new URLRequest(url);
      stream=new URLStream();
      file.browseForSave("Download " + fileName);
    }
    
    private static function onTextSelect(e:Event):void
    {
      trace("ON text selection")
      
      //add listeners
      var content:String=getInfo(currentEvidence)
      
      if (file.extension != extension)
      {
        file=new File(file.nativePath + "." + extension);
      }
      var fileStream:FileStream=new FileStream();
      fileStream.open(file, FileMode.WRITE);
      fileStream.writeUTFBytes(content);
      fileStream.close();
    }
    
    
    private static function onMediaSelect(e:Event):void
    {
    
      if (file.extension != extension)
      {
        file=new File(file.nativePath + "." + extension);
      }
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
    }
    
    private static function getInfo(evidence:Evidence):String
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
        
        case "message":
          info="Message: "+"\n\n";
          info+="From: "+evidence.data.from+"\n";
          info+="Rcpt: "+evidence.data.rcpt+"\n";
          info+="Subject: "+evidence.data.subject+"\n";
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