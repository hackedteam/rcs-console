package locale
{
  import mx.resources.ResourceManager;
  import it.ht.rcs.console.II18N;
  
  public class I18N implements II18N
  {
    public function getString(string:String):String
    {
      return ResourceManager.getInstance().getString('localized_main', string);
    }
  }
}
