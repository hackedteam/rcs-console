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
	 * This is the base interface
	 * of our data items, like nodes (vertices)
	 * and edges, it specifies ID and data properties.
	 */
	public interface IDataItem extends IEventDispatcher {
		
		/**
		 * Access to the id property of any item.
		 * */
		function get id():int;
		

		/**
		 * Access to the data object associated with
		 * any item.
		 * @param o The data object to be associated.
		 * */
		function set data(o:Object): void;
		/**
		 * @private
		 * */
		function get data(): Object;
		
		/**
		 * @internal
		 * Decided not to allow setting the id
		 * in a regular method, it will be constructor only.
		 * */
	}
}