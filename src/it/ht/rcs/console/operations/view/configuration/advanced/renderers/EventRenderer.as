package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  import it.ht.rcs.console.operations.view.configuration.advanced.forms.events.EventForm;
  
  import mx.binding.utils.BindingUtils;
  import mx.managers.PopUpManager;
  
  import spark.components.BorderContainer;
  import spark.components.Group;
  import spark.components.Label;
  import spark.primitives.BitmapImage;

  public class EventRenderer extends Group implements Linkable
	{
    private static const WIDTH_EXPANDED:Number  = 150;
    private static const WIDTH_COLLAPSED:Number = 50;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:uint   = 0xffffff;
    private static const SELECTED_COLOR:uint = 0xdddddd;
    private static const ACCEPT_COLOR:uint   = 0x99bb99;
    private static const REJECT_COLOR:uint   = 0xbb9999;
		
    private var container:BorderContainer;
    private var icon:BitmapImage;
		private var textLabel:Label;
    
    public var inBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return null; }
    
    public var startPin:Pin;
    public var repeatPin:Pin;
    public var endPin:Pin;
    
    private var graph:ConfigurationGraph;
    
    public var event:Object;
		
		public function EventRenderer(event:Object, graph:ConfigurationGraph)
		{
			super();
      layout = null;
      doubleClickEnabled = true;
      width = graph.collapsed ? WIDTH_COLLAPSED : WIDTH_EXPANDED;
      height = HEIGHT;
      
			this.event = event;
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      addEventListener(MouseEvent.CLICK, onClick);
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
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
        var pin:Pin = graph.currentConnection.from as Pin;
        var origin:Object = pin.parent;
        if (origin is ActionRenderer && ( pin.type == 'enable' || pin.type == 'disable' ) && !isConnected(origin)) { // Accept only inbound connections from actions not already connected
          graph.currentTarget = this;
          container.setStyle('backgroundColor', ACCEPT_COLOR);
        } else {
          graph.currentTarget = null;
          container.setStyle('backgroundColor', REJECT_COLOR);
        }
      }
    }
    
    private function isConnected(origin:Object):Boolean
    {
      for each (var c:Connection in inBound)
        if (c.from['parent'] === origin)
          return true;
      return false;
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
    
    private function onClick(me:MouseEvent):void
    {
      me.stopPropagation();
      graph.removeSelection();
      
      selected = true;
      graph.selectedElement = this;
      
      setFocus();
      graph.highlightElement(this);
    }
    
    private function onDoubleClick(me:MouseEvent):void
    {
      var popup:EventForm = PopUpManager.createPopUp(root, EventForm, true) as EventForm;
      popup.event = event;
      popup.graph = graph;
      PopUpManager.centerPopUp(popup);
    }
    
    private function onKeyDown(ke:KeyboardEvent):void
    {
      if (ke.keyCode == Keyboard.DELETE || ke.keyCode == Keyboard.BACKSPACE)
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
      graph.config.events.splice(graph.config.events.indexOf(event), 1);
    }
    
    private function getAllConnections():Vector.<Connection>
    {
      var v:Vector.<Connection> = new Vector.<Connection>();
      v = v.concat(inBoundConnections());
      v = v.concat(startPin.outBoundConnections());
      v = v.concat(repeatPin.outBoundConnections());
      v = v.concat(endPin.outBoundConnections());
      return v;
    }
    
    private var _selected:Boolean = false;
    public function get selected():Boolean { return _selected; }
    public function set selected(s:Boolean):void
    {
      _selected = s;
      container.setStyle('backgroundColor', _selected ? SELECTED_COLOR : NORMAL_COLOR);
    }
    
    override protected function createChildren():void
    {
			super.createChildren();
      
      toolTip = event.desc;
      
      if (container == null) {
        container = new BorderContainer();
        container.width = width;
        container.height = height;
        container.setStyle('backgroundColor', NORMAL_COLOR);
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.left = 6;
        icon.verticalCenter = -1;
        icon.source = ModuleIcons[event.event];
        container.addElement(icon);
        
        textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', event, 'desc');
        textLabel.left = 50;
        textLabel.right = 0;
        textLabel.height = height;
        textLabel.maxDisplayedLines = 2;
        container.addElement(textLabel);
        
        addElement(container);
      }

      if (startPin == null) {
        startPin = new Pin(graph, 0, 1, 'start');
        BindingUtils.bindProperty(startPin, 'visible', graph, {name: 'mode', getter: isStartVisible });
        startPin.x = 5;
        startPin.y = height;
        startPin.toolTip = 'Start';
        addElement(startPin);
      }
      
      if (repeatPin == null) {
        repeatPin = new Pin(graph, 0, 1, 'repeat');
        BindingUtils.bindProperty(repeatPin, 'visible', graph, {name: 'mode', getter: isRepeatVisible });
        repeatPin.x = width / 2;
        repeatPin.y = height;
        repeatPin.toolTip = 'Repeat';
        addElement(repeatPin);
      }
      
      if (endPin == null) {
        endPin = new Pin(graph, 0, 1, 'end');
        BindingUtils.bindProperty(endPin, 'visible', graph, {name: 'mode', getter: isEndVisible });
        endPin.x = width - 5;
        endPin.y = height;
        endPin.toolTip = 'End';
        addElement(endPin);
      }
		}
    
    private function isStartVisible(graph:ConfigurationGraph):Boolean  { return isVisible(graph, startPin);  }
    private function isRepeatVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, repeatPin); }
    private function isEndVisible(graph:ConfigurationGraph):Boolean    { return isVisible(graph, endPin);    }
    private function isVisible(graph:ConfigurationGraph, pin:Pin):Boolean {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        return graph.currentConnection.from == pin ? true : false;
      else return true;
    }
		
    public function getLinkPoint():Point
    {
      return new Point(x + width/4, y + height);
    }
		
	}
	
}