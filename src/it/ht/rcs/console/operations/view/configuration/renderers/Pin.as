package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.core.UIComponent;
  
  public class Pin extends UIComponent implements Linkable
  {
    private static const RADIUS:Number = 5;
    
    private static const NORMAL_COLOR:uint   = 0xbbbbbb;
    private static const SELECTED_COLOR:uint = 0x999999;
    private static const OVER_COLOR:uint     = 0x4444bb;
    private var backgroundColor:uint = NORMAL_COLOR;
    
    private var outBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return null; }
    public function outBoundConnections():Vector.<Connection> { return outBound; }
    
    private var graph:ConfigurationGraph;
    private var maxIn:Number, maxOut:Number;
    
    public function Pin(graph:ConfigurationGraph, maxIn:Number, maxOut:Number)
    {
      super();
      
      this.graph = graph;
      this.maxIn = maxIn;
      this.maxOut = maxOut;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
      
      if (outBound.length < maxOut)
        graph.startConnection(this);
    }
    
    private function onMouseOver(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.NORMAL) {
        backgroundColor = OVER_COLOR;
        invalidateDisplayList();
      }
    }
    
    private function onMouseOut(me:MouseEvent):void
    {
      backgroundColor = NORMAL_COLOR;
      invalidateDisplayList();
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      graphics.clear();
      graphics.beginFill(backgroundColor);
      graphics.drawCircle(0, 0, RADIUS);
      graphics.endFill();
    }
    
    public function getLinkPoint():Point
    {
      return new Point(parent.x + x, parent.y + y);
    }
    
  }
  
}