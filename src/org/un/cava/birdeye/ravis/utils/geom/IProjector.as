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

import flash.geom.Point;
import flash.display.DisplayObject;

	/**
	 * This interface defines the functionality of a projector,
	 * which is used to map points in Display Geometry (Screen) to
	 * those in Non-Euclidean Space (Hyperbolic Geometry).
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
	public interface IProjector {

		/** 
		 * Project a IPoint (Hyperbolic Geometry) to Point (Display Geometry)
		 */
		function project(p:IPoint, d:DisplayObject):Point;

		/** 
		 * Un-project a Point (Display Geometry) to IPoint (Hyperbolic Geometry)
		 */
		function unProject(p:Point, d:DisplayObject, adjustBadNodes:Boolean):IPoint;
		
		/**
		 * Returns the center of the circle in Euclidean space, which joins 
		 * the two points P (x1, y1) and Q (x2, y2)
		 * @return The center of the circle
		 * */
		function getCenter(x1:Number, y1:Number, x2:Number, y2:Number, d:DisplayObject):Point;
		
 		/**
		 * Returns the scaling factors at a point in the non-euclidean space.
		 * @param p The point in the non-euclidean space
		 * @return A point with scaling factors in X and Y directions.
		 */
		function getScale(p:IPoint):Point;

 		/**
		 * Returns the inverse of the view matrix.
		 * @return The inverse of the view matrix.
		 */
		function getInverseViewMatrix():IIsometry;

		/**
		 * Returns the view matrix.
		 * @return The view matrix.
		 */		
		function getViewMatrix():IIsometry;
		
		/**
		 * Sets the view matrix and computes the inverse of the view matrix.
		 * If vm is null, the view matrix is set to the identity transformation.
		 * 
		 * @param vm The new view matrix.
		 */
		function setViewMatrix(vm:IIsometry):void;
	}

}