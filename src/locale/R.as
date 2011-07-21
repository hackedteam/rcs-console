package locale
{
  import it.ht.rcs.console.II18N;
  
  import mx.resources.ResourceManager;
  
  public class R implements II18N
  {
    
    public static function get(string:String):String
    {
      return ResourceManager.getInstance().getString('localized_main', string);
    }
    
    public function getString(string:String):String
    {
      return ResourceManager.getInstance().getString('localized_main', string);
    }
    
  }
  
}