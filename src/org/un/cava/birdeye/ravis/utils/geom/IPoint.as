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
package org.un.cava.birdeye.ravis.utils.geom {

	/**
	 * Represents a generic point in any geometry.
	 * We use this to define a point in non-euclidean space
   * <hr>
	 * The implementation is a rewrite of Jens Kanschik's Hypergraph
	 * implementation in Java. However, apart from the general idea 
	 * and some variable names, this code improves on hypergraph 
	 * and also implements additional functionality.
	 * 
	 * Copyright (C) 2003  Jens Kanschik,
	 * mail : jensKanschik@users.sourceforge.net
	 * 
	 * Copyright of this reimplementation in Flex:
	 * (c) Nitin Lamba, 2007.
	 * 
	 * @author Nitin Lamba
	 */
	public interface IPoint {
		/**
		 * Sets this point to the given point.
		 * @param p The new point.
		 */
		function setTo(p:IPoint):void;
		
		/** Creates a deep copy of the Point.
		 * @return A deep copy of the Point.
		 */
		function clone():Object;
		
		/**
		 * Returns true if the parameter object is equals to
     * this and false otherwise.
		 * 
     * @param obj Any object.
     * @return True if obj equals this.
		 */
		function equals(obj:Object):Boolean;
		
		/** Returns a String representation of the point.
		 * @return A String in appropriate format.
		 */
		function toString():String;
	}
}
