package it.ht.rcs.console.main
{
  import spark.components.ButtonBarButton;
  
  public class FixedSizeButtonBarButton extends ButtonBarButton
  {
  
    public function FixedSizeButtonBarButton()
    {
      super();
    }
    
    override public function set label(value:String):void
    {
      super.label = value;
      width = measureText(value).width + 40;
    }
    
  }
  
}