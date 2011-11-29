package it.ht.rcs.console.main.skins
{
  import mx.controls.Alert;
  
  import spark.components.ButtonBarButton;
  import spark.components.Label;
  
  public class FixedSizeButtonBarButton extends ButtonBarButton
  {
  
    public function FixedSizeButtonBarButton()
    {
      super();
    }
    
    override public function set label(value:String):void
    {
      super.label = value;
      var size:int = parseInt((labelDisplay as Label).getStyle('fontSize'));
      width = measureText(value).width + (size * 3);
    }
    
  }
  
}