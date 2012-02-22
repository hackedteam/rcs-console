package it.ht.rcs.console.operations.view.configuration
{
  import com.maccherone.json.JSON;

  public class PrettyPrinter
  {
    public static function prettyPrint(o:Object):String
    {
      return com.maccherone.json.JSON.encode(o, true, 100);
    }
  }
}