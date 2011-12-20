package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.collections.ArrayCollection;
  import mx.core.UIComponent;
  
  public class Pin extends UIComponent implements Linkable
  {
    private static const RADIUS:Number = 5;
    
    private static const NORMAL_COLOR:uint = 0x8888bb;
    private static const OVER_COLOR:uint = 0x5555bb;
    private static const GREEN_COLOR:uint = 0x00ff00;
    private static const RED_COLOR:uint = 0xff0000;
    private var backgroundColor:uint = NORMAL_COLOR;
    
    private var outBound:ArrayCollection = new ArrayCollection();
    public function inBoundConnections():ArrayCollection { return null; }
    public function outBoundConnections():ArrayCollection { return outBound; }
    
    private var graph:ConfigurationGraph;
    
    public function Pin(graph:ConfigurationGraph)
    {
      super();
      
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onDown);
      addEventListener(MouseEvent.MOUSE_OVER, onOver);
      addEventListener(MouseEvent.MOUSE_OUT, onOut);
    }
    
    private function onDown(me:MouseEvent):void {
      me.stopPropagation();
      var e:ConnectionEvent = new ConnectionEvent(ConnectionEvent.START_CONNECTION);
      e.from = this;
      dispatchEvent(e);
    }
    
    private function onOver(me:MouseEvent):void {
      me.stopPropagation();
      if (graph.mode == ConfigurationGraph.NORMAL)
        backgroundColor = OVER_COLOR;
      else if (graph.mode == ConfigurationGraph.CONNECTING) {
        backgroundColor = graph.currentConnection.from == this ? RED_COLOR : GREEN_COLOR;
        graph.currentTarget = this;
      }
      setStyle('backgroundColor', backgroundColor);
    }
    private function onOut(me:MouseEvent):void {
      graph.currentTarget = null;
      backgroundColor = NORMAL_COLOR;
      setStyle('backgroundColor', backgroundColor);
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