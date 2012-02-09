package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  
  import mx.graphics.BitmapSmoothingQuality;
  
  import spark.components.Group;
  import spark.components.Image;
  
  public class ModuleRenderer3 extends Group implements Linkable
  {
    private static const WIDTH:Number  = 36;
    private static const HEIGHT:Number = 36;
    
    private static const NORMAL_COLOR:uint = 0xffffff;
    private static const OVER_COLOR:uint   = 0x99bb99;
    private var backgroundColor:uint = NORMAL_COLOR;
    
    private var icon:Image;
    
    private var inBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return null; }
    
    private var graph:ConfigurationGraph;
    
    public var module:Object;
    
    public function ModuleRenderer3(module:Object, graph:ConfigurationGraph)
    {
      super();
      layout = null;
      doubleClickEnabled = true;
      width = WIDTH;
      height = HEIGHT;
      
      this.module = module;
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
    }
    
    private function onMouseOver(me:MouseEvent):void
    {
      me.stopPropagation();
      Mouse.cursor = MouseCursor.AUTO;
      
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        graph.currentTarget = this;
        backgroundColor = OVER_COLOR;
        invalidateDisplayList();
      }
    }
    
    private function onMouseOut(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        graph.currentTarget = null;
        backgroundColor = NORMAL_COLOR;
        invalidateDisplayList();
      }
    }
    
    private function onMouseUp(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        backgroundColor = NORMAL_COLOR;
        invalidateDisplayList();
      }
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (icon == null) {
        icon = new Image();
        icon.toolTip = module.module;
        icon.smooth = true;
        icon.source = ModuleIcons[module.module];
        icon.width = width;
        icon.height = height;
        addElement(icon);
      }
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      graphics.beginFill(backgroundColor);
      graphics.drawRect(0, 0, width, height);
      graphics.endFill();
    }
    
    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y - 5);
    }
    
  }
  
}