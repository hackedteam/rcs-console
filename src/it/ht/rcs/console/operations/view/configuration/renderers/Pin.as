package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.display.DisplayObjectContainer;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.core.UIComponent;
  
  public class Pin extends UIComponent implements Linkable
  {
    private static const RADIUS:Number = 10;
    
    private static const NORMAL_COLOR:uint = 0x8888bb;
    private static const OVER_COLOR:uint = 0x5555bb;
    private static const GREEN_COLOR:uint = 0x00ff00;
    private static const RED_COLOR:uint = 0xff0000;
    private var backgroundColor:uint = NORMAL_COLOR;
    
    private var outBound:ConnectionLine;
    public function getInBound():ConnectionLine { return null; }
    public function setInBound(conn:ConnectionLine):void {}
    public function getOutBound():ConnectionLine { return outBound; }
    public function setOutBound(conn:ConnectionLine):void { outBound = conn; }
    
    public function Pin()
    {
      super();
      addEventListener(MouseEvent.MOUSE_DOWN, onDown);
      addEventListener(MouseEvent.MOUSE_OVER, onOver);
      addEventListener(MouseEvent.MOUSE_OUT, onOut);
    }
    
    private function onDown(me:MouseEvent):void {
      var e:ConnectionEvent = new ConnectionEvent(ConnectionEvent.START_CONNECTION);
      e.startPin = this;
      dispatchEvent(e);
    }
    
    private function onOver(me:MouseEvent):void {
      if (getGraph().mode == ConfigurationGraph.NORMAL)
        backgroundColor = OVER_COLOR;
      else if (getGraph().mode == ConfigurationGraph.CONNECTING)
        backgroundColor = getGraph().currentLine.from == this ? RED_COLOR : GREEN_COLOR;
      setStyle('backgroundColor', backgroundColor);
    }
    private function onOut(me:MouseEvent):void {
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
    
    private var _graph:ConfigurationGraph = null;
    private function getGraph():ConfigurationGraph
    {
      if (!_graph) {
        var currentParent:DisplayObjectContainer = this.parent;
        while (!(currentParent is ConfigurationGraph))
          currentParent = currentParent.parent;
        _graph = currentParent as ConfigurationGraph;
      }
      
      return _graph;
    }
    
//    public function getGlobalCenter():Point
//    {
//      var point:Point = new Point(x, y);
//      return parent.localToGlobal(point);
//    }
    
    public function getLinkPoint():Point
    {
      return new Point(parent.x + x, parent.y + y);
    }
    
  }
  
}