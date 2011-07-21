package it.ht.rcs.console.utils
{
  import flash.events.MouseEvent;
  
  import spark.components.Button;
  import spark.components.Group;
  import spark.components.TitleWindow;

  public class TitleWindowMinMaxClose extends TitleWindow
  {
    
    [SkinPart(required="false")]
    public var minMaxButton:Button;
    
    [SkinPart(required="false")]
    public var contents:Group;
    
    [SkinPart(required="false")]
    public var topGroup:Group;
    
    public function TitleWindowMinMaxClose()
    {
      super();
      //currentState = "maximized";
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);

      if (instance == minMaxButton)
      {
        minMaxButton.focusEnabled = false;
        minMaxButton.addEventListener(MouseEvent.CLICK, minMaxButtonClick);
      }
    }
    
    private var prevHeight:Number;
    private function minMaxButtonClick(event:MouseEvent):void
    {
      //currentState = currentState == "maximized" ? "minimized" : "maximized";
      if (contentGroup.visible)
        prevHeight = height;
      contentGroup.visible = contentGroup.includeInLayout = !contentGroup.visible;
      height = contentGroup.visible ? prevHeight : 23;
    }
    
  }
}