package it.ht.rcs.console.utils
{
  import flash.display.Sprite;
  
  import mx.controls.Alert;
  import mx.core.IFlexModuleFactory;

  /* wrapper class to be used from the library since there is no implementation of Alert on mobile */
  
  public class AlertPopUp
  {
    /* copied from Alert.as */
    public static const YES:uint = 0x0001;
    public static const NO:uint = 0x0002;
    public static const OK:uint = 0x0004;
    public static const CANCEL:uint= 0x0008;
    public static const NONMODAL:uint = 0x8000;
    
    public function AlertPopUp()
    {
    }
    
    public static function show(text:String = "", title:String = "",
                                flags:uint = 0x4 /* Alert.OK */, 
                                parent:Sprite = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* Alert.OK */,
                                moduleFactory:IFlexModuleFactory = null):Alert
    {
      return Alert.show(text, title, flags, parent, closeHandler, iconClass, defaultButtonFlag, moduleFactory);
    }
  }
}