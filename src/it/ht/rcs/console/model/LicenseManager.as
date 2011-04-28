package it.ht.rcs.console.model
{
  import flash.events.Event;
  
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.core.FlexGlobals;
  
  public class LicenseManager
  {
    [Bindable]
    public var serial:Number = 0;
    
    /* singleton */
    private static var _instance:LicenseManager = new LicenseManager();
    public static function get instance():LicenseManager { return _instance; } 
    
    public function LicenseManager()
    {
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, onRefresh);
    }
    
    private function onRefresh(e:Event):void
    {
      trace('LicenseManager -- Refresh');
    }
  }
}