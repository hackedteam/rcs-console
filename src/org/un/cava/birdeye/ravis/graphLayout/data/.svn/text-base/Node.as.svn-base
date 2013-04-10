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
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	
	
	/**
	 * Implements the Node data structure, which is part of
	 * a graph. Nodes can be connected via directional or
	 * non-directional edges. A node has an id, a String id
	 * and may be associated with a visual node.
	 * */
	public class Node extends EventDispatcher implements INode, IDataRenderer {
	
		/**
		 * @internal
		 * attributes
		 * */
		protected var _inEdges:Array;
		protected var _outEdges:Array;
		protected var _dataObject:Object;
		protected var _id:int;
		protected var _stringid:String; // this is used by the app, so we need to add it
		protected var _vnode:IVisualNode;
		
		/**
		 * @internal
		 * for convenience we keep track of
		 * the predecessors and successors
		 * 
		 * NOTE: this may create rather heavy, large
		 * objects (although we only ever store references)
		 * maybe all this should just be kept within
		 * the graph object....
		 * */
		protected var _predecessors:Array;
		protected var _successors:Array;
		
		/**
		 * The constructor assigns the two ids and may also be used
		 * to associate a VisualNode and/or a data object.
		 * @param id The internal (numeric) id of the node.
		 * @param sid The string id of the node (typically specified in XML).
		 * @param vn The associated VisualNode of the node (may be null).
		 * @param o The associated data object of the node (may be null).
		 * */
		public function Node(id:int, sid:String, vn:IVisualNode, o:Object) {
			_inEdges = new Array;
			_outEdges = new Array;
			_predecessors = new Array;
			_successors = new Array;
			_id = id;
			_stringid = sid;
			_dataObject = o;
			_vnode = vn;
		}
	
		/**
		 * @inheritDoc
		 * */
		public function addInEdge(e:IEdge):void {
			
			/* the next assumes that the Edge knows
			 * already both its endpoints (which should
			 * always be the case */
			
			/* the IN coming edge, so this means we are the TO
			 * node and the other must be the from Node */
			if(e.othernode(this) == null) {
				throw Error("Edge:"+e.id+" has no fromNode");
			}
			_predecessors.unshift(e.othernode(this));
			_inEdges.unshift(e);
		}
		
		/**
		 * @inheritDoc
		 * */
		public function addOutEdge(e:IEdge):void {
			/* same story here */
			if(e.othernode(this) == null) {
				throw Error("Edge:"+e.id+" has no toNode");
			}
			//LogUtil.debug(_LOG, "added successor node:"+e.othernode(this).id+" to node:"+_id);
			_successors.unshift(e.othernode(this));
			_outEdges.unshift(e);
		}
		
		/**
		 * @inheritDoc
		 * */
		public function removeInEdge(e:IEdge):void {
			/* get the other node, as it must be deleted
			 * from the predecessor list */
			var otherNode:INode = e.othernode(this); // because it is an IN edge
			var theEdgeIndex:int = _inEdges.indexOf(e);
			var theNodeIndex:int = _predecessors.indexOf(otherNode);
			
			if(theEdgeIndex == -1) {
				throw Error("Could not find edge: "+e.id+" in InEdge list of node: "+_id);
			} else {
				_inEdges.splice(theEdgeIndex,1);
			}
			if(otherNode == null) {
				throw Error("Edge:"+e.id+" has no node 1");
			}
			if(theNodeIndex  == -1) {
				throw Error("Could not find node: "+otherNode.id+" in predecessor list of node: "+_id);
			} else {
				_predecessors.splice(theEdgeIndex,1);
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function removeOutEdge(e:IEdge):void {
			/* get the other node, as it must be deleted
			 * from the successor list */
			var otherNode:INode = e.othernode(this); // because it is an OUT edge
			var theEdgeIndex:int = _outEdges.indexOf(e);
			var theNodeIndex:int = _successors.indexOf(otherNode);
			
			if(theEdgeIndex == -1) {
				throw Error("Could not find edge: "+e.id+" in OutEdge list of node: "+_id);
			} else {
				_outEdges.splice(theEdgeIndex,1);
			}
			if(otherNode == null) {
				throw Error("Edge: "+e.id+" has no node 2");
			}
			if(theNodeIndex  == -1) {
				throw Error("Could not find node: "+otherNode.id+" in predecessor list of node: "+_id);
			} else {
				_successors.splice(theEdgeIndex,1);
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get successors():Array {
			return _successors;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get outEdges():Array {
			return _outEdges;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get inEdges():Array {
			return _inEdges;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get predecessors():Array {
			return _predecessors;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set data(o:Object):void {
			_dataObject = o;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get data():Object	{
			return _dataObject;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get vnode():IVisualNode {
			return _vnode;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set vnode(v:IVisualNode):void {
			_vnode = v;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get id():int {
			return _id;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get stringid():String {
			return _stringid;
		}
	}
}
