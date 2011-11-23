package locale
{
  import it.ht.rcs.console.II18N;
  
  import mx.resources.IResourceManager;
  import mx.resources.ResourceManager;
  
  public class R implements II18N
  {
    
    private static var resourceManager:IResourceManager = ResourceManager.getInstance();
    
    // this is for console
    public static function get(string:String, parameters:Array = null):String
    {
      return resourceManager.getString('localized_main', string, parameters);
    }
    
    // this is for console-library
    public function get(string:String, parameters:Array = null):String
    {
      return resourceManager.getString('localized_main', string, parameters);
    }
    
  }
  
}