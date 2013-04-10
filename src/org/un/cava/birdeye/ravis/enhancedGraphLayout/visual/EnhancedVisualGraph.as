package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;
	
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.event.VGEdgeEvent;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.event.VGNodeEvent;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.edgeRenderers.EdgeControlRenderer;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.edgeRenderers.EdgeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.layout.HierarchicalLayouter;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.VisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	public class EnhancedVisualGraph extends VisualGraph
	{
		private static var _LOG:String = "graphLayout.visual.EnhancedVisualGraph";
		
		protected var _viewToVEdgeRendererMap:Dictionary;
		
		protected var _enableDefaultDoubleClick:Boolean = true;
		
		protected var _enableDragNodeWithSubTree:Boolean = false;
		
		/**
		 * This is the current Edge Control component that is dragged by the mouse.
		 * */
		protected var _dragControlComponent:UIComponent;
		
		
		/**
		 * Also allow the specification of an IFactory for edge
		 * controls.
		 * */
		protected var _edgeControlRendererFactory:IFactory = null;
		
		/**
		 * Specify whether edge labels should be displayed or not
		 * */
		protected var _displayEdgeControls:Boolean = true;
		
		
		/**
		 * Also allow the specification of an IFactory for node
		 * labels.
		 * */
		protected var _nodeLabelRendererFactory:IFactory = null;
		
		/**
		 * Specify whether node labels should be displayed or not
		 * */
		protected var _displayNodeLabels:Boolean = true;
		
		public function EnhancedVisualGraph()
		{
			super();
			_viewToVEdgeRendererMap = new Dictionary();
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set edgeControlRenderer(ecr:IFactory):void {
			/* if the factory was changed, then we have to remove all
			* instances of vedgeViews to have them updated */
			if(ecr != _edgeLabelRendererFactory) {
				/* set all edges invisible, this should delete all instances
				* of view components */
				setAllEdgesInVisible();
				
				/* set the new renderer */
				_edgeControlRendererFactory = ecr;	
				
				/* update i.e. recreate the instances */
				updateEdgeVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get edgeControlRenderer():IFactory {
			return _edgeControlRendererFactory;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set nodeLabelRenderer(elr:IFactory):void {
			/* if the factory was changed, then we have to remove all
			* instances of vedgeViews to have them updated */
			if(elr != _nodeLabelRendererFactory) {
				/* set all edges invisible, this should delete all instances
				* of view components */
				setAllInVisible();
				
				/* set the new renderer */
				_nodeLabelRendererFactory = elr;	
				
				/* update i.e. recreate the instances */
				updateVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get nodeLabelRenderer():IFactory {
			return _nodeLabelRendererFactory;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set displayEdgeControls(dec:Boolean):void {
			var e:IEdge;
			
			if(_displayEdgeControls == dec) {
				// no change
			} else {
				_displayEdgeControls = dec;
				setAllEdgesInVisible();
				//_canvas.invalidateDisplayList(); // maybe this is enough
				updateEdgeVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get displayEdgeControls():Boolean {
			return _displayEdgeControls;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set displayNodeLabels(del:Boolean):void {
			var e:INode;
			
			if(_displayNodeLabels == del) {
				// no change
			} else {
				_displayNodeLabels = del;
				setAllInVisible();
				//_canvas.invalidateDisplayList(); // maybe this is enough
				updateVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get displayNodeLabels():Boolean {
			return _displayNodeLabels;
		}
		
		
		public function set moveGraphInDrag(f:Boolean):void {
			_moveGraphInDrag = f;
		}
		
		public function set moveEdgeInDrag(f:Boolean):void {
			_moveEdgeInDrag = f;
		}
		
		/**
		 * Creates VNode and requires a Graph node to associate
		 * it with. Originally also created the view, but we no
		 * longer do that directly but only on demand.
		 * @param n The graph node to be associated with.
		 * @return The created VisualNode.
		 * */
		protected override function createVNode(n:INode):IVisualNode {
			
			var vnode:IVisualNode;
			
			/* as an id we use the id of the graph node for simplicity
			* for now, it is not really used separately anywhere
			* we also use the graph data object as our data object.
			* the view is set to null and remains so. */
			vnode = new EnhancedVisualNode(this, n, n.id, null, n.data);
			
			/* if the node should be visible by default 
			* we need to make sure that the view is created */
			if(newNodesDefaultVisible) {
				setNodeVisibility(vnode, true);
			}
			
			/* now set the vnode in the node */
			n.vnode = vnode;
			
			/* add the node to the hash to keep track */
			_vnodes[vnode] = vnode;
			
			
			return vnode;
		}
		
		protected override function removeNodeView(component:UIComponent, honorEffect:Boolean = true):void {
			
			var vn:IVisualNode;
			
			/* if there is an effect, start the effect and register a
			* handler that actually calls this method again, but
			* with honorEffect set to false */
			if(honorEffect && (removeItemEffect != null)) {
				super.removeNodeView(component, honorEffect);
			} else {
				vn = _nodeViewToVNodeMap[component];
				super.removeNodeView(component, honorEffect);
				var labelView:UIComponent = IEnhancedVisualNode(vn).labelView;
				if (labelView && labelView.parent){
					labelView.parent.removeChild(labelView);
				}
			}
		}
		
		/**
		 * Removes a VNode, this also removes the node's view
		 * if it existed, but does not touch the Graph node.
		 * @param vn The VisualNode to be removed.
		 * */
		protected override function removeVNode(vn:IVisualNode):void {			
			if (vn is IEnhancedVisualNode)
			{
				var labelView:UIComponent;
				labelView = IEnhancedVisualNode(vn).labelView;
				
				IEnhancedVisualNode(vn).labelView = null;
				
				if (labelView != null && labelView.parent) {
					labelView.parent.removeChild(labelView);	
				}
			}
			
			super.removeVNode(vn);			
		}
		
		/**
		 * Creates a VEdge from a graph Edge.
		 * @param e The Graph Edge.
		 * @return The created VEdge.
		 * */
		protected override function createVEdge(e:IEdge):IVisualEdge {
			
			var vedge:IVisualEdge;
			var n1:INode;
			var n2:INode;
			var lStyle:Object;
			var edgeAttrs:XMLList;
			var attr:XML;
			var attname:String;
			var attrs:Array;
			
			/* create a copy of the default style */
			lStyle = ObjectUtil.copy(_defaultEdgeStyle);
			
			/* extract style data from associated XML data for each parameter */
			attrs = ObjectUtil.getClassInfo(lStyle).properties;
			
			if (e.data is XML)
			{
				for each(attname in attrs) {
					if(e.data != null && (e.data as XML).attribute(attname).length() > 0) {
						lStyle[attname] = e.data.@[attname];
					}
				}
			}
			else
			{
				for each(attname in attrs) {
					if(e.data != null && e.data.hasOwnProperty(attname)) {
						lStyle[attname] = e.data[attname];
					}
				}
			}
			vedge = new EnhancedVisualEdge(this, e, e.id, e.data, null, lStyle);
			
			/* set the VisualEdge reference in the graph edge */
			e.vedge = vedge;
			
			/* check if the edge is supposed to be visible */
			n1 = e.node1;
			n2 = e.node2;
			
			/* if both nodes are visible, the edge should
			* be made visible, which may also create a label
			*/
			if(n1.vnode.isVisible && n2.vnode.isVisible) {
				setEdgeVisibility(vedge, true);
			}
			
			/* add to tracking hash */
			_vedges[vedge] = vedge;
			
			return vedge;
		}
		
		
		/**
		 * Create a "view" object (UIComponent) for the given node and
		 * return it. These methods are only exported to be used by
		 * the VisualNode. Alas, AS does not provide the "friend" directive.
		 * Not sure how to get around this problem right now.
		 * @param vn The node to replace/add a view object.
		 * @return The created view object.
		 * */
		protected override function createVNodeComponent(vn:IVisualNode):UIComponent {
			
			var mycomponent:UIComponent = null;
			var mylabelcomponent:UIComponent = null;
			/////////////////////////////////////////////////////
			
			if((_nodeLabelRendererFactory != null) && 
				(vn is IEnhancedVisualNode) && 
				(_edgeRendererFactory.newInstance() is IControllableEdgeRenderer)) {
				mylabelcomponent = _nodeLabelRendererFactory.newInstance();
				/* assigns the edge to the IDataRenderer part of the view
				* this is important to access the data object of the VEdge
				* which contains information for rendering. */		
				if(mylabelcomponent is IDataRenderer) {
					(mylabelcomponent as IDataRenderer).data = vn;
				}
				
				mylabelcomponent.x = this.width / 2.0;
				mylabelcomponent.y = this.height / 2.0;
				
				/* enable bitmap cachine if required */
				mylabelcomponent.cacheAsBitmap = cacheRendererObjects;
				/* add the component to its parent component
				* this can create problems, we have to see where we
				* check for all children
				* Add after the edges layer, but below all other elements such as nodes */
				nodeLayer.addChildAt(mylabelcomponent, 0);
				IEnhancedVisualNode(vn).labelView = mylabelcomponent;
			}	
			
			return super.createVNodeComponent(vn);
		}
		
		/**
		 * Create a "view" object (UIComponent) for the given edge and
		 * return it.
		 * @param ve The edge to replace/add a view object.
		 * @return The created view object.
		 * */
		protected override function createVEdgeLabelView(ve:IVisualEdge):UIComponent {
			var mycomponent:UIComponent = super.createVEdgeLabelView(ve);
			if(_edgeLabelRendererFactory != null) {
				var fromControl:UIComponent;
				var toControl:UIComponent
				if ((_edgeControlRendererFactory != null) && (ve is IControllableVisualEdge)) {
					fromControl = _edgeControlRendererFactory.newInstance();
					fromControl['type'] = EdgeControlRenderer.FROM_CONTROL;
					toControl = _edgeControlRendererFactory.newInstance();
					toControl['type'] = EdgeControlRenderer.TO_CONTROL;
					if (toControl is IDataRenderer)
					{
						(fromControl as IDataRenderer).data = ve;
						(toControl as IDataRenderer).data = ve;
					}
					fromControl.cacheAsBitmap = cacheRendererObjects;
					toControl.cacheAsBitmap = cacheRendererObjects;
					IControllableVisualEdge(ve).fromControl = fromControl;
					IControllableVisualEdge(ve).toControl = toControl;
					Object(mycomponent).fromControl = fromControl;
					Object(mycomponent).toControl = toControl;
					fromControl.addEventListener(MouseEvent.MOUSE_DOWN, edgeMouseDown);
					toControl.addEventListener(MouseEvent.MOUSE_DOWN, edgeMouseDown);
					_viewToVEdgeRendererMap[fromControl] = mycomponent;
					_viewToVEdgeRendererMap[toControl] = mycomponent;
					
					if(ve.edgeView)
						ve.edgeView.render();
				}
			}
			
			return mycomponent;
		}		
		
		/**
		 * Remove a "view" object (UIComponent) for the given edge.
		 * @param component The UIComponent to be removed.
		 * */
		protected override function removeVEdgeLabelView(component:UIComponent):void {
			
			/* remove the  control component from it's parent (which should be the canvas) */
			if(component.parent != null) {
				if (component is EdgeRenderer)
				{
					var fromControl:UIComponent = EdgeRenderer(component).fromControl;
					if (fromControl)
					{
						fromControl.parent.removeChild(fromControl);
						delete _viewToVEdgeRendererMap[fromControl];
						
					}
					
					var toControl:UIComponent = EdgeRenderer(component).toControl
					if (toControl)
					{
						toControl.parent.removeChild(toControl);
						delete _viewToVEdgeRendererMap[toControl];
					}
				}
			}
			
			super.removeVEdgeLabelView(component);
		}
		
		protected function edgeMouseDown(e:MouseEvent):void{
			dragControlBegin(e);
		}
		
		/**
		 * Start a drag operation. This sets the drag node and
		 * registeres a 'MouseMove' event handler with the
		 * VNode, so it can follow the mouse movement.
		 * @param event The MouseEvent that was triggered by clicking on the node.
		 * @see handleDrag()
		 * */
		protected override function dragBegin(event:MouseEvent):void {
			
			var ecomponent:UIComponent;
			var evnode:IVisualNode;
			var node:INode;
			
			var pt:Point;
			
			if (_moveNodeInDrag == false)
				return;
			
			/* if there is an animation in progress, we ignore
			* the drag attempt */
			if(_layouter && _layouter.animInProgress) {
				LogUtil.info(_LOG,"Animation in progress, drag attempt ignored");
				return;
			}
			
			/* make sure we get the right component */
			if(event.currentTarget is UIComponent) {
				
				ecomponent = (event.currentTarget as UIComponent);
				
				/* get the associated VNode of the view */
				evnode = _nodeViewToVNodeMap[ecomponent];
				
				/* stop propagation to prevent a concurrent backgroundDrag */
				event.stopImmediatePropagation();
				
				if(evnode != null) {
					node = evnode.node;
					
					/* if (ElectricalGraph.isConnected(node) == false)
					{
					var dragSource:DragSource = new DragSource();
					dragSource.addData(node, 'node');
					DragManager.doDrag(ecomponent, dragSource, event);
					return;
					} */
					
					if(!dragLockCenter) {
						// lockCenter is false, use the mouse coordinates at the point
						pt = ecomponent.localToGlobal(new Point(ecomponent.mouseX, ecomponent.mouseY));
					} else {
						// lockCenter is true, ignore the mouse coordinates
						// and use (0,0) instead as the point
						//TODO: change to the components`s center instead
						pt = ecomponent.localToGlobal(new Point(0,0));
					}
					
					/* Save the offset values in the map 
					* so we can compute x and y correctly in case
					* we use lockCenter */
					var nodeComponent:UIComponent;
					var enode:INode = evnode.node;
					
					var arrTreeNodes:ArrayCollection = new ArrayCollection();
					var arrTreeRoots:Array = [enode];
					var curTreeRoot:INode = arrTreeRoots.pop();
					
					if (_enableDragNodeWithSubTree)
					{
						while(curTreeRoot)
						{
							if (arrTreeNodes.contains(curTreeRoot) == false)
							{
								arrTreeNodes.addItem(curTreeRoot);
								for each (var nextTreeRoot:INode in curTreeRoot.successors)
								arrTreeRoots.push(nextTreeRoot);
							}
							curTreeRoot = arrTreeRoots.pop();
						}
					}
					else
					{
						arrTreeNodes.addItem(enode);
					}
					
					for each (var movedNode:INode in arrTreeNodes)
					{
						nodeComponent = movedNode.vnode.view;
						if (nodeComponent)
						{
							_drag_x_offsetMap[nodeComponent] = pt.x / (scaleX*this.scaleX) - nodeComponent.x;
							_drag_y_offsetMap[nodeComponent] = pt.y / (scaleY*this.scaleY) - nodeComponent.y;
						}
					}
					
					
					/* now we would need to set the bounds
					* rectangle in _drag_boundsMap, but this is
					* currently not implemented *
					_drag_boundsMap[ecomponent] = rectangle;
					*/
					
					/* Registeran eventListener with the component's stage that
					* handles any mouse move. This wires the component
					* to the mouse. On every mouse move, the event handler
					* is called, which updates its coordinates.
					* We need to save the drag component, since we have to 
					* register the event handler with the stage, not the component
					* itself. But from the stage we have no way to get back to
					* the component or the VNode in case of the mouse move or 
					* drop event. 
					*/
					_dragComponent = ecomponent;
					ecomponent.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
					this.addEventListener(MouseEvent.MOUSE_UP,dragEnd);
					/* also register a drop event listener */
					// ecomponent.stage.addEventListener(MouseEvent.MOUSE_UP, dragEnd);
					
					/* and inform the layouter about the dragEvent */
					_layouter.dragEvent(event, evnode);
				} else {
					throw Error("Event Component was not in the viewToVNode Map");
				}
			} else {
				throw Error("MouseEvent target was no UIComponent");
			}
		}
		
		protected function dragControlBegin(event:MouseEvent):void {
			
			var ecomponent:UIComponent;
			var evedge:IVisualEdge;
			var pt:Point;
			
			if (_moveEdgeInDrag == false)
				return;
			
			/* if there is an animation in progress, we ignore
			* the drag attempt */
			if(_layouter && _layouter.animInProgress) {
				LogUtil.info(_LOG,"Animation in progress, drag attempt ignored");
				return;
			}
			
			/* make sure we get the right component */
			if(event.currentTarget is UIComponent) {
				
				ecomponent = (event.currentTarget as UIComponent);
				
				/* stop propagation to prevent a concurrent backgroundDrag */
				event.stopImmediatePropagation();
				
				pt = ecomponent.localToGlobal(new Point(0,0));
				
				/* Save the offset values in the map 
				* so we can compute x and y correctly in case
				* we use lockCenter */
				_drag_x_offsetMap[ecomponent] = pt.x / (scaleX*this.scaleX) - ecomponent.x;
				_drag_y_offsetMap[ecomponent] = pt.y / (scaleY*this.scaleY) - ecomponent.y;
				
				/* now we would need to set the bounds
				* rectangle in _drag_boundsMap, but this is
				* currently not implemented *
				_drag_boundsMap[ecomponent] = rectangle;
				*/
				
				/* Registeran eventListener with the component's stage that
				* handles any mouse move. This wires the component
				* to the mouse. On every mouse move, the event handler
				* is called, which updates its coordinates.
				* We need to save the drag component, since we have to 
				* register the event handler with the stage, not the component
				* itself. But from the stage we have no way to get back to
				* the component or the VNode in case of the mouse move or 
				* drop event. 
				*/
				_dragControlComponent = ecomponent;
				ecomponent.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDragControl);
				this.addEventListener(MouseEvent.MOUSE_UP,dragControlEnd);
				/* also register a drop event listener */
				// ecomponent.stage.addEventListener(MouseEvent.MOUSE_UP, dragEnd);
			} else {
				throw Error("MouseEvent target was no UIComponent");
			}
		}
		
		/**
		 * Called everytime the mouse moves after the dragBegin() method has
		 * been called.  Updates the position of the Component based on
		 * the location of the mouse cursor.
		 * @param event The MouseMove event that has been triggered.
		 */
		protected override function handleDrag(event:MouseEvent):void {
			var myvnode:IVisualNode;
			var sp:UIComponent;
			
			if (_moveNodeInDrag == false) {	
				return;
			}
			
			/* we set our Component to be the saved
			* dragComponent, because we cannot access it
			* through the event. */
			sp = _dragComponent;
			
			/* Sometimes we get spurious events */
			if(_dragComponent == null) {
				LogUtil.info(_LOG,"received handleDrag event but _dragComponent is null, ignoring");
				return;
			}
			
			/* update the coordinates with the current
			* event's stage coordinates (i.e. current mouse position),
			* modified by the lock-center offset */
			
			var ptrObj:Object;
			for (ptrObj in _drag_x_offsetMap)
			{
				sp = ptrObj as UIComponent;
				sp.x = event.stageX / (scaleX*this.scaleX) - _drag_x_offsetMap[sp];	
			}
			for (ptrObj in _drag_y_offsetMap)
			{
				sp = ptrObj as UIComponent;
				sp.y = event.stageY / (scaleY*this.scaleY) - _drag_y_offsetMap[sp];
			}
			
			/* and inform the layouter about the dragEvent */
			for (ptrObj in _drag_x_offsetMap)
			{
				sp = ptrObj as UIComponent;
				myvnode = _nodeViewToVNodeMap[sp];
				myvnode.refresh();
				if (myvnode is IEnhancedVisualNode)
					IEnhancedVisualNode(myvnode).setNodeLabelCoordinates();
				_layouter.dragContinue(event, myvnode);
			}
			
			/* make sure flashplayer does an update after the event */
			refresh();
			event.updateAfterEvent();			
		}
		
		protected function handleDragControl(event:MouseEvent):void {
			var eRendererComp:EdgeRenderer;
			var sp:UIComponent;
			var controlType:int;
			var layoutOrientation:int;
			
			if (_moveEdgeInDrag == false) {	
				return;
			}
			//var bounds:Rectangle;
			
			/* we set our Component to be the saved
			* dragComponent, because we cannot access it
			* through the event. */
			sp = _dragControlComponent;
			eRendererComp = _viewToVEdgeRendererMap[sp];
			
			/* Sometimes we get spurious events */
			if(_dragControlComponent == null) {
				LogUtil.info(_LOG,"received handleDrag event but _dragComponent is null, ignoring");
				return;
			}
			
			sp['isDragging'] = true;
			
			/* update the coordinates with the current
			* event's stage coordinates (i.e. current mouse position),
			* modified by the lock-center offset */
			
			layoutOrientation = eRendererComp['layoutOrientation'];
			controlType = sp['type'];
			var oldPos:Number;
			if (controlType == EdgeControlRenderer.FROM_CONTROL)
			{
				var dFrom:Number;
				if ((layoutOrientation == HierarchicalLayouter.ORIENT_LEFT_RIGHT) ||
					(layoutOrientation == HierarchicalLayouter.ORIENT_RIGHT_LEFT))
				{
					oldPos = sp.x;
					sp.x = event.stageX / (scaleX*this.scaleX) - _drag_x_offsetMap[sp];
					dFrom = (sp.x - oldPos);
				}
				else if ((layoutOrientation == HierarchicalLayouter.ORIENT_BOTTOM_UP) ||
					(layoutOrientation == HierarchicalLayouter.ORIENT_TOP_DOWN))
				{
					oldPos = sp.y;
					sp.y = event.stageY / (scaleY*this.scaleY) - _drag_y_offsetMap[sp];
					dFrom = (sp.y - oldPos);
				}
				eRendererComp['fromDistance'] += dFrom;
			}
			else if (controlType == EdgeControlRenderer.TO_CONTROL)
			{
				var dTo:Number;
				if ((layoutOrientation == HierarchicalLayouter.ORIENT_BOTTOM_UP) ||
					(layoutOrientation == HierarchicalLayouter.ORIENT_TOP_DOWN))
				{
					oldPos = sp.x
					sp.x = event.stageX / (scaleX*this.scaleX) - _drag_x_offsetMap[sp];
					dTo = (sp.x - oldPos);
				}
				else if ((layoutOrientation == HierarchicalLayouter.ORIENT_LEFT_RIGHT) ||
					(layoutOrientation == HierarchicalLayouter.ORIENT_RIGHT_LEFT))
				{
					oldPos = sp.y
					sp.y = event.stageY / (scaleY*this.scaleY) - _drag_y_offsetMap[sp];
					dTo = (sp.y - oldPos);
				}
				
				eRendererComp['toDistance'] += dTo;
			}
			
			/* make sure flashplayer does an update after the event */
			refresh();			
		}
		
		/**
		 * This handles a background drag (i.e. scroll). The
		 * event listener is usually registered with the canvas,
		 * i.e. this object.
		 * @param event The triggered event.
		 * */
		protected override function backgroundDragBegin(event:MouseEvent):void {
			
			if (_moveGraphInDrag == false)
				return;
			super.backgroundDragBegin(event);
		}
		
		/**
		 * This method handles the drop event (usually MOUSE_UP).
		 * It stops any dragging in progress (including background drag)
		 * and unregisters the current dragged node.
		 * @param event The triggered event.
		 * */
		protected override function dragEnd(event:MouseEvent):void {
			
			var mycomp:UIComponent;
			var myback:DisplayObject;
			var myvnode:IVisualNode;
			this.removeEventListener(MouseEvent.MOUSE_UP,dragEnd);
			if(_backgroundDragInProgress) {
				
				/* if it was a background drag we stop it here */
				_backgroundDragInProgress = false;
				
				/* get the background drag object, which is usually
				* the canvasm so we just set it to this */
				//myback = (event.currentTarget as DisplayObject);
				myback = (this as DisplayObject);
				
				/* unregister event handler */				
				myback.removeEventListener(MouseEvent.MOUSE_MOVE,backgroundDragContinue);
				// myback.removeEventListener(MouseEvent.MOUSE_MOVE,dragEnd);
				
				/* and inform the layouter about the dropEvent */
				if(_layouter) {
					_layouter.bgDropEvent(event);
				}
			} else {
				var ptrObj:Object; 
				if (_dragComponent){
					_dragComponent = null;
					
					for (ptrObj in _drag_x_offsetMap)
					{
						mycomp = ptrObj as UIComponent;
						if (mycomp.stage != null)
						{
							mycomp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
						}
						delete _drag_x_offsetMap[ptrObj];
					}
					for (ptrObj in _drag_y_offsetMap)
					{
						mycomp = ptrObj as UIComponent;
						myvnode = _nodeViewToVNodeMap[mycomp];
						if(_layouter) 
						{
							_layouter.dropEvent(event, myvnode);
						}
						delete _drag_y_offsetMap[ptrObj];
						//TODO, Fix this
						
						this.dispatchEvent(new VGNodeEvent(VGNodeEvent.VG_NODE_END_DRAG, myvnode.node, event));
					}
				}
				if (_dragControlComponent)
				{
					
					mycomp = _dragControlComponent;
					
					/* reset the dragComponent */
					_dragControlComponent = null;
					
					for (ptrObj in _drag_x_offsetMap)
					{
						mycomp = ptrObj as UIComponent;
						if (mycomp.stage != null)
						{
							mycomp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
						}
						delete _drag_x_offsetMap[ptrObj];
					}
					for (ptrObj in _drag_y_offsetMap)
					{
						mycomp = ptrObj as UIComponent;
						if(_layouter) 
						{
							_layouter.dropEvent(event, myvnode);
						}
						delete _drag_y_offsetMap[ptrObj];
					}
					
					/* remove the event listeners */
					//mycomp.stage.removeEventListener(MouseEvent.MOUSE_DOWN, dragEnd);
					// HACK: I have to check the stage because there are eventual components not added to the display list
					if (mycomp.stage != null)
					{
						mycomp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDragControl);
					}
				}
			}
			
			/* and stop propagation, as otherwise we could get the
			* event multiple times */
			//event.stopImmediatePropagation();			
		}
		
		protected function dragControlEnd(event:MouseEvent):void {
			
			this.removeEventListener(MouseEvent.MOUSE_UP,dragControlEnd);
			if(_backgroundDragInProgress) {
				var myback:DisplayObject;
				/* if it was a background drag we stop it here */
				_backgroundDragInProgress = false;
				
				/* get the background drag object, which is usually
				* the canvasm so we just set it to this */
				//myback = (event.currentTarget as DisplayObject);
				myback = (this as DisplayObject);
				
				/* unregister event handler */				
				myback.removeEventListener(MouseEvent.MOUSE_MOVE,backgroundDragContinue);
				// myback.removeEventListener(MouseEvent.MOUSE_MOVE,dragEnd);
				
				/* and inform the layouter about the dropEvent */
				if(_layouter) {
					_layouter.bgDropEvent(event);
				}
			} else {
				
				/* if it was no background drag, the component
				* is the saved dragComponent */
				var sp:UIComponent = _dragControlComponent;
				var mycomp:UIComponent;
				var myvedge:IVisualEdge;
				/* But sometimes the dragComponent was already null, 
				* in this case we have to ignore the thing. */
				if(sp == null) {
					LogUtil.info(_LOG,"dragEnd: received dragEnd but _dragComponent was null, ignoring");
					return;
				}
				
				var eRendererComp:EdgeRenderer = _viewToVEdgeRendererMap[sp];
				myvedge = _edgeLabelViewToVEdgeMap[eRendererComp];
				/* remove the event listeners */
				//mycomp.stage.removeEventListener(MouseEvent.MOUSE_DOWN, dragEnd);
				// HACK: I have to check the stage because there are eventual components not added to the display list
				
				/* bounds are not implemented:
				bounds = _drag_boundsMap[sp];
				*/
				
				/* update the coordinates with the current
				* event's stage coordinates (i.e. current mouse position),
				* modified by the lock-center offset */
				
				var layoutOrientation:int = eRendererComp['layoutOrientation'];
				var controlType:uint = sp['type'];
				var isDragging:Boolean = sp['isDragging'] as Boolean;
				var oldPos:Number;
				if (isDragging == true)
				{
					if (controlType == EdgeControlRenderer.FROM_CONTROL)
					{
						var dFrom:Number;
						if ((layoutOrientation == HierarchicalLayouter.ORIENT_LEFT_RIGHT) ||
							(layoutOrientation == HierarchicalLayouter.ORIENT_RIGHT_LEFT))
						{
							oldPos = sp.x;
							sp.x = event.stageX / (scaleX*this.scaleX) - _drag_x_offsetMap[sp];
							dFrom = (sp.x - oldPos);
						}
						else if ((layoutOrientation == HierarchicalLayouter.ORIENT_BOTTOM_UP) ||
							(layoutOrientation == HierarchicalLayouter.ORIENT_TOP_DOWN))
						{
							oldPos = sp.y;
							sp.y = event.stageY / (scaleY*this.scaleY) - _drag_y_offsetMap[sp];
							dFrom = (sp.y - oldPos);
						}
						eRendererComp['fromDistance'] += dFrom;
					}
					else if (controlType == EdgeControlRenderer.TO_CONTROL)
					{
						var dTo:Number;
						if ((layoutOrientation == HierarchicalLayouter.ORIENT_BOTTOM_UP) ||
							(layoutOrientation == HierarchicalLayouter.ORIENT_TOP_DOWN))
						{
							oldPos = sp.x
							sp.x = event.stageX / (scaleX*this.scaleX) - _drag_x_offsetMap[sp];
							dTo = (sp.x - oldPos);
						}
						else if ((layoutOrientation == HierarchicalLayouter.ORIENT_LEFT_RIGHT) ||
							(layoutOrientation == HierarchicalLayouter.ORIENT_RIGHT_LEFT))
						{
							oldPos = sp.y
							sp.y = event.stageY / (scaleY*this.scaleY) - _drag_y_offsetMap[sp];
							dTo = (sp.y - oldPos);
						}
						
						eRendererComp['toDistance'] += dTo;
					}
				}
				/* reset the dragComponent */
				var ptrObj:Object;
				for (ptrObj in _drag_x_offsetMap)
				{
					mycomp = ptrObj as UIComponent;
					if (mycomp.stage != null)
					{
						mycomp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDragControl);
					}
					delete _drag_x_offsetMap[ptrObj];
				}
				for (ptrObj in _drag_y_offsetMap)
				{
					mycomp = ptrObj as UIComponent;
					delete _drag_y_offsetMap[ptrObj];
				}
				_dragControlComponent = null;
				sp['isDragging'] = false;
				this.removeEventListener(MouseEvent.MOUSE_UP,dragControlEnd);
				if (isDragging)
					this.dispatchEvent(new VGEdgeEvent(VGEdgeEvent.VG_EDGE_CONTROL_END_DRAG, myvedge.edge, event));
				
			}
			
			/* and stop propagation, as otherwise we could get the
			* event multiple times */
			//event.stopImmediatePropagation();			
		}
		
		public override function draw(flags:uint=0):void
		{
			super.draw(flags);
			//_canvas.dispatchEvent(new VGraphEvent(VGraphEvent.VGRAPH_CHANGED)); 
		} 
		
		public function get enableDefaultDoubleClick():Boolean
		{
			return _enableDefaultDoubleClick;
		}
		
		public function set enableDefaultDoubleClick(value:Boolean):void
		{
			_enableDefaultDoubleClick = value;
		}
		
		protected override function nodeDoubleClick(e:MouseEvent):void 
		{
			if (_enableDefaultDoubleClick)
				super.nodeDoubleClick(e);
		}
		
		public function get enableDragNodeWithSubTree():Boolean
		{
			return _enableDragNodeWithSubTree;
		}
		
		public function set enableDragNodeWithSubTree(value:Boolean):void
		{
			_enableDragNodeWithSubTree = value;
		}
		
		public function createVNodeFromVO(sid:String, data:Object):IVisualNode
		{
			var tmpVEdge:IVisualEdge;
			var tmpEdge:IEdge;
			var edgeData:Object;
			var node:INode;
			var vnode:IVisualNode;
			
			if (_graph == null)
				return null;
			
			node = _graph.createNode(sid, data);
			
			vnode = createVNode(node);
			setNodeVisibility(vnode, true);
			
			return vnode;
		}
		
		public function addVNodeAsChild(sid:String, data:Object, parentNode:INode):Boolean
		{
			var tmpVEdge:IVisualEdge;
			var tmpEdge:IEdge;
			var edgeData:Object;
			var node:INode;
			var vnode:IVisualNode;
			
			if (_graph == null)
				return false;
			
			node = _graph.createNode(sid, data);
			vnode = createVNode(node);
			setNodeVisibility(vnode, true);
			
			var nodeID:String = node.stringid;
			edgeData = new Object()
			edgeData.fromID = parentNode.stringid;
			edgeData.toID = node.stringid;
			
			tmpEdge = _graph.link(parentNode,node,edgeData);
			
			if(tmpEdge == null) {
				throw Error("Could not create or find Graph edge!!");
			} else {
				if(tmpEdge.vedge == null) {
					/* we have a new edge, so we create a new VEdge */
					tmpVEdge = createVEdge(tmpEdge);
				} else {
					/* existing one, so we use the existing vedge */
					tmpVEdge = tmpEdge.vedge;
				}
			}
			draw();
			return true;
		}
		
		public function addVNodeToEdge(sid:String, data:Object, edge:IEdge, removeOldEdge:Boolean = false):Boolean
		{
			var fromNode:INode = edge.fromNode;
			var toNode:INode = edge.toNode;	
			var tmpVEdge:IVisualEdge;
			var tmpEdge:IEdge;
			var edgeData:Object;
			var node:INode;
			var vnode:IVisualNode;
			
			node = _graph.createNode(sid, data);
			node.data['id'] = node.stringid;
			
			vnode = createVNode(node);
			setNodeVisibility(vnode, true);
			var nodeID:String = node.stringid;
			
			edgeData = new Object();
			edgeData.fromID = fromNode.stringid;
			edgeData.toID = node.stringid;
			
			//tmpVEdge = linkNodes(fromNode.vnode, node.vnode, edgeData);
			
			tmpEdge = _graph.link(fromNode,node,edgeData);
			
			if(tmpEdge == null) {
				throw Error("Could not create or find Graph edge!!");
			} else {
				if(tmpEdge.vedge == null) {
					/* we have a new edge, so we create a new VEdge */
					tmpVEdge = createVEdge(tmpEdge);
				} else {
					/* existing one, so we use the existing vedge */
					tmpVEdge = tmpEdge.vedge;
				}
			}
			
			edgeData = new Object();
			edgeData.fromID = node.stringid;
			edgeData.toID = toNode.stringid;
			//tmpVEdge = linkNodes(node.vnode, toNode.vnode, edgeData);
			
			tmpEdge = _graph.link(node,toNode,edgeData);
			
			if(tmpEdge == null) {
				throw Error("Could not create or find Graph edge!!");
			} else {
				if(tmpEdge.vedge == null) {
					/* we have a new edge, so we create a new VEdge */
					tmpVEdge = createVEdge(tmpEdge);
				} else {
					/* existing one, so we use the existing vedge */
					tmpVEdge = tmpEdge.vedge;
				}
			}
			
			if (removeOldEdge)
			{
				//unlinkNodes(fromNode.vnode, toNode.vnode);
				tmpEdge = _graph.getEdge(fromNode,toNode);
				if (tmpEdge)
				{
					tmpVEdge = tmpEdge.vedge;			
					removeVEdge(tmpVEdge);
					_graph.removeEdge(tmpEdge);
				}
			}
			
			draw();
			return true;
		}
		
		public function removeNodeWithOption(node:INode, rebindEdge:Boolean = true):Boolean
		{
			var vnode:IVisualNode = node.vnode;
			var successors:Array = node.successors;
			var precessors:Array = node.predecessors;
			
			var tmpEdge:IEdge;
			var tmpVEdge:IVisualEdge;
			
			if (rebindEdge && (precessors.length == 1))
			{
				var precessor:INode = precessors[0] as INode;
				var oldEdge:IEdge = _graph.getEdge(precessor, node);
				if (oldEdge != null)
				{
					for (var i:int = 0; i < successors.length; i++)
					{
						var fromNode:INode = precessor;
						var toNode:INode = successors[i] as INode;
						var edgeData:Object = ObjectUtil.copy(oldEdge.data);
						edgeData.toID = toNode.stringid;
						tmpEdge = _graph.link(fromNode,toNode,edgeData);
						if(tmpEdge == null) {
							throw Error("Could not create or find Graph edge!!");
						} else {
							if(tmpEdge.vedge == null) {
								/* we have a new edge, so we create a new VEdge */
								tmpVEdge = createVEdge(tmpEdge);
							} else {
								/* existing one, so we use the existing vedge */
								tmpVEdge = tmpEdge.vedge;
							}
						}
					}
				}
			}
			
			removeNode(vnode);
			draw();
			return true;
		}
		
		/**
		 * Removes a subtree from the main tree for which the root node is @node.
		 */ 
		public function removeSubTree(node:INode, isRootNodeRemovable:Boolean = true):Boolean
		{
			if ((isRootNodeRemovable == false) && (node.vnode == currentRootVNode))
				return false;
			
			var arrTreeRoots:Array = [node];
			var curTreeRoot:INode = arrTreeRoots.pop();
			
			while(curTreeRoot)
			{
				for each (var nextTreeRoot:INode in curTreeRoot.successors)
				arrTreeRoots.push(nextTreeRoot)
				removeNode(curTreeRoot.vnode);
				
				curTreeRoot = arrTreeRoots.pop();
			}
			
			draw();
			return true;
		}
		
		/**
		 * Removes all hierarchical children of the node referred to by parameter
		 * @node.
		 */ 
		public function removeNodeChildren(node:INode):Boolean
		{
			var arrTreeRoots:Array = new Array();
			for each (var nextTreeRoot:INode in node.successors)
			arrTreeRoots.push(nextTreeRoot);
			
			var curTreeRoot:INode = arrTreeRoots.pop();
			
			while(curTreeRoot)
			{
				for each (var nextTreeRoot2:INode in curTreeRoot.successors)
				arrTreeRoots.push(nextTreeRoot)
				removeNode(curTreeRoot.vnode);
				
				curTreeRoot = arrTreeRoots.pop();
			}
			
			draw();
			return true;
		}
		
		public function setVNodeData(vn:IVisualNode, data:Object):void
		{
			vn.data = data;
			vn.node.data = data;
			
			if (vn.view)
			{
				IDataRenderer(vn.view).data = vn;
			}
			
			this.refresh();
		}
		
		public function setVEdgeData(ve:IVisualEdge, data:Object):void
		{
			ve.data = data;
			ve.edge.data = data;
			if (ve.labelView)
			{
				IDataRenderer(ve.labelView).data = ve;
			}
			this.refresh();
		}
		
		public function setVisibleNodeWithRelated(vn:IVisualNode):void
		{
			_layouter.resetAll();
			
			for each(var tmpNode:IVisualNode in _visibleVNodes) {
				setNodeVisibility(tmpNode, false);
			}
			
			for each(var e:IEdge in _graph.edges) {
				setEdgeVisibility(e.vedge, true);
			}
			
			var enode:INode = vn.node;
			
			var arrTreeNodes:ArrayCollection = new ArrayCollection();
			var arrTreeRoots:Array = [enode];
			var curTreeRoot:INode = arrTreeRoots.pop();
			
			while(curTreeRoot)
			{
				if (arrTreeNodes.contains(curTreeRoot) == false)
				{
					arrTreeNodes.addItem(curTreeRoot);
				}
				
				if 	(curTreeRoot.vnode != currentRootVNode)
				{
					for each (var prevTreeRoot:INode in curTreeRoot.predecessors)
					{
						if (arrTreeRoots.indexOf(prevTreeRoot) < 0)
							arrTreeRoots.push(prevTreeRoot);
					}
				}
				curTreeRoot = arrTreeRoots.pop();
			}
			
			arrTreeRoots = [enode];
			curTreeRoot = arrTreeRoots.pop();
			
			while(curTreeRoot)
			{
				if (arrTreeNodes.contains(curTreeRoot) == false)
				{
					arrTreeNodes.addItem(curTreeRoot);
				}
				
				for each (var nextTreeRoot:INode in curTreeRoot.successors)
				{
					if (arrTreeRoots.indexOf(nextTreeRoot) < 0)
						arrTreeRoots.push(nextTreeRoot);
				}
				curTreeRoot = arrTreeRoots.pop();
			}
			
			
			for each (var movedNode:INode in arrTreeNodes)
			{
				setNodeVisibility(movedNode.vnode, true);
			}
			
			for each(var tmpEdge:IVisualEdge in _visibleVEdges) {
				if (tmpEdge.edge.fromNode.vnode.isVisible == false ||
					tmpEdge.edge.toNode.vnode.isVisible == false)
				{
					setEdgeVisibility(tmpEdge, false);
				}
			}
			
			this.draw();
		}
	}
}