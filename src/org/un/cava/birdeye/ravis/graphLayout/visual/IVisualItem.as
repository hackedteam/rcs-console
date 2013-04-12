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
package org.un.cava.birdeye.ravis.graphLayout.visual {
	import flash.events.IEventDispatcher;
	

	/**
	 * Interface for any visual item, provides
	 * access to an internal id, a data object
	 * and a related VisualGraph.
	 */
	public interface IVisualItem extends IEventDispatcher {
		 
		/**
		 * Access to the item's unique id. Every item has one.
		 * This interface does not support the direct setting of
		 * the id, this should rather happen through the constructor.
		 * */
		function get id():int;
		
		/**
		 * Access to the items data object.
		 * */
		function get data():Object;
		
		/**
		 * @private
		 * */
		function set data(o:Object):void;
	
		/**
		 * Access to the associated VisualGraph of this item.
		 * */
		function get vgraph():IVisualGraph;
	
		/**
		 * Method to specify if the current Visual Item
		 * is considered to be visible or not.
		 * */
		function get isVisible():Boolean;

		/**
		 * @private
		 * */
		function set isVisible(v:Boolean):void
	
		/**
		 * Property to indicate if the node should be
		 * centered around it's geometrical center (i.e.
		 * the center of it's view) or if it's origin would
		 * be the usual upper left corner. The value will
		 * be applied by the commit() and refresh() methods.
		 * @see commit()
		 * @see refresh()
		 * */
		function get centered():Boolean;
		
		/**
		 * @private
		 * */	
		function set centered(c:Boolean):void;
	}
}