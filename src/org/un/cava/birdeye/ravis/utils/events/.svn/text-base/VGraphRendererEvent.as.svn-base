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
	public class VGraphRendererEvent extends Event {
		
		/**
		 * This event type signals that a specific renderer
		 * has been selected, to allow updating of listener
		 * components, that might want to display its title
		 * or any other information
		 * */
		public static const VG_RENDERER_SELECTED:String = "vgRendererSelected";
	
		/**
		 * this attribute allows the transmission of
		 * the renderer name
		 * */
		public var rname:String;
	
		/**
		 * this attribute allows the transmission of
		 * the renderer description
		 * */
		public var rdesc:String;
	
		/**
		 * constructor, allows specification of
		 * event subtype
		 * */	
		public function VGraphRendererEvent(type:String, nm:String = "", dk:String = "", bubbles:Boolean=false, cancelable:Boolean=false) {
			rname = nm;			
			rdesc = dk;
			super(type, bubbles, cancelable);
		}
	}
}