package it.ht.rcs.console.styles
{
  import flash.text.Font;
  
  public class FontZapfino extends Font 
  {
    [Embed(source="img/fonts/Zapfino.ttf", fontFamily="FontZapfino")]
    private var _zapfino_font:String;
    
    public static const NAME:String = "FontZapfino";
    
    public function FontZapfino() 
    {
      super();
      _zapfino_font;
    }
  }
}
