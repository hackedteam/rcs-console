package it.ht.rcs.console.system.view.frontend.healthCheck
{
  public class HealthCheckEntry
  {
    
    public static const IDLE:int     = 0;
    public static const CHECKING:int = 1;
    public static const OK:int       = 2;
    public static const KO:int       = 3;
    public static const INVALID:int  = 4;

    
    [Bindable]
    public var ip:String;
    [Bindable]
    public var name:String;
    [Bindable]
    public var status:int;
    
    public function HealthCheckEntry(obj:Object)
    {
      ip = obj.ip;
      name = obj.name;
      status = IDLE;
    }
  }
}