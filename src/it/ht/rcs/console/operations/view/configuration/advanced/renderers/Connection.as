package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  import it.ht.rcs.console.operations.view.configuration.advanced.forms.events.RepeatForm;
  import it.ht.rcs.console.operations.view.configuration.advanced.renderers.utils.GraphicsUtil;
  
  import mx.core.UIComponent;
  import mx.managers.PopUpManager;
  
  public class Connection extends UIComponent
  {
    
    public var start:Point;
    public var end:Point;
    
    private var _from:Linkable;
    public function get from():Linkable { return _from; }
    public function set from(item:Linkable):void { _from = item; item.outBoundConnections().push(this); }
    private var _to:Linkable;
    public function get to():Linkable { return _to; }
    public function set to(item:Linkable):void { _to = item; item.inBoundConnections().push(this); }
    
    private static const NORMAL_THICKNESS:Number = 1;
    private static const SELECTED_THICKNESS:Number = 3;
    private var thickness:Number = NORMAL_THICKNESS;
    
    private static const NORMAL_COLOR:uint = 0xbbbbbb;
    private static const SELECTED_COLOR:Number = 0x333333;
    private var color:uint = NORMAL_COLOR;
    
    private var graph:ConfigurationGraph;
    
    public function Connection(graph:ConfigurationGraph)
    {
      super();
      doubleClickEnabled = true;
      depth = -10; // Connections will appear under other elements
      
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_DOWN, onClick);
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      
      addEventListener(MouseEvent.DOUBLE_CLICK, displayRepeatPopup);
    }
    
    private function displayRepeatPopup(me:MouseEvent):void
    {
      if ((_from as Pin).type == 'repeat')
      {
        var event:Object = ((_from as Pin).parent as EventRenderer).event;
        var popup:RepeatForm = PopUpManager.createPopUp(root, RepeatForm, true) as RepeatForm;
        popup.event = event;
        PopUpManager.centerPopUp(popup);
      }
    }
    
    private function onMouseOver(me:MouseEvent):void
    {
      me.stopPropagation();
      Mouse.cursor = MouseCursor.AUTO;
    }
    
    private function onClick(me:MouseEvent):void
    {
      me.stopPropagation();
      graph.removeSelection();

      selected = true;
      graph.selectedElement = this;
      
      setFocus();
      graph.highlightElement(this);
    }
    
    private function onKeyDown(ke:KeyboardEvent):void
    {
      if (ke.keyCode == Keyboard.DELETE || ke.keyCode == Keyboard.BACKSPACE)
        deleteConnection();
    }
    
    public function deleteConnection():void
    {
      graph.removeSelection();
      graph.removeHighlight();
      
      graph.manageDeleteConnection(this);
      
      // Clear references
      if (_from != null) {
        var outBounds:Vector.<Connection> = _from.outBoundConnections();
        outBounds.splice(outBounds.indexOf(this), 1);
      }
      
      if (_to != null) {
        var inBounds:Vector.<Connection> = _to.inBoundConnections();
        inBounds.splice(inBounds.indexOf(this), 1);
      }
      
      graph.removeElement(this);
    }
    
    private var _selected:Boolean = false;
    public function get selected():Boolean { return _selected; }
    public function set selected(s:Boolean):void
    {
      _selected = s;
      thickness = _selected ? SELECTED_THICKNESS : NORMAL_THICKNESS;
      color = _selected ? SELECTED_COLOR : NORMAL_COLOR;
      invalidateDisplayList();
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      graphics.clear();
      
      var pin:Pin = from as Pin;
      if (pin.type == 'start')
        color = 0x00bb00;
      else if (pin.type == 'stop' || pin.type == 'end')
        color = 0xbb0000;
      else if (pin.type == 'repeat')
        color = 0x0000bb;
      
      graphics.beginFill(color);
      GraphicsUtil.drawArrow(graphics, start, end, {shaftThickness: thickness});
      graphics.endFill();
      
      // A thick invisible line to ease selection
      graphics.lineStyle(10, 0x000000, 0, true);
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