package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  import it.ht.rcs.console.operations.view.configuration.renderers.utils.GraphicsUtil;
  
  import mx.collections.ArrayCollection;
  import mx.core.UIComponent;
  
  public class Connection extends UIComponent
  {
    
    public var start:Point;
    public var end:Point;
    
    private var _from:Linkable;
    public function get from():Linkable { return _from; }
    public function set from(item:Linkable):void { _from = item; item.outBoundConnections().addItem(this); }
    private var _to:Linkable;
    public function get to():Linkable { return _to; }
    public function set to(item:Linkable):void { _to = item; item.inBoundConnections().addItem(this); }
    
    private static const NORMAL_THICKNESS:Number = 1;
    private static const SELECTED_THICKNESS:Number = 3;
    private var thickness:Number = NORMAL_THICKNESS;
    
    private var graph:ConfigurationGraph;
    
    public function Connection(graph:ConfigurationGraph)
    {
      super();
      depth = -10; // Connections will appear under other elements
      
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onClick);
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }
    
    private function onClick(me:MouseEvent):void
    {
      me.stopPropagation();
      graph.deselectConnection();
      graph.selectedConnection = this;
      selected = true;
      setFocus();
    }
    
    private function onKeyDown(ke:KeyboardEvent):void
    {
      if (ke.keyCode == Keyboard.DELETE)
        deleteConnection();
    }
    
    public function deleteConnection():void
    {
      var index:int;
      
      // Visually remove the connection
      graph.removeElement(this);
      
      // Clear references
      if (_from != null) {
        var outBounds:ArrayCollection = _from.outBoundConnections();
        index = outBounds.getItemIndex(this);
        if (index != -1) outBounds.removeItemAt(index);
      }
      
      if (_to != null) {
        var inBounds:ArrayCollection = _to.inBoundConnections();
        index = inBounds.getItemIndex(this);
        if (index != -1) inBounds.removeItemAt(index);
      }
    }
    
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
      graphics.lineStyle(1, 0x666666, 1, true);

      graphics.beginFill(0x666666);
      GraphicsUtil.drawArrow(graphics, start, end, {shaftThickness: thickness});
      graphics.endFill();
      
      // A thick line to ease selection
      graphics.lineStyle(20, 0x000000, 0, true);
      graphics.moveTo(start.x, start.y);
      graphics.lineTo(end.x, end.y);
      
      // Straight Line
      //graphics.lineTo(end.x, end.y);
      
      // Curved Line
      //var offset:Number = start.x > end.x ? 50 : -50;
      //var controlX:Number = start.x - (start.x - end.x)/2 + offset;
      //var controlY:Number = end.y - (end.y - start.y)/2;
      //graphics.curveTo(controlX, controlY, end.x, end.y);
      
    }
    
  }
  
}