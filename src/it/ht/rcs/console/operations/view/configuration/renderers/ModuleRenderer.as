package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.core.UIComponent;
  
  import spark.components.Group;
  import spark.primitives.BitmapImage;
  
  public class ModuleRenderer extends Group implements Linkable
  {
    private static const WIDTH:Number  = 48;
    private static const HEIGHT:Number = 48;
    
    private static const NORMAL_COLOR:uint = 0xbbbbbb;
    private static const OVER_COLOR:uint   = 0x88bb88;
    private var backgroundColor:uint = NORMAL_COLOR;
    
    private var icon:BitmapImage;
    
    private var inBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection> { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return null; }
    
    private var graph:ConfigurationGraph;
    
    public var module:Object;
    
    public function ModuleRenderer(module:Object, graph:ConfigurationGraph)
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
    }
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
    }
    
    private function onMouseOver(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        backgroundColor = graph.currentConnection.from == this ? NORMAL_COLOR : OVER_COLOR;
        graph.currentTarget = this;
        setStyle('backgroundColor', backgroundColor);
      }
    }
    
    private function onMouseOut(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        graph.currentTarget = null;
        backgroundColor = NORMAL_COLOR;
        setStyle('backgroundColor', backgroundColor);
      }
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (icon == null) {
        icon = new BitmapImage();
        icon.source = ModuleIcons[module.module];
        icon.width = width;
        icon.height = height;
        addElement(icon);
      }
    }

//    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
//    {
//      super.updateDisplayList(unscaledWidth, unscaledHeight);
//      
//      graphics.beginFill(backgroundColor);
//      graphics.drawRect(0, 0, width, height);
//      graphics.endFill();
//    }
    
    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y - 5);
    }
    
  }
  
}