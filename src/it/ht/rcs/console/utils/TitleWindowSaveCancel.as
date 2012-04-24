package it.ht.rcs.console.utils
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.events.SaveEvent;
  import it.ht.rcs.console.events.SessionEvent;
  
  import mx.managers.PopUpManager;
  import mx.core.FlexGlobals;
  
  import spark.components.Button;
  import spark.components.TitleWindow;
  
  [Event(name='save', type='it.ht.rcs.console.events.SaveEvent')]
  public class TitleWindowSaveCancel extends TitleWindow
  {
    
    [Bindable]
    [SkinPart(required='false')]
    public var saveButton:Button;
    
    [Bindable]
    [SkinPart(required='false')]Ï
    public var cancelButton:Button;
    
    public var showSaveButton:Boolean = true;
    public var showCancelButton:Boolean = true;
    
    public function TitleWindowSaveCancel()
    {
      super();
      // add listener for logout event and close window
      FlexGlobals.topLevelApplication.addEventListener(SessionEvent.LOGOUT, close, false, 0, true);
    }
    
    override protected function partAdded(partName:String, instance:Object):void
    {
      super.partAdded(partName, instance);
      
      if (instance == saveButton)
      {
        saveButton.addEventListener(MouseEvent.CLICK, save);
        saveButton.visible = saveButton.includeInLayout = showSaveButton;
      } 
      else if (instance == cancelButton)
      {
        instance.addEventListener(MouseEvent.CLICK, close);
        cancelButton.visible = cancelButton.includeInLayout = showCancelButton;
      }
      else if (instance == closeButton)
      {
        instance.addEventListener(MouseEvent.CLICK, close);
      }
    }
    
    private function save(event:Event=null):void
    {
      dispatchEvent(new SaveEvent(SaveEvent.SAVE));
    }
    
    protected function close(event:Event=null):void
    {
      PopUpManager.removePopUp(this);
    }
    
  }
  
}