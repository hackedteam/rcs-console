package it.ht.rcs.console.utils
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Point;
  import flash.ui.Mouse;
  import flash.ui.MouseCursorData;

  public class NativeCursor
  {
    
    [Embed(source='/img/windows/hand.png')]
    private static var handOpen:Class;
    public static const HAND_OPEN:String = 'handOpen';
    
    [Embed(source='/img/windows/drag_hand.png')]
    private static var handClose:Class;
    public static const HAND_CLOSE:String = 'handClose';
    
    
    public static function registerCursors():void {
      
      register(HAND_OPEN, 7, 7, new handOpen());
      register(HAND_CLOSE, 7, 7, new handClose());

    }
    
    private static function register(name:String, x:Number, y:Number, image:Bitmap):void {
      var cursorData:MouseCursorData = new MouseCursorData();
      cursorData.hotSpot = new Point(x, y);
      cursorData.data = new <BitmapData>[image.bitmapData];
      Mouse.registerCursor(name, cursorData);
    }
    
  }
}