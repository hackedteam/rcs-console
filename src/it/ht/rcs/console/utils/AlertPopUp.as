package it.ht.rcs.console.utils
{
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.ui.Keyboard;
  
  import mx.controls.Alert;
  import mx.core.IFlexModuleFactory;
  import mx.managers.PopUpManager;

  /* wrapper class to be used from the library since there is no implementation of Alert on mobile */
  
  public class AlertPopUp
  {
    /* copied from Alert.as */
    public static const YES:uint = 0x0001;
    public static const NO:uint = 0x0002;
    public static const OK:uint = 0x0004;
    public static const CANCEL:uint= 0x0008;
    public static const NONMODAL:uint = 0x8000;
    
    
    private static var alert:Alert
    
    public function AlertPopUp()
    {
    }
    
    public static function show(text:String = "", title:String = "",
                                flags:uint = 0x4 /* Alert.OK */, 
                                parent:Sprite = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* Alert.OK */,
                                moduleFactory:IFlexModuleFactory = null,
                                mandatory:Boolean=false):Alert
    {
      alert=Alert.show(text, title, flags, parent, closeHandler, iconClass, defaultButtonFlag, moduleFactory);
      
      if(mandatory)
      {
        alert.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp,true);
        alert.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
      }
      return alert;
    }
    
    protected static function onRemovedFromStage(e:Event):void
    {
      alert.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    protected static function onKeyUp(event:KeyboardEvent):void{
      
       if(event.keyCode == Keyboard.DOWN && event.shiftKey)
      {
        PopUpManager.removePopUp(alert)
      }
      
      if(event.charCode ==Keyboard.ESCAPE){
        trace("ESC PRESSED")
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();
      }
      alert.addEventListener(KeyboardEvent.KEY_DOWN, onKeyUp,true);
    }
  }
}