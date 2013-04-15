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
package org.un.cava.birdeye.ravis.utils.events
{
	import flash.events.Event;
	
	/* this event may be dispatched to force the
	 * visual graph to do certain things like refresh
	 * this may be needed in case of a dragged node
	 * for example */
	public class VGraphEvent extends Event {
		
		/**
		 * This event type signals that something has changed
		 * in the VGraph.
		 * */
		public static const VGRAPH_CHANGED:String = "vgraphChanged";
	
		/**
		 * This event type signals that the layouter was changed
		 * on the vgraph.
		 * */
		public static const LAYOUTER_CHANGED:String = "layouterChanged";
	
		/**
		 * This event type signals that the hierarchical layouter
		 * has changed sibling spread (maybe this can be generalized).
		 * */
		public static const LAYOUTER_HIER_SIBLINGSPREAD:String = "hierLayouterSiblingSpreadChanged";
	
		/**
		 * This event type signals that a VNode has been
		 * updated (e.g. its orientation)
		 * */
		public static const VNODE_UPDATED:String = "vnodeUpdated";
	
		/**
		 * This event type signals that the visibility
		 * of some nodes may have changed
		 * */
		public static const VISIBILITY_CHANGED:String = "visibilityChanged";
	
		/**
		 * This subtype specifies some undefined general
		 * change.
		 * */
		public static const VEST_DEFAULT:uint = 0;
	
		/**
		 * This subtype specifies that the layouter
		 * has changed.
		 * */
		public static const VEST_LAYOUTER:uint = 1;
	
		/* the subtype of this event */
		private var _subtype:uint;
	
	
		/**
		 * constructor, allows specification of
		 * event subtype
		 * */	
		public function VGraphEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, subtype:uint = VEST_DEFAULT) {
			_subtype = subtype;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Specifies the subtype of the event. 
		 * */
		public function get subtype():uint {
			return _subtype;
		}
		
	}
}