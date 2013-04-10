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
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	
	
	/** 
	 * Interface for the node (vertex) data structure.
	 * A node can have incoming and outgoing edges,
	 * neighbour nodes, and may be associated with a
	 * VisualNode
	 */
	public interface INode extends IDataItem {
		
		/**
		 * Access to the string id of a node
		 * */
		function get stringid():String;
		

		/**
		 * The Array containing all incoming edges
		 * of this node. (In a non-directional graph, this is
		 * the same as the outgoing edges.)
		 * */
		function get inEdges():Array;
		
		/**
		 * The Array containing all outgoing edges
		 * of this node. (In a non-directional graph, this is
		 * the same as the incoming edges.)
		 * */
		function get outEdges():Array;
		
		/**
		 * The Array containing all preceding nodes,
		 * i.e. nodes that are at the other end of an 
		 * outgoing edge. (In a non-directional graph
		 * this is the same as the successor nodes).
		 * */
		function get predecessors():Array;
		
		/**
		 * The Array containing all succeeding nodes,
		 * i.e. nodes that are at the other end of an 
		 * incoming edge. (In a non-directional graph
		 * this is the same as the predecessor nodes).
		 * */
		function get successors():Array;
		
		
		/**
		 * Access to the associated VisualNode object
		 * of this data node
		 * */
		function get vnode():IVisualNode;
		
		/**
		 * @private
		 * */
		function set vnode(v:IVisualNode):void;
		
		/**
		 * Registers an incoming edge with this node.
		 * This method does nothing else, and should normally
		 * not be used directly, but is typically used by
		 * the link method of the graph.
		 * @param e The edge to add to this node.
		 * @throws An error if the edge does not connect to another node.
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.Graph#link()
		 * */
		function addInEdge(e:IEdge):void;
		
		/**
		 * Registers an outgoing edge with this node.
		 * This method does nothing else, and should normally
		 * not be used directly, but is typically used by
		 * the link method of the graph.
		 * @param e The edge to add to this node.
		 * @throws An error if the edge does not connect to another node.
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.Graph#link()
		 * */
		function addOutEdge(e:IEdge):void;
		
		/**
		 * Removes an edge from the list of incoming edges
		 * of this node. Removes also the predecessor node
		 * from the list.
		 * Should not be used directly, but is typically used
		 * by the unlink or removeEdge method of the graph.
		 * @param e The edge to remove to this node.
		 * @throws An error if the edge does not connect to another node.
		 * @throws An error if the edge is not in the list of incoming edges of this node.
		 * @throws An error if the node at the other end of this edge is not in the list of predecessor nodes.
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.Graph#unlink()
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.Graph#removeEdge()
		 * */
		function removeInEdge(e:IEdge):void;
		
		/**
		 * Removes an edge from the list of outgiong edges
		 * of this node. Removes also the successor node
		 * from the list.
		 * Should not be used directly, but is typically used
		 * by the unlink or removeEdge method of the graph.
		 * @param e The edge to remove to this node.
		 * @throws An error if the edge does not connect to another node.
		 * @throws An error if the edge is not in the list of incoming edges of this node.
		 * @throws An error if the node at the other end of this edge is not in the list of successor nodes.
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.Graph#unlink()
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.Graph#removeEdge()
		 * */
		function removeOutEdge(e:IEdge):void;
		
	}
}