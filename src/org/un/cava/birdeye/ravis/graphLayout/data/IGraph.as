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

package org.un.cava.birdeye.ravis.graphLayout.data {
	import flash.events.IEventDispatcher;
	
	
	/**
	 * Interface to the Graph datastructure class
	 * that hold the set of nodes
	 * and edges that actually form that graph
	 * */
	public interface IGraph	extends IEventDispatcher {
		
		/**
		 * The id (or name) of the graph
		 * */
		function get id():String;
		
		/**
		 * Return a reference to the XML graph
		 * structure that was used to initialise the graph.
		 * */
		function get xmlData():XML;
		
		/**
		 * An Array that contains all nodes of the graph.
		 * */
		function get nodes():Array;
		
		/**
		 * An Array that contains all edges of the graph.
		 * */
		function get edges():Array;
		
		/**
		 * The number of nodes in the graph.
		 * */ 
		function get noNodes():int;
		
		/**
		 * The number of edges in the graph.
		 * */ 
		function get noEdges():int;

		/** 
		 * Indicator if the graph is directional or not.
		 * */
		function get isDirectional():Boolean;

		/**
		 * Provide a method to sort nodes in a graph.
		 * This can be used by GTree when building
		 * a spanning tree.
		 * The function must be compatible with a function
		 * to sort an Array.
		 * @see Array
		 * @param f The function reference to use.
		 * @default null
		 * */
		function set nodeSortFunction(f:Function):void;
		
		/**
		 * @private
		 * */
		function get nodeSortFunction():Function;

		/**
		 * A lookup to find a node by it's string id.
		 * @param sid The node's string id.
		 * @return The node if one was found, null otherwise.
		 * */
		function nodeByStringId(sid:String,caseSensitive:Boolean=true):INode;
		
		/**
		 * A lookup to find a node by it's (int) id.
		 * @param id The node's id.
		 * @return The node if one was found, null otherwise.
		 * */
		function nodeById(id:int):INode;

		
		/**
	     * Creates a graph from XML.
	     * The XML you provide should contain 2 kinds of elements<br>
	     *  &lt;Node id="xxx" anything-else..../&gt;<br>
	     *  and<br>
	     *  &lt;Edge fromID="xxx" toID="yyy"/&gt;<br><br>
	     * <p>You can have additional tags, and/or nest the tags any way you like; this will not
	     * have any effect. We create a graph where each Item corresponds to a single node. The item's
	     * id will come from the Node's id attribute (make sure this is unique). The item's data will
	     * be the Node, and will be of type XML. The &lt;Edge&gt; elements must come *after* the corresponding
	     * &lt;Node&gt; elements have appeared.
	     * 
	     * @param xml an XML document containing Node and Edge elements.
	     * @return a graph that corresponds to the Node and Edge elements in the input.
	     */
		function initFromXML(xml:XML):void;
		
		/**
		 * Creates a graph node in the graph, optionally takes a string
		 * id for the node and an object to associate the node with.
		 * @param sid A unique string id for the node (if empty the numerical id will be used).
		 * @param o Dataobject to be associated with this node.
		 * @return The created node object.
		 * @throws Error if the string id was already used before (must be unique).
		 * */
		function createNode(sid:String = "", o:Object = null):INode;
		
		
		/**
		 * Removes a node from the graph. If the node is part of any edge,
		 * and error is thrown (i.e. edges must be removed/nodes unlinked first).
		 * @param n The node object to be removed.
		 * @throws An error if the node is still part of any edge.
		 * @throws An error if the node to be removed cannot be found in the graph.
		 * @throws An error if there exists still a vnode associated with this node.
		 * */
		function removeNode(n:INode):void;

		/**
		 * returns the current BFS tree of the graph, rooted in the given node,
		 * optionally the tree is restricted to only contain currently visible
		 * nodes. 
		 * The trees are cached, that means a tree is only created once and then
		 * stored in a map, unless the "nocache" flag is set! If the flag is set,
		 * then the tree will be created once and returned, the existing cache will
		 * not be touched or overwritten, this is useful if a full tree is needed
		 * for a specific purpose but the cache should not be overwritten or consulted.
		 * @param n The root node of the tree.
		 * @param restr This flag specifies if the resulting tree should be restricted to currently visible nodes.
		 * @param nocache If set, always a new tree will be created and returned and the cache will be untouched.
		 * @return The a GTree object that contains the tree.
		 * */
		function getTree(n:INode,restr:Boolean = false, nocache:Boolean = false, direction:int = 2):IGTree;
		
		/**
		 * Under certain circumstances all cached trees need
		 * to be purged.
		 * */
		function purgeTrees():void;
		
		/**
		 * Link two nodes together (i.e. create an edge). If the graph is NOT directional
		 * the same edge will be incoming and outgoing for both nodes. If the nodes are
		 * already linked, it will just return the existing edge between them.
		 * @param node1 First node to be linked.
		 * @param node2 Second node to be linked.
		 * @param o Optional data object to be associated with the resulting edge.
		 * @return The resulting edge.
		 * @throws Errors if any node is null.
		 * */
		function link(node1:INode, node2:INode, o:Object = null):IEdge;
		
		/**
		 * Unlink two nodes, effectively removing the edge between
		 * them.
		 * @param node1 The first node to be unlinked.
		 * @param node2 The second node to be unlinked.
		 * @throws An error if the nodes were not linked before.
		 * */
		function unlink(node1:INode, node2:INode):void;
		
		/**
		 * Find an edge between two nodes.
		 * @param n1 The first node of the edge.
		 * @param n2 The second node of the edge.
		 * @return The resulting edge or null if the nodes were not linked.
		 * */		
		function getEdge(n1:INode, n2:INode):IEdge;
		
		/**
		 * Removes an edge between two nodes.
		 * @param e The edge to be removed.
		 * @throws An error if the edge was not part of the graph.
		 * */		
		function removeEdge(e:IEdge):void;			  
		
		/**
		 * Remove all edges and nodes from the Graph.
		 * */
		function purgeGraph():void;
	}
}