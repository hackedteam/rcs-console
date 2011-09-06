package locale
{
  import it.ht.rcs.console.II18N;
  
  import mx.resources.ResourceManager;
  
  public class R implements II18N
  {
    
    public static function get(string:String, parameters:Array=null):String
    {
      return ResourceManager.getInstance().getString('localized_main', string, parameters);
    }
    
    public function getString(string:String, parameters:Array=null):String
    {
      return ResourceManager.getInstance().getString('localized_main', string, parameters);
    }
    
  }
  
}