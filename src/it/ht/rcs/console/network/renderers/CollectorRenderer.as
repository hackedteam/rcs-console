package it.ht.rcs.console.network.renderers
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.network.model.Collector;
  
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;

  public class CollectorRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number = 120;
    private static const HEIGHT:Number = 32;
	
		public var collector:Collector;
		
		private var textLabel:Label;
		
		public function CollectorRenderer(collector:Collector)
		{
			super();
			
			this.collector = collector;
  	  this.buttonMode = collector.type == 'remote';
      
			setStyle('backgroundColor', 0xbbbbbb);
			
      addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
    override protected function createChildren():void
    {
			super.createChildren();

      if (textLabel == null)
      {
  			textLabel = new Label();
  			textLabel.text = collector.address;
  			textLabel.setStyle('fontSize', 12);
        textLabel.setStyle('textAlign', 'center');
        textLabel.width = WIDTH - 20;
        textLabel.maxDisplayedLines = 1;
  			addElement(textLabel);
      }
		}
		
		override protected function measure():void
    {
			super.measure();
			
			width = measuredWidth = WIDTH;
			height = measuredHeight = HEIGHT;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.beginFill(getStyle('backgroundColor'));
			graphics.drawRoundRect(0, 0, measuredWidth, measuredHeight, 20, 20);
			graphics.endFill();
		}
    
    
    
    private function mouseDown(event:MouseEvent):void
    {
      if ((event.currentTarget as CollectorRenderer).collector.type == 'remote')
      {
        var dragInitiator:CollectorRenderer = event.currentTarget as CollectorRenderer;
        var dragSource:DragSource = new DragSource();
        DragManager.doDrag(dragInitiator, dragSource, event, getProxy(dragInitiator));
      }
    }
    
    private function dragEnter(event:DragEvent):void
    {
      if (nextHop !== event.dragInitiator as CollectorRenderer)
      {
        var dropTarget:UIComponent = UIComponent(event.currentTarget);					
        DragManager.acceptDragDrop(dropTarget);
        DragManager.showFeedback(DragManager.COPY);
        setStyle('backgroundColor', 0x5555bb);
      }
    }
    
    private function dragExit(event:DragEvent):void
    {
      setStyle('backgroundColor', 0xbbbbbb);
    }
    
    private function dragDrop(event:DragEvent):void
    {
      //			var sourceAnon:Anonymizer = (event.dragInitiator as AnonymizerRenderer).anonymizer;
      //			var destAnon:Collector = this.collector;
      //			
      //			sourceAnon.moveAfter(destAnon);
      //      (parent as UIComponent).invalidateSize();
      //			(parent as UIComponent).invalidateDisplayList();
      
      setStyle('backgroundColor', 0xbbbbbb);
    }
    
    
    
    private var _nextHop:CollectorRenderer;
    private var _prevHop:CollectorRenderer;
    
    public function get nextHop():CollectorRenderer
    {
      return _nextHop;
    }
    
    public function set nextHop(newNextHop:CollectorRenderer):void
    {
      _nextHop = newNextHop;
    }
    
    public function get prevHop():CollectorRenderer
    {
      return _prevHop;
    }
    
    public function set prevHop(newPrevHop:CollectorRenderer):void
    {
      _prevHop = newPrevHop;
    }
    
    public function moveAfter(destination:CollectorRenderer):void
    {
      if (_prevHop === destination)
        return;
      
      _prevHop._nextHop = _nextHop;
      if (_nextHop != null)
        _nextHop._prevHop = _prevHop;
      
      if (destination._nextHop != null)
        destination._nextHop._prevHop = this;
      _nextHop = destination._nextHop;
      _prevHop = destination;
      destination._nextHop = this;
    }
    
    public function detach():void
    {
      if (_nextHop != null)
        _nextHop._prevHop = _prevHop;
      _prevHop._nextHop = _nextHop;
    }
		
	}
	
}