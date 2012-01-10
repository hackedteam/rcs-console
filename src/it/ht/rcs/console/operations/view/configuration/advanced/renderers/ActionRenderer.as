package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  
  import mx.binding.utils.BindingUtils;
  
  import spark.components.Group;
  import spark.components.Label;

  public class ActionRenderer extends Group implements Linkable
	{
    private static const WIDTH:Number  = 200;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:uint   = 0xbbbbbb;
    private static const SELECTED_COLOR:uint = 0x999999;
    private static const ACCEPT_COLOR:uint   = 0x99bb99;
    private static const REJECT_COLOR:uint   = 0xbb9999;
    private var backgroundColor:uint = NORMAL_COLOR;
		
		private var textLabel:Label;
    
    private var inBound:Vector.<Connection>  = new Vector.<Connection>();
    private var outBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return outBound; }
    
    public var startEventPin:Pin;
    public var stopEventPin:Pin;
    
    public var startModulePin:Pin;
    public var stopModulePin:Pin;
    
    private var graph:ConfigurationGraph;
    
    public var action:Object;
    
		public function ActionRenderer(action:Object, graph:ConfigurationGraph)
		{
			super();
      layout = null;
      doubleClickEnabled = true;
      width = WIDTH;
      height = HEIGHT;
      
			this.action = action;
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      addEventListener(MouseEvent.CLICK, onClick);
      addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
        if ((graph.currentConnection.from as Pin).parent is EventRenderer) { // Accept only inbound connections from events
          graph.currentTarget = this;
          backgroundColor = ACCEPT_COLOR;
        } else {
          graph.currentTarget = null;
          backgroundColor = REJECT_COLOR;
        }
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
      if (ke.keyCode == Keyboard.DELETE)
        deleteEvent();
    }
    
    public function deleteEvent():void
    {
      graph.removeSelection();
      graph.removeHighlight();
      
      var conns:Vector.<Connection> = getAllConnections();
      for each (var c:Connection in conns)
        c.deleteConnection();
      
      graph.removeElement(this);
      graph.config.actions.splice(graph.config.actions.indexOf(action), 1);
    }
    
    private function getAllConnections():Vector.<Connection>
    {
      var v:Vector.<Connection> = new Vector.<Connection>();
      v = v.concat(inBoundConnections());
      v = v.concat(startEventPin.outBoundConnections());
      v = v.concat(stopEventPin.outBoundConnections());
      v = v.concat(startModulePin.outBoundConnections());
      v = v.concat(stopModulePin.outBoundConnections());
      return v;
    }
    
    private var _selected:Boolean = false;
    public function get selected():Boolean { return _selected; }
    public function set selected(s:Boolean):void
    {
      _selected = s;
      backgroundColor = _selected ? SELECTED_COLOR : NORMAL_COLOR;
      invalidateDisplayList();
    }
    
    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null) {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', action, 'desc');
        textLabel.width = width;
        textLabel.height = height;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }
      
      if (startEventPin == null) {
        startEventPin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(startEventPin, 'visible', graph, {name: 'mode', getter: isStartEventVisible });
        startEventPin.x = width - 45;
        startEventPin.y = 0;
        startEventPin.toolTip = 'Start events';
        addElement(startEventPin);
      }
      
      if (stopEventPin == null) {
        stopEventPin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(stopEventPin, 'visible', graph, {name: 'mode', getter: isStopEventVisible });
        stopEventPin.x = width - 5;
        stopEventPin.y = 0;
        stopEventPin.toolTip = 'Stop events';
        addElement(stopEventPin);
      }
      
      if (startModulePin == null) {
        startModulePin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(startModulePin, 'visible', graph, {name: 'mode', getter: isStartModuleVisible });
        startModulePin.x = width / 2 - 20;
        startModulePin.y = height;
        startModulePin.toolTip = 'Start modules';
        addElement(startModulePin);
      }
      
      if (stopModulePin == null) {
        stopModulePin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(stopModulePin, 'visible', graph, {name: 'mode', getter: isStopModuleVisible });
        stopModulePin.x = width / 2 + 20;
        stopModulePin.y = height;
        stopModulePin.toolTip = 'Stop modules';
        addElement(stopModulePin);
      }
		}
    
    private function isStartEventVisible(graph:ConfigurationGraph):Boolean  { return isVisible(graph, startEventPin);  }
    private function isStopEventVisible(graph:ConfigurationGraph):Boolean   { return isVisible(graph, stopEventPin);   }
    private function isStartModuleVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, startModulePin); }
    private function isStopModuleVisible(graph:ConfigurationGraph):Boolean  { return isVisible(graph, stopModulePin);  }
    private function isVisible(graph:ConfigurationGraph, pin:Pin):Boolean {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        return graph.currentConnection.from == pin ? true : false;
      else return true;
    }
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(backgroundColor);
      graphics.drawRect(0, 0, width, height);
      //graphics.drawRoundRect(0, 0, width, height, 10, 10);
      //graphics.drawRoundRectComplex(0, 0, width, height, 5, 5, 5, 5);
			graphics.endFill();
		}
    
    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y);
    }
		
	}
	
}