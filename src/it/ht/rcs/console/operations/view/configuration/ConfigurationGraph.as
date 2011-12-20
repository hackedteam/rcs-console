package it.ht.rcs.console.operations.view.configuration
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import it.ht.rcs.console.operations.view.configuration.renderers.ActionRenderer;
	import it.ht.rcs.console.operations.view.configuration.renderers.Connection;
	import it.ht.rcs.console.operations.view.configuration.renderers.ConnectionEvent;
	import it.ht.rcs.console.operations.view.configuration.renderers.EventRenderer;
	import it.ht.rcs.console.operations.view.configuration.renderers.Linkable;
	import it.ht.rcs.console.utils.NativeCursor;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.supportClasses.ScrollBarBase;
	import spark.primitives.Rect;
	import spark.skins.spark.ScrollerSkin;

	public class ConfigurationGraph extends Group
	{

    // The original config object
    public var config:Object;
    
    // Modes of operation
    public static const NORMAL:String     = 'normal';
    public static const CONNECTING:String = 'connecting';
    public static const DRAGGING:String   = 'dragging';
    private var _mode:String = NORMAL;
    public function get mode():String { return _mode; }
    
    // A reference to the currently selected connection
    public var selectedConnection:Connection;
    public function deselectConnection():void
    {
      if (selectedConnection != null) {
        selectedConnection.selected = false;
        selectedConnection = null;
      }
    }
    
    
    // Constructor
		public function ConfigurationGraph()
		{
			super();
			layout = null;
      addEventListener(FlexEvent.CREATION_COMPLETE, init);
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); // Dragging
      addEventListener(ConnectionEvent.START_CONNECTION, onStartConnection); // Connecting
		}
    
    // Creation complete handler. Cache some useful references
    private var hScrollBar:ScrollBarBase, vScrollBar:ScrollBarBase;
    private function init(e:FlexEvent):void
    {
      hScrollBar = (this.parent as ScrollerSkin).hostComponent.horizontalScrollBar;
      vScrollBar = (this.parent as ScrollerSkin).hostComponent.verticalScrollBar;
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
      trace('down on graph');
      _mode = DRAGGING;
      dragged = false;
      
      dragX = me.stageX;
      dragY = me.stageY;
      addEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      addEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      Mouse.cursor = NativeCursor.HAND_CLOSE;
    }
    
    private function onDraggingMove(me:MouseEvent):void
    {
      trace('move on graph');
      dragged = true;
      
      hScrollBar.value = hScrollBar.value + dragX - me.stageX;
      dragX = me.stageX;
      
      vScrollBar.value = vScrollBar.value + dragY - me.stageY;
      dragY = me.stageY;
    }
    
    private function onDraggingUp(me:MouseEvent):void
    {
      trace('up on graph');
      removeEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      Mouse.cursor = MouseCursor.AUTO;
      
      _mode = NORMAL;
      
      // No dragging. We can simulate a click
      if (!dragged)
        deselectConnection();
    }
    
    
    
    
    
    // ----- CONNECTING -----
    
    // A reference to the currently dragged connection
    public var currentConnection:Connection;
    // A reference to the link target (this is set by sub-components)
    [Bindable] public var currentTarget:Linkable;
    
    private function onStartConnection(ce:ConnectionEvent):void
    {
      _mode = CONNECTING;
      
      deselectConnection();
      
      currentConnection = new Connection(this);
      currentConnection.from = ce.from;
      
      var start:Point = ce.from.getLinkPoint();
      currentConnection.start = start;
      currentConnection.end = start;
      currentConnection.depth = -10; // The line will appear under other elements
      
      addElement(currentConnection);
      
      addEventListener(MouseEvent.MOUSE_MOVE, onDrawingMove);
      addEventListener(MouseEvent.MOUSE_UP, onDrawingUp);
    }
    
    private function onDrawingMove(me:MouseEvent):void
    {
      // We set a small 1 pixel offset because if the line ends exactely on the mouse pointer,
      // we get problems with MOUSE_OVER events
      var end:Point = globalToLocal(new Point(me.stageX - 1, me.stageY - 1));
      currentConnection.end = end;
      
      currentConnection.invalidateDisplayList();
    }
    
    private function onDrawingUp(me:MouseEvent):void
    {
      if (currentTarget != null) { // Dropping the line on a target
        currentConnection.to = currentTarget;
        var end:Point = currentTarget.getLinkPoint();
        currentConnection.end = end;
        currentConnection.invalidateDisplayList();
      } else { // Dropping the line nowhere... cancel connecting operation
        removeElement(currentConnection);
      }
      
      removeEventListener(MouseEvent.MOUSE_MOVE, onDrawingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDrawingUp);
      currentConnection = null;
      currentTarget = null;
      
      _mode = ConfigurationGraph.NORMAL;
    }
    
    
    
    
    
    // ----- RENDERING -----
    
    private var bg:Rect;
    private var events:Vector.<EventRenderer>;
    private var actions:Vector.<ActionRenderer>;
    private var lines:Vector.<Connection>;
		public function rebuildGraph():void
		{
			removeAllElements();
      
      // Saving references will make positioning and drawing of elements so much easier...
      events = new Vector.<EventRenderer>();
      actions = new Vector.<ActionRenderer>();
      lines = new Vector.<Connection>();
      
      // Adding event renderers
      var er:EventRenderer;
      for each (var e:Object in config.events) {
        er = new EventRenderer(e, this);
        events.push(er);
				addElement(er);
      }
      
      // Adding actions
      var ar:ActionRenderer;
      for each (var a:Object in config.actions) {
        ar = new ActionRenderer(a, this);
        actions.push(ar);
        addElement(ar);
      }
      
      // Adding connections from events to actions
      for each (er in events) {
        if (er.event.hasOwnProperty('start'))  createConnection(er.startPin,  actions[er.event.start]);
        if (er.event.hasOwnProperty('repeat')) createConnection(er.repeatPin, actions[er.event.repeat]);
        if (er.event.hasOwnProperty('end'))    createConnection(er.endPin,    actions[er.event.end]);
      }
      
      // Adding connections from actions to events
      for each (ar in actions) {
        // cycle in action's subactions and look for event action...
        // if (er.event.hasOwnProperty('start')) createConnection(ar.startPin, events[subaction.start]);
        // if (er.event.hasOwnProperty('stop'))  createConnection(ar.stopPin,  events[subaction.stop]);
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
    
    private function createConnection(from:Linkable, to:Linkable):void
    {
      var line:Connection = new Connection(this);
      line.depth = -10;
      line.from = from;
      line.to = to;
      lines.push(line);
      addElement(line);
    }
    
    private static const NODE_DISTANCE:int     = 60;
    private static const VERTICAL_DISTANCE:int = 60;
    private static const VERTICAL_GAP:int      = 200;
    private static const HORIZONTAL_PAD:int    = 50;
    private function computeSize():Point
    {
      var x:Number = 0, y:Number = 0;
      if (events != null && events.length > 0) {
        x = (events[0].width * events.length) + (NODE_DISTANCE * (events.length - 1)) + HORIZONTAL_PAD * 2;
        y = 1500; // TODO: Compute real height!!!
      }
      return new Point(x, y);
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
      
			var _width:Number = unscaledWidth > measuredWidth ? unscaledWidth : measuredWidth;
			var _height:Number = unscaledHeight > measuredHeight ? unscaledHeight : measuredHeight;
      
      var i:int = 0; // Generic loop index
      var cX:int = 0, cY:int = 0; // Generic currentX, currentY
      var offsetFromCenter:int = 0; // Generic offset
      
      
      // Draw events
			if (events != null && events.length > 0) {
      
				// Where to draw the first event?
				var eventRenderer:EventRenderer = events[0];
  			offsetFromCenter = events.length % 2 == 0 ?
          _width / 2 - (events.length / 2 * (NODE_DISTANCE + eventRenderer.width)) + NODE_DISTANCE / 2 : // Even
          _width / 2 - (Math.floor(events.length / 2) * (NODE_DISTANCE + eventRenderer.width)) - eventRenderer.width / 2; // Odd

        cY = VERTICAL_DISTANCE;
				for (i = 0; i < events.length; i++) {
          eventRenderer = events[i];
					cX = offsetFromCenter + i * (NODE_DISTANCE + eventRenderer.width);
          eventRenderer.move(cX, cY);
				}

			} // End events
      
      
      // Draw actions
      if (actions != null && actions.length > 0) {
        
        // Where to draw the first action?
        var actionRenderer:ActionRenderer = actions[0];
        offsetFromCenter = actions.length % 2 == 0 ?
          _width / 2 - (actions.length / 2 * (NODE_DISTANCE + actionRenderer.width)) + NODE_DISTANCE / 2 : // Even
          _width / 2 - (Math.floor(actions.length / 2) * (NODE_DISTANCE + actionRenderer.width)) - actionRenderer.width / 2; // Odd
        
        cY = VERTICAL_DISTANCE + VERTICAL_GAP;
        for (i = 0; i < actions.length; i++) {
          actionRenderer = actions[i];
          cX = offsetFromCenter + i * (NODE_DISTANCE + actionRenderer.width);
          actionRenderer.move(cX, cY);
        }
        
      } // End actions
      
      // Draw lines
      var line:Connection;
      if (lines != null && lines.length > 0) {
        for (i = 0; i < lines.length; i++) {
          line = lines[i];
          line.start = line.from.getLinkPoint();
          line.end = line.to.getLinkPoint();
        }
      }
      

		}

	}

}