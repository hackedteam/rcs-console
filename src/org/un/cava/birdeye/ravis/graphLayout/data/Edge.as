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
	
	import flash.events.EventDispatcher;
	
	import mx.core.IDataRenderer;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	
	
	/**
	 * Edge class that implements the IEdge interface
	 * an edge has an id, two nodes a potential data
	 * object and may be associated with an IVisualEdge
	 * @see IEdge
	 * @see INode
	 * @see Node
	 * @see IVisualEdge
	 * */
	public class Edge extends EventDispatcher implements IEdge, IDataRenderer {
		
		/** 
		 * attributes
		 * 
		 * */
		protected var _graph:IGraph;
		protected var _node1:INode; /* potential fromNode */
		protected var _node2:INode; /* potential toNode */
		protected var _dataObject:Object;
		protected var _id:int;
		protected var _vedge:IVisualEdge;
		
		/* per default we have undirected graphs */
		protected var _directional:Boolean;
		
		
		/**
		 * constructor for an Edge
		 * @param graph The graph that this edge is part of
		 * @param ve The VisualEdge that this Edge may be associated with
		 * @param id The internal id of this new edge
		 * @param node1 The first node (or fromNode) of this edge
		 * @param node2 The second node (or toNode) of this edge
		 * @param data The potentially associated data object, typically an XML object
		 * */
		public function Edge(graph:IGraph, ve:IVisualEdge, id:int, node1:INode, node2:INode, data:Object) {
			
			/**
			 * @internal
			 * some constraints:
			 * the id must be unique, so we have to find a way to
			 * ensure that, maybe an integer counting up
			 * would be easier, but where should we keep
			 * track? It would need to be done in the Graph
			 * then we would need a reference to the Graph...
			 * 
			 * I leave it for now, not doing the check here
			 * it will be created from the graph normally,
			 * so we can make sure there....
			 * 
			 * ok we pass the graph rerence now, that means,
			 * we pull the id out of the graph
			 * * */
			
			//_id = id; -> pull the id out of the graph
			_graph = graph;
			_vedge = ve;
			_id = id;
			_directional = graph.isDirectional;
			_node1 = node1;
			_node2 = node2;
			_dataObject = data;
	
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get toNode():INode {
			if(_directional) {
				return _node2;
			} else {
				throw Error("Graph: "+_graph.id+" is not directional");
			}
		}

		/**
		 * @inheritDoc
		 * */
		public function get fromNode():INode {
			if(_directional) {
				return _node1;
			} else {
				throw Error("Graph: "+_graph.id+" is not directional");
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get node1():INode {
			return _node1;
		}

		/**
		 * @inheritDoc
		 * */
		public function get node2():INode {
			return _node2;
		}
	
		/**
		 * @inheritDoc
		 * */
		public function othernode(node:INode):INode {
			if(node == _node1) {
				return _node2;
			}
			else if(node == _node2) {
				return _node1;
			} else {
				return null;
			}
		}
	
		/**
		 * Access to the associated data object with this
		 * edge, in many cases an XML object is used.
		 * @see Object
		 * @see XML 
		 * */
		public function set data(o:Object):void {
			_dataObject = o;
		}
		/**
		 * @private
		 * */
		public function get data():Object	{
			return _dataObject;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get vedge():IVisualEdge {
			return _vedge;
		}
		/**
		 * @private
		 * */
		public function set vedge(ve:IVisualEdge):void {
			_vedge = ve;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get isDirectional():Boolean {
			return _directional;
		}
		
		/**
		 * The id of this edge.
		 * @return the id of this edge
		 * */
		public function get id():int {
			return _id;
		}
	}
}