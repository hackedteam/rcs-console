package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.ui.Keyboard;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.ObjectUtils;
  import it.ht.rcs.console.operations.view.configuration.advanced.ConfigurationGraph;
  import it.ht.rcs.console.operations.view.configuration.advanced.forms.actions.ActionForm;
  
  import mx.binding.utils.BindingUtils;
  import mx.managers.PopUpManager;
  
  import spark.components.BorderContainer;
  import spark.components.Group;
  import spark.components.Label;
  import spark.primitives.BitmapImage;

  public class ActionRenderer extends Group implements Linkable
	{
    [Embed (source="img/modules/Create.png" )]
    public var okIcon:Class;
    
    [Embed (source="img/modules/No-entry.png" )]
    public var noIcon:Class;
    
    private static const WIDTH_EXPANDED:Number  = 170;
    private static const WIDTH_COLLAPSED:Number = 50;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:uint   = 0xffffff;
    private static const SELECTED_COLOR:uint = 0xdddddd;
    private static const ACCEPT_COLOR:uint   = 0x99bb99;
    private static const REJECT_COLOR:uint   = 0xbb9999;
		
    private var container:BorderContainer;
    private var icon:BitmapImage;
		private var textLabel:Label;
    
    private var inBound:Vector.<Connection>  = new Vector.<Connection>();
    private var outBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection>  { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return outBound; }
    
    public var enableEventPin:Pin;
    public var disableEventPin:Pin;
    
    public var startModulePin:Pin;
    public var stopModulePin:Pin;
    
    private var graph:ConfigurationGraph;
    
    private var acceptDragIcon:BitmapImage;
    
    public var action:Object;
    
		public function ActionRenderer(action:Object, graph:ConfigurationGraph)
		{
			super();
      layout = null;
      doubleClickEnabled = true;
      width = graph.collapsed ? WIDTH_COLLAPSED : WIDTH_EXPANDED;
      height = HEIGHT;
      
			this.action = action;
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
        if ((graph.currentConnection.from as Pin).parent is EventRenderer) { // Accept only inbound connections from events
          graph.currentTarget = this;
          container.setStyle('backgroundColor', ACCEPT_COLOR);
        } else {
          graph.currentTarget = null;
          container.setStyle('backgroundColor', REJECT_COLOR);
        }
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
      //this.owner is configurationGraph
      var popup:ActionForm = PopUpManager.createPopUp(root, ActionForm, true) as ActionForm;
      popup.action = action;
      popup.graph = graph;
      PopUpManager.centerPopUp(popup);
    }
    
    private function onKeyDown(ke:KeyboardEvent):void
    {
      if (ke.keyCode == Keyboard.DELETE || ke.keyCode == Keyboard.BACKSPACE)
        deleteAction();
    }
    
    public function deleteAction():void
    {
      graph.removeSelection();
      graph.removeHighlight();
      
      var conns:Vector.<Connection> = getAllConnections();
      for each (var c:Connection in conns)
        c.deleteConnection();
      
      graph.removeElement(this);
      var index:int = graph.config.actions.indexOf(action);
      graph.config.actions.splice(index, 1);
      graph.fixEventIndices(index);
    }
    
    private function getAllConnections():Vector.<Connection>
    {
      var v:Vector.<Connection> = new Vector.<Connection>();
      v = v.concat(inBoundConnections());
      v = v.concat(enableEventPin.outBoundConnections());
      v = v.concat(disableEventPin.outBoundConnections());
      v = v.concat(startModulePin.outBoundConnections());
      v = v.concat(stopModulePin.outBoundConnections());
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
        changeIcon();
        container.addElement(icon);
        
        textLabel = new Label();
        textLabel.left = 50;
        textLabel.right = 0;
        textLabel.height = height;
        //BindingUtils.bindProperty(textLabel, 'text', action, 'desc');
        BindingUtils.bindSetter(changeLabel, action, 'desc');
        textLabel.maxDisplayedLines = 2;
        container.addElement(textLabel);
        
        acceptDragIcon=new BitmapImage();
        acceptDragIcon.source=okIcon
        acceptDragIcon.x=72;
        acceptDragIcon.y=-6;
        //acceptDragIcon.visible=false;
        
        addElement(container);
        //addElement(acceptDragIcon);
      }
      
      if (enableEventPin == null) {
        enableEventPin = new Pin(graph, 0, Number.POSITIVE_INFINITY, 'enable');
        BindingUtils.bindProperty(enableEventPin, 'visible', graph, {name: 'mode', getter: isEnableEventVisible });
        enableEventPin.x = width - 45;
        enableEventPin.y = 0;
        enableEventPin.toolTip = 'Enable events';
        addElement(enableEventPin);
      }
      
      if (disableEventPin == null) {
        disableEventPin = new Pin(graph, 0, Number.POSITIVE_INFINITY, 'disable');
        BindingUtils.bindProperty(disableEventPin, 'visible', graph, {name: 'mode', getter: isDisableEventVisible });
        disableEventPin.x = width - 5;
        disableEventPin.y = 0;
        disableEventPin.toolTip = 'Disable events';
        addElement(disableEventPin);
      }
      
      if (startModulePin == null) {
        startModulePin = new Pin(graph, 0, Number.POSITIVE_INFINITY, 'start');
        BindingUtils.bindProperty(startModulePin, 'visible', graph, {name: 'mode', getter: isStartModuleVisible });
        startModulePin.x = width / 2 - 20;
        startModulePin.y = height;
        startModulePin.toolTip = 'Start modules';
        addElement(startModulePin);
      }
      
      if (stopModulePin == null) {
        stopModulePin = new Pin(graph, 0, Number.POSITIVE_INFINITY, 'stop');
        BindingUtils.bindProperty(stopModulePin, 'visible', graph, {name: 'mode', getter: isStopModuleVisible });
        stopModulePin.x = width / 2 + 20;
        stopModulePin.y = height;
        stopModulePin.toolTip = 'Stop modules';
        addElement(stopModulePin);
      }
		}
    
    public function changeLabel(object:Object):void
    {
      textLabel.text = object == null || object == '' ? getLabel() : object as String;
      toolTip = textLabel.text;
    }
    
    private function getLabel():String
    {
      if (action.subactions.length == 0) return '(empty action)';
      var sub:Object = action.subactions[0];
      switch (sub.action) {
        case 'synchronize': return 'Sync on ' + sub.host;
        case 'module': return ObjectUtils.capitalize(sub.status) + ' ' + sub.module;
        case 'event': return ObjectUtils.capitalize(sub.status) + ' event';
        case 'execute': return 'Execute\n(' + sub.command + ')';
        case 'uninstall': return 'Uninstall';
        case 'log': return 'Log ' + sub.text;
        case 'destroy': return 'Destroy' + (sub.permanent ? ' permanently' : '');
        case 'sms': return 'Sms with ' + (sub.position ? 'position' : (sub.sim ? 'sim info' : 'text'));
        default: return '-';
      }
    }
    
    public function changeIcon():void
    {
      icon.source = action.subactions.length > 0 ? getIcon() : null;
      invalidateDisplayList();
    }
    
    private function getIcon():Class
    {
      var action:Object = action.subactions[0];
      switch (action.action) {
        case 'event':
          return (action.status == 'enable') ? ModuleIcons.event_enable : ModuleIcons.event_disable;
        case 'module':
          return (action.status == 'start') ? ModuleIcons.module_start : ModuleIcons.module_stop;
        default:
          return ModuleIcons[action.action];
      }
    }
    
    private function isEnableEventVisible(graph:ConfigurationGraph):Boolean  { return isVisible(graph, enableEventPin);  }
    private function isDisableEventVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, disableEventPin); }
    private function isStartModuleVisible(graph:ConfigurationGraph):Boolean  { return isVisible(graph, startModulePin);  }
    private function isStopModuleVisible(graph:ConfigurationGraph):Boolean   { return isVisible(graph, stopModulePin);   }
    private function isVisible(graph:ConfigurationGraph, pin:Pin):Boolean {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        return graph.currentConnection.from === pin ? true : false;
      else return true;
    }
		
    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y);
    }
		
	}
	
}