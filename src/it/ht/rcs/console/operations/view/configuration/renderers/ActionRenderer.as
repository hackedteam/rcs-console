package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.binding.utils.BindingUtils;
  
  import spark.components.Group;
  import spark.components.Label;

  public class ActionRenderer extends Group implements Linkable
	{
    private static const WIDTH:Number = 200;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:Number = 0xbbbbbb;
    private static const OVER_COLOR:Number   = 0x88bb88;
    private var backgroundColor:uint = NORMAL_COLOR;
	  
		public var action:Object;
		
		private var textLabel:Label;
    
    private var inBound:Vector.<Connection> = new Vector.<Connection>();
    private var outBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection> { return inBound; }
    public function outBoundConnections():Vector.<Connection> { return outBound; }
    
    public var startEventPin:Pin;
    public var stopEventPin:Pin;
    
    public var startModulePin:Pin;
    public var stopModulePin:Pin;
    
    private var graph:ConfigurationGraph;
    
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
    
    private function onMouseUp(me:MouseEvent):void
    {
      backgroundColor = NORMAL_COLOR;
      setStyle('backgroundColor', backgroundColor);
    }
    
    private function onClick(me:MouseEvent):void
    {
      graph.highlightElement(this);
    }
    
    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null) {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', action, 'desc');
        textLabel.width = WIDTH;
        textLabel.height = HEIGHT;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }
      
      if (startEventPin == null) {
        startEventPin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(startEventPin, 'visible', graph, {name: 'mode', getter: isStartEventVisible });
        startEventPin.x = 0;
        startEventPin.y = 0;
        startEventPin.toolTip = 'Start events';
        addElement(startEventPin);
      }
      
      if (stopEventPin == null) {
        stopEventPin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(stopEventPin, 'visible', graph, {name: 'mode', getter: isStopEventVisible });
        stopEventPin.x = width;
        stopEventPin.y = 0;
        stopEventPin.toolTip = 'Stop events';
        addElement(stopEventPin);
      }
      
      if (startModulePin == null) {
        startModulePin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(startModulePin, 'visible', graph, {name: 'mode', getter: isStartModuleVisible });
        startModulePin.x = 0;
        startModulePin.y = height;
        startModulePin.toolTip = 'Start modules';
        addElement(startModulePin);
      }
      
      if (stopModulePin == null) {
        stopModulePin = new Pin(graph, 0, Number.POSITIVE_INFINITY);
        BindingUtils.bindProperty(stopModulePin, 'visible', graph, {name: 'mode', getter: isStopModuleVisible });
        stopModulePin.x = width;
        stopModulePin.y = height;
        stopModulePin.toolTip = 'Stop modules';
        addElement(stopModulePin);
      }
		}
    
    private function isStartEventVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, startEventPin); }
    private function isStopEventVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, stopEventPin); }
    private function isStartModuleVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, startModulePin); }
    private function isStopModuleVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, stopModulePin); }
    private function isVisible(graph:ConfigurationGraph, pin:Pin):Boolean {
      if (graph.mode == ConfigurationGraph.CONNECTING)
        return graph.currentConnection.from == pin ? true : false;
      else return true;
    }
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(backgroundColor);
      graphics.drawRoundRect(0, 0, width, height, 10, 10);
			graphics.endFill();
		}
    
    public function getLinkPoint():Point
    {
      return new Point(x + width/2, y);
    }
		
	}
	
}