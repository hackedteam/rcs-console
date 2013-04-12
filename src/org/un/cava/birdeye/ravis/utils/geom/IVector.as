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
	 * Represents a generic vector in any geometry.
	 * We use this to define a vector in non-euclidean space
	 * 
	 * Each vector is located at a given base (point) of type <code>IPoint</code>.
	 * For implementations where no information on the vector is available, 
	 * its constructor must set itself to 0.
	 * 
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
	public interface IVector {

		/**
		 * Returns the base (point) of the vector.
		 * 
		 * @return The base (point).
		 */
		function get base():IPoint;

		/**
		 * Sets the base (point) of the vector. 
		 * 
		 * For correct behavior, all implementation have to set 
		 * this vector to 0 after the base has changed.
		 * 
		 * @param p The new base point.
		 */
		function set base(p:IPoint):void;

		/**
		 * Returns the direction (point) of the vector.
		 * 
		 * @return The direction (point).
		 */
		function get dir():IPoint;
		
		/**Scales the vector with the specified factor.
		 * This changes the length of the vector, but the base (point) is unchanged.
		 * 
		 * @param f The scaling factor.
		 */
		function scale(f:Number):void;

		/** 
		 * Sets this vector to the given vector.
		 * The specified vector must belong to the same model.
		 * 
		 * @param vector The new vector</code>.
		 */
		function setTo(vector:IVector):void;

		/** 
		 * Creates a deep copy of the vector.
		 * 
		 * @return A deep copy of the vector.
		 */
		function clone():Object;
		
		/** 
		 * Returns a String representation of the vector.
		 * 
		 * @return A String in appropriate format.
		 */
		function toString():String;
	}

}