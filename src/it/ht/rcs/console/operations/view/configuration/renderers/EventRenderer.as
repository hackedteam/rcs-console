package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.binding.utils.BindingUtils;
  
  import spark.components.Group;
  import spark.components.Label;

  public class EventRenderer extends Group implements Linkable
	{
    private static const WIDTH:Number  = 120;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:uint = 0xbbbbbb;
    private static const OVER_COLOR:uint   = 0x88bb88;
    private var backgroundColor:uint = NORMAL_COLOR;
		
		private var textLabel:Label;
    
    public var inBound:Vector.<Connection> = new Vector.<Connection>();
    public function inBoundConnections():Vector.<Connection> { return inBound; }
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
      width = WIDTH;
      height = HEIGHT;
      
			this.event = event;
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
        BindingUtils.bindProperty(textLabel, 'text', event, 'desc');
        textLabel.width = width;
        textLabel.height = height;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }

      if (startPin == null) {
        startPin = new Pin(graph, 0, 1);
        BindingUtils.bindProperty(startPin, 'visible', graph, {name: 'mode', getter: isStartVisible });
        startPin.x = 5;
        startPin.y = height;
        startPin.toolTip = 'Start';
        addElement(startPin);
      }
      
      if (repeatPin == null) {
        repeatPin = new Pin(graph, 0, 1);
        BindingUtils.bindProperty(repeatPin, 'visible', graph, {name: 'mode', getter: isRepeatVisible });
        repeatPin.x = width / 2;
        repeatPin.y = height;
        repeatPin.toolTip = 'Repeat';
        addElement(repeatPin);
      }
      
      if (endPin == null) {
        endPin = new Pin(graph, 0, 1);
        BindingUtils.bindProperty(endPin, 'visible', graph, {name: 'mode', getter: isEndVisible });
        endPin.x = width - 5;
        endPin.y = height;
        endPin.toolTip = 'End';
        addElement(endPin);
      }
		}
    
    private function isStartVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, startPin); }
    private function isRepeatVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, repeatPin); }
    private function isEndVisible(graph:ConfigurationGraph):Boolean { return isVisible(graph, endPin); }
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
      //graphics.drawRoundRectComplex(0, 0, width, height, 5, 5, 0, 0);
			graphics.endFill();
		}
    
    public function getLinkPoint():Point
    {
      return new Point(x + width/4, y + height);
    }
		
	}
	
}