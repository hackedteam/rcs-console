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


	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;

	/**
	 * The Edge interface for graph edges.
	 * It contains a reference to any associated
	 * object (like a label, or a visual item
	 * to be displayed, which could include more
	 * attributes like a length.
	 */
	public interface IEdge extends IDataItem {
	
		/**
		 * Indicates if the graph that contains this edge is directional.
		 * @return if the graph that contains this edge is directional.
		 * */
		function get isDirectional():Boolean;
	
		/**
		 * The first node associated with this edge.
		 * @return The first node associated with this edge.
		 * */
		function get node1():INode;
		
		/**
		 * The second node associated with this edge.
		 * @return The second node associated with this edge.
		 * */
		function get node2():INode;
	
		/**
		 * returns the source node (fromNode) of the edge.
		 * Only available if the graph is directional as otherwise
		 * there is no designated source node.
		 * @return The source node of this edge.
		 * @throws Error that the graph is not directional.
		 * */
		function get fromNode():INode;
		
		/**
		 * returns the target node (toNode) of the edge.
		 * Only available if the graph is directional as otherwise
		 * there is no designated target node.
		 * @return The target node of this edge.
		 * @throws Error that the graph is not directional.
		 * */
		function get toNode():INode;
		
		/**
		 * Access to the associated VisualEdge
		 * of this Edge.
		 * @internal
		 * this may be a breach of encapsulation if we explicitly
		 * use objects of the visualisation part.
		 */
		function get vedge():IVisualEdge;
		
		/**
		 * @private
		 * */
		function set vedge(ve:IVisualEdge):void;
	
		/**
		 * This method returns the other node than the node
		 * given as parameter, so it can be used to follow along
		 * the edge.
		 * @param node The node that is known (implicit source node)
		 * @return The node that is unknown (implicit target node)
		 * */
		function othernode(node:INode):INode;
	}
} // package