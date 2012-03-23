package it.ht.rcs.console.utils
{
  import flash.events.MouseEvent;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import mx.events.FlexEvent;
  
  import spark.components.Group;
  import spark.components.supportClasses.ScrollBarBase;
  import spark.skins.spark.ScrollerSkin;
  
  public class ScrollableGraph extends Group
  {
    
    // Modes of operation
    public static const NORMAL:String   = 'normal';
    public static const DRAGGING:String = 'dragging';
    [Bindable] public var mode:String = NORMAL;
    
    public function ScrollableGraph()
    {
      super();
      layout = null;
      
      addEventListener(FlexEvent.CREATION_COMPLETE, init);
      
      // Dragging
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      
      // Mouse cursors
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }
    
    // Creation complete handler. Cache some useful references.
    // Remember: this component MUST be a child of a Spark Scroller!
    private var hScrollBar:ScrollBarBase, vScrollBar:ScrollBarBase;
    private function init(e:FlexEvent):void
    {
      hScrollBar = (this.parent as ScrollerSkin).hostComponent.horizontalScrollBar;
      vScrollBar = (this.parent as ScrollerSkin).hostComponent.verticalScrollBar;
    }
    
    
    // ----- MOUSE CURSOR -----
    
    private function onMouseOver(me:MouseEvent):void
    {
      if (mode == NORMAL)
        Mouse.cursor = NativeCursor.HAND_OPEN;
      else if (mode == DRAGGING)
        Mouse.cursor = NativeCursor.HAND_CLOSE;
    }
    private function onMouseOut(me:MouseEvent):void
    {
      Mouse.cursor = MouseCursor.AUTO;
    }
    
    
    // ----- DRAGGING -----
    
    // This flag tells if there actually was some dragging.
    // If we go through MOUSE_DOWN and MOUSE_UP events without dragging,
    // we can simulate a CLICK
    private var dragged:Boolean = false;
    private var dragX:Number, dragY:Number;
    
    // Any other MOUSE_DOWN propagation is stopped by target sub-components,
    // so we only get events fired when the pointer is on the white background,
    // meaning we want to start dragging
    private function onMouseDown(me:MouseEvent):void
    {
      mode = DRAGGING;
      dragged = false;
      
      dragX = me.stageX;
      dragY = me.stageY;
      addEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      addEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      Mouse.cursor = NativeCursor.HAND_CLOSE;
    }
    
    private function onDraggingMove(me:MouseEvent):void
    {
      dragged = true;
      
      hScrollBar.value = hScrollBar.value + dragX - me.stageX;
      dragX = me.stageX;
      
      vScrollBar.value = vScrollBar.value + dragY - me.stageY;
      dragY = me.stageY;
    }
    
    private function onDraggingUp(me:MouseEvent):void
    {
      removeEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      Mouse.cursor = NativeCursor.HAND_OPEN;
      
      mode = NORMAL;
      
      // No dragging. We can simulate a click.
      if (!dragged) {
        setFocus();
        onSimulatedClick();
      }
    }
    
    protected function onSimulatedClick():void {}
    
  }
  
}