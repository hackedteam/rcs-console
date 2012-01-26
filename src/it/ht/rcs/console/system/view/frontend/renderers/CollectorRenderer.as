package it.ht.rcs.console.system.view.frontend.renderers
{
  import flash.events.MouseEvent;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.events.NodeEvent;
  import it.ht.rcs.console.network.model.Collector;
  import it.ht.rcs.console.system.view.frontend.CollectorListRenderer;
  import it.ht.rcs.console.system.view.frontend.Frontend;
  import it.ht.rcs.console.system.view.frontend.FrontendGraph;
  
  import mx.binding.utils.BindingUtils;
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  import spark.components.BorderContainer;
  import spark.components.Label;
  import spark.primitives.BitmapImage;

  public class CollectorRenderer extends NetworkObject
	{
    
    private static const WIDTH:Number  = 90; // 5*2 (padding) + 80 (width of label)
    private static const HEIGHT:Number = 66 + 26; // 5*2 (padding) + 50 (height of container) + 6 (gap) + 26 (height of label)
    
    private static const NORMAL_COLOR:Number = 0xffffff;
    private static const SELECTED_COLOR:Number = 0xa8c6ee;
    private static const DRAG_COLOR:Number = 0x999999;
	  
		public var collector:Collector;
		
    [Embed(source='/img/NEW/anonymizer.png')]
    private const anonymizerIcon:Class;
    [Embed(source='/img/NEW/collector.png')]
    private const collectorIcon:Class;
    
    [Embed(source='/img/NEW/ok.png')]
    private const okIcon:Class;
    [Embed(source='/img/NEW/error.png')]
    private const errorIcon:Class;
    
    private var container:BorderContainer;
    private var icon:BitmapImage;
    private var status:BitmapImage;
    private var textLabel:Label;
		
		public function CollectorRenderer(collector:Collector, graph:FrontendGraph)
		{
			super();
      this.width = WIDTH;
      this.height = HEIGHT;
			
			this.collector = collector;
      this.graph = graph;

      doubleClickEnabled = true;
      
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.CLICK, onClick);
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(DragEvent.DRAG_ENTER, dragEnter);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
    override protected function createChildren():void
    {
			super.createChildren();

      if (container == null)
      {
        container = new BorderContainer();
        container.width = 50;
        container.height = 50;
        container.setStyle('backgroundColor', NORMAL_COLOR);
        container.setStyle('borderColor', 0xdddddd);
        container.setStyle('cornerRadius', 10);
        
        icon = new BitmapImage();
        icon.horizontalCenter = icon.verticalCenter = 0;
        icon.source = collector.type == 'local' ? collectorIcon : anonymizerIcon;
        container.addElement(icon);
        
        status = new BitmapImage();
        status.top = -6;
        status.right = -6;
        status.source = collector.type == 'local' ? okIcon : errorIcon;
        container.addElement(status);
        
        addElement(container);
      }
      
      if (textLabel == null)
      {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', collector, 'name');
        textLabel.setStyle('textAlign', 'center');
        textLabel.width = 80;
        textLabel.maxDisplayedLines = 2;
  			addElement(textLabel);
      }
		}
    
    private function onMouseOver(me:MouseEvent):void
    {
      me.stopPropagation();
      Mouse.cursor = MouseCursor.AUTO;
    }
    
    private function onClick(me:MouseEvent):void
    {
      me.stopPropagation();
      graph.removeSelection();
      
      selected = true;
      graph.selectedElement = this;
      (this.parentDocument as Frontend).list.selectedItem = collector;
      
      setFocus();
    }
    
    private function onDoubleClick(me:MouseEvent):void
    {
      (this.parentDocument as Frontend).list.edit();
    }
    
    private var _selected:Boolean = false;
    public function get selected():Boolean { return _selected; }
    public function set selected(s:Boolean):void
    {
      _selected = s;
      container.setStyle('backgroundColor', _selected ? SELECTED_COLOR : NORMAL_COLOR);
    }
    
    
    private function onMouseDown(me:MouseEvent):void
    {
      me.stopPropagation();
      if (collector.type == 'remote')
      {
        var dragSource:DragSource = new DragSource();
        DragManager.doDrag(this, dragSource, me, getProxy(this));
      }
    }

    private function dragEnter(event:DragEvent):void
    {
      var accept:Boolean = false;
      if (event.dragInitiator is CollectorRenderer) {
        var cr:CollectorRenderer = event.dragInitiator as CollectorRenderer;
        accept = cr !== _nextHop && cr !== this;
      } else if (event.dragInitiator is CollectorListRenderer) {
        accept = true;
      }
      
      if (accept)
      {
        var dropTarget:UIComponent = UIComponent(event.currentTarget);					
        DragManager.acceptDragDrop(dropTarget);
        DragManager.showFeedback(DragManager.COPY);
        container.setStyle('backgroundColor', DRAG_COLOR)
      }
    }
    
    private function dragExit(event:DragEvent):void
    {
      container.setStyle('backgroundColor', NORMAL_COLOR);
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
        source = new CollectorRenderer(collector, graph);
        source.moveAfter(dest);
      }
      
      container.setStyle('backgroundColor', NORMAL_COLOR);
      
      graph.rebuildGraph();
    }

    private var _nextHop:CollectorRenderer;
    private var _prevHop:CollectorRenderer;
    
    public function get nextHop():CollectorRenderer { return _nextHop; }
    public function get prevHop():CollectorRenderer { return _prevHop; }
    
    public function set nextHop(newNextHop:CollectorRenderer):void
    {
      _nextHop = newNextHop;
      if (newNextHop != null)
        newNextHop._prevHop = this;
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