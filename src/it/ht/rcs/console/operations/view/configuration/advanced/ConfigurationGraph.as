package it.ht.rcs.console.operations.view.configuration.advanced
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import it.ht.rcs.console.operations.view.configuration.advanced.forms.events.RepeatForm;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.ActionRenderer;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.Connection;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.EventRenderer;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.Linkable;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.ModuleRenderer;
	import it.ht.rcs.console.operations.view.configuration.advanced.renderers.Pin;
	import it.ht.rcs.console.utils.ScrollableGraph;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import spark.primitives.Rect;

	public class ConfigurationGraph extends ScrollableGraph
	{

    // The original config object
    public var config:Object;
    
    // Modes of operation
    public static const CONNECTING:String = 'connecting';
    
    public var collapsed:Boolean = false;
    
    // A reference to the currently selected element
    public var selectedElement:UIComponent;
    public function removeSelection():void
    {
      if (selectedElement != null) {
        selectedElement['selected'] = false;
        selectedElement = null;
      }
    }
    
    
    // Constructor
		public function ConfigurationGraph()
		{
			super();
		}
    
    override protected function onSimulatedClick():void
    {
      removeSelection();
      removeHighlight();
      setFocus();
    }
    
    
    
    
    
    // ----- CONNECTING -----
    
    // A reference to the currently dragged connection
    [Bindable] public var currentConnection:Connection;
    // A reference to the link target (this is set by sub-components)
    [Bindable] public var currentTarget:Linkable;
    
    public function startConnection(from:Linkable):void
    {
      removeSelection();
      removeHighlight();
      
      currentConnection = new Connection(this);
      currentConnection.from = from;
      var start:Point = from.getLinkPoint();
      currentConnection.start = start;
      currentConnection.end = start;
      
      addElement(currentConnection);
      
      addEventListener(MouseEvent.MOUSE_MOVE, onDrawingMove);
      addEventListener(MouseEvent.MOUSE_UP, onDrawingUp);
      mode = CONNECTING;
    }
    
    private function onDrawingMove(me:MouseEvent):void
    {
      currentConnection.end = globalToLocal(new Point(me.stageX, me.stageY));
      currentConnection.invalidateDisplayList();
    }
    
    private function onDrawingUp(me:MouseEvent):void
    {
      if (currentTarget != null) { // Dropping the line on a target
        currentConnection.to = currentTarget;
        currentConnection.end = currentTarget.getLinkPoint();
        connections.push(currentConnection);
        currentConnection.invalidateDisplayList();
        
        manageNewConnection(currentConnection);
      } else { // Dropping the line nowhere... cancel connecting operation
        currentConnection.deleteConnection();
      }
      
      currentConnection = null;
      currentTarget = null;
      
      removeEventListener(MouseEvent.MOUSE_MOVE, onDrawingMove);
      removeEventListener(MouseEvent.MOUSE_UP, onDrawingUp);
      mode = NORMAL;
    }
    
    public function manageNewConnection(connection:Connection):void
    {
      var type:String = (connection.from as Pin).type;
      if (connection.to is ModuleRenderer) {
        var module:String = (connection.to as ModuleRenderer).module.module;
        var subactions:Array = ((connection.from as Pin).parent as ActionRenderer).action.subactions;
        var subaction:Object = {action: 'module', status: type, module: module};
        subactions.push(subaction);
      } else if (connection.to is ActionRenderer) {
        var action:Object = (connection.to as ActionRenderer).action;
        var event:Object = ((connection.from as Pin).parent as EventRenderer).event;
        event[type] = (config.actions as Array).indexOf(action);
        if (type == 'repeat')
          displayRepeatPopup(event);
      } else if (connection.to is EventRenderer) {
        action = ((connection.from as Pin).parent as ActionRenderer).action;
        event = (connection.to as EventRenderer).event;
        action.subactions.push({action: 'event', status: type, event: (config.events as Array).indexOf(event)});
      }
    }
    
    private function displayRepeatPopup(event:Object):void
    {
      var popup:RepeatForm = PopUpManager.createPopUp(root, RepeatForm, true) as RepeatForm;
      popup.event = event;
      PopUpManager.centerPopUp(popup);
    }
    
    public function manageDeleteConnection(connection:Connection):void
    {
      var type:String = (connection.from as Pin).type;
      if (connection.to is ModuleRenderer) {
        var module:String = (connection.to as ModuleRenderer).module.module;
        var subactions:Array = ((connection.from as Pin).parent as ActionRenderer).action.subactions;
        var subaction:Object = findModuleSubaction(subactions, type, module);
        subactions.splice(subactions.indexOf(subaction), 1);
      } else if (connection.to is ActionRenderer) {
        var event:Object = ((connection.from as Pin).parent as EventRenderer).event;
        delete(event[type]);
      } else if (connection.to is EventRenderer) {
        var index:int = (config.events as Array).indexOf((connection.to as EventRenderer).event);
        subactions = ((connection.from as Pin).parent as ActionRenderer).action.subactions;
        subaction = findEventSubaction(subactions, type, index);
        subactions.splice(subactions.indexOf(subaction), 1);
      }
    }
    
    private function findModuleSubaction(subactions:Array, status:String, module:String):Object
    {
      for each (var subaction:Object in subactions)
        if (subaction.status == status && subaction.module == module)
          return subaction;
      return null;
    }
    
    private function findEventSubaction(subactions:Array, status:String, index:int):Object
    {
      for each (var subaction:Object in subactions)
        if (subaction.status == status && subaction.event == index)
          return subaction;
      return null;
    }
    
    
    
    
    
    // ----- HIGHLIGHTING -----
    
    private static const FULL_ALPHA:Number = 1;
    private static const FADED_ALPHA:Number = .2;
    private var highlightedElement:UIComponent;
    public function highlightElement(element:UIComponent):void
    {
      removeHighlight();
      
      var all:Vector.<UIComponent> = getAllElements();
      
      var toExclude:Vector.<UIComponent> = new Vector.<UIComponent>();
      toExclude.push(element);
      
      if (element is Connection) {
        toExclude = toExclude.concat(getConnectionBounds(element as Connection));
      } else {
        toExclude = toExclude.concat(getOutBoundElements(element));
        toExclude = toExclude.concat(getDestinations(toExclude));
      }
      
      var component:UIComponent;
      for each (component in toExclude)
        all.splice(all.indexOf(component), 1);
      
      for each (component in all)  
        component.alpha = FADED_ALPHA;
      
      highlightedElement = element;
    }
    
    private function getOutBoundElements(element:UIComponent):Vector.<UIComponent>
    {
      var v:Vector.<UIComponent> = new Vector.<UIComponent>();
      
      if (element is EventRenderer) {
        var er:EventRenderer = element as EventRenderer;
        v = v.concat(er.startPin.outBoundConnections());
        v = v.concat(er.repeatPin.outBoundConnections());
        v = v.concat(er.endPin.outBoundConnections());
      }
      
      if (element is ActionRenderer) {
        var ar:ActionRenderer = element as ActionRenderer;
        v = v.concat(ar.enableEventPin.outBoundConnections());
        v = v.concat(ar.disableEventPin.outBoundConnections());
        v = v.concat(ar.startModulePin.outBoundConnections());
        v = v.concat(ar.stopModulePin.outBoundConnections());
      }
      
      return v;
    }
    
    private function getDestinations(elements:Vector.<UIComponent>):Vector.<UIComponent>
    {
      var v:Vector.<UIComponent> = new Vector.<UIComponent>();
      
      for each (var element:UIComponent in elements)
        if (element is Connection) {
          var destination:Linkable = (element as Connection).to;
          if (v.indexOf(destination) == -1)
            v.push(destination);
        }
      
      return v;
    }
    
    private function getConnectionBounds(connection:Connection):Vector.<UIComponent>
    {
      var v:Vector.<UIComponent> = new Vector.<UIComponent>();
      
      v.push((connection.from as Pin).parent);
      v.push(connection.to);
      
      return v;
    }
    
    private function getAllElements():Vector.<UIComponent>
    {
      var all:Vector.<UIComponent> = new Vector.<UIComponent>();
      all = all.concat(events); all = all.concat(actions); all = all.concat(connections); all = all.concat(modules);
      return all;
    }
    
    public function removeHighlight():void
    {
      if (highlightedElement == null) return;
      
      var component:UIComponent;
      var all:Vector.<UIComponent> = getAllElements();
      
      for each (component in all)
        component.alpha = FULL_ALPHA;
      
      highlightedElement = null;
    }
    
    
    
    
    
    // ----- RENDERING -----
    
    private var bg:Rect;
    private var events:Vector.<EventRenderer>;
    private var actions:Vector.<ActionRenderer>;
    private var modules:Vector.<ModuleRenderer>;
    private var connections:Vector.<Connection>;
    private var modulesMap:Dictionary;
		public function rebuildGraph():void
		{
			removeAllElements();
      
      // Saving references will make positioning and drawing of elements so much easier...
      events = new Vector.<EventRenderer>();
      actions = new Vector.<ActionRenderer>();
      modules = new Vector.<ModuleRenderer>();
      connections = new Vector.<Connection>();
      modulesMap = new Dictionary();
      
      if (config == null) return;
      
      collapsed = config.globals.collapsed;
      NODE_DISTANCE = collapsed ? NODE_DISTANCE_COLLAPSED : NODE_DISTANCE_EXPANDED;
      
      // Adding events
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
      
      // Adding modules
      var mr:ModuleRenderer;
      for each (var m:Object in config.modules) {
        if (m.module == 'social') // Zingaza per Naga, maledetto!
          continue;
        mr = new ModuleRenderer(m, this);
        modules.push(mr);
        modulesMap[m.module] = mr;
        addElement(mr);
      }
      
      // Adding connections from actions to events and from actions to modules
      for each (ar in actions) {
        for each (var subaction:Object in ar.action.subactions) {
          if (subaction.action == 'event') {
            if (subaction.status == 'enable')  createConnection(ar.enableEventPin,  events[subaction.event]);
            if (subaction.status == 'disable') createConnection(ar.disableEventPin, events[subaction.event]);
          } else if (subaction.action == 'module') {
            if (subaction.status == 'start') createConnection(ar.startModulePin, modulesMap[subaction.module]);
            if (subaction.status == 'stop')  createConnection(ar.stopModulePin,  modulesMap[subaction.module]);
          }
        }
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
      line.from = from;
      line.to = to;
      connections.push(line);
      addElement(line);
    }
    
    private static const NODE_DISTANCE_EXPANDED:int  = 60;
    private static const NODE_DISTANCE_COLLAPSED:int = 30;
    private static var   NODE_DISTANCE:int;
    private static const MODULE_DISTANCE:int   = 10;
    private static const VERTICAL_DISTANCE:int = 60;
    private static const VERTICAL_GAP:int      = 200;
    private static const HORIZONTAL_PAD:int    = 50;
    // TODO: Comment this method...
    private function computeSize():Point
    {
      var eventsX:Number = 0, eventsY:Number = 0;
      if (events != null && events.length > 0) {
        eventsX = (events[0].width * events.length) + (NODE_DISTANCE * (events.length - 1)) + HORIZONTAL_PAD * 2;
        eventsY = 520; // TODO: Compute real height!!!
      }
      var actionsX:Number = 0, actionsY:Number = 0;
      if (actions != null && actions.length > 0) {
        actionsX = (actions[0].width * actions.length) + (NODE_DISTANCE * (actions.length - 1)) + HORIZONTAL_PAD * 2;
        actionsY = 520; // TODO: Compute real height!!!
      }
      var modulesX:Number = 0;
      if (modules != null && modules.length > 0) {
        modulesX = (modules[0].width * modules.length) + (MODULE_DISTANCE * (modules.length - 1)) + HORIZONTAL_PAD * 2;
      }
      return new Point(Math.max(eventsX, actionsX, modulesX), Math.max(eventsY, actionsY));
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
      
      
      // Draw modules
      if (modules != null && modules.length > 0) {
        
        // Where to draw the first module?
        var moduleRenderer:ModuleRenderer = modules[0];
        offsetFromCenter = modules.length % 2 == 0 ?
          _width / 2 - (modules.length / 2 * (MODULE_DISTANCE + moduleRenderer.width)) + MODULE_DISTANCE / 2 : // Even
          _width / 2 - (Math.floor(modules.length / 2) * (MODULE_DISTANCE + moduleRenderer.width)) - moduleRenderer.width / 2; // Odd
        
        cY = VERTICAL_DISTANCE + VERTICAL_GAP * 2;
        for (i = 0; i < modules.length; i++) {
          moduleRenderer = modules[i];
          cX = offsetFromCenter + i * (MODULE_DISTANCE + moduleRenderer.width);
          moduleRenderer.move(cX, cY);
        }
        
      } // End modules
      
      
      // Draw lines
      var line:Connection;
      if (connections != null && connections.length > 0) {
        for (i = 0; i < connections.length; i++) {
          line = connections[i];
          line.start = line.from.getLinkPoint();
          line.end = line.to.getLinkPoint();
          line.invalidateDisplayList();
        }
      }
		}
    
    override public function removeElement(element:IVisualElement):IVisualElement
    {
           if (element is EventRenderer && events.indexOf(element) != -1) events.splice(events.indexOf(element), 1);
      else if (element is ActionRenderer && actions.indexOf(element) != -1) actions.splice(actions.indexOf(element), 1);
      else if (element is Connection && connections.indexOf(element) != -1) connections.splice(connections.indexOf(element), 1);
      
      invalidateDisplayList();
      
      return super.removeElement(element);
    }
    
    public function log():void
    {
      trace('Events: ' + events.length as String);
      trace('Actions: ' + actions.length as String);
      trace('Connections: ' + connections.length as String);
      trace('=====');
    }

	}

}