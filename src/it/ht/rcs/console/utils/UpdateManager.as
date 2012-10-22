package it.ht.rcs.console.utils
{
  import flash.desktop.Updater;
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.TimerEvent;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.net.URLRequest;
  import flash.net.URLStream;
  import flash.utils.ByteArray;
  import flash.utils.Timer;
  
  import it.ht.rcs.console.DB;
  import it.ht.rcs.console.events.SessionEvent;
  import it.ht.rcs.console.update.model.UpdateVersions;
  
  import locale.R;
  
  import mx.core.FlexGlobals;
  import mx.events.CloseEvent;
  import mx.managers.PopUpManager;
  import mx.rpc.events.ResultEvent;

  public class UpdateManager
  {

    private static var _instance:UpdateManager = new UpdateManager();
    public static function get instance():UpdateManager { return _instance; }
    
    private var autoCheck:Timer = new Timer(10*60*1000);
    
    public function UpdateManager()
    {
      FlexGlobals.topLevelApplication.addEventListener(SessionEvent.LOGOUT, onLogout);
      autoCheck.addEventListener(TimerEvent.TIMER, check);
    }
        
    protected function onLogout(e:SessionEvent):void 
    {
      autoCheck.stop();
    }
    
    public function start():void
    {
      autoCheck.start();
      check(null);      
    }
    
    public static function check(e:*):void
    {
      DB.instance.update.all(function (e:ResultEvent):void {
        
        var versions:UpdateVersions = e.result as UpdateVersions;
        var current_version:String = Console.appVersion.replace(/\./g, "");
        var update_version:String = versions.console;
        
        trace("UpdateCheck -- current: " + current_version + " update: " + update_version);
        
        if (update_version != "-1" && current_version != update_version) {
          AlertPopUp.show(R.get('UPDATE_CONSOLE', [current_version, update_version]), 
                          R.get('NEW_VERSION'), 
                          AlertPopUp.YES|AlertPopUp.NO, 
                          null, 
                          function (event:CloseEvent):void {
                            if (event.detail == AlertPopUp.YES) {
                              update(update_version);
                            }
                          } );
        }
       
      });
      
    }
    
    private static function update(version:String):void 
    {
      var urlString:String = DB.hostAutocomplete(Console.currentSession.server) + "version/" + version; 
      var urlReq:URLRequest = new URLRequest(urlString); 
      var urlStream:URLStream = new URLStream(); 
      
      var file:File = File.applicationStorageDirectory.resolvePath("rcs-console-update.air"); 
      var fileStream:FileStream = new FileStream(); 
      
      var updater:Updater = new Updater(); 
      
      /* format the version accordingly to the AIR package (yy.xx.zz) */
      var version_air:String = version.substr(2,2) + '.' + version.substr(4,2) + '.' + version.substr(6,2);
      
      /* make sure a previous file is not there... */
      if (file.exists)
        file.deleteFile();
     
      var updatePopup:UpdatePopup = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, UpdatePopup, true) as UpdatePopup;
      PopUpManager.centerPopUp(updatePopup);
      
      /* prepare the handlers for the download */
      urlStream.addEventListener(IOErrorEvent.IO_ERROR, 
                                 function (e:Event):void {
                                   AlertPopUp.show(R.get('UPDATE_ERROR'), R.get('ERROR'));
                                   if (file.exists)
                                     file.deleteFile();
                                 });
      
      urlStream.addEventListener(ProgressEvent.PROGRESS, 
                                function (e:ProgressEvent):void {
                                  updatePopup.progressBar.setProgress(e.bytesLoaded, e.bytesTotal);
                                });
      
      urlStream.addEventListener(Event.COMPLETE, 
                                 function (e:Event):void {
                                   var buffer:ByteArray = new ByteArray();

                                   /* get the buffer */
                                   urlStream.readBytes(buffer, 0, urlStream.bytesAvailable);
                                   
                                   /* write the buffer to the file */
                                   fileStream.open(file, FileMode.WRITE); 
                                   fileStream.writeBytes(buffer, 0, buffer.length); 
                                   fileStream.close(); 
                                   
                                   trace("UpdateCheck -- updating to version " + version_air);
                                   
                                   /* update the application */
                                   updater.update(file, version_air);
                                 }); 

      trace("UpdateCheck -- downloading version " + version);
      
      /* start the download */
      urlStream.load(urlReq); 
      
    }

    
  }
}