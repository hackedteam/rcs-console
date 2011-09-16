package it.ht.rcs.console.system.view.frontend.renderers
{
  import flash.events.MouseEvent;
  
  import it.ht.rcs.console.events.NodeEvent;
  import it.ht.rcs.console.network.model.Collector;
  import it.ht.rcs.console.system.view.frontend.CollectorListRenderer;
  
  import mx.binding.utils.BindingUtils;
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.Label;

  public class CollectorRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number  = 120;
    private static const HEIGHT:Number = 32;
    
    private static const NORMAL_COLOR:Number   = 0xbbbbbb;
    private static const SELECTED_COLOR:Number = 0x8888bb;
    private static const DRAG_COLOR:Number     = 0x5555bb;
	  
		public var collector:Collector;
		
		private var textLabel:Label;
		
		public function CollectorRenderer(collector:Collector)
		{
			super();
			
			this.collector = collector;
  	  this.buttonMode = collector.type == 'remote';
      
			setStyle('backgroundColor', NORMAL_COLOR);
			
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
        BindingUtils.bindProperty(textLabel, 'text', collector, 'name');
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
    
    
    
    public function selectNode(select:Boolean):void
    {
      setStyle('backgroundColor', select ? SELECTED_COLOR : NORMAL_COLOR);
    }
    
    private function mouseDown(event:MouseEvent):void
    {
      if (this.collector.type == 'remote')
      {
        var dragInitiator:CollectorRenderer = event.currentTarget as CollectorRenderer;
        var dragSource:DragSource = new DragSource();
        DragManager.doDrag(dragInitiator, dragSource, event, getProxy(dragInitiator));
      }
    }
    
    private function dragEnter(event:DragEvent):void
    {
      var accept:Boolean = false;
      if (event.dragInitiator is CollectorRenderer) {
        var cr:CollectorRenderer = event.dragInitiator as CollectorRenderer;
        accept = cr !== nextHop && cr !== this;
      } else if (event.dragInitiator is CollectorListRenderer) {
        accept = true;
      }
      
      if (accept)
      {
        var dropTarget:UIComponent = UIComponent(event.currentTarget);					
        DragManager.acceptDragDrop(dropTarget);
        DragManager.showFeedback(DragManager.COPY);
        setStyle('backgroundColor', DRAG_COLOR);
      }
    }
    
    private function dragExit(event:DragEvent):void
    {
      setStyle('backgroundColor', NORMAL_COLOR);
    }
    
    private function dragDrop(event:DragEvent):void
    {
      var dest:CollectorRenderer = this;
      var source:CollectorRenderer;
      if (event.dragInitiator is CollectorRenderer) {
        source = event.dragInitiator as CollectorRenderer;
        source.moveAfter(dest);
      } else if (event.dragInitiator is CollectorListRenderer) {
        var collector:Collector = (event.dragInitiator as CollectorListRenderer).data as Collector;
        source = new CollectorRenderer(collector);
        source.moveAfter(dest);
      }
      
      setStyle('backgroundColor', NORMAL_COLOR);
      
      var e:NodeEvent = new NodeEvent(NodeEvent.CHANGED);
      e.node = collector;
      dispatchEvent(e);
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
      if (newNextHop != null)
        newNextHop._prevHop = this;
    }
    
    public function get prevHop():CollectorRenderer
    {
      return _prevHop;
    }
    
    public function set prevHop(newPrevHop:CollectorRenderer):void
    {
      _prevHop = newPrevHop;
      if (newPrevHop != null)
        newPrevHop._nextHop = this;
    }
    
    public function moveAfter(destination:CollectorRenderer):void
    {
      if (_prevHop === destination)
        return;
      
      if (_prevHop != null)
        _prevHop._nextHop = _nextHop;
      if (_nextHop != null) {
        _nextHop._prevHop = _prevHop;
        _prevHop.collector.next = [_nextHop.collector._id];
        _nextHop.collector.prev = [_prevHop.collector._id];
      }
      
      if (destination._nextHop != null) {
        destination._nextHop._prevHop = this;
        destination._nextHop.collector.prev = [this.collector._id];
      }
      _nextHop = destination._nextHop;
      if (destination._nextHop != null)
        this.collector.next = [destination._nextHop.collector._id];
      _prevHop = destination;
      this.collector.prev = [destination.collector._id];
      destination._nextHop = this;
      destination.collector.next = [this.collector._id];
    }
    
    public function detach():void
    {
      if (_nextHop != null) {
        _nextHop._prevHop = _prevHop;
        _prevHop.collector.next = [_nextHop.collector._id];
        _nextHop.collector.prev = [_prevHop.collector._id];
      }
      _prevHop._nextHop = _nextHop;
      this.collector.prev = this.collector.next = [null];
    }
		
	}
	
}