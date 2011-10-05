package locale
{
  import it.ht.rcs.console.II18N;
  
  import mx.resources.ResourceManager;
  
  public class R implements II18N
  {
    
    // this is for console
    public static function get(string:String, parameters:Array=null):String
    {
      return ResourceManager.getInstance().getString('localized_main', string, parameters);
    }
    
    // this is for console-library
    public function getString(string:String, parameters:Array=null):String
    {
      return ResourceManager.getInstance().getString('localized_main', string, parameters);
    }
    
  }
  
}