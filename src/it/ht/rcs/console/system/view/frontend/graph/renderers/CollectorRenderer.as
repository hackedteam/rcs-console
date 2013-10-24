package it.ht.rcs.console.system.view.frontend.graph.renderers
{
  import flash.events.MouseEvent;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  
  import it.ht.rcs.console.monitor.controller.MonitorManager;
  import it.ht.rcs.console.monitor.model.Status;
  import it.ht.rcs.console.network.model.Collector;
  import it.ht.rcs.console.system.view.frontend.CollectorListRenderer;
  import it.ht.rcs.console.system.view.frontend.Frontend;
  import it.ht.rcs.console.system.view.frontend.graph.FrontendGraph;
  import it.ht.rcs.console.system.view.frontend.graph.NodeEvent;
  
  import mx.binding.utils.BindingUtils;
  import mx.core.BitmapAsset;
  import mx.core.DragSource;
  import mx.core.UIComponent;
  import mx.events.DragEvent;
  import mx.managers.DragManager;
  
  
  import spark.components.BorderContainer;
  import spark.components.Image;
  import spark.components.Label;
  import spark.layouts.supportClasses.DropLocation;
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
    [Embed(source='/img/NEW/warn.png')]
    private const warnIcon:Class;
    [Embed(source='/img/NEW/unknown.png')]
    private const unknownIcon:Class;
    
    [Embed(source='/img/system/deny.png')]
    private var DenyIcon:Class;
    
    private var container:BorderContainer;
    private var icon:BitmapImage;
    private var status:BitmapImage;
    private var textLabel:Label;
    
    private var prevLabel:Label;
    private var nextlabel:Label;
    
    private var denyIcon:Image
		
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
      addEventListener(DragEvent.DRAG_OVER, dragOver);
			addEventListener(DragEvent.DRAG_EXIT, dragExit);
			addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
    override protected function createChildren():void
    {
			super.createChildren();
      
      toolTip = collector.address;

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
        status.source = getStatusIcon();
        container.addElement(status);
        
        
        var img:BitmapAsset = new DenyIcon() as BitmapAsset;
        denyIcon=new Image()
        denyIcon.source=img;
        denyIcon.top=-6
        denyIcon.left=-6
        container.addElement(denyIcon)
          
        denyIcon.visible=false;
        addElement(container);
        
        
        
      }
      
      if (textLabel == null)
      {
  			textLabel = new Label();
        BindingUtils.bindProperty(textLabel, 'text', collector, 'name');
        textLabel.setStyle('textAlign', 'center');
        textLabel.width = 80;
        textLabel.maxDisplayedLines = 2;
        textLabel.setStyle('fontFamily', 'Myriad');
        textLabel.setStyle('fontSize', 12);
  			addElement(textLabel);
  
      }
      
		}
    
    private function getStatusIcon():Class
    {
      if (collector.type == 'remote' && !collector.poll)
        return unknownIcon;
      
      var address:String = (collector.type == 'local') ? collector.internal_address : collector.address;
      
      var status:Status = MonitorManager.instance.getStatusByAddress(address);
      
      if (status == null)
        return errorIcon;
      
      switch (status.status) {
        case '0':
          return okIcon;
        case '1':
          return warnIcon;
        case '2':
          return errorIcon;
        default:
          return errorIcon;
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
      
      setFocus();
      dispatchEvent(new NodeEvent(NodeEvent.SELECTED, collector));
    }
    
    private function onDoubleClick(me:MouseEvent):void
    {
      if (Console.currentSession.user.is_sys_frontend())
        (this.parentDocument as Frontend).list.edit(collector);
      selected = true;
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
      if (collector.type == 'remote' && Console.currentSession.user.is_sys_frontend())
      {
        var dragSource:DragSource = new DragSource();
        DragManager.doDrag(this, dragSource, me, getProxy(this));
      }
    }

    private function dragEnter(event:DragEvent):void
    {
     
      var accept:Boolean = false;
      if (collector.address && collector.address.length > 0) {
        if (event.dragInitiator is CollectorRenderer) {
          var cr:CollectorRenderer = event.dragInitiator as CollectorRenderer;
          accept = cr !== _nextHop && cr !== this;
        } else if (event.dragInitiator is CollectorListRenderer) {
          var clr:CollectorListRenderer=event.dragInitiator as CollectorListRenderer
          accept = (clr.data.good && this.collector.good) || (!clr.data.good && !this.collector.good) || (clr.data.good && this.collector.next[0]==null);
        }
      }
      var dropTarget:UIComponent = UIComponent(event.currentTarget);		
      if (accept)
      {
        denyIcon.visible=false;
        DragManager.acceptDragDrop(dropTarget);
        DragManager.showFeedback(DragManager.COPY);
        container.setStyle('backgroundColor', DRAG_COLOR)
      }
      else
      {
        if (event.dragInitiator !== this && event.dragInitiator !== _nextHop)
        denyIcon.visible=true;
      
      }
    }
    
    private function dragOver(event:DragEvent):void
    {
      var accept:Boolean = false;
      if (collector.address && collector.address.length > 0) {
        if (event.dragInitiator is CollectorRenderer) {
          var cr:CollectorRenderer = event.dragInitiator as CollectorRenderer;
          accept = cr !== _nextHop && cr !== this;
        } else if (event.dragInitiator is CollectorListRenderer) {
          var clr:CollectorListRenderer=event.dragInitiator as CollectorListRenderer
          accept = (clr.data.good && this.collector.good) || (!clr.data.good && !this.collector.good) || (clr.data.good  && this.collector.next[0]==null);
        }
      }
      var dropTarget:UIComponent = UIComponent(event.currentTarget);		
      if (accept)
      {
        denyIcon.visible=false;
        DragManager.acceptDragDrop(dropTarget);
        DragManager.showFeedback(DragManager.COPY);
        container.setStyle('backgroundColor', DRAG_COLOR)
      }
      else
      {
        if (event.dragInitiator !== this && event.dragInitiator !== _nextHop)
          denyIcon.visible=true;
      }
    }
    
    
    private function dragExit(event:DragEvent):void
    {
      container.setStyle('backgroundColor', NORMAL_COLOR);
      denyIcon.visible=false;
    }

    private function dragDrop(event:DragEvent):void
    {
      var dest:CollectorRenderer = this;
      var source:CollectorRenderer;
      if (event.dragInitiator is CollectorRenderer) {
        source = event.dragInitiator as CollectorRenderer;
        if((source.collector.good && dest.collector.good) ||  (!source.collector.good && !dest.collector.good) || (source.collector.good  && dest.collector.next[0]==null))
        {
           source.moveAfter(dest);
        }
      } else if (event.dragInitiator is CollectorListRenderer) {
        var collector:Collector = (event.dragInitiator as CollectorListRenderer).data as Collector;
        
    
        if((collector.good && dest.collector.good) ||  (!collector.good && !dest.collector.good) || (collector.good  && dest.collector.next[0]==null))
        {
        source = new CollectorRenderer(collector, graph);
        source.moveAfter(dest);
        }
      }
      
      container.setStyle('backgroundColor', NORMAL_COLOR);
      graph.dirty=true;
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
      
      detach();
      
      if (destination._nextHop != null) {
        destination._nextHop._prevHop = this;
        destination._nextHop.collector.prev = [this.collector._id];
        
        _nextHop = destination._nextHop;
        this.collector.next = [destination._nextHop.collector._id];
      }
      
      destination._nextHop = this;
      destination.collector.next = [this.collector._id];
      
      _prevHop = destination;
      this.collector.prev = [destination.collector._id];
    }
    
    public function detach():void
    {
      graph.dirty=true;
      if (_prevHop != null) {
        if (_nextHop != null) {
          _prevHop.nextHop = _nextHop;
          _prevHop.collector.next = [_nextHop.collector._id];
          
          _nextHop._prevHop = _prevHop;
          _nextHop.collector.prev = [_prevHop.collector._id];
        } else {
          _prevHop.nextHop = null;
          _prevHop.collector.next = [null];
        }
        _prevHop = _nextHop = null;
        this.collector.prev = [null];
        this.collector.next = [null];
      }
    }
		
	}
	
}