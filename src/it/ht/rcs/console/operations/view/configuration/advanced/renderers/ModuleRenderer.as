package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  
  import spark.components.BorderContainer;
  import spark.components.Group;
  import spark.primitives.BitmapImage;
  
  public class ModuleRenderer extends Group implements Linkable
  {
    private static const WIDTH:Number  = 45;
    private static const HEIGHT:Number = 45;
    
    private static const NORMAL_COLOR:uint = 0xffffff;
    private static const OVER_COLOR:uint   = 0x99bb99;
    
    private var container:BorderContainer;
    private var icon:BitmapImage;
    
    private var inBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return inBound; }
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
        container.setStyle('backgroundColor', OVER_COLOR);
      }
    }
    
    private function onMouseOut(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING) {
        graph.currentTarget = null;
        container.setStyle('backgroundColor', NORMAL_COLOR);
      }
    }
    
    private function onMouseUp(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        container.setStyle('backgroundColor', NORMAL_COLOR);
    }
    
    override protected function createChildren():void
    {
      super.createChildren();
      
      if (container == null)
      {
        
        container = new BorderContainer();
        container.width = width;
        container.height = height;
        container.toolTip = module.module;
        container.setStyle('backgroundColor', NORMAL_COLOR);
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.horizontalCenter = icon.verticalCenter = 0;
        icon.source = ModuleIcons[module.module];
        container.addElement(icon);
        
        addElement(container);
        
      }
      
    }

    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y - 5);
    }
    
  }
  
}