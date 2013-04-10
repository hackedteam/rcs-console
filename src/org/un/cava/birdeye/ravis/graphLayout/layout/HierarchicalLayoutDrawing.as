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
package org.un.cava.birdeye.ravis.graphLayout.layout {
	
	import flash.utils.Dictionary;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	
	/**
	 * This class holds all the parameters needed
	 * for a drawing representation of a graph drawing
	 * with a Hierarchical Layout according to 
	 * */
	public class HierarchicalLayoutDrawing extends BaseLayoutDrawing {

		/* to hold the modifiers */
		private var _modifiers:Dictionary;

		/* to defer the subtree moves we need "change" and "shift" 
		 * for each node */
		private var _changes:Dictionary;
		private var _shifts:Dictionary;

		/* the "threads" */
		private var _threads:Dictionary;
		
		/* the ancestors */
		private var _ancestors:Dictionary;

		/* the preliminary x values for the nodes */
		private var _prelims:Dictionary;
		
		/* a depth offset to spread sibling nodes */
		private var _depthOffsets:Dictionary;

		/**
		 * The constructor just initializes the internal data structures.
		 * */
		public function HierarchicalLayoutDrawing() {
			super();
			_modifiers = new Dictionary;
			_changes = new Dictionary;
			_shifts = new Dictionary;
			_threads = new Dictionary;
			_ancestors = new Dictionary;
			_prelims = new Dictionary;
			_depthOffsets = new Dictionary;
		}

		/**
		 * Get the modifier value for a node, default is 0.
		 * @param n The Node for which the modifier is needed.
		 * @return The modifier value for the node n.
		 * */
		public function getModifier(n:INode):Number {
			/* check if a value exists already. If not
			 * preset it to 0 */
			if(_modifiers[n] == null) {
				_modifiers[n] = 0.0;
			}
			return _modifiers[n];
		}			

		/**
		 * Set the modifier value for a node.
		 * @param n The Node for which the modifier is to be set.
		 * @param v The modifier value for the node n.
		 * */
		public function setModifier(n:INode, v:Number):void {
			_modifiers[n] = v;
		}
		
		/**
		 * Adds a value to the modifier
		 * @param n The node for the modifier is to b modified ;-)
		 * @param v The value to add.
		 * */
		public function addToModifier(n:INode, v:Number):void {
			/* remember that a modifier is supposed to be
			 * preinitialised with 0, so if we do not have it
			 * yet, we just set the value */
			if(_modifiers[n] == null) {
				_modifiers[n] = v;
			} else {
				_modifiers[n] += v;
			}
		}

		/**
		 * Get the change value for a node, default is 0.
		 * @param n The Node for which the change value is needed.
		 * @return The change value for the node n.
		 * */
		public function getChange(n:INode):Number {
			/* check if a value exists already. If not
			 * preset it to 0 */
			if(_changes[n] == null) {
				_changes[n] = 0.0;
			}
			return _changes[n];
		}			

		/**
		 * Set the change value for a node.
		 * @param n The Node for which the change is to be set.
		 * @param v The change value for the node n.
		 * */
		public function setChange(n:INode, v:Number):void {
			if(isNaN(v) || !isFinite(v)) {
				throw Error("illegal set change value for node:"+n.id);
			}
			_changes[n] = v;
		}
		
		/**
		 * Adds a value to the change.
		 * @param n The node for the change is to be modified ;-)
		 * @param v The value to add.
		 * */
		public function addToChange(n:INode, v:Number):void {
			
			if(isNaN(v) || !isFinite(v)) {
				throw Error("illegal addto change value for node:"+n.id);
			}			
			/* remember that a change is supposed to be
			 * preinitialised with 0, so if we do not have it
			 * yet, we just set the value */
			if(_changes[n] == null) {
				_changes[n] = v;
			} else {
				_changes[n] += v;
			}
		}
		
		/**
		 * Get the shift value for a node, default is 0.
		 * @param n The Node for which the shift value is needed.
		 * @return The shift value for the node n.
		 * */
		public function getShift(n:INode):Number {
			/* check if a value exists already. If not
			 * preset it to 0 */
			if(_shifts[n] == null) {
				_shifts[n] = 0.0;
			}
			return _shifts[n];
		}			

		/**
		 * Set the shift value for a node.
		 * @param n The Node for which the shift is to be set.
		 * @param v The shift value for the node n.
		 * */
		public function setShift(n:INode, v:Number):void {
			if(isNaN(v) || !isFinite(v)) {
				throw Error("illegal set shift value for node:"+n.id);
			}			
			_shifts[n] = v;
		}
		
		/**
		 * Adds a value to the shift.
		 * @param n The node for the shift is to be modified ;-)
		 * @param v The value to add.
		 * */
		public function addToShift(n:INode, v:Number):void {
			if(isNaN(v) || !isFinite(v)) {
				throw Error("illegal addto shift value for node:"+n.id);
			}
			/* remember that a shift is supposed to be
			 * preinitialised with 0, so if we do not have it
			 * yet, we just set the value */
			if(_shifts[n] == null) {
				_shifts[n] = v;
			} else {
				_shifts[n] += v;
			}
		}

		/**
		 * Get the thread pointer for a node, default is null.
		 * @param n The Node for which the thread is needed.
		 * @return The thread target node.
		 * */
		public function getThread(n:INode):INode {
			return _threads[n];
		}			

		/**
		 * Set the thread pointer for a node.
		 * @param n The Node for which the modifier is to be set.
		 * @param t The thread target node for the node n.
		 * */
		public function setThread(n:INode, t:INode):void {
			_threads[n] = t;
		}
		
		/**
		 * Get the ancestor node for a node, default is the node itself.
		 * @param n The Node for which the ancestor is needed.
		 * @return The ancestor node.
		 * */
		public function getAncestor(n:INode):INode {
			if(_ancestors[n] == null) {
				_ancestors[n] = n;
			}
			return _ancestors[n];
		}			

		/**
		 * Set the ancestor for a node.
		 * @param n The Node for which the ancestor is to be set.
		 * @param a The ancestor node for the node n.
		 * */
		public function setAncestor(n:INode, a:INode):void {
			_ancestors[n] = a;
		}

		/**
		 * Get the preliminary x value for a node.
		 * @param n The Node for which the value is needed.
		 * @return The prelim value for the node n.
		 * */
		public function getPrelim(n:INode):Number {
			return _prelims[n];
		}			

		/**
		 * Set the preliminary x value for a node.
		 * @param n The Node for which the value is needed.
		 * @param v The prelim value for the node n.
		 * */
		public function setPrelim(n:INode, v:Number):void {
			_prelims[n] = v;
		}

		/**
		 * Add a value to the preliminary x value for a node.
		 * @param n The Node for which the value is needed.
		 * @param v The prelim value for the node n to add.
		 * */
		public function addToPrelim(n:INode, v:Number):void {
			/* Warning: There is no check here if the entry
			 * already exists, but also not sure if 0 init
			 * would be appropriate here */
			_prelims[n] += v;
		}
		
		/**
		 * Set the depth offset of a node. This results in a variation
		 * of the depth of the node within the same layer.
		 * @param n The node for which to set the offset.
		 * @param v The offset value.
		 * */
		public function setDepthOffset(n:INode, v:Number):void {
			_depthOffsets[n] = v;
		}
		
		/**
		 * Get the current depth offset of a node. The 
		 * default is 0.
		 * @param n The node for which the depth offset it needed.
		 * @return The depth offset of the given node (or 0).
		 * */
		public function getDepthOffset(n:INode):Number {
			if(_depthOffsets[n] == null) {
				return 0.0;
			} else {
				return _depthOffsets[n];
			}
		}
	}
}