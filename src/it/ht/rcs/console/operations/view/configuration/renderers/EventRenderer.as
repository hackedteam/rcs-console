package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  import it.ht.rcs.console.operations.view.configuration.ConfigurationGraph;
  
  import mx.binding.utils.BindingUtils;
  import mx.collections.ArrayCollection;
  
  import spark.components.Group;
  import spark.components.Label;

  public class EventRenderer extends Group implements Linkable
	{
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 50;
    
    private static const NORMAL_COLOR:Number   = 0xbbbbbb;
    private static const SELECTED_COLOR:Number = 0x8888bb;
    private var backgroundColor:uint = NORMAL_COLOR;
	  
		public var event:Object;
		
		private var textLabel:Label;
    
    public var inBound:ArrayCollection = new ArrayCollection();
    public function inBoundConnections():ArrayCollection { return inBound; }
    public function outBoundConnections():ArrayCollection { return null; }
    
    public var startPin:Pin;
    public var repeatPin:Pin;
    public var endPin:Pin;
    
    private var graph:ConfigurationGraph;
		
		public function EventRenderer(event:Object, graph:ConfigurationGraph)
		{
			super();
      layout = null;
      width = WIDTH;
      height = HEIGHT;
      
			this.event = event;
      this.graph = graph;
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
    }
    
    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null) {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', event, 'desc');
        textLabel.width = WIDTH;
        textLabel.height = HEIGHT - 5;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }

      if (startPin == null) {
        startPin = new Pin(graph);
        startPin.x = 0;
        startPin.y = height;
        addElement(startPin);
      }
      
      if (repeatPin == null) {
        repeatPin = new Pin(graph);
        repeatPin.x = width/2;
        repeatPin.y = height;
        addElement(repeatPin);
      }
      
      if (endPin == null) {
        endPin = new Pin(graph);
        endPin.x = width;
        endPin.y = height;
        addElement(endPin);
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
      return new Point(x + width/3, y + height);
    }
		
	}
	
}