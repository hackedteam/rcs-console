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
	 * A common interface to the geometric model typically used for 
	 * Non-Euclidean layouts
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
  public interface IModel {

    /** 
		 * Returns the origin of the model.<br>
     * A model doesn't present a riemannian manifold, but the pair (M, p) of a
     * riemannian manifold and a fixed point, the origin.<br>
		 * 
     * For a vector space, the origin is naturally 0.
		 * 
     * @return The origin of the model.
     */
    function getOrigin():IPoint;

		/** 
		 * Returns a "default" vector at the origin.<br>
		 * In most models, there is no special vector,
		 * but it is very convenient to have such a default vector to start with.<br>
		 * This vector is always located at the origin, is always normalized (i.e. has length 1)
		 * and it always has to be the same.<br>
		 *
		 * @return A normalized vector at the origin.
		 */
		function getDefaultVector():IVector;

    /** 
		 * Returns the identity transformation.
		 * 
     * @return The identity transformation.
     */
    function getIdentity():IIsometry;

    /** 
		 * Returns a rotation of <code>alpha</code> at the origin.
     * Only well defined in 2D, oriented models.<br>
		 * 
     * @param alpha The angle of the rotation.
     * @return The rotation at the origin with angle <code>alpha</code>.
     */
    function getRotation(alpha:Number):IIsometry;

		/** 
		 * Returns a rotation of <code>alpha</code> at the point <code>p</code>.
		 * Only well defined in 2D, oriented models.<br>
		 * 
		 * @param p The basepoint of the rotation.
		 * @param alpha The angle of the rotation.
		 * @return The rotation at <code>p</code> with angle <code>alpha</code>.
		 */
    function getRotationP(p:IPoint, alpha:Number):IIsometry;

    /** 
		 * Returns the translation to a given point <code>z</code>.
     * @param z the given point.
     */
    function getTranslationP(z:IPoint):IIsometry; 

    /** 
		 * Returns the r-th root (isometry) of the translation to
		 * a given point.
		 * 
     * @param z the given point.
     * @param r the root.
     */
    function getTranslationPR(z:IPoint, r:Number):IIsometry;
		
    /** 
		 * Translate a point to another point
     * @param z1 The destination point
		 * @param z2 The point to be moved.
     */
    function getTranslationPP(z1:IPoint, z2:IPoint):IIsometry;

    /** 
		 * Translate a given point to a destination point in a given number of steps
		 * 
     * @param z1 The destination point
		 * @param z2 The given point
		 * @param r Number of steps (roots)
     */
    function getTranslationPPR(z1:IPoint, z2:IPoint, r:Number):IIsometry;
		
		/**
		 * Calculates the translation (isometry) to a given point <code>p</code>.
		 * 
		 * @param	isom the resulting isometry
		 * @param	p the given point
		 */
	  function getTranslationIP(isom:IIsometry, p:IPoint):void;
	  
		/**
		 * Calculates the translation (isometry) from a given point <code>p2</code>
		 * to a destination point <code>p1</code>.
	   * 
	   * @param	isom the resulting isometry
	   * @param	p1 the destination point
	   * @param	p2 the given point
	   */
		function getTranslationIPP(isom:IIsometry, p1:IPoint, p2:IPoint):void;		
	  
		/**
		 * Calculates the r-th root (isometry) of the translation to
		 * a given point.
		 * 
		 * @param	isom the resulting isometry
		 * @param	p the given point
		 * @param	r the root.
		 */
		function getTranslationIPR(isom:IIsometry, p:IPoint, r:Number):void;

	  /**
		 * Calculate the translation of a given point to a destination point 
		 * in a given number of steps
	   * 
	   * @param	isom the resulting isometry
     * @param p1 The destination point
		 * @param p2 The given point
		 * @param r Number of steps (roots)
	   */
		function getTranslationIPPR(isom:IIsometry, p1:IPoint, p2:IPoint, r:Number):void;		
    
		/** 
		 * Returns the translation for the base of the given vector in a specific direction
		 * 
		 * @param vector the vector to move
		 * @param r distance to move
     */
		function getTranslationVR(vector:IVector, r:Number):IIsometry;
		
		/**
		 * Calculates the translation for the base of the given vector in a specific direction
		 * 
		 * @param	isom the resulting isometry
		 * @param	vector the vector to move
		 * @param	r distance to move
		 */
		function getTranslationIVR(isom:IIsometry, vector:IVector, r:Number):void;

    /** 
		 * Calculates the distance from <code>z</code> to the origin.
		 * 
     * @param z A point in the model.
     * @return The distance from <code>z</code> to the origin.
     */
    function dist(z:IPoint):Number;

		/** 
		 * Computes the squared distance from <code>z</code> to the origin.
		 * 
		 * @param z A point in the model.
		 * @return The squared distance from <code>z</code> to the origin.
		 */
    function dist2(z:IPoint):Number;

    /** 
		 * Computes the distance between two points.
		 * 
     * @param z1 A point in the model.
     * @param z2 A point in the model.
     * @return The distance of the two points.
     */
		function distP(z1:IPoint, z2:IPoint):Number;

		/** 
		 * Computes the squared distance between two points.
		 * 
		 * @param z1 A point in the model.
		 * @param z2 A point in the model.
		 * @return The squared distance of the two points.
		 */
		function distP2(z1:IPoint, z2:IPoint):Number;

		/** 
		 * Returns the distance of <code>p</code> to the line, ray or line segment
		 * from <code>z1</code> to <code>z2</code>.<br>
		 * 
		 * The parameters <code>cutoff1</code> and <code>cutoff2</code>
		 * define whether the whole line should be considered or only parts.
		 * <ul>
		 * <li><code>getDistance(p, z1, z2, true, true)</code>
		 * returns the distance to the line segment.</li>
		 * <li><code>getDistance(p, z1, z2, false, true)</code>
		 * returns the distance to the ray starting in <code>z1</code>.</li>
		 * <li><code>getDistance(p, z1, z2, false, false)</code>
		 * returns the distance to the whole (infinite) line.</li>
		 * </ul>
		 * If the geometry of the model
		 * allows to give the distance a sign using a well defined orientation,
		 * (e.g. for most two dimensional models) it should do so, but it is not required.
		 *
		 * @param p        The point from which the distance is computed.
		 * @param z1       The starting point of the line segment.
		 * @param z2       The end point of the line segment.
		 * @param cutoff1  If true, the line is cut off at <code>z1</code>.
		 * @param cutoff2  If true, the line is cut off at <code>z2</code>.
		 * @return         The distance from <code>p</code> to the line,
		 *                 ray or linesegment defined by the other parameters.
		 */
		function getDistance(p:IPoint,
												 z1:IPoint, z2:IPoint,
												 cutoff1:Boolean, cutoff2:Boolean):Number;

		/** 
		 * Returns the projection of point <code>p</code> on the line defined by
		 * the points <code>z1</code> and <code>z2</code>.
		 * 
		 * @param p The point to project.
		 * @param z1 A point on the line on which to project.
		 * @param z2 A point on the line on which to project.
		 * @return The projection.
		 */
		function getProjection(p:IPoint,
													 z1:IPoint, z2:IPoint,
													 cutoff1:Boolean, cutoff2:Boolean):IPoint;

		/** 
		 * Returns the angle between the line segments
		 * starting at <code>p</code> and ending in <code>z1</code>
		 * and <code>z2</code> respectively.<br>
		 * If the model is orientated, the angle may have a sign, but this is not required.
		 *
		 * @param p        The commong starting point of the two segments.
		 * @param z1       The end point of the first line segment.
		 * @param z2       The end point of the first line segment.
		 * @return         The angle of the hinge defined by the three parameters.
		 */
		function getAngle(p:IPoint, z1:IPoint, z2:IPoint):Number;

		/** 
		 * Returns the scalar product of the two vectors.<br>
		 * They have to have the same base point, otherwise, a computation is not possible.
		 * <code>NaN</code> is returned in this situation.
		 * 
		 * @param v1 A vector in the tangentspace of the model.
		 * @param v2 A vector in the tangentspace of the model.
		 * @return The scalar product of both vectors.
		 */
		function product(v1:IVector, v2:IVector):Number;
		
		/** 
		 * Returns the squared length of the vector.
		 * 
		 * @param v A vector in the tangent space of the model.
		 * @return The squared length of the vector.
		 */
		function length2(v:IVector):Number;
		
		/** 
		 * Returns the length of the vector.
		 * 
		 * @param v A vector in the tangent space of the model.
		 * @return The length of the vector.
		 */
		function length(v:IVector):Number;
		
		/**
		 * Calculates the exponent of the vector maintaining the same direction as the vector
		 * 
		 * @param	v the vector to use
		 * @param	length the new length
		 * @return new vector length as a complex number
		 */
		function exp(v:IVector, length:Number):IPoint;

		/**
		 * Computes the gradient at <code>basePoint</code> of the distance functions to
		 * <code>z</code>, i.e.
		 * <pre>
		 *       grad           d(*,z)
		 *           |basepoint
		 * </pre>
		 * or "grad_{|basepoint}d(\cdot,z)" in tex.
		 *
		 * @param base The base of the gradient
		 * @param z The end point of the gradient
		 * @return the resulting gradient vector
		 */
		function distanceGradient(base:IPoint, z:IPoint):IVector;
		
		/**
		 * Computes the gradient at <code>basePoint</code> of the distance functions to
		 * <code>z</code>, i.e.
		 * <pre>
		 *       grad           d(*,z)
		 *           |basepoint
		 * </pre>
		 * or "grad_{|basepoint}d(\cdot,z)" in tex.
		 *
		 * @param base The base of the gradient
		 * @param z The end point of the gradient
		 * @param gradient the resulting gradient vector
		 */
	  function distanceGradientV(base:IPoint, z:IPoint, gradient:IVector):void;
	}
}
