package it.ht.rcs.console.model
{
  import com.adobe.serialization.json.JSON;
  
  import it.ht.rcs.console.events.RefreshEvent;
  
  import mx.core.FlexGlobals;
  import mx.rpc.events.ResultEvent;
  
  [Bindable]
  public class LicenseManager
  {
    public var type:String = "reusable";
    public var serial:String = "off";
    public var users:CurrMaxObject = new CurrMaxObject("0", "0");
    
    public var bck_total:CurrMaxObject = new CurrMaxObject("0", "0");
    public var bck_desktop:CurrMaxObject = new CurrMaxObject("0", "0");
    public var bck_linux:Boolean = false;
    public var bck_osx:Boolean = false;
    public var bck_windows:Boolean = false;
    public var bck_mobile:CurrMaxObject = new CurrMaxObject("0", "0");
    public var bck_android:Boolean = false;
    public var bck_blackberry:Boolean = false;
    public var bck_ios:Boolean = false;
    public var bck_symbian:Boolean = false;
    public var bck_winmo:Boolean = false;
    
    public var collectors:CurrMaxObject = new CurrMaxObject("0", "0");
    public var anonymizers:CurrMaxObject = new CurrMaxObject("0", "0");
    
    public var alerting:Boolean = false;
    public var correlation:Boolean = false;
    
    public var ipa:CurrMaxObject = new CurrMaxObject("0", "0");
    public var rmi:Boolean = false;
    
    
    /* singleton */
    private static var _instance:LicenseManager = new LicenseManager();
    public static function get instance():LicenseManager { return _instance; } 
    
    public function LicenseManager()
    {
    }
    
    public function start():void
    {
      /* react to the global refresh event */
      FlexGlobals.topLevelApplication.addEventListener(RefreshEvent.REFRESH, load_license);
    }
    
    public function stop():void
    {
      /* after stop, we don't want to refresh anymore */
      FlexGlobals.topLevelApplication.removeEventListener(RefreshEvent.REFRESH, load_license);
    }
    
    public function load_license(e:RefreshEvent):void
    {
      trace('LicenseManager -- Refresh');

      console.currentDB.license_limit(onLoadLimit);
      console.currentDB.license_count(onLoadCount);
    }
    
    private function onLoadLimit(e:ResultEvent):void
    {
      var limits:Object = JSON.decode(e.result as String);
        
      type = limits['type'];
      serial = limits['serial'].toString();
      
      users.max = (limits['users'] == null) ? 'U' : limits['users'].toString();
      
      bck_total.max = (limits['backdoors']['total'] == null) ? 'U' : limits['backdoors']['total'].toString();
      bck_desktop.max = (limits['backdoors']['desktop'] == null) ? 'U' : limits['backdoors']['desktop'].toString();
      bck_mobile.max = (limits['backdoors']['mobile'] == null) ? 'U' : limits['backdoors']['mobile'].toString();
      
      bck_linux = limits['backdoors']['linux'];
      bck_osx = limits['backdoors']['osx'];
      bck_windows = limits['backdoors']['windows'];
      bck_android = limits['backdoors']['android'];
      bck_blackberry = limits['backdoors']['blackberry'];
      bck_ios = limits['backdoors']['ios'];
      bck_symbian = limits['backdoors']['symbian'];
      bck_winmo = limits['backdoors']['winmo'];
      
      collectors.max = (limits['collectors']['collectors'] == null) ? 'U' : limits['collectors']['collectors'].toString();
      anonymizers.max = (limits['collectors']['anonymizers'] == null) ? 'U' : limits['collectors']['anonymizers'].toString();
      
      alerting = limits['alerting'];
      correlation = limits['correlation'];
      
      ipa.max = (limits['ipa'] == null) ? 'U' : limits['ipa'].toString();
      rmi = limits['rmi'];
    }

    private function onLoadCount(e:ResultEvent):void
    {
      var current:Object = JSON.decode(e.result as String);
      
      users.curr = current['users'].toString();
      
      bck_total.curr = current['backdoors']['total'].toString();
      bck_desktop.curr = current['backdoors']['desktop'].toString();
      bck_mobile.curr = current['backdoors']['mobile'].toString();
      
      collectors.curr = current['collectors']['collectors'].toString();
      anonymizers.curr = current['collectors']['anonymizers'].toString();
      
      ipa.curr = current['ipa'].toString();
    }

  }
}