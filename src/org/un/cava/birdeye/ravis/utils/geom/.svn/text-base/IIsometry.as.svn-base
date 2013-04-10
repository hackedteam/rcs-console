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
	 * This interface provides a common definition for isometries in any Hyperbolic Model.
	 * The models have the actual implementation, which should provide at least a default constructor, 
	 * say, the identity transformation.
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
	 *
	 * @author Nitin Lamba
	 */
	public interface IIsometry {

		/**
		 * Sets the isometry to an identity transformation.
		 */
		function setToIdentity():void;
		
		/**
		 * Multiplies this isometry with the given isometry (to the right) and store the result:
		 * <code>this = this * isometry</code>
		 *
		 * @param isometry The factor from the right.
		 */
		function multiplyRight(isometry:IIsometry):void;
		
		/**
		 * Multiplies the given isometry with this isometry (to the left) and store the result:
		 * <code>this = isometry * this</code>
		 *
		 * @param isometry The isometry multiplied from the left.
		 */
		function multiplyLeft(isometry:IIsometry):void;

		/**
		 * Applies this isometry to a given <code>IPoint</code> and modify it.
		 *
		 * @param p The point to be modified.
		 */
		function applyToPoint(p:IPoint):void;
		
		/**
		 * Applies this isometry to a given <code>IVector</code> and modify it.
		 *
		 * @param v The vector to be modified.
		 */
		function applyToVector(v:IVector):void;

		/**
		 * Returns a new instance of this isometry representing its inverse.
		 * In other words: this * this.getInverse() = Identity
		 * 
		 * This isometry is not modified. 
		 * 
		 * @return The inverse of this isometry.
		 */
		function getInverse():IIsometry;
		
		/**
		 * Inverts this isometry. Similar to <code>getInverse()</code>.
		 */
		function invert():void;

		/** 
		 * Sets this isometry to the given isometry.
		 * The specified isometry must belong to the same model.
		 * 
		 * @param isom The new isometry.
		 */
		function setTo(isom:IIsometry):void;
		
		/**
		 * Returns true if the parameter object is equals to
     * this and false otherwise.
		 * 
     * @param obj Any object.
     * @return True if obj equals this.
		 */
		function equals(obj:Object):Boolean;
		
		/** 
		 * Creates a deep copy of this isometry.
		 * 
		 * @return A deep copy of this isometry.
		 */
		function clone():Object;

		/**
		 * Returns a string representation of the isometry.
		 * 
		 * @return A String in appropriate format.
		 */
		function toString():String;

	}

}