package it.ht.rcs.console
{
  import mx.resources.ResourceManager;
  
  public class I18N implements II18N
  {
    public function getString(string:String):String
    {
      return ResourceManager.getInstance().getString('localized_main', string);
    }
  }
}
