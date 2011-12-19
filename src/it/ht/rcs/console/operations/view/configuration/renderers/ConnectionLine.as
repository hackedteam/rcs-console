package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.geom.Point;
  
  import mx.core.UIComponent;
  
  public class ConnectionLine extends UIComponent
  {
    
    public var startX:Number = 100;
    public var startY:Number = 100;
    public var endX:Number = 200;
    public var endY:Number = 200;
    
    public var from:Linkable;
    public var to:Linkable;
    
    private static const NORMAL_THICKNESS:Number = 1;
    private static const SELECTED_THICKNESS:Number = 3;
    private var thickness:Number = NORMAL_THICKNESS;
    
    private var _selected:Boolean = false;
    public function get selected():Boolean { return _selected; }
    public function set selected(s:Boolean):void
    {
      _selected = s;
      thickness = _selected ? SELECTED_THICKNESS : NORMAL_THICKNESS;
      invalidateDisplayList();
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      graphics.clear();
      graphics.lineStyle(thickness, 0x000000, 1, true);
      
      graphics.moveTo(startX, startY);
      
      // Straight Line
      //graphics.lineTo(endX, endY);
      
      // Curved Line
      var offset:Number = startX > endX ? 50 : -50;
      var controlX:Number = startX - (startX-endX)/2 + offset;
      var controlY:Number = endY - (endY-startY)/2;
      graphics.curveTo(controlX, controlY, endX, endY);
      
      // A thick line to ease selection
      graphics.lineStyle(20, 0x000000, 0, true);
      graphics.moveTo(startX, startY);
      graphics.curveTo(controlX, controlY, endX, endY);
    }
    
  }
  
}