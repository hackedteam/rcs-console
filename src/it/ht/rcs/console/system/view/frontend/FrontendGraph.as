package it.ht.rcs.console.system.view.frontend
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import it.ht.rcs.console.events.NodeEvent;
	import it.ht.rcs.console.network.model.Collector;
	import it.ht.rcs.console.system.view.frontend.renderers.CollectorRenderer;
	import it.ht.rcs.console.system.view.frontend.renderers.DBRenderer;
	import it.ht.rcs.console.system.view.frontend.renderers.IPRenderer;
	import it.ht.rcs.console.utils.NativeCursor;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.supportClasses.ScrollBarBase;
	import spark.primitives.Rect;
	import spark.skins.spark.ScrollerSkin;

	[Event(name="nodeChanged", type="it.ht.rcs.console.events.NodeEvent")]
	public class FrontendGraph extends Group
	{

		public var db:DBRenderer;
    
    // Modes of operation
    public static const NORMAL:String     = 'normal';
    public static const DRAGGING:String   = 'dragging';
    private var mode:String = NORMAL;

		public function FrontendGraph()
		{
			super();
			layout = null;
      
      addEventListener(FlexEvent.CREATION_COMPLETE, init);
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); // Dragging
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(NodeEvent.CHANGED, onNodeEvent);
			addEventListener(NodeEvent.ADDED, onNodeEvent);
			addEventListener(NodeEvent.REMOVED, onNodeEvent);
//      addEventListener(MouseEvent.CLICK, onClick);
		}
    
    // Creation complete handler. Cache some useful references.
    private var hScrollBar:ScrollBarBase, vScrollBar:ScrollBarBase;
    private function init(e:FlexEvent):void
    {
      hScrollBar = (this.parent as ScrollerSkin).hostComponent.horizontalScrollBar;
      vScrollBar = (this.parent as ScrollerSkin).hostComponent.verticalScrollBar;
    }
    
    // Mouse pointer handling
    private function onMouseOver(me:MouseEvent):void
    {
      if (mode == NORMAL)
        Mouse.cursor = NativeCursor.HAND_OPEN;
      else if (mode == DRAGGING)
        Mouse.cursor = NativeCursor.HAND_CLOSE;
    }
    private function onMouseOut(me:MouseEvent):void
    {
      Mouse.cursor = MouseCursor.AUTO;
    }
    
    
    
    
    
    // ----- DRAGGING -----
    
    // This flag tells if there actually was some dragging.
    // If we go through MOUSE_DOWN and MOUSE_UP events without dragging,
    // we can simulate a CLICK
    private var dragged:Boolean = false;
    private var dragX:Number, dragY:Number;
    
    // Any other MOUSE_DOWN propagation is stopped by target sub-components,
    // so we only get events fired when the pointer is on the white background,
    // meaning we want to start dragging
    private function onMouseDown(me:MouseEvent):void
    {
      mode = DRAGGING;
      dragged = false;
      
      dragX = me.stageX;
      dragY = me.stageY;
      addEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      addEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      Mouse.cursor = NativeCursor.HAND_CLOSE;
    }
    
    private function onDraggingMove(me:MouseEvent):void
    {
      dragged = true;
      
      hScrollBar.value = hScrollBar.value + dragX - me.stageX;
      dragX = me.stageX;
      
      vScrollBar.value = vScrollBar.value + dragY - me.stageY;
      dragY = me.stageY;
    }
    
    private function onDraggingUp(me:MouseEvent):void
    {
      removeEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      Mouse.cursor = NativeCursor.HAND_OPEN;
      
      mode = NORMAL;
      
      // No dragging. We can simulate a click
      if (!dragged) {
        removeSelection();
        setFocus();
      }
    }
    
    
    
    
    
    // ----- SELECTION -----
    
//    private function onClick(event:MouseEvent):void
//    {
//      for each (var cr:CollectorRenderer in _db.collectors) {
//        cr.selectNode(false);
//        while (cr.nextHop != null) {
//          cr = cr.nextHop;
//          cr.selectNode(false);
//        }
//      }
//      
//      var node:CollectorRenderer;
//      if (event.target is CollectorRenderer)
//        node = event.target as CollectorRenderer;
//      else if (event.target.parent is CollectorRenderer)
//        node = event.target.parent as CollectorRenderer;
//      else return;
//
//      node.selectNode(true);
//
//      (this.parentDocument as Frontend).list.selectedItem = node.collector;
//    }

		private function onNodeEvent(e:Event):void
		{
			if (!(e is NodeEvent) || e.target == this)
				return;

			trace('NetworkGraph: NodeEvent');
			rebuildGraph();
		}

    public var selectedElement:CollectorRenderer;
    public function removeSelection():void
    {
      if (selectedElement != null) {
        selectedElement.selected = false;
        selectedElement = null;
      }
    }
    
//    public function selectNode(c:Collector):void
//    {
//      removeSelection();
//      var node:CollectorRenderer = map[c] as CollectorRenderer;
//      if (node == null) return;
//      
//      node.selected = true;
//    }
    
    
    
    
    
    // ----- RENDERING -----
    
    private var bg:Rect;
    private var ips:Vector.<IPRenderer>;
    private var map:Dictionary;
		public function rebuildGraph():void
		{
			removeAllElements();
      
			ips = new Vector.<IPRenderer>();
      map = new Dictionary();

			if (db == null) return;

			addElement(db);
			for each (var cr:CollectorRenderer in db.collectors)
			{
				addElement(cr);
        map[cr.collector] = cr;
        
				var lastNode:CollectorRenderer = cr;
				while (lastNode.nextHop != null)
				{
          lastNode = lastNode.nextHop;
					addElement(lastNode);
          map[lastNode.collector] = lastNode;
				}
        
				var ip:IPRenderer = new IPRenderer(lastNode.collector);
				ips.push(ip);
				addElement(ip);
			}
      
      // The background. We need a dummy component as background for two reasons:
      // 1) it defines maximum sizes
      // 2) will react to mouse events when the user clicks "nowhere" (eg, dragging)
      var p:Point = computeSize();
      bg = new Rect();
      bg.visible = false; // No need to see it, save rendering time...
      bg.width = p.x;
      bg.height = p.y;
      bg.depth = -1000; // Very bottom layer
      addElement(bg);

			invalidateSize();
			invalidateDisplayList();
		}
    
    private static const HORIZONTAL_DISTANCE:int = 60;
    private static const VERTICAL_DISTANCE:int   = 15;
    private static const HORIZONTAL_PAD:int      = 50;
    private static const VERTICAL_PAD:int        = 10;
    
    private function computeSize():Point
		{
			var _width:Number = 0, _height:Number = 0;
      
      if (db != null) {
      
        _width = (db.collectors[0].width * db.collectors.length) + (HORIZONTAL_DISTANCE * (db.collectors.length - 1)) + HORIZONTAL_PAD * 2;
  
  			var branch:Number = 0;
  			for each (var collector:CollectorRenderer in db.collectors)
  			{
  				branch = VERTICAL_PAD * 2 + db.height + VERTICAL_DISTANCE + collector.height;
  				collector = collector.nextHop;
  				while (collector != null)
  				{
  					branch += VERTICAL_DISTANCE + collector.height;
            collector = collector.nextHop;
  				}
  				branch += VERTICAL_DISTANCE + ips[0].height;
          _height = Math.max(branch, _height);
  			}
      
      }

      return new Point(_width, _height);
		}
    
    override protected function measure():void
    {
      super.measure();
      var p:Point = computeSize();
      measuredWidth = measuredMinWidth = p.x;
      measuredHeight = measuredMinHeight = p.y;
    }

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			var _width:Number = Math.max(unscaledWidth, measuredWidth);
			var _height:Number = Math.max(unscaledHeight, measuredHeight);

      var i:int = 0; // Generic loop index
      var cX:int = 0, cY:int = 0; // Generic currentX, currentY
      var offsetFromCenter:int = 0; // Generic offset
      
			graphics.lineStyle(1, 0x999999, 1, true);

      
			if (db != null) {

				db.move(_width / 2 - db.width / 2, _height - VERTICAL_PAD - db.height);
        
        // Draw collectors
				if (db.collectors != null && db.collectors.length > 0) {
          
          // Where to draw the first collector?
					var renderer:CollectorRenderer = db.collectors[0];
  				offsetFromCenter = db.collectors.length % 2 == 0 ?
            _width / 2 - (db.collectors.length / 2 * (HORIZONTAL_DISTANCE + renderer.width)) + HORIZONTAL_DISTANCE / 2 : // Even
		        _width / 2 - (Math.floor(db.collectors.length / 2) * (HORIZONTAL_DISTANCE + renderer.width)) - renderer.width / 2; // Odd
				
  				for (i = 0; i < db.collectors.length; i++) {
  
  					renderer = db.collectors[i];
  
  					cX = offsetFromCenter + i * (HORIZONTAL_DISTANCE + renderer.width);
  					cY = _height - VERTICAL_PAD - db.height - VERTICAL_DISTANCE - renderer.height;
            renderer.move(cX, cY);

  					graphics.moveTo(_width / 2,              cY + renderer.height + VERTICAL_DISTANCE);
            graphics.lineTo(_width / 2,              cY + renderer.height + VERTICAL_DISTANCE / 2);
            graphics.lineTo(cX + renderer.width / 2, cY + renderer.height + VERTICAL_DISTANCE / 2);
            graphics.lineTo(cX + renderer.width / 2, cY + renderer.height);

            // Draw anonymizers
  					var lastNode:CollectorRenderer = renderer;
  					while (lastNode.nextHop != null) {

              lastNode = lastNode.nextHop;
              
  						cY = cY - VERTICAL_DISTANCE - lastNode.height;
              lastNode.move(cX, cY);
              
  						graphics.moveTo(cX + lastNode.width / 2, cY + lastNode.height + VERTICAL_DISTANCE);
  						graphics.lineTo(cX + lastNode.width / 2, cY + lastNode.height);

  					} // End anonymizers

						var ip:IPRenderer = ips[i];
            
            cX = cX + lastNode.width / 2 - ip.width / 2;
            cY = cY - VERTICAL_DISTANCE - ip.height
						ip.move(cX, cY);
      
						graphics.moveTo(cX + ip.width / 2, cY + ip.height + VERTICAL_DISTANCE);
						graphics.lineTo(cX + ip.width / 2, cY + ip.height);
  
  				}
          
        } // End collectors
        
			}

		}

	}

}