package it.ht.rcs.console.utils
{
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.ui.Keyboard;
  
  import it.ht.rcs.console.events.SaveEvent;
  import it.ht.rcs.console.skins.TitleWindowSaveCloseSkin;
  
  import mx.events.FlexEvent;
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
      setStyle('skinClass', TitleWindowSaveCloseSkin);
      addEventListener(FlexEvent.CREATION_COMPLETE, onShow);
    }
    
    private function onShow(event:FlexEvent):void
    {
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      setFocus();
    }
    
    private function onKeyDown(event:KeyboardEvent):void
    {
      if (event.keyCode == Keyboard.ESCAPE && event.controlKey)
        close();
      else if (event.keyCode == Keyboard.ENTER && event.controlKey)
        save();
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == closeButton)
      {
        closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
        closeButton.addEventListener(MouseEvent.CLICK, close);
      }
      else if (instance == saveButton)
      {
        saveButton.focusEnabled = false;
        saveButton.addEventListener(MouseEvent.CLICK, save);
      }
    }
    
    protected function close(event:MouseEvent=null):void
    {
      PopUpManager.removePopUp(this);
    }
    
    private function save(event:MouseEvent=null):void
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