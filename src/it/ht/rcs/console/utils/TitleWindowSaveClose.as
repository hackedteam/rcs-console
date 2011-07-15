package it.ht.rcs.console.utils
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.events.SaveEvent;
  
  import mx.managers.PopUpManager;
  
  import spark.components.Button;
  import spark.components.TitleWindow;

  [Event(name="save", type="it.ht.rcs.console.events.SaveEvent")]
  public class TitleWindowSaveClose extends TitleWindow
  {
    
    [SkinPart(required="false")]
    public var saveButton:Button;
    
    public var showCloseButton:Boolean = true;
    public var showSaveButton:Boolean = true;
    
    public function TitleWindowSaveClose()
    {
      super();
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == closeButton)
      {
        closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
        closeButton.addEventListener(MouseEvent.CLICK, closeMe);

      }
      else if (instance == saveButton)
      {
        saveButton.focusEnabled = false;
        saveButton.addEventListener(MouseEvent.CLICK, saveButton_clickHandler);
      }
    }
    
    private function closeMe(event:MouseEvent):void {
      PopUpManager.removePopUp(this);
    }
    
    private function saveButton_clickHandler(event:MouseEvent):void
    {
      dispatchEvent(new SaveEvent(SaveEvent.SAVE));
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      closeButton.visible = closeButton.includeInLayout = showCloseButton;
      saveButton.visible = saveButton.includeInLayout = showSaveButton;
    }
    
  }
}