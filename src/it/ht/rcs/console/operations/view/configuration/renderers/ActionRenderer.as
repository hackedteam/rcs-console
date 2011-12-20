package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.binding.utils.BindingUtils;
  import mx.collections.ArrayCollection;
  
  import spark.components.Group;
  import spark.components.Label;

  public class ActionRenderer extends Group implements Linkable
	{
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:Number   = 0xbbbbbb;
    private static const OVER_COLOR:Number     = 0xaaaaaa;
    private static const SELECTED_COLOR:Number = 0x88bb88;
    private var backgroundColor:uint = NORMAL_COLOR;
	  
		public var action:Object;
		
		private var textLabel:Label;
    
    private var inBound:ArrayCollection = new ArrayCollection();
    private var outBound:ArrayCollection = new ArrayCollection();
    public function inBoundConnections():ArrayCollection { return inBound; }
    public function outBoundConnections():ArrayCollection { return outBound; }
    
    public var startPin:Pin;
    public var stopPin:Pin;
    
    private var graph:ConfigurationGraph;
    
		public function ActionRenderer(action:Object, graph:ConfigurationGraph)
		{
			super();
      layout = null;
      width = WIDTH;
      height = HEIGHT;
      
			this.action = action;
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
    
    private function onMouseOver(me:MouseEvent):void
    {
      if (graph.mode == ConfigurationGraph.NORMAL) {
        backgroundColor = OVER_COLOR;
      } else if (graph.mode == ConfigurationGraph.CONNECTING) {
        backgroundColor = graph.currentConnection.from == this ? NORMAL_COLOR : SELECTED_COLOR;
        graph.currentTarget = this;
      }
      setStyle('backgroundColor', backgroundColor);
    }
    
    private function onMouseOut(me:MouseEvent):void {
      graph.currentTarget = null;
      backgroundColor = NORMAL_COLOR;
      setStyle('backgroundColor', backgroundColor);
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
      
      if (startPin == null) {
        startPin = new Pin(graph);
        startPin.x = width;
        startPin.y = 0;
        addElement(startPin);
      }
      
      if (stopPin == null) {
        stopPin = new Pin(graph);
        stopPin.x = width;
        stopPin.y = height;
        addElement(stopPin);
      }
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
      return new Point(x + width/2, y + height/2);
    }
		
	}
	
}