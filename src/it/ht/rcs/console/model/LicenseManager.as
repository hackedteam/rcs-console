package it.ht.rcs.console.model
{
  import mx.core.FlexGlobals;
  import it.ht.rcs.console.events.RefreshEvent;
  
  [Bindable]
  public class LicenseManager
  {
    public var start_date:String = "2011-06-02 15:30"
    public var end_date:String = "Unlimited"
    public var serial:String = "off";
    
    public var users:CurrMaxObject = new CurrMaxObject("0", "U");
    public var backdoors:CurrMaxObject = new CurrMaxObject("1", "U");
    public var bck_desktop:CurrMaxObject = new CurrMaxObject("2", "U");
    public var bck_macos:CurrMaxObject = new CurrMaxObject("3", "U");
    public var bck_windows:CurrMaxObject = new CurrMaxObject("4", "U");
    public var bck_mobile:CurrMaxObject = new CurrMaxObject("5", "U");
    public var bck_android:CurrMaxObject = new CurrMaxObject("6", "U");
    public var bck_blackberry:CurrMaxObject = new CurrMaxObject("7", "U");
    public var bck_iphone:CurrMaxObject = new CurrMaxObject("8", "U");
    public var bck_symbian:CurrMaxObject = new CurrMaxObject("9", "U");
    public var bck_winmo:CurrMaxObject = new CurrMaxObject("10", "U");
    
    public var coll_nodes:CurrMaxObject = new CurrMaxObject("11", "U");
    public var anonymizers:CurrMaxObject = new CurrMaxObject("12", "U");
    
    public var alerting:Boolean = true;
    public var correlation:Boolean = false;
    
    public var ipa:CurrMaxObject = new CurrMaxObject("13", "U");
    public var rmi:Boolean = true;
    
    
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
      
      // FIXME: remove the mock
      users.curr = (Math.round( Math.random() * 100 )).toString();

    }
  }
}