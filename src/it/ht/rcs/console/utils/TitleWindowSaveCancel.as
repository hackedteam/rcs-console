package it.ht.rcs.console.utils
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.events.SaveEvent;
  
  import spark.components.Button;
  import spark.components.TitleWindow;

  [Event(name="save", type="it.ht.rcs.console.events.SaveEvent")]
  public class TitleWindowSaveCancel extends TitleWindow
  {
    
    [SkinPart(required="false")]
    public var saveButton:Button;
    
    public function TitleWindowSaveCancel()
    {
      super();
    }
    
    override protected function partAdded(partName:String, instance:Object) : void
    {
      super.partAdded(partName, instance);
      
      if (instance == saveButton)
      {
        saveButton.focusEnabled = false;
        saveButton.addEventListener(MouseEvent.CLICK, saveButton_clickHandler);   
      }
    }
    
    private function saveButton_clickHandler(event:MouseEvent):void
    {
      dispatchEvent(new SaveEvent(SaveEvent.SAVE));
    }
    
  }
}