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
	import flash.utils.Dictionary;
	
	/**
	 * interface to the GTree data structure that
	 * holds a spanning tree of the graph
	 * */
	public interface IGTree	extends IEventDispatcher {
		
		/**
		 * Indicating flag if the returned tree is restricted to currently invisible nodes.
		 * */
		function get restricted():Boolean;
		
		/**
		 * The map (Dictionary) that contains the parents for each node (keys are node
		 * objects, with their parent node objects as values).
		 * */
		function get parents():Dictionary;
		
		/** 
		 * The map that contains the distance for each node (keys are node objects,
		 * values are integers that indicate the distance (in hops) from the root node
		 * */
		function get distances():Dictionary;
		
		/**
		 * access to the current root node of the tree. If a new root
		 * node is set, this means the tree has to be recalculated.
		 * */
		function get root():INode;
		
		/**
		 * @private
		 * */
		function set root(r:INode):void;
		
		/**
		 * The maximum depth of the tree, which is the maximum distance
		 * of any node from the root 
		 * */
		function get maxDepth():int;
	
		/**
		 * Returns a nested XML representation of the tree.
		 * It will only contain <Node> tags with all the attributes
		 * of the source GraphML data, nothing else.
		 * Beware, if the created tree is restriced to visible nodes,
		 * you will only get those.
		 * */
		function get XMLtree():XML;
		
		/**
		 * Get the distance of a particular node from the root.
		 * @param n The node object for which the distance is requested.
		 * @return The distance from the root in hops.
		 * */
		function getDistance(n:INode):int;
		
		/**
		 * Each node is also the i'th child of it's parent. This index
		 * is called the child index. The child index of each node is stored
		 * and can be looked up by this method.
		 * @param n The node lookup its child index.
		 * @return The child index of this node.
		 * */
		function getChildIndex(n:INode):int;
		
		/**
		 * The number of children of any node in the tree.
		 * @param The parent node.
		 * @return The number of its children.
		 * */
		function getNoChildren(n:INode):int;
		
		/**
		 * Returns the number of siblings of a node, including the node itself
		 * so basically this is the number of the children of the node's parents.
		 * If the node has no parent, it is the root node and therefore
		 * the number of its sibling including itself is 1.
		 * @param n The node for which its number of siblings is required.
		 * @return The number of of siblings plus the node itself.
		 * */
		function getNoSiblings(n:INode):int;
		
		/**
		 * Checks if two nodes are siblings or not.
		 * @param n First node to check.
		 * @param m Potential sibling of n.
		 * @return True if the nodes are siblings, false otherwise.
		 * */
		function areSiblings(n:INode, m:INode):Boolean;
		
		/**
		 * An array that contains all children of this node
		 * in the tree in the order of each child's child index.
		 * @param n The parent node.
		 * @return The array of children of the given node.
		 * */
		function getChildren(n:INode):Array;
		
		/**
		 * This method returns the node, which is the i'th child
		 * of a given (parent) node. Note that 'i' starts with 0,
		 * i.e. the frist child is actually the 0th child.
		 * @param n The parent node.
		 * @param i The child index of the desired child.
		 * @return The node which is it the i'th child of node n.
		 * */
		function getIthChildPerNode(n:INode,i:int):INode;
		
		/**
		 * This initialiases the (spanning) tree
		 * using BFS (Breadth first search).
		 * @param walkingDirection The direction in which to walk the graph.
		 * 		  The proper value is GraphWalkingDirectionsEnum.BOTH.
		 * 		  The value for the old functionality is GraphWalkingDirectionsEnum.FORWARD.
		 * @return The map that contains each node's parent node.
		 * */
		function initTree():Dictionary;
		
		/**
		 * This method returns a map (Object) containing only 
		 * the nodes which are within a certain distance of the
		 * root node.
		 * @param limit The distance limit.
		 * @return An object containing a map of node id's which are within the distance limit.
		 * */
		function getLimitedNodes(limit:int):Dictionary;
		
		/**
		 * This returns the number of nodes that have exactly
		 * the specified distance.
		 * @param d The distance from the root.
		 * @return The number of nodes in the tree with distance d.
		 * */
		function getNumberNodesWithDistance(d:uint):uint;
		
		/**
		 * This returns all nodes that dont have a connection to any level larger then them
		 */ 
		function getNodesWithoutLinkToNextLevel():Array;
		/**
		 * This is the maximum number of nodes at any
		 * distance, i.e. the maximum over all distances
		 * of getNumberNodesWithDistance().
		 * @see getNumberNodesWithDistance
		 * */
		function get maxNumberPerLayer():uint;
        
        /**
         * @private
         * */
        function get walkingDirection():int;

	}
}