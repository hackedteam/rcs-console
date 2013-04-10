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
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IGraph;
	import org.un.cava.birdeye.ravis.graphLayout.layout.ILayoutAlgorithm;
	
	/**
	 * Interface to the VisualGraph Flex Component,
	 * which also has to implement the IUIComponent
	 * and the IInvalidating interface.
	 * */
	public interface IVisualGraph extends IUIComponent, IInvalidating {
		
		/**
		 * Access to the underlying Graph datastructure object.
		 * */
		function get graph():IGraph;
		
		/**
		 * @private
		 * */
		function set graph(g:IGraph):void
		
		
		/**
		 * Allow the provision of an ItemRenderer (which is
		 * more precisely an IFactory). This is important to allow
		 * the Drawing of the items in a customised way.
		 * Note that any ItemRenderer will have to be a UIComponent.
		 * */
		function set itemRenderer(ifac:IFactory):void;
		
		/**
		 * @private
		 * */
		function get itemRenderer():IFactory;
		
		
		/**
		 * Allow the provision of an EdgeRenderer to
		 * allow drawing of edges in a customised way.
		 * The edgeRenderer has to implement the IEdgeRenderer interface.
		 * */
		function set edgeRendererFactory(er:IFactory):void;
		
		/**
		 * @private
		 * */
		function get edgeRendererFactory():IFactory;
		
		/**
		 * Allow to provide an EdgeLabelRenderer in order to
		 * display edge labels. The created instances must be
		 * UIComponents.
		 * */
		function set edgeLabelRenderer(elr:IFactory):void;
		
		/**
		 * @private
		 * */
		function get edgeLabelRenderer():IFactory;
		
		/**
		 * Specify whether to display edge labels or not.
		 * If no edge label renderer is present a default
		 * will be used.
		 * */
		function set displayEdgeLabels(del:Boolean):void;
		
		/**
		 * @private
		 * */
		function get displayEdgeLabels():Boolean;
		
		/**
		 * Access to the layouter to be used for the
		 * layout of the graph.
		 * */
		function get layouter():ILayoutAlgorithm;

		/**
		 * @private
		 * */		
		function set layouter(l:ILayoutAlgorithm):void;

		/**
		 * Provide access to the current origin of the of the Visual Graph
		 * which is required for proper drawing.
		 * */
		function get origin():Point;
		
		/**
		 * Provide access to the center point of the VGraph's
		 * drawing surface, used by layouters to properly center
		 * their layout.
		 * */
		function get center():Point;
		
		/**
		 * Provide access to a list of currently visible VNodes.
		 * This is very important for layouters, if we have many many
		 * nodes, but only a few of them are visible at a time. Layouters
		 * typically will only layout the currently visible nodes.
		 * */
		function get visibleVNodes():Array;
		
		/**
		 * Returns the number of currently visible nodes.
		 * */
		function get noVisibleVNodes():uint;
		
		/**
		 * Provide access to a list of currently visible edges,
		 * i.e. edges whose both nodes are visible and thus need
		 * to be drawn. Likewise this can save a lot of CPU if
		 * the layouter only needs to consider the currently visible
		 * edges.
		 * */
		function get visibleVEdges():Array;

		/**
		 * This property controls whether to show the history of
		 * root nodes (or focused nodes) or not. If enabled, these
		 * previous root nodes will be shown even though they are
		 * are now more degrees of separation away from the current
		 * root node than the limit allows. Also any intermediate node
		 * from a previous root node to the current root node will
		 * be shown to have a complete link and not a disconnected graph.
		 * @see maxVisibleDistance
		 * */
		function get showHistory():Boolean;

		/**
		 * @private
		 * */
		function set showHistory(h:Boolean):void;

		/**
		 * Set or get the current root node (or focused node). Setting
		 * this property will result in a redraw of the graph to reflect
		 * the change (if it was actually a change).
		 * */
		function get currentRootVNode():IVisualNode;

		/**
		 * @private
		 * */
		function set currentRootVNode(vn:IVisualNode):void;
		
		/**
		 * Specifies if any visibility limits should be active
		 * or not. If not active, always all nodes are visible.
		 * If you have many nodes, this could have a severe
		 * impact on your performance so handle with care.
		 * @default true
		 * */
		function get visibilityLimitActive():Boolean;
		
		/**
		 * @private
		 * */
		function set visibilityLimitActive(ac:Boolean):void;
		
		/**
		 * Limit the currently visible nodes to those in a limited
		 * distance (in terms of degrees of separation) from the current
		 * root node. If showHistory is enabled, the previous root nodes
		 * will be shown regardless of this limit. 
		 * @see showHistory
		 * */
		function get maxVisibleDistance():int;

		/**
		 * @private
		 * */
		function set maxVisibleDistance(md:int):void;
		
		/**
		 * The scale property of VGraph will affect
		 * the scaleX and scaleY properties and also
		 * will ensure drag&drop works properly.
		 * */
		function get scale():Number;
		
		/**
		 * @private
		 * */
		function set scale(s:Number):void;
		
		/**
		 * Initializes the VisualGraph from its currently set Graph object,
		 * basically removing all existing VNodes and VEdges and
		 * recreating them based on the information found in the associated
		 * Graph object.
		 * */
		function initFromGraph():void;
		
		/**
		 * Clears the current history of root nodes.
		 * @see showHistory
		 * */
		function clearHistory():void;
		
		/**
		 * Create a new Node in this VisualGraph, this automatically
		 * creates an underlying Node in the Graph object. It does not
		 * link the node to any other node, yet and it does not trigger
		 * a layout pass. The reason is that currently all layouters require
		 * a CONNECTED graph, since the new node would create a disconnected
		 * graph (since it is not linked, yet) this would break things.
		 * @param sid The string id of the new node.
		 * @param o The data object of this new node.
		 * @return The created VisualNode object.
		 * */
		function createNode(sid:String = "", o:Object = null):IVisualNode;
		
		/**
		 * Removes a node from this VisualGraph. This removes any associated
		 * VEdges and Edges with the node and of course the underlying Node from
		 * the Graph datastructure.
		 * @param vn The VisualNode to be removed.
		 * */
		function removeNode(vn:IVisualNode):void;
		
		/**
		 * Links two nodes, thus creating an edge. If the underlying Graph
		 * is directional, the order matters, not otherwise. If the nodes are
		 * already linked, simply returns the existing edge between them.
		 * @param v1 The first node (from node) to link.
		 * @param v2 The second node (to node) to link.
		 * @return The created VisualEdge.
		 * */
		function linkNodes(v1:IVisualNode, v2:IVisualNode):IVisualEdge;
		
		/**
		 * Unlinks two nodes, thus removing the edge between them, if it
		 * exists. Does nothing if the nodes were not linked.
		 * Again, order matters of the graph is directional.
		 * @param v1 The first node to unlink.
		 * @param v2 The second node to unlink.
		 * */
		function unlinkNodes(v1:IVisualNode, v2:IVisualNode):void;
	
		/**
		 * Calling this results in a redrawing of all edges during the next
		 * update cycle (and only the edges).
		 * */
		function refresh():void;
		
		/**
		 * Calling this forces a full calculation and redraw of the layout
		 * including all edges.
		 * */
		function draw(flags:uint = 0):void;

		/**
		 * This forces a redraw of all edges */
		function redrawEdges():void;
		
		/**
         * This forces a redraw of all nodes and their renderers */
		function redrawNodes():void;


		/**
		 * Scrolls all objects according to the specified coordinates
		 * (used as an offset).
		 * */
		function scroll(sx:Number, sy:Number, reset:Boolean):void;
        
        function calcNodesBoundingBox():Rectangle;
	}
}