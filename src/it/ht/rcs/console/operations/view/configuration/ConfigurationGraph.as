package it.ht.rcs.console.operations.view.configuration
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import it.ht.rcs.console.operations.view.configuration.renderers.ActionRenderer;
	import it.ht.rcs.console.operations.view.configuration.renderers.ConnectionEvent;
	import it.ht.rcs.console.operations.view.configuration.renderers.ConnectionLine;
	import it.ht.rcs.console.operations.view.configuration.renderers.EventRenderer;
	import it.ht.rcs.console.operations.view.configuration.renderers.Pin;
	
	import spark.components.Group;
	import spark.components.supportClasses.ScrollBarBase;
	import spark.primitives.Rect;
	import spark.skins.spark.ScrollerSkin;

	public class ConfigurationGraph extends Group
	{

    public var config:Object;
    
    public static const NORMAL:String = 'normal';
    public static const CONNECTING:String = 'connecting';
    private var _mode:String = ConfigurationGraph.NORMAL;
    public function get mode():String { return _mode; }
    
		public function ConfigurationGraph()
		{
			super();
			layout = null;
      setStyle('paddingLeft', 50);
      
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      
      addEventListener(ConnectionEvent.START_CONNECTION, onStartConnection);
      
      addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
    
//    addEventListener(MouseEvent.MOUSE_OVER, put);
//    addEventListener(MouseEvent.MOUSE_OUT, rem);
//    private function put(me:MouseEvent):void {
//      Mouse.cursor = NativeCursor.HAND_OPEN;
//    }
//    private function rem(me:MouseEvent):void {
//      Mouse.cursor = MouseCursor.AUTO;
//    }
    
    private var selectedLine:ConnectionLine = null;
    private function onMouseDown(me:MouseEvent):void
    {
      setFocus(); // To receive keyboard events
      
      if (selectedLine) {
        selectedLine.selected = false;
        selectedLine = null;
      }
      
      if (me.target is ConnectionLine) {
        selectedLine = me.target as ConnectionLine;
        selectedLine.selected = true;
      }
      
      if (me.target == this) {
        dragX = me.stageX;
        dragY = me.stageY;
        addEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
        addEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
      }
      
    }
    
    private var dragX:Number, dragY:Number;
    private function onDraggingMove(me:MouseEvent):void
    {
      var scrollBar:ScrollBarBase = (this.parent as ScrollerSkin).hostComponent.horizontalScrollBar;
      scrollBar.value = scrollBar.value + dragX - me.stageX;
      dragX = me.stageX;
      
      scrollBar = (this.parent as ScrollerSkin).hostComponent.verticalScrollBar;
      scrollBar.value = scrollBar.value + dragY - me.stageY;
      dragY = me.stageY;
    }
    
    private function onDraggingUp(me:MouseEvent):void
    {
      removeEventListener(MouseEvent.MOUSE_MOVE, onDraggingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDraggingUp);
    }
    
    
    
    private function onKey(ke:KeyboardEvent):void
    {
      if (ke.keyCode == Keyboard.DELETE && selectedLine) {
        removeElement(selectedLine);
        selectedLine.from.setOutBound(null);
        selectedLine.to.setInBound(null);
        selectedLine = null;
      }
    }
    
    
    
    public var currentLine:ConnectionLine;
    private function onStartConnection(ce:ConnectionEvent):void
    {
//      _mode = ConfigurationGraph.CONNECTING;
//      
//      currentLine = new ConnectionLine();
//      currentLine.from = ce.startPin;
//      ce.startPin.outBound = currentLine;
//      
//      var start:Point = globalToLocal(ce.startPin.getGlobalCenter());
//      currentLine.startX = start.x;
//      currentLine.startY = start.y;
//      currentLine.endX = start.x;
//      currentLine.endY = start.y;
//      currentLine.depth = -10; // Will appear under other elements
//      
//      addElement(currentLine);
//      
//      addEventListener(MouseEvent.MOUSE_MOVE, onDrawingMove);
//      addEventListener(MouseEvent.MOUSE_UP, onDrawingUp);
    }
    
    private function onDrawingMove(me:MouseEvent):void
    {
      var pt:Point = new Point(me.stageX, me.stageY);
      pt = globalToLocal(pt);
      
      currentLine.endX = pt.x - 1; // -1 because if the line ends exactely on the mouse pointer, we get problems with mouse overs
      currentLine.endY = pt.y - 1;
      
      currentLine.invalidateDisplayList();
    }
    
    private function onDrawingUp(me:MouseEvent):void
    {
      currentLine = null;
      removeEventListener(MouseEvent.MOUSE_MOVE, onDrawingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDrawingUp);
      _mode = ConfigurationGraph.NORMAL;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private var bg:Rect;
    private var events:Vector.<EventRenderer>;
    private var actions:Vector.<ActionRenderer>;
    private var lines:Vector.<ConnectionLine>;
		public function rebuildGraph():void
		{
			removeAllElements();
      
      events = new Vector.<EventRenderer>();
      actions = new Vector.<ActionRenderer>();
      lines = new Vector.<ConnectionLine>;
      
      // Adding event renderers
      var er:EventRenderer;
      for each (var e:Object in config.events) {
        er = new EventRenderer(e);
        events.push(er);
				addElement(er);
      }
      
      // Adding actions
      var ar:ActionRenderer;
      for each (var a:Object in config.actions) {
        ar = new ActionRenderer(a);
        actions.push(ar);
        addElement(ar);
      }
      
      // Adding connections from events to actions
      for each (er in events) {
        if (er.event.hasOwnProperty('start'))  addLine(er.startPin,  actions[er.event.start]);
        if (er.event.hasOwnProperty('repeat')) addLine(er.repeatPin, actions[er.event.repeat]);
        if (er.event.hasOwnProperty('end'))    addLine(er.endPin,    actions[er.event.end]);
      }
      
      var p:Point = computeSize();
      bg = new Rect();
      bg.visible = false; // it just defines boundaries, save rendering time...
      bg.width = p.x;
      bg.height = p.y;
      bg.depth = -1000; // bottom layer
      addElement(bg);
      
			invalidateSize();
			invalidateDisplayList();
		}
    
    private function addLine(startPin:Pin, action:ActionRenderer):void
    {
      var line:ConnectionLine = new ConnectionLine();
      line.depth = -10;
      line.from = startPin;
      line.to = action;
      startPin.setOutBound(line);
      action.setInBound(line);
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
        y = 1500;
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
      
      // Draw lines starting from events
      if (lines != null && lines.length > 0) {
        var line:ConnectionLine;
        for (i = 0; i < lines.length; i++) {
          line = lines[i];
          var start:Point = line.from.getLinkPoint();
          var end:Point = line.to.getLinkPoint();
          line.startX = start.x;
          line.startY = start.y;
          line.endX = end.x;
          line.endY = end.y;
        }
      }
      

		}

	}

}