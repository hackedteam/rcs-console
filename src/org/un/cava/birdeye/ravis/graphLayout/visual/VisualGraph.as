/* 
* The MIT License
*
* Copyright (c) 2007 The SixDegrees Project Team
* (Jason Bellone, Juan Rodriguez, Segolene de Basquiat, Daniel Lang).
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package org.un.cava.birdeye.ravis.graphLayout.visual {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.effects.Effect;
	import mx.events.EffectEvent;
	import mx.managers.CursorManager;
	import mx.utils.ObjectUtil;
	
	import org.un.cava.birdeye.ravis.distortions.IDistortion;
	import org.un.cava.birdeye.ravis.graphLayout.data.*;
	import org.un.cava.birdeye.ravis.graphLayout.layout.ILayoutAlgorithm;
	import org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers.BaseEdgeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
	
	
	/**
	 *  Dispatched when there is any change to the nodes and/or links of this graph.
	 *
	 *  @eventType org.un.cava.birdeye.ravis.utils.events.VGraphEvent
	 */
	[Event(name=VGraphEvent.VGRAPH_CHANGED, type="org.un.cava.birdeye.ravis.utils.events.VGraphEvent")]
	
	/**
	 *  Dispatched when a drag event starts
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
	 */
	[Event(name="nodeDragStart", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
	
	/**
	 *  Dispatched when a drag event ends
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
	 */
	[Event(name="nodeDragEnd", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
	
	/**
	 *  Dispatched when a node is clicked it is totally independant of drags, this means you 
	 *  do not have to use double clicks to handle expanding or resetting the root
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
	 */
	[Event(name="nodeClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
	
	/**
	 *  Dispatched when an edge has been rolled over
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent
	 */
	[Event(name="edgeRollOver", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent")]
	
	/**
	 *  Dispatched when an edge has been rolled out
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent
	 */
	[Event(name="edgeRollOut", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent")]
	
	/**
	 *  Dispatched when an edge has been clicked
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent
	 */
	[Event(name="edgeClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualEdgeEvent")]
	
	/**
	 *  Dispatched when a node is double clicked it is totally independant of drags.
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent
	 */
	[Event(name="nodeDoubleClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualNodeEvent")]
	
	/**
	 *  Dispatched when the background is done dragging.
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent
	 */
	[Event(name="backgroundDragEnd", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent")]
	
	/**
	 *  Dispatched when the background is done dragging.
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent
	 */
	[Event(name="graphScaled", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent")]
	
	/**
	 *  Dispatched when the background has been clicked but no nodes selected, and no drag occured
	 *
	 *  @eventType org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent
	 */
	[Event(name="backgroundClick", type="org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent")]
	
	/**
	 * This component can visualize and layout a graph data structure in 
	 * a Flex application. It is derived from canvas and thus behaves much
	 * like that in general.
	 * 
	 * Currently the graphs are required to be connected. And for most layouts
	 * a root node is required (as they are tree based).
	 * 
	 * A graph object needs to be specified as well as a layouter object
	 * that implements the ILayoutAlgorithm interface.
	 * 
	 * XXX provide example code here
	 * */
	public class VisualGraph extends Canvas implements IVisualGraph {
		
		private static const _LOG:String = "graphLayout.visual.VisualGraph";		
		
		[Embed('/org/un/cava/birdeye/ravis/assets/cursors/openhand.png')]
		private static const HAND_CURSOR:Class;
		
		/**
		 * Distortion to be applied on mouse over 
		 **/
		public var distortion:IDistortion;
		
		private var _nodeMouseDownLocation:Point;
		private var _mouseDownLocation:Point
		/**
		 * Used to determine if a node has been moved or if it was just a click
		 */ 
		private var _nodeMovedInDrag:Boolean = false;
		/**
		 * This flag for draw() specifies that the linklength
		 * shall be reset to 100 when calling draw();
		 * */
		public static const DF_RESET_LL:uint = 1;
		
		/**
		 * This property holds the Graph object with the graph
		 * data, that is supposed to be visualised. This is also
		 * the only data structure that keeps track of nodes and
		 * edges.
		 * */
		protected var _graph:IGraph = null;
		
		/**
		 * This property holds the layouter object. The layouter does the 
		 * calculation of the layout and the placement of the nodes.
		 * It may be exchanged on the fly.
		 * */
		protected var _layouter:ILayoutAlgorithm;
		
		
		/**
		 * for cleanup we also need a reference source for
		 * vnodes and vedges
		 * */
		protected var _vnodes:Dictionary;
		protected var _vedges:Dictionary;
		
		/**
		 * Every visual node is associated with an UIComponent that 
		 * will be the actual visual representation of the node in the
		 * Flashplayer. This UIComponent (which is typically an ItemRenderer)
		 * is called a "view". Node's views are now mainly created on
		 * demand and destroyed if the node is currently not visible
		 * to save resources. This map keeps track of which VNode belongs
		 * to which view. This is required as in certain events, we get
		 * only access to the UIComponent and we need to get hold of
		 * the corresponding node.
		 * */
		protected var _nodeViewToVNodeMap:Dictionary;
		
		/**
		 * A similar map needs to exist for edges
		 * */
		protected var _edgeLabelViewToVEdgeMap:Dictionary;
		
		protected var _edgeViewToVEdgeMap:Dictionary;
		
		/**
		 * The standard origin is the upper left corner, but if
		 * the graph is scrolled, this origin may change, so we keep
		 * track of that here.
		 * */
		protected var _origin:Point;
		
		/**
		 * The current zooming scale of the vgraph.
		 * This is used to facilitate the use of scaleX/scaleY
		 * and take it into account for drag and drop.
		 * Supported by getter/setting methods.
		 * (Contributed by Ivan Bulanov)
		 * */
		protected var _scale:Number = 1;
		
		/* drag and drop support */
		
		/**
		 * This is the current UIComponent that is dragged by the mouse.
		 * */
		protected var _dragComponent:UIComponent;
		
		/**
		 * These two maps keep the drag cursor offset positions
		 * for each dragged component. This allows to (theoretically)
		 * drag more than one component at once and to correctly reposition the
		 * component during the drag and at the drop.
		 * */
		protected var _drag_x_offsetMap:Dictionary;
		protected var _drag_y_offsetMap:Dictionary;
		
		/**
		 * There is generally support to restrict dragging and dropping
		 * to a certain area. These bounds are kept for each dragged
		 * component in this map.
		 * */
		protected var _drag_boundsMap:Dictionary;
		
		/**
		 * The drag cursors starting position is required
		 * if we do a "background drag", i.e. scroll the whole
		 * VisualGraph around. All this does is basically moving all
		 * components with the mouse, thus creating the effect of a 
		 * background drag.
		 * */
		protected var _dragCursorStartX:Number;
		protected var _dragCursorStartY:Number;
		
		/**
		 * To distinguish an active mouse move drag that drags
		 * a component from one that should drag the background, 
		 * we need this property.
		 * */
		protected var _backgroundDragInProgress:Boolean = false;
		
		/**
		 * To enable/disable scrolling while background is being
		 * dragged 
		 * */
		protected var _scrollBackgroundInDrag:Boolean = true;
		
		/**
		 * To enable/disable movement while node is being
		 * dragged 
		 * */
		protected var _moveNodeInDrag:Boolean = true;
		
		/**
		 * To enable/disable movement while edge is being
		 * dragged 
		 * */
		protected var _moveEdgeInDrag:Boolean = true;
		
		/**
		 * To enable/disable movement while background is being
		 * dragged 
		 * */
		protected var _moveGraphInDrag:Boolean = true;
		
		/* Rendering */
		
		/**
		 * We allow the specification of an EdgeRenderer (i.e. an IFactory)
		 * that allows us to specify the view's for each edge in MXML
		 * */
		protected var _edgeRendererFactory:IFactory = null;
		
		/**
		 * We allow the specification of an ItemRenderer (i.e. an IFactory)
		 * that allows us to specify the view's for each node in MXML
		 * */
		protected var _itemRendererFactory:IFactory = null;
		
		/**
		 * Also allow the specification of an IFactory for edge
		 * labels.
		 * */
		protected var _edgeLabelRendererFactory:IFactory = null;
		
		/**
		 * Flag to force a redraw of all edge even if the layout
		 * has not changed
		 * */
		protected var _forceUpdateEdges:Boolean = false;
		
		/**
		 * Flag to force a redraw of all nodes even if the layout
		 * has not changed
		 * */
		protected var _forceUpdateNodes:Boolean = false;
		/**
		 * Specify whether edge labels should be displayed or not
		 * */
		protected var _displayEdgeLabels:Boolean = true;
		
		/**
		 * We keep the default parameters
		 * to draw edges (line width, color, alpha channel)
		 * in this object. The params to be expected are all
		 * params which can be accepted by the lineStyle()
		 * method of the Graphics class.
		 * We keep a separate default set for regular edges and
		 * for distinguished edges.
		 * */
		protected var _defaultEdgeStyle:Object = {
			thickness:1,
			alpha:1.0,
			color:0xcccccc,
			pixelHinting:false,
			scaleMode:"normal",
			caps:null,
			joints:null,
			miterLimit:3
		}
		
		/* The visibility of nodes can be controlled in a few ways.
		* The principal limit is to restrict nodes to only be visible if they
		* are within a certain distance (in degrees of separation) from the
		* current root node. In addition previous root nodes can be
		* made visible */
		
		/**
		 * This property controls if any visibility limit is currently
		 * active at all. Strongly recommended for large graphs.
		 * The application will be brought to its knees if thousands of nodes
		 * should be displayed. 
		 * */
		protected var _visibilityLimitActive:Boolean = true;
		
		/**
		 * Controls the maximum distance from the root that a node
		 * can have to still be visible.
		 * */
		protected var _maxVisibleDistance:uint = int.MAX_VALUE;
		
		/**
		 * This object hash contains all node ids 
		 * of nodes which are currently within the visible
		 * distance limit. This hash is typically initialised from
		 * from the Graph object. These nodes are NOT all
		 * visible nodes (since the history nodes are also
		 * visible).
		 * */
		protected var _nodeIDsWithinDistanceLimit:Dictionary;
		
		/**
		 * This object contains the previuos hash of nodes
		 * within the distance. To keep this helps to avoid
		 * running through all nodes to render the olds
		 * invisible and the new ones visible.
		 * */
		protected var _prevNodeIDsWithinDistanceLimit:Dictionary;
		
		/**
		 * This is the number of nodes within the distance
		 * limit.
		 * */
		protected var _noNodesWithinDistance:uint;
		
		/**
		 * This Dictionary holds all visible nodes,
		 * i.e. those within the limit and the history
		 * nodes (if the history is enabled), or even all
		 * nodes, if the visibility limitation is disabled.
		 * This directory is indexed by VNode and the values
		 * are the same VNode.
		 * */
		protected var _visibleVNodes:Dictionary;
		protected var _visibleVNodesList:Array;
		
		/**
		 * The number of currently visible VNodes.
		 * */
		protected var _noVisibleVNodes:int;
		
		/**
		 * This Dictionary keeps track of all currently
		 * visible edges. An edge is visible iff both
		 * attached nodes are visible. This hash is indexed
		 * with VEdges and the values are the same VEdge objects.
		 * */
		protected var _visibleVEdges:Dictionary;
		protected var _visibleVEdgesList:Array;
		
		/* root nodes, distinguished nodes and history */
		
		/**
		 * This is the current focused / root node. It will be
		 * used as the root for any tree computations and
		 * currently all layouters depend on this.
		 * Typically the root node is selected by double-click.
		 * */
		protected var _currentRootVNode:IVisualNode = null;
		
		/**
		 * This hash keeps track of all the past root VNodes
		 * thus being the history. If showHistory is enabled,
		 * these nodes are also visible even if they are outside
		 * the visible distance.
		 * */
		protected var _currentVNodeHistory:Array = null;
		
		/**
		 * This flag controls whether to show the history nodes or not.
		 * */
		protected var _showCurrentNodeHistory:Boolean = false;
		
		
		protected var edgeLayer:Canvas;
		protected var edgeLabelLayer:Canvas;
		protected var nodeLayer:Canvas;
		/* public attributes */
		
		/**
		 * enable bitmap caching in renderer components
		 * */
		public var cacheRendererObjects:Boolean = false;
		
		/**
		 * Default visibility setting for new nodes. If
		 * set all new nodes are created visible and with
		 * a view component. Beware of that if you have
		 * many nodes.
		 * */
		public var newNodesDefaultVisible:Boolean = false;
		
		/**
		 * This property controls whether the mouse cursor
		 * should be locked in the dragged node's center or not.
		 * */
		public var dragLockCenter:Boolean = false;
		
		/**
		 * If set, this effect will be applied if a view
		 * is created (e.g. while a node becomes visible
		 * or if a new node is created).
		 * */
		public var addItemEffect:Effect;
		
		/**
		 * If set, this effect will be applied if a view
		 * is removed (e.g. a node becomes invisible or
		 * is removed).
		 * */
		public var removeItemEffect:Effect;
		
		private var _clippingMask:UIComponent;
		/**
		 * The constructor just initialises most data structures, but not all
		 * required. Currently it does neither set a Graph object, nor a 
		 * Layouter object. Reasonable defaults may be added as an option.
		 * */
		public function VisualGraph() {
			
			/* call super class constructor */
			super();
			
			/* initialize maps for drag and drop */
			_drag_x_offsetMap = new Dictionary;
			_drag_y_offsetMap = new Dictionary;
			_drag_boundsMap = new Dictionary;
			
			/* initialise view/ItemRenderer and visibility mapping */
			_vnodes = new Dictionary;
			_vedges = new Dictionary;
			
			_nodeViewToVNodeMap = new Dictionary;            
			_edgeLabelViewToVEdgeMap = new Dictionary;
			_edgeViewToVEdgeMap = new Dictionary;
			
			_visibleVNodes = new Dictionary;
			_visibleVNodesList = new Array;
			_visibleVEdges = new Dictionary;
			_visibleVEdgesList = new Array;
			
			_noVisibleVNodes = 0;
			_visibilityLimitActive = true;
			
			/* init the history array */
			_currentVNodeHistory = new Array;
			
			/* set an edge renderer, for now we use the Default,
			* but at a later stage this could be set externally */
			_edgeRendererFactory = new ClassFactory(BaseEdgeRenderer);
			
			
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			this.clipContent = true;
			
			/* add event handlers for background drag/drop i.e. scrolling */
			this.addEventListener(MouseEvent.MOUSE_DOWN,backgroundDragBegin,false, int.MIN_VALUE);
			this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			this.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler); 
			
			_origin = new Point(0,0);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_clippingMask = new UIComponent();
			addChild(_clippingMask);
			
			this.mask = _clippingMask;
			
			edgeLayer = new Canvas();
			edgeLayer.clipContent = false;
			edgeLayer.horizontalScrollPolicy = ScrollPolicy.OFF;
			edgeLayer.verticalScrollPolicy = ScrollPolicy.OFF;
			edgeLayer.percentWidth = 100;
			edgeLayer.percentHeight = 100;
			addChild(edgeLayer);
			
			edgeLabelLayer = new Canvas();
			edgeLabelLayer.clipContent = false;
			edgeLabelLayer.horizontalScrollPolicy = ScrollPolicy.OFF;
			edgeLabelLayer.verticalScrollPolicy = ScrollPolicy.OFF;
			edgeLabelLayer.percentWidth = 100;
			edgeLabelLayer.percentHeight = 100;
			addChild(edgeLabelLayer);
			
			nodeLayer = new Canvas();
			nodeLayer.clipContent = false;
			nodeLayer.horizontalScrollPolicy = ScrollPolicy.OFF;
			nodeLayer.verticalScrollPolicy = ScrollPolicy.OFF;
			nodeLayer.percentWidth = 100;
			nodeLayer.percentHeight = 100;
			addChild(nodeLayer);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			if(distortion && layouter.animInProgress == false)
			{
				var dp:Point = new Point(e.stageX,e.stageY);
				dp = dp.subtract(localToGlobal(new Point(x,y)));
				distortion.distort(dp);
			}
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			CursorManager.setCursor(HAND_CURSOR,3);
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			if(distortion)
			{
				draw();
			}
			CursorManager.removeAllCursors();
		}
		
		public function releaseNodes():void
		{
			for each(var node:IVisualNode in visibleVNodes)
			{
				node.moveable = true;
			}
		}
		
		/**
		 * This property allows access and setting of the underlying
		 * graph object. If set, it will automatically initialise the VGraph
		 * from the Graph object, i.e. create VNodes and VEdges for each
		 * Graph node and Graph edge.
		 * If there was already a Graph present, the VGraph is purged, but no other
		 * cleanup is done, which means that there could still be
		 * some references floating around thus leaking memory.
		 * For now, avoid setting it more than once in the same
		 * VGraph.
		 * @param g The Graph object to be assigned.
		 * */
		public function set graph(g:IGraph):void {
			
			if(_graph != null) {
				LogUtil.warn(_LOG, "_graph in VisualGraph was not null when new graph was assigned."+
					" Some cleanup done, but this may leak memory");
				/* this cleanes the VGraph so we are pristine */
				clearHistory();
				purgeVGraph();
				_graph.purgeGraph();
				_nodeIDsWithinDistanceLimit = null;
				_prevNodeIDsWithinDistanceLimit = null;
				_noNodesWithinDistance = 0;
				
				/* this may have been removed already before */
				if(_layouter) {
					_layouter.resetAll();
				}
			}
			
			/* assign defaults */
			_graph = g;
			
			/* IMPORTANT: a layouter also has a graph reference
			* separate, this must be updated in order for
			* this to work properly
			*/
			if(_layouter) {
				_layouter.graph = g;
			}
			
			/* better safe than sorry even if it is an empty one */
			initFromGraph();
			
			/* invalidate old root node */
			_currentRootVNode = null;
			
			/* now use the first node as the new default root node */
			if(_graph.nodes.length > 0) {
				_currentRootVNode = (_graph.nodes[0] as INode).vnode;
			}
			
			LogUtil.warn(_LOG, "Setting a new graph object invalidates the root node,"+
				" a new default root node was set, but it may not be what you want");
		}
		
		/**
		 * @private
		 * */
		public function get graph():IGraph {
			return _graph;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set itemRenderer(ifac:IFactory):void {
			if(ifac != _itemRendererFactory) {
				_itemRendererFactory = ifac;
				
				/* if that has changed, we would need to recreate all
				* currently visible nodes */
				setAllInVisible();
				updateVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get itemRenderer():IFactory {
			return _itemRendererFactory;
		}
		
		
		/**
		 * @inheritDoc
		 * */
		public function set edgeRendererFactory(er:IFactory):void {
			if(er != _edgeRendererFactory) {
				
				setAllEdgesInVisible();
				
				_edgeRendererFactory = er;
				
				updateEdgeVisibility();
			}
		}
		/**
		 * @private
		 * */
		public function get edgeRendererFactory():IFactory {
			return _edgeRendererFactory;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set edgeLabelRenderer(elr:IFactory):void {
			/* if the factory was changed, then we have to remove all
			* instances of vedgeViews to have them updated */
			if(elr != _edgeLabelRendererFactory) {
				/* set all edges invisible, this should delete all instances
				* of view components */
				setAllEdgesInVisible();
				
				/* set the new renderer */
				_edgeLabelRendererFactory = elr;	
				
				/* update i.e. recreate the instances */
				updateEdgeVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get edgeLabelRenderer():IFactory {
			return _edgeLabelRendererFactory;
		}
		
		
		/**
		 * @inheritDoc
		 * */
		public function set displayEdgeLabels(del:Boolean):void {
			var e:IEdge;
			
			if(_displayEdgeLabels == del) {
				// no change
			} else {
				_displayEdgeLabels = del;
				setAllEdgesInVisible();
				updateEdgeVisibility();
			}
		}
		
		/**
		 * @private
		 * */
		public function get displayEdgeLabels():Boolean {
			return _displayEdgeLabels;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get layouter():ILayoutAlgorithm {
			return _layouter;
		}
		
		/**
		 * @private
		 * */
		public function set layouter(l:ILayoutAlgorithm):void {
			if(_layouter != null) {
				_layouter.resetAll(); // to stop any pending animations
			}
			_layouter = l;
			/* need to signal control components possibly */
			this.dispatchEvent(new VGraphEvent(VGraphEvent.LAYOUTER_CHANGED));
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get origin():Point {
			return _origin;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get center():Point {
			return new Point(this.width / 2.0, this.height / 2.0);
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get visibleVNodes():Array {
			return _visibleVNodesList.sortOn("id");
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get noVisibleVNodes():uint {
			return _noVisibleVNodes;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get visibleVEdges():Array {
			return _visibleVEdgesList.sortOn("id");
		}
		
		/**
		 * @inheritDoc
		 * */
		[Bindable]
		public function get visibilityLimitActive():Boolean {
			return _visibilityLimitActive;
		}
		/**
		 * @private
		 * */
		public function set visibilityLimitActive(ac:Boolean):void {
			/* check for a change */
			if(_visibilityLimitActive != ac) {	
				/* execute the change */
				_visibilityLimitActive = ac;
				/* activate? */
				if(ac) {
					if(_currentRootVNode == null) {
						LogUtil.warn(_LOG, "No root selected, not creating limited graph, not doing anything.");
						return;
					}
					//LogUtil.debug(_LOG, "getting limited node ids with limit:"+_maxVisibleDistance);
					
					/* 1. Get the spanning tree, rooted in our current root node from
					*    the graph object.
					* 2. Get the hash from this tree, that contains only the nodes
					*    within the set distance.
					* 3. Use this to set our properties for the nodes within the distance
					*    limit.
					*/
					setDistanceLimitedNodeIds(_graph.getTree(_currentRootVNode.node).
						getLimitedNodes(_maxVisibleDistance));
					
					/* now update all other visibility data structure
					* this also forces a redraw() (and layout) of the 
					* visualisation */
					updateVisibility();
				}
					/* when we deactivate this limit, we render all nodes
					* visible! */
				else {
					setAllVisible();
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 * */
		[Bindable]
		public function get maxVisibleDistance():int {
			return _maxVisibleDistance;
		}
		
		/**
		 * @private
		 * */
		public function set maxVisibleDistance(md:int):void {
			/* check if there was a change */
			if(_maxVisibleDistance != md) {
				/* if yes, apply the change */
				_maxVisibleDistance = md;
				//LogUtil.debug(_LOG, "visible distance changed to: "+md);
				
				/* if our current limits are active we create a new
				* set of nodes within the distance and update the
				* visibility */
				if(_visibilityLimitActive) {
					if(_currentRootVNode == null) {
						LogUtil.warn(_LOG, "No root selected, not creating limited graph");
						return;
					} else {
						setDistanceLimitedNodeIds(_graph.getTree(_currentRootVNode.node).
							getLimitedNodes(_maxVisibleDistance));
						updateVisibility();
					}
				}
			}
		}
		
		
		/**
		 * This was added for testing. It may be removed
		 * again.
		 * */
		public function get currentRootSID():String {
			return _currentRootVNode.node.stringid;
		}
		
		/**
		 * @inheritDoc
		 * */
		/* [Bindable]  */
		public function get currentRootVNode():IVisualNode {
			return _currentRootVNode;
		}
		/**
		 * @private
		 * */
		public function set currentRootVNode(vn:IVisualNode):void {
			/* check for a change */
			if(_currentRootVNode != vn) {
				
				/* apply the change */
				_currentRootVNode = vn;
				
				/* now update the history with the new node */
				_currentVNodeHistory.unshift(_currentRootVNode);
			}	
			//LogUtil.debug(_LOG, "node:"+_currentRootVNode.id+" added to history");
			
			//we always need to the following because:
			//the _currentRootVNode can be set when you 
			//create a node. Then if you set a custom renderer for nodes
			//every node is made to be invisible, and because this stuff
			//following hasn't been called it stays that way and is not deployed 
			
			/* if we are currently limiting node visibility,
			* update the set of visible nodes since we 
			* have changed the root, the spanning tree has changed
			* and thus the set of visible nodes */
			if(_visibilityLimitActive) {
				setDistanceLimitedNodeIds(_graph.getTree(_currentRootVNode.node).
					getLimitedNodes(_maxVisibleDistance));
				updateVisibility();
			} else {					
				//if the visibility limit is not active, get all the nodes
				setDistanceLimitedNodeIds(getNodesAsDictionary());
				updateVisibility();
			}
			
		}
		
		private function getNodesAsDictionary():Dictionary {
			var retVal:Dictionary = new Dictionary();
			for each(var node:INode in _graph.nodes)
			{
				retVal[node] = node;
			}
			
			return retVal;
		}		
		
		public function set scrollBackgroundInDrag(f:Boolean):void {
			_scrollBackgroundInDrag = f;
		}
		
		public function set moveNodeInDrag(f:Boolean):void {
			_moveNodeInDrag = f;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get showHistory():Boolean {
			return _showCurrentNodeHistory;
		}
		
		/**
		 * @private
		 * */
		public function set showHistory(h:Boolean):void {
			/* check for a change */
			if(_showCurrentNodeHistory != h) {
				_showCurrentNodeHistory = h;
				
				/* makes no sense without root set */
				if(_currentRootVNode != null) {
					/* becomes only active if we have the limit active */
					if(_visibilityLimitActive) {
						/* now update the visibility. This also applies the
						* history information to the node visibility */
						updateVisibility();
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get scale():Number {
			return _scale;
		}
		
		/**
		 * @private
		 * */
		public function set scale(s:Number):void {
			
			var w:Number = width - width/s;
			var h:Number = height - height/s;
			
			//the scroll takes care of the refresh            
			scroll(-w/2 - _origin.x ,-h/2 - _origin.y, false);
			
			nodeLayer.scaleX = s;
			nodeLayer.scaleY = s;
			
			edgeLayer.scaleX = s;
			edgeLayer.scaleY = s;
			
			edgeLabelLayer.scaleX = s;
			edgeLabelLayer.scaleY = s;
			
			_scale = s;
			
			dispatchEvent(new VisualGraphEvent(VisualGraphEvent.GRAPH_SCALED));
		}
		
		
		/**
		 * This initialises a VGraph from a Graph object.
		 * I.e. it crates a VNode for every Node found in
		 * the Graph and a VEdge for every Edge in the Graph.
		 * Careful, this currently does not check if the VGraph
		 * was already initialised and it does not purge anything.
		 * Things could break if used on an already initialized VGraph.
		 * */
		public function initFromGraph():void {
			
			var node:INode;
			var edge:IEdge;
			
			/* create the vnode from the node */
			for each(node in _graph.nodes) {
				this.createVNode(node);
				//LogUtil.debug(_LOG, "created VNode for node:"+node.id);
			}
			
			/* we also create the edge objects, since they
			* may carry additional label information or something
			* like that, but they do not have a view */
			for each(edge in _graph.edges) {
				this.createVEdge(edge);
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function clearHistory():void {
			_currentVNodeHistory = new Array();
		}
		
		/** 
		 * @inheritDoc
		 * */
		public function createNode(sid:String = "", o:Object = null):IVisualNode {
			
			var gnode:INode;
			var vnode:IVisualNode;
			
			/* first add a new node to the underlying graph */
			gnode = _graph.createNode(sid,o);
			
			/* Then create the VNode with associated with the graph node */
			vnode = createVNode(gnode);
			
			/* since it is a requirement from most layouters
			* to always have a current root node
			* we assign the current root node to the newly
			* created node so we have one. Note that this does
			* not affect the root node history. */
			_currentRootVNode = vnode;
			
			return vnode;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function removeNode(vn:IVisualNode):void {
			
			var n:INode;
			var e:IEdge;
			var ve:IVisualEdge;
			var i:int;
			
			n = vn.node;
			
			/* if the current root node is the
			* node to be removed it must be
			* changed.
			*
			* First, we set it to null, then we remove the
			* node, then at the end we reset it
			* to the first node still in the
			* nodes array */
			if(vn == _currentRootVNode) {
				/* temporary set to null */
				_currentRootVNode = null;
			}
			
			/* remove all incoming edges */
			while(n.inEdges.length > 0) {
				e = n.inEdges[0] as IEdge;
				ve = e.vedge;
				removeVEdge(ve);
				_graph.removeEdge(e);
			}
			
			/* remove all outgoing edges */
			while(n.outEdges.length > 0) {
				e = n.outEdges[0] as IEdge;
				ve = e.vedge;
				removeVEdge(ve);
				_graph.removeEdge(e);
			}
			
			/* remove the vnode */
			removeVNode(vn);
			
			/* remove the node from the graph */
			_graph.removeNode(n);
			
			/* now set a new root node, implies that there is
			* still a node */
			if(_currentRootVNode == null && _graph.noNodes > 0) {
				_currentRootVNode = (_graph.nodes[0] as INode).vnode;
			}
			
			/* since we removed also edges, we need a refresh */
			refresh();
		}
		
		
		/** 
		 * @inheritDoc
		 * */
		public function linkNodes(v1:IVisualNode, v2:IVisualNode):IVisualEdge {
			
			var n1:INode;
			var n2:INode;
			var e:IEdge;
			var ve:IVisualEdge;
			
			/* make sure both nodes do exist */
			if(v1 == null || v2 == null) {
				throw Error("linkNodes: one of the nodes does not exist");
				//return null;
			}
			
			n1 = v1.node;
			n2 = v2.node;
			
			/* now first link the graph nodes and create the corresponding edge */
			e = _graph.link(n1,n2,null);
			
			/* if the edge existed already, e is just the
			* already existing edge. But if it existed
			* previously it might already have a VEdge.
			* So we only create a new VEdge, if it did not exist
			* already. */		
			if(e == null) {
				throw Error("Could not create or find Graph edge!!");
			} else {
				if(e.vedge == null) {
					/* we have a new edge, so we create a new VEdge */
					ve = createVEdge(e);
				} else {
					/* existing one, so we use the existing vedge */
					LogUtil.info(_LOG, "Edge already existed, returning existing vedge");
					ve = e.vedge;
				}
			}
			
			//LogUtil.debug(_LOG, "linkNodes, created edge "+(e as Object).toString()+" from nodes: "+n1.id+", "+n2.id);
			
			/* this changes the layout, so we have to do a full redraw */
			// if we link nodes we may not necesarily want to draw();
			/* just refresh the edges */
			refresh();
			return ve;
		}
		
		/** 
		 * @inheritDoc
		 * */
		public function unlinkNodes(v1:IVisualNode, v2:IVisualNode):void {
			
			var n1:INode;
			var n2:INode;
			var e:IEdge;
			var ve:IVisualEdge;
			
			/* make sure both nodes exist */
			if(v1 == null || v2 == null) {
				throw Error("unlink nodes: one of the nodes does not exist");
				return;
			}
			
			n1 = v1.node;
			n2 = v2.node;
			
			/* find the graph edge */
			e = _graph.getEdge(n1,n2);
			
			/* if we do not get an edge, it may simply not exist */
			if(e == null) {
				LogUtil.warn(_LOG, "No edge found between: "+n1.id+" and "+n2.id);
				return;
			}
			
			/* now get and remove the VEdge first */
			ve = e.vedge;			
			removeVEdge(ve);
			
			/* now remove the edge itself, basically
			* unlinking the nodes */
			_graph.removeEdge(e);
			
			refresh();
		}
		
		
		/**
		 * @inheritDoc
		 * */
		public function scroll(deltaX:Number, deltaY:Number, reset:Boolean):void {
			
			//set the x and y of each node with the diff
			// do not commit the change because
			// we want it to change the same time as the arrows do
			for each(var node:INode in _graph.nodes)
			{
				node.vnode.x += deltaX;
				node.vnode.y += deltaY;
			}
			
			//if we are resetting the origin do that
			if(reset) {
				_origin = new Point(0,0);
			}
			
			//update the origin with the new delta
			_origin.offset(deltaX,deltaY);
			
			//redraw everything on the next updateDisplayList
			refresh();
		}
		
		/**
		 * @inheritDoc
		 * */
		public function redrawNodes():void
		{
			if(_graph == null) {
				LogUtil.debug(_LOG, "_graph object in VisualGraph is null");
				return;
			}
			
			for each(var node:INode in _graph.nodes) {
				if(node.vnode !=null && node.vnode.view != null) {
					node.vnode.commit();
					node.vnode.view.invalidateDisplayList();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function refresh():void {
			/* this forces the next call of updateDisplayList()
			* to redraw all edges and all nodes*/
			_forceUpdateEdges = true;
			_forceUpdateNodes = true;
			if(_graph == null) {
				return;
			}
			//we want this because we have our own 
			//specific display list things in updateDisplayList
			invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 * */
		public function draw(flags:uint = 0):void {	
			
			var completeFunction:Function = function():void
			{
				/* after the layout was done, the layout has
				* probably changed again, the layouter will have
				* itself set to that, but has maybe not
				* invalidated the display list, so we make sure it
				* happens here (may not always be necessary) */
				invalidateDisplayList();
				
				/* dispatch this change event, so some UI items
				* in the application can poll for updated values
				* for labels or something.
				* XXX To do: specify a subtype for more specific changes
				*/
				
				dispatchEvent(new VGraphEvent(VGraphEvent.VGRAPH_CHANGED));
			}
			
			/* first refresh does layoutChanges to true and
			* invalidate display list */
			refresh();
			
			if(flags == VisualGraph.DF_RESET_LL) {
				if(_layouter != null && _layouter.linkLength == 0) {
					_layouter.linkLength = 100;
				}
			}
			
			/* we need to do some sanity checks, e.g. if the canvas window
			* size was reduced to 0 or linklength 0 or similar things,
			* the layouter might crash */
			if(_layouter == null ||
				_currentRootVNode == null ||
				_graph.noNodes == 0 ||
				width == 0 ||
				height == 0 ||
				_layouter.linkLength <= 0)
			{
				completeFunction();
				return;	
			}
			
			_layouter.layoutPass();
			completeFunction();
		}
		
		/**
		 * Refresh the VGraph fully. I.e. recreate and
		 * reassign all data objects, etc.
		 * This is a heavy operation */
		public function fullVGraphRefresh(xmlData:XML = null, directional:Boolean = false):void {
			
			var graph:IGraph;	
			var oldroot:IVisualNode;
			var oldsid:String;
			var newroot:INode;
			var theXMLData:XML = xmlData;
			var layouter:ILayoutAlgorithm;
			
			/* if we do not have been passed an XML object
			* we try to get one from the old graph */
			if(theXMLData == null && _graph != null) {
				theXMLData = _graph.xmlData;
			}
			
			/* still null? then we have to bail out */
			if(theXMLData == null) {
				LogUtil.warn(_LOG, "No XML object passed or found in old graph");
				return;
			}
			
			/* reset layouter and remember it */			
			if(_layouter != null) {
				_layouter.resetAll();
				layouter = _layouter;
				_layouter = null;
				
			}
			
			/* init a graph object with the XML data */
			graph = new Graph("myXMLbasedGraphID",directional,theXMLData);
			
			/* remember the old root and id */
			oldroot = _currentRootVNode;
			oldsid = oldroot.node.stringid;
			
			/* reapply the previous layouter 
			* IMPORTANT: this has to be done before the
			* graph object is set, because otherwise the graph
			* attribute in the layouter will not be updated!
			*/
			_layouter = layouter;		
			
			
			/* set the graph in the VGraph object, this automatically
			* initializes the VGraph items */
			this.graph = graph;
			
			
			
			/* setting a new graph invalidated our old root, we need to reset it */
			/* we try to find a node, that has the same string-id as the old root node */
			newroot = _graph.nodeByStringId(oldsid);
			if(newroot != null) {
				this.currentRootVNode = newroot.vnode;
			} else {
				throw Error("Cannot set a default root, bailing out");
			}
			
			/* send an event for controls to reapply their currently
			* set values to layouters */
			this.dispatchEvent(new VGraphEvent(VGraphEvent.LAYOUTER_CHANGED));
			
			/* trigger a redraw
			* XXXX think if we should do that here */
			this.draw(VisualGraph.DF_RESET_LL);
		}		
		
		/**
		 * this function takes the node with the specified
		 * string id and selects it as a root
		 * node, automatically centering the layout around it
		 * */
		public function centerNodeByStringId(nodeID:String):IVisualNode {
			
			var newroot:INode;
			
			if(_graph == null) {
				LogUtil.warn(_LOG, "VGraph has no Graph object, probably not correctly initialised, yet");
				return null;
			}
			
			newroot = _graph.nodeByStringId(nodeID);
			
			/* if we have a node, set its vnode as the new root */
			if(newroot) {
				/* is it really a new node */
				if(newroot.vnode != _currentRootVNode) {
					/* set it */
					this.currentRootVNode = newroot.vnode;
					return newroot.vnode;
				} else {
					return _currentRootVNode;
				}
			}
			LogUtil.warn(_LOG, "Node with id:"+nodeID+" not found!");
			return null;
		}
		
		
		
		/**
		 * This calls the base updateDisplayList() method of the
		 * Canvas and in addition redraws all edges if the layouter
		 * indicates that the layout has changed.
		 * 
		 * @inheritDoc
		 * */
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			/* call the original function */
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			_clippingMask.graphics.clear();
			_clippingMask.graphics.beginFill(0x000000,1);
			_clippingMask.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			_clippingMask.graphics.endFill();
			
			/* now add part to redraw edges */
			if(_layouter) {
				
				if(_layouter.layoutChanged) {
					
					redrawEdges();
					redrawNodes();
					
					_forceUpdateNodes = false;
					_forceUpdateEdges = false;
					_layouter.layoutChanged = false;
				}
				
				if(_forceUpdateNodes) {
					redrawNodes();
					_forceUpdateNodes = false;
				}
				
				if(_forceUpdateEdges) {
					redrawEdges();
					_forceUpdateEdges = false;
				}
			}
			
		}
		
		/* private methods */
		
		/**
		 * Creates VNode and requires a Graph node to associate
		 * it with. Originally also created the view, but we no
		 * longer do that directly but only on demand.
		 * @param n The graph node to be associated with.
		 * @return The created VisualNode.
		 * */
		protected function createVNode(n:INode):IVisualNode {
			
			var vnode:IVisualNode;
			
			/* as an id we use the id of the graph node for simplicity
			* for now, it is not really used separately anywhere
			* we also use the graph data object as our data object.
			* the view is set to null and remains so. */
			vnode = new VisualNode(this, n, n.id, null, n.data);
			
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
		
		/**
		 * Removes a VNode, this also removes the node's view
		 * if it existed, but does not touch the Graph node.
		 * @param vn The VisualNode to be removed.
		 * */
		protected function removeVNode(vn:IVisualNode):void {
			
			var view:UIComponent;
			
			/* get access to the node's view, but get the 
			* raw view to avoid unnecessary creation of a view
			*/
			view = vn.rawview;
			
			/* delete reference to the view from the node */
			vn.view = null;
			
			/* remove the reference to this node from the graph node */
			vn.node.vnode = null;
			
			/* now remove the view component if it existed */
			if(view != null) {
				removeNodeView(view);
			}
			
			/* remove from the visible vnode map if present */
			if(_visibleVNodes[vn] != undefined) {
				
				deleteVisibleVNode(vn);
			}
			
			/* remove from tracking hash */
			delete _vnodes[vn];
			
			/* this should clean up all references to this VNode
			* thus freeing it for garbage collection */
		}
		
		private function deleteVisibleVNode(vn:IVisualNode):void
		{
			vn.isVisible = false;
			delete _visibleVNodes[vn];
			var newVisibleVNodes:Array = new Array();
			for each(var node:IVisualNode in _visibleVNodesList)
			{
				if(node != vn)
					newVisibleVNodes.push(node);
			}
			
			_visibleVNodesList = newVisibleVNodes;
			
			/* remove the view if there is one */
			if(vn.view != null) {
				removeNodeView(vn.view, false);
			}
			
			--_noVisibleVNodes;
		}
		
		/**
		 * Creates a VEdge from a graph Edge.
		 * @param e The Graph Edge.
		 * @return The created VEdge.
		 * */
		protected function createVEdge(e:IEdge):IVisualEdge {
			
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
			
			for each(attname in attrs) {
				if(e.data != null && (e.data as XML).attribute(attname).length() > 0) {
					lStyle[attname] = e.data.@[attname];
				}
			}
			
			vedge = new VisualEdge(this, e, e.id, e.data, null, lStyle);
			
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
		
		protected function edgeClicked(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			_backgroundDragInProgress = false;
			var t:UIComponent = e.target as UIComponent;
			if(t == null)
				return;
			
			var edge:IVisualEdge = _edgeViewToVEdgeMap[t];
			
			if(edge == null)
				return;
			
			dispatchEvent(new VisualEdgeEvent(VisualEdgeEvent.CLICK,edge,e.ctrlKey));
		}
		
		protected function edgeRollOver(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
			var t:UIComponent = e.target as UIComponent;
			if(t == null)
				return;
			
			var edge:IVisualEdge = _edgeViewToVEdgeMap[t];
			
			if(edge == null)
				return;
			
			dispatchEvent(new VisualEdgeEvent(VisualEdgeEvent.ROLL_OVER,edge,e.ctrlKey));
		}
		
		protected function edgeRollOut(e:MouseEvent):void
		{
			CursorManager.setCursor(HAND_CURSOR,3);
			var t:UIComponent = e.target as UIComponent;
			if(t == null)
				return;
			
			var edge:IVisualEdge = _edgeViewToVEdgeMap[t];
			
			if(edge == null)
				return;
			
			dispatchEvent(new VisualEdgeEvent(VisualEdgeEvent.ROLL_OUT,edge,e.ctrlKey));
		}
		
		/**
		 * Remove a VisualEdge, but leaves the Graph Edge alone.
		 * @param ve The VisualEdge to be removed.
		 * */
		protected function removeVEdge(ve:IVisualEdge):void {
			
			/* just in case */
			if(ve == null) {
				return;
			}
			
			/* first turn it invisible, which should
			* remove the labelview */
			setEdgeVisibility(ve, false);
			
			delete _edgeViewToVEdgeMap[ve.edgeView];
			
			/* remove the reference from the real edge */
			ve.edge.vedge = null;
			
			/* remove from tracking hash */
			delete _vedges[ve];
		}
		
		/**
		 * Purges the VGraph by dropping all VNodes and VEdges.
		 * This is a bit tricky, since we do not really
		 * keep track of them in the VGraph, they are only referenced
		 * by the Graph nodes and egdes.
		 * */
		protected function purgeVGraph():void {
			
			var ves:Array = new Array;
			var vns:Array = new Array;
			var ve:IVisualEdge;
			var vn:IVisualNode;
			
			/* this appears rather inefficient, however
			* ObjectUtil.copy does not work on dictionaries
			* currently I have no other solution
			*/
			for each(ve in _vedges) {
				ves.unshift(ve);
			}
			for each(vn in _vnodes) {
				vns.unshift(vn);
			}
			
			LogUtil.debug(_LOG, "purgeVGraph called");
			
			if(_graph != null) {
				for each(ve in ves) {
					removeVEdge(ve);
				}
				for each(vn in vns) {
					removeVNode(vn);
				}
			} else {
				LogUtil.warn(_LOG, "we had no graph to purge from, so nothing was done");
			}				
		}
		
		/**
		 * Redraw all edges, this is called from the updateDisplayList()
		 * method.
		 * @inheritDoc
		 * */
		public function redrawEdges():void {
			
			var vn1:IVisualNode;
			var vn2:IVisualNode;
			var vedge:IVisualEdge;
			
			/* make sure we have a graph */
			if(_graph == null) {
				LogUtil.debug(_LOG, "_graph object in VisualGraph is null");
				return;
			}
			
			for each(vedge in _edgeViewToVEdgeMap)
			{
				IEdgeRenderer(vedge.edgeView).render();
			}
			
		}
		
		/**
		 * Lookup a node by its UIComponent. This is more a convenience
		 * method with some sanity check. Primarily used by event handlers.
		 * @param c The component to find the VisualNode for.
		 * @return The found Node.
		 * @throws An Error if the component was not registered in the map.
		 * */
		protected function lookupNode(c:UIComponent):IVisualNode {
			var vn:IVisualNode = _nodeViewToVNodeMap[c];
			if(vn == null) {
				throw Error("Component not in viewToVNodeMap");
			}
			return vn;
		}
		
		
		
		/**
		 * Create a "view" object (UIComponent) for the given node and
		 * return it. These methods are only exported to be used by
		 * the VisualNode. Alas, AS does not provide the "friend" directive.
		 * Not sure how to get around this problem right now.
		 * @param vn The node to replace/add a view object.
		 * @return The created view object.
		 * */
		protected function createVNodeComponent(vn:IVisualNode):UIComponent {
			
			var mycomponent:UIComponent = null;
			
			if(_itemRendererFactory != null) {
				mycomponent = _itemRendererFactory.newInstance();
			} else {
				mycomponent = new UIComponent();
			}			
			
			/* assigns the item (VisualNode) to the IDataRenderer part of the view
			* this is important to access the data object of the VNode
			* which contains information for rendering. */		
			if(mycomponent is IDataRenderer) {
				(mycomponent as IDataRenderer).data = vn;
			}
			
			/* set initial x/y values */
			mycomponent.x = this.width / 2.0;
			mycomponent.y = this.height / 2.0;
			
			/* add event handlers for dragging and double click */			
			mycomponent.doubleClickEnabled = true;
			mycomponent.addEventListener(MouseEvent.DOUBLE_CLICK, nodeDoubleClick,false,0,true);
			mycomponent.addEventListener(MouseEvent.MOUSE_DOWN, nodeMouseDown,false,0,true);
			mycomponent.addEventListener(MouseEvent.ROLL_OVER, nodeRollOver,false,0,true);
			mycomponent.addEventListener(MouseEvent.ROLL_OUT, nodeRollOut,false,0,true);
			mycomponent.addEventListener(MouseEvent.CLICK, nodeMouseClick,false,0,true);
			
			/* enable bitmap cachine if required */
			mycomponent.cacheAsBitmap = cacheRendererObjects;
			
			/* add the component to its parent component */
			nodeLayer.addChild(mycomponent);
			
			/* do we have an effect set for addition of
			* items? If yes, create and start it. */
			if(addItemEffect != null) {
				addItemEffect.createInstance(mycomponent).startEffect();
			}
			
			/* register it the view in the vnode and the mapping */
			vn.view = mycomponent;
			_nodeViewToVNodeMap[mycomponent] = vn;
			
			/* we need to invalidate the display list since
			* we created new children */
			refresh();
			
			return mycomponent;
		}
		
		private function nodeRollOver(e:MouseEvent):void {
			CursorManager.removeAllCursors()
		}
		
		private function nodeRollOut(e:MouseEvent):void {
			CursorManager.setCursor(HAND_CURSOR,3);
		}
		
		/**
		 * Remove a "view" object (UIComponent) for the given node and specify whether
		 * this should honor any specified add/remove effects.
		 * These methods are only exported to be used by
		 * the VisualNode. Alas, AS does not provide the "friend" directive.
		 * Not sure how to get around this problem right now.
		 * @param component The UIComponent to be removed.
		 * @param honorEffect To specify whether the effect should be applied or not.
		 * */
		protected function removeNodeView(component:UIComponent, honorEffect:Boolean = true):void {
			
			var vn:IVisualNode;
			
			/* if there is an effect, start the effect and register a
			* handler that actually calls this method again, but
			* with honorEffect set to false */
			if(honorEffect && (removeItemEffect != null)) {
				removeItemEffect.addEventListener(EffectEvent.EFFECT_END,
					removeEffectDone);
				removeItemEffect.createInstance(component).startEffect();
			} else {
				/* remove the component from it's parent (which should be the canvas) */
				if(component.parent != null) {
					component.parent.removeChild(component);
				}
				
				/* remove event mouse listeners */
				component.removeEventListener(MouseEvent.DOUBLE_CLICK,nodeDoubleClick);
				component.removeEventListener(MouseEvent.MOUSE_DOWN,nodeMouseDown);
				component.removeEventListener(MouseEvent.CLICK,nodeMouseClick);
				component.removeEventListener(MouseEvent.MOUSE_UP, dragEnd);
				
				/* get the associated VNode and remove the view from it
				* and also remove the map entry */
				vn = _nodeViewToVNodeMap[component];
				vn.view = null;
				delete _nodeViewToVNodeMap[component];
			}
		}
		
		/**
		 * Create a "view" object (UIComponent) for the given edge and
		 * return it.
		 * @param ve The edge to replace/add a view object.
		 * @return The created view object.
		 * */
		protected function createVEdgeLabelView(ve:IVisualEdge):UIComponent {
			
			var mycomponent:UIComponent = null;
			
			if(_edgeLabelRendererFactory != null) {
				mycomponent = _edgeLabelRendererFactory.newInstance();
			} else {
				/* this is only for the basic default */
				mycomponent = new Label; // this is our default label.
				mycomponent.setStyle("textAlign","center");
				
				if(ve.data != null) {
					(mycomponent as Label).text = ve.data.@association;
				}
			}			
			
			/* assigns the edge to the IDataRenderer part of the view
			* this is important to access the data object of the VEdge
			* which contains information for rendering. */		
			if(mycomponent is IDataRenderer) {
				(mycomponent as IDataRenderer).data = ve;
			}
			
			/* enable bitmap cachine if required */
			mycomponent.cacheAsBitmap = cacheRendererObjects;
			
			/* add the component to its parent component
			* this can create problems, we have to see where we
			* check for all children
			* Add after the edges layer, but below all other elements such as nodes */
			edgeLabelLayer.addChild(mycomponent);
			
			ve.labelView = mycomponent;
			_edgeLabelViewToVEdgeMap[mycomponent] = ve;
			
			/* we need to invalidate the display list since
			* we created new children */
			refresh();
			
			return mycomponent;
		}
		
		/**
		 * Remove a "view" object (UIComponent) for the given edge.
		 * @param component The UIComponent to be removed.
		 * */
		protected function removeVEdgeLabelView(component:UIComponent):void {
			
			var ve:IVisualEdge;
			
			
			/* remove the component from it's parent (which should be the canvas) */
			if(component.parent != null) {
				component.parent.removeChild(component);
			}
			
			/* get the associated VEdge and remove the view from it
			* and also remove the map entry */
			ve = _edgeLabelViewToVEdgeMap[component];
			ve.labelView = null;
			delete _edgeLabelViewToVEdgeMap[component];
		}
		
		/**
		 * Create a "view" object (UIComponent) for the given edge and
		 * return it.
		 * @param ve The edge to replace/add a view object.
		 * @return The created view object.
		 * */
		protected function createVEdgeView(ve:IVisualEdge):IEdgeRenderer {
			
			var mycomponent:IEdgeRenderer = null;
			
			if(_edgeRendererFactory != null) {
				mycomponent = edgeRendererFactory.newInstance();
			} else {
				/* this is only for the basic default */
				mycomponent = new BaseEdgeRenderer(); // this is our default label.
			}
			
			mycomponent.percentWidth = 100;
			mycomponent.percentHeight = 100;
			
			UIComponent(mycomponent).useHandCursor = true;
            UIComponent(mycomponent).buttonMode = true;
			
			mycomponent.addEventListener(MouseEvent.CLICK,edgeClicked,false,0,true);
			mycomponent.addEventListener(MouseEvent.ROLL_OVER,edgeRollOver,false,0,true);
			mycomponent.addEventListener(MouseEvent.ROLL_OUT,edgeRollOut,false,0,true);
			
			/* assigns the edge to the IDataRenderer part of the view
			* this is important to access the data object of the VEdge
			* which contains information for rendering. */		
			if(mycomponent is IDataRenderer) {
				(mycomponent as IDataRenderer).data = ve;
			}
			
			/* enable bitmap cachine if required */
			mycomponent.cacheAsBitmap = cacheRendererObjects;
			
			/* add the component to its parent component
			* this can create problems, we have to see where we
			* check for all children
			* Add after the edges layer, but below all other elements such as nodes */
			edgeLayer.addChild(DisplayObject(mycomponent));
			
			ve.edgeView = mycomponent;
			_edgeViewToVEdgeMap[mycomponent] = ve;
			
			/* we need to invalidate the display list since
			* we created new children */
			refresh();
			
			return mycomponent;
		}
		
		/**
		 * Remove a "view" object (UIComponent) for the given edge.
		 * @param component The UIComponent to be removed.
		 * */
		protected function removeVEdgeView(component:IEdgeRenderer):void {
			
			var ve:IVisualEdge;
			
			/* remove the component from it's parent (which should be the canvas) */
			if(component.parent != null) {
				component.parent.removeChild(DisplayObject(component));
			}
			
			/* get the associated VEdge and remove the view from it
			* and also remove the map entry */
			ve = _edgeViewToVEdgeMap[component];
			ve.edgeView = null;
			delete _edgeViewToVEdgeMap[component];
		}
		
		
		/**
		 * Event handler for a removal node procedure. Calls
		 * removeComponent with a flag to avoid doing the effect again.
		 * */
		protected function removeEffectDone(event:EffectEvent):void {
			var mycomponent:UIComponent = event.effectInstance.target as UIComponent;
			/* call remove component again, but specify to ignore the effect */
			removeNodeView(mycomponent, false);
		}
		
		/**
		 * Event handler to work on double-click events.
		 * Any double click also counts as a drop event to
		 * the layouter. But primarily the double click
		 * sets a new root node.
		 * @param e The corresponding event.
		 * */
		protected function nodeDoubleClick(e:MouseEvent):void {
			var comp:UIComponent;
			var vnode:IVisualNode;
			
			/* get the view object that was klicked on (actually
			* the one that has the event handler registered, which
			* is the VNode's view */
			comp = (e.currentTarget as UIComponent);
			
			/* get the associated VNode */
			vnode = lookupNode(comp);
			
			var evt:VisualNodeEvent = new VisualNodeEvent(VisualNodeEvent.DOUBLE_CLICK, vnode.node,e.ctrlKey);
			dispatchEvent(evt);
			//LogUtil.debug(_LOG, "double click!");
			
			/* Now we change the root node, we go through
			* our public setter method to get all associated
			* updates done. */
			this.currentRootVNode = vnode;
			
			//LogUtil.debug(_LOG, "currentVNode:"+this.currentRootVNode.id);
			
			/* here we still want to implicitly redraw */
			draw();
		}
		
		/**
		 * This is the event handler for a mouse down event on a node
		 * event. Currently does only one thing:
		 * - Starts a drag operation of this node.
		 * @param e The associated event.
		 * */
		protected function nodeMouseDown(e:MouseEvent):void {
			_nodeMovedInDrag = false;
			dragBegin(e);
		}
		
		/**
		 * This is the event handler for a mouse click on a node
		 * The purpose of this event is to broadcast that a node has
		 * been clicked on by a user, it has no other internal function
		 * 
		 * @param e The associated event
		 */ 
		protected function nodeMouseClick(e:MouseEvent):void {
			if(e.currentTarget is UIComponent) {
				
				var ecomponent:UIComponent = (e.currentTarget as UIComponent);
				
				if(_nodeMovedInDrag)
				{
					return;	
				}
				
				/* get the associated VNode of the view */
				var evnode:IVisualNode = _nodeViewToVNodeMap[ecomponent];
				
				
				
				/* stop propagation to prevent a concurrent backgroundDrag */
				e.stopImmediatePropagation();
				dispatchEvent(new VisualNodeEvent(VisualNodeEvent.CLICK,evnode.node,e.ctrlKey));
			}
		}
		
		/**
		 * Start a drag operation. This sets the drag node and
		 * registeres a 'MouseMove' event handler with the
		 * VNode, so it can follow the mouse movement.
		 * @param event The MouseEvent that was triggered by clicking on the node.
		 * @see handleDrag()
		 * */
		protected function dragBegin(event:MouseEvent):void {
			
			var ecomponent:UIComponent;
			var evnode:IVisualNode;
			var pt:Point;
			
			//LogUtil.debug(_LOG, "DragBegin was called...");
			
			/* if there is an animation in progress, we ignore
			* the drag attempt */
			if(_layouter && _layouter.animInProgress) {
				LogUtil.info(_LOG, "Animation in progress, drag attempt ignored");
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
					if(!dragLockCenter) {
						// lockCenter is false, use the mouse coordinates at the point
						pt = new Point(ecomponent.mouseX, ecomponent.mouseY);
					} else {
						// lockCenter is true, ignore the mouse coordinates
						pt = new Point(ecomponent.width/2,ecomponent.height/2);
					}
					
					/* Save the offset values in the map 
					* so we can compute x and y correctly in case
					* we use lockCenter */
					
					_drag_x_offsetMap[ecomponent] = pt.x
					_drag_y_offsetMap[ecomponent] = pt.y;
					
					
					/* now we would need to set the bounds
					* rectangle in _drag_boundsMap, but this is
					* currently not implemented *
					_drag_boundsMap[ecomponent] = rectangle;
					*/
					
					/* Register an eventListener with the component's stage that
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
					_nodeMouseDownLocation = globalMousePosition();
					dispatchEvent(new VisualNodeEvent(VisualNodeEvent.DRAG_START,evnode.node,event.ctrlKey));
					_layouter.dragEvent(event, evnode);
				} else {
					throw Error("Event Component was not in the viewToVNode Map");
				}
			} else {
				throw Error("MouseEvent target was not UIComponent");
			}
		}
		
		/**
		 * Called everytime the mouse moves after the dragBegin() method has
		 * been called.  Updates the position of the Component based on
		 * the location of the mouse cursor.
		 * @param event The MouseMove event that has been triggered.
		 */
		protected function handleDrag(event:MouseEvent):void {
			var myvnode:IVisualNode = _nodeViewToVNodeMap[_dragComponent];
			
			/* Sometimes we get spurious events */
			if(_dragComponent == null) {
				LogUtil.info(_LOG, "received handleDrag event but _dragComponent is null, ignoring");
				return;
			}
			
			if (_moveNodeInDrag) {
				
				myvnode.viewX = mouseX/scale - _drag_x_offsetMap[_dragComponent];
				myvnode.viewY = mouseY/scale - _drag_y_offsetMap[_dragComponent];
				myvnode.refresh();
				_nodeMovedInDrag = true;
			}
			
			_layouter.dragContinue(event, myvnode);
			
			//refresh();
		}
		
		/**
		 * This handles a background drag (i.e. scroll). The
		 * event listener is usually registered with the canvas,
		 * i.e. this object.
		 * @param event The triggered event.
		 * */
		protected function backgroundDragBegin(event:MouseEvent):void {
			
			var mycomponent:UIComponent = event.target as UIComponent;
			
			if(_edgeViewToVEdgeMap[mycomponent] != null ||
				_edgeLabelViewToVEdgeMap[mycomponent] != null ||
				_nodeViewToVNodeMap[mycomponent] != null)
				return;
			
			const mpoint:Point = globalMousePosition();
			
			/* if there is an animation in progress, we ignore
			* the drag attempt */
			if(_layouter && _layouter.animInProgress) {
				LogUtil.info(_LOG, "Animation in progress, drag attempt ignored");
				dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BACKGROUND_CLICK));
				return;
			}
			
			/* set the progress flag and save the starting coordinates */
			_backgroundDragInProgress = true;
			_dragCursorStartX = mpoint.x;
			_dragCursorStartY = mpoint.y;
			_mouseDownLocation = mpoint;
			
			/* register the backgroundDrag listener to react to
			* the mouse movements */
			this.addEventListener(MouseEvent.MOUSE_MOVE, backgroundDragContinue);
			this.addEventListener(MouseEvent.MOUSE_UP,dragEnd);
			this.addEventListener(MouseEvent.ROLL_OUT,dragEnd);
			
			/* and inform the layouter about the dragEvent */
			if(_layouter) {
				_layouter.bgDragEvent(event);
			}
			
		}
		
		/**
		 * This does the actual background drag by having
		 * all UIComponents move to follow the mouse
		 * @param event The triggered mouse move event.
		 * */ 
		protected function backgroundDragContinue(event:MouseEvent):void {
			
			const mpoint:Point = globalMousePosition();
			
			var deltaX:Number;
			var deltaY:Number;
			
			if (_scrollBackgroundInDrag) {
				/* compute the movement offset of this move by
				* subtracting the current mouse position from
				* the last mouse position */
				deltaX = mpoint.x - _dragCursorStartX;
				deltaY = mpoint.y - _dragCursorStartY;
				
				deltaX /= scaleX;
				deltaY /= scaleY;
				
				
				/* scroll all objects by this offset */
				scroll(deltaX, deltaY,false);
			}
			/* and inform the layouter about the dragEvent */
			if(_layouter) {
				_layouter.bgDragContinue(event);
			}
			
			/* reset the drag start point for the next step */
			_dragCursorStartX = mpoint.x;
			_dragCursorStartY = mpoint.y;
			
			/* make sure edges are redrawn */
			_forceUpdateEdges = true;
			//invalidateDisplayList();
		}
		
		
		/**
		 * This method handles the drop event (usually MOUSE_UP).
		 * It stops any dragging in progress (including background drag)
		 * and unregisters the current dragged node.
		 * @param event The triggered event.
		 * */
		protected function dragEnd(event:MouseEvent):void {
			
			const mpoint:Point = globalMousePosition();
			
			var mycomp:UIComponent;
			var myback:DisplayObject;
			var myvnode:IVisualNode;
			
			this.removeEventListener(MouseEvent.ROLL_OUT,dragEnd);
			this.removeEventListener(MouseEvent.MOUSE_UP,dragEnd);
			
			if(_backgroundDragInProgress) {
				
				/* if it was a background drag we stop it here */
				_backgroundDragInProgress = false;
				
				/* get the background drag object, which is usually
				* the canvasm so we just set it to this */
				myback = (this as DisplayObject);
				
				/* unregister event handler */				
				myback.removeEventListener(MouseEvent.MOUSE_MOVE,backgroundDragContinue);
				
				/* and inform the layouter about the dropEvent */
				if(_layouter) {
					_layouter.bgDropEvent(event);
				}
				
				if(event.type == MouseEvent.ROLL_OUT) {
					CursorManager.removeAllCursors();
				}
				
				//dispatch the drag event only if we have moved somewhere
				if(_mouseDownLocation && 
					Math.abs(mpoint.x - _mouseDownLocation.x) > 2 ||
					Math.abs(mpoint.y - _mouseDownLocation.y) > 2) {
					dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BACKGROUND_DRAG_END));
				}else{
					dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BACKGROUND_CLICK));                    
				}
			} else {
				
				/* if it was no background drag, the component
				* is the saved dragComponent */
				mycomp = _dragComponent;
				
				/* But sometimes the dragComponent was already null, 
				* in this case we have to ignore the thing. */
				if(mycomp == null) {
					LogUtil.info(_LOG, "dragEnd: received dragEnd but _dragComponent was null, ignoring");
					return;
				}
				
				/* remove the event listeners */
				// HACK: I have to check the stage because there are eventual components not added to the display list
				if (mycomp.stage != null)
				{
					mycomp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDrag);
				}
				
				/* get the associated VNode to notify the layouter */
				myvnode = _nodeViewToVNodeMap[mycomp];
				if(_layouter) {
					_layouter.dropEvent(event, myvnode);
				}
				
				if(_nodeMouseDownLocation && 
					Math.abs(mpoint.x - _nodeMouseDownLocation.x) > 2 ||
					Math.abs(mpoint.y - _nodeMouseDownLocation.y) > 2) {
					dispatchEvent(new VisualNodeEvent(VisualNodeEvent.DRAG_END,myvnode.node,event.ctrlKey));
				}
				/* reset the dragComponent */
				_dragComponent = null;
			}	
		}
		
		/**
		 * return the current mouse position, used by 
		 * certain drag&drop issues
		 * */
		protected function globalMousePosition():Point {
			return localToGlobal(new Point(mouseX, mouseY));
		}
		
		/** 
		 * 1. saves the old nodeID hash object.
		 * 2. sets the new _nodeIDsWithinDistanceLimit Object from the object
		 *    provided (typically provided from the GTree of a Graph).
		 * 3. updates the amount of nodes in that object, by linearly
		 *    counting them. This may be optimized...
		 * @param vnids Object containing a hash with all node id's currently within the distance limit.
		 * */
		protected function setDistanceLimitedNodeIds(vnids:Dictionary):void {
			var val:Boolean;
			var amount:uint;
			var vn:IVisualNode;
			var n:INode;
			
			/* reset the amount */
			amount = 0;
			
			/* save the old hash */
			_prevNodeIDsWithinDistanceLimit = _nodeIDsWithinDistanceLimit;
			
			/* set the new hash object */
			_nodeIDsWithinDistanceLimit = new Dictionary;
			
			/* walk through the hash and build the distanceLimit hash */
			for each(n in vnids) {
				vn = n.vnode;
				_nodeIDsWithinDistanceLimit[vn] = vn;
				
				/* increase the amount */
				++amount;
			}
			
			/* count all entries in this hash */
			for each(val in vnids) {
				if(val) {
					++amount;
				}
			}
			/* set the new amount */
			_noNodesWithinDistance = amount;
			
			//LogUtil.debug(_LOG, "current visible nodeids:"+_noNodesWithinDistance);
		}
		
		/**
		 * This needs to walk through all nodes in the graph, as some nodes
		 * have become invisible and other have become visible. There may be
		 * a better way to do this, when adjusting the visibility but it is
		 * not that clear.
		 * 
		 * walk through the graph and the limitedGraph and
		 * turn off visibility for those that are not listed in
		 * both
		 * beware that the limited graph has no VItems, so 
		 * we don't really need it, we would rather need
		 * an array of node ids....
		 * */
		protected function updateVisibility():void {
			var n:INode;
			var e:IEdge;
			var edges:Array;
			var treeparents:Dictionary;
			var vn:IVisualNode;
			var vno:IVisualNode;
			
			var newVisibleNodes:Dictionary;
			var potentialInvisibleNodes:Dictionary;
			
			/* since a layouter that uses timer based iterations
			* might find itself on a changing node set, we need
			* to stop/reset anything before altering the node
			* visibility */
			if(_layouter != null) {
				_layouter.resetAll();
			}
			
			
			//LogUtil.debug(_LOG, "update node visibility");
			
			/* create a copy of the currently visible 
			* node set, as the set for nodes to potentially
			* turned invisible */
			potentialInvisibleNodes = new Dictionary;
			for each(vn in _visibleVNodes) {
				potentialInvisibleNodes[vn] = vn;
			}
			
			/* now populate the set of nodes which should be
			* turned visible, first by using the nodes  within
			* distance limit */
			newVisibleNodes = new Dictionary;
			
			for each(vn in _nodeIDsWithinDistanceLimit) {
				newVisibleNodes[vn] = vn;
			}
			
			/* now add the history nodes to the set of new visible
			* nodes if the history is enabled */
			/* Step 3: render all (new?) history nodes and nodes on the path visible (if applicable) */
			if(_showCurrentNodeHistory) {
				
				/* this is mapping in the tree that provides a parent
				* for each single node in the tree 
				* we need this to find the way to the root */
				treeparents = _graph.getTree(_currentRootVNode.node).parents;
				
				for each(vn in _currentVNodeHistory) {
					n = vn.node;		
					/* we cannot use vn here, because it is n that is changed
					* in this while loop. Basically we are walking the tree
					* backward from the current vnode's node n to the root
					* for every vn in the history */
					while(n.vnode != _currentRootVNode) {
						
						/* set it visible */
						newVisibleNodes[n.vnode] = n.vnode;
						//setNodeVisibility(n.vnode, true);
						
						/* move to the parent node */
						n = treeparents[n];
						if(n == null) {
							throw Error("parent node was null but node was not root node");
						}
					}
				}
			}
			
			/* now from each set remove the common nodes, these
			* are the nodes that should remain visible, so they
			* must not be turned invisible and should also not
			* be turned visible again. */
			for each(vn in potentialInvisibleNodes) {
				if(newVisibleNodes[vn] != null) {
					/* this is a common node, remove it from
					* both dictionaries 
					*/
					delete potentialInvisibleNodes[vn];
					delete newVisibleNodes[vn];
				} 
			}
			
			/* now finally turn all toInvisibleNodes invisible
			* likewise any edge adjacent to an invisible node
			* will become invisible */
			for each(vn in potentialInvisibleNodes) {
				setNodeVisibility(vn, false);
			}
			
			/* and all new visible nodes to visible */
			for each(vn in newVisibleNodes) {
				setNodeVisibility(vn, true);
			}
			
			/* and now walk again to update the edges */
			for each(vn in potentialInvisibleNodes) {
				updateConnectedEdgesVisibility(vn);
			}
			
			/* and all new visible nodes to visible */
			for each(vn in newVisibleNodes) {
				updateConnectedEdgesVisibility(vn);
			}
			
			/* send an event */
			this.dispatchEvent(new VGraphEvent(VGraphEvent.VISIBILITY_CHANGED));
		}
		
		/**
		 * This methods walks through all nodes and updates
		 * the edge visibility (only the edge visibility)
		 * taking into account three factors:
		 * visibility of adjacent nodes and
		 * if we want edge labels or not at all
		 * */
		protected function updateEdgeVisibility():void {
			
			var vn:IVisualNode;
			
			for each(vn in _visibleVNodes) {
				updateConnectedEdgesVisibility(vn);
			}
		}
		
		/**
		 * Reset visibility of all nodes, all nodes are back to visible.
		 * This can be a very very heavy operation if you have many nodes. 
		 * */
		protected function setAllVisible():void {
			var n:INode;
			var e:IEdge;
			
			/* not sure if this is really, really needed, but
			* since similar code was added, I optimise it a bit.
			*/
			if(_graph == null) {
				LogUtil.warn(_LOG, "setAllVisible() called, but graph is null");
				return;
			}
			
			/* since a layouter that uses timer based iterations
			* might find itself on a changing node set, we need
			* to stop/reset anything before altering the node
			* visibility */
			if(_layouter != null) {
				_layouter.resetAll();
			}
			
			/* recreate those, this is cheaper probably */
			_visibleVNodes = new Dictionary;
			_visibleVNodesList = new Array;
			_noVisibleVNodes = 0;
			
			for each(n in _graph.nodes) {
				setNodeVisibility(n.vnode, true);
			}
			
			/* same for edges */
			_visibleVEdges = new Dictionary;
			_visibleVNodesList = new Array;
			for each(e in _graph.edges) {
				setEdgeVisibility(e.vedge, true);
			}
		}
		
		/**
		 * Reset visibility of all nodes, all nodes are INVISIBLE.
		 * */
		protected function setAllInVisible():void {
			
			var vn:IVisualNode;			
			var ve:IVisualEdge;
			
			/* not sure if this is really, really needed, but
			* since similar code was added, I optimise it a bit.
			*/
			if(_graph == null) {
				LogUtil.warn(_LOG, "setAllInVisible() called, but graph is null");
				return;
			}
			
			/* since a layouter that uses timer based iterations
			* might find itself on a changing node set, we need
			* to stop/reset anything before altering the node
			* visibility */
			if(_layouter != null) {
				_layouter.resetAll();
			}
			
			for each(vn in _visibleVNodes) {
				setNodeVisibility(vn, false);
			}
			
			for each(ve in _visibleVEdges) {
				setEdgeVisibility(ve, false);
			}
		}
		
		/**
		 * Reset visibility of all edges to INVISIBLE.
		 * */
		protected function setAllEdgesInVisible():void {
			var ve:IVisualEdge;
			for each(ve in _visibleVEdges) {
				setEdgeVisibility(ve, false);
			}
		}	
		
		/**
		 * This sets a VNode visible or invisible, updating all related
		 * data.
		 * @param vn The VisualNode to be turned invisible or not.
		 * @param visible The indicator if visible or not.
		 * */
		protected function setNodeVisibility(vn:IVisualNode, visible:Boolean):void {
			
			var comp:UIComponent;
			
			/* was there actually a change, if not issue a warning */
			if(vn.isVisible == visible) {
				LogUtil.warn(_LOG, "Tried to set node:"+vn.id+" visibility to:"+visible.toString()+" but it was already.");
				return;
			}
			
			if(visible == true) {
				
				/* set the node to visible, this might create a view for it */
				vn.isVisible = true;
				/* add it to the hash of currently visible nodes */
				_visibleVNodes[vn] = vn;
				
				if(_visibleVNodesList.indexOf(vn) == -1)
					_visibleVNodesList.push(vn);
				/* increase the counter */
				++_noVisibleVNodes;
				
				/* create the node's view */
				comp = createVNodeComponent(vn);
				
				/* set it to visible, should be default anyway */
				comp.visible = true;
				
			} else { // i.e. set to invisible 
				
				deleteVisibleVNode(vn);
			}
		}
		
		
		/**
		 * This sets a VEdge visible or invisible, updating all related
		 * data.
		 * @param ve The VisualEdge to be turned invisible or not.
		 * @param visible The indicator if visible or not.
		 * */	
		protected function setEdgeVisibility(ve:IVisualEdge, visible:Boolean):void {
			
			var labelComp:UIComponent;
			var edgeComp:IEdgeRenderer;
			
			/* was there actually a change, if not issue a warning */
			if(ve.isVisible == visible) {
				//LogUtil.warn(_LOG, "Tried to set vedge:"+ve.id+" visibility to:"+visible.toString()+" but it was already.");
				return;
			}
			
			if(visible == true) {
				
				/* add it to the hash of currently visible nodes */
				_visibleVEdges[ve] = ve;
				
				if(_visibleVEdgesList.indexOf(ve) == -1)
					_visibleVEdgesList.push(ve);
				
				/* check if there is no view and we need one */
				if(_displayEdgeLabels && ve.labelView == null) {
					labelComp = createVEdgeLabelView(ve);
				}
				
				if(ve.edgeView == null)
					edgeComp = createVEdgeView(ve);
				
				/* set the edges view to visible */
				ve.isVisible = true;
				
			} else { // i.e. set to invisible 
				/* render node invisible, thus potentially destroying its view */
				ve.isVisible = false;
				
				deleteVisibleVEdge(ve);
			}
		}
		
		private function deleteVisibleVEdge(ve:IVisualEdge):void
		{
			ve.isVisible = false;
			
			var newEdgeList:Array = new Array();
			for each(var e:IVisualEdge in _visibleVEdgesList)
			{
				if(e != ve)
					newEdgeList.push(e);
			}
			_visibleVEdgesList = newEdgeList;
			
			/* remove the view if there is one */
			if(ve.labelView != null) {
				removeVEdgeLabelView(ve.labelView);
			}
			
			if(ve.edgeView != null) {
				removeVEdgeView(ve.edgeView);
			}
			/* remove it from the hash */
			delete _visibleVEdges[ve];
		}
		
		/**
		 * This methods walks through all edges connected
		 * to a node and sets them either visible or invisible
		 * depending on the visibility of the given node and
		 * the node on the other end. An edge is only visible
		 * if both nodes are visible.
		 * @param vn The VisualNode of which connected edges should be updated.
		 * */
		protected function updateConnectedEdgesVisibility(vn:IVisualNode):void {
			
			var edges:Array;
			var ovn:IVisualNode;
			var e:IEdge;
			
			/* now here we have to test each edges othernode
			* if it is also visible */
			edges = vn.node.inEdges;
			
			/* concat might lead to duplication in the case of
			* undirected graphs... :( not sure how to efficiently
			* only add items which are not there, yet?
			*/
			edges = edges.concat(vn.node.outEdges);
			
			for each(e in edges) {
				
				/* get the other node at the end of the edge */
				ovn = e.othernode(vn.node).vnode;
				
				/* if this node either is still visible or in the
				* list to become visible, then the edge is also
				* visible */
				if(vn.isVisible && ovn.isVisible) {
					setEdgeVisibility(e.vedge,true);
				} else {
					setEdgeVisibility(e.vedge,false);
				}
			}
		}
		
		public function calcNodesBoundingBox():Rectangle {
			var children:Array;
			var result:Rectangle;
			
			children = nodeLayer.getChildren();
			
			result = new Rectangle(Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY);
			
			if(children.length == 0) {
				LogUtil.warn(_LOG, "Canvas has no children, not even the drawing surface!");
			}
			
			for(var i:int = 0;i < children.length; ++i) {
				var view:UIComponent = (children[i] as UIComponent);
				
				if(view.visible) {
					result.left = Math.min(result.left, view.x);
					result.right = Math.max(result.right, view.x + view.width);
					result.top = Math.min(result.top, view.y)
					result.bottom = Math.max(result.bottom, view.y+view.height);
				}
			}
			
			return result;
		}
	}
}
