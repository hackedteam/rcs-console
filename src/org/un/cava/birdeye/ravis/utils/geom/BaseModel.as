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
	 * This class provides a skeleton implementation of the <code>Model</code> interface
	 * to minimize the effort to implement a new model. It provides implementation
	 * of isometry providing methods such as those for rotation and translation.<br>
	 * 
	 * Other methods for computing distance, projection, and gradient are no-ops.<br>
	 * 
	 * For a given model, it is usually more efficient to implement the isometry
	 * providing methods directly.
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
	public class BaseModel implements IModel {
		
		// TEMPORARY VARIABLES - to speed-up computations
		protected var t_isom1:IIsometry = getIdentity();
		protected var t_isom2:IIsometry = getIdentity();
		protected var t_z1:IPoint = getOrigin();
		
		/** @inheritDoc <br>
		 * 
		 * The implementation uses method <code>getRotation(Number)</code>, because
		 * a rotation of 0 degree around any point is the identity transformation.
		 */
		public function getIdentity():IIsometry {
			return getRotation(0);
		}
		
		/** @inheritDoc <br>
		 * 
		 * The implementation builds the isometry using methods <code>getRotation(Number)</code>,
		 * <code>getTranslationP(IPoint)</code> and <code>Isometry#invert()</code>, i.e.
		 * it conjugates <code>getRotation(Number)</code>.
		 */
		public function getRotationP(mp:IPoint, alpha:Number):IIsometry {
			var translation1:IIsometry = getTranslationP(mp);
			var translation3:IIsometry = (translation1.clone() as IIsometry);
			
			translation1.invert();

			translation3.multiplyRight(getRotation(alpha));
			translation3.multiplyRight(translation1);

			return translation3;
		}

		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIP(IIsometry, IPoint)</code>.
		 */
		public function getTranslationP(mp1:IPoint):IIsometry {
			var isom:IIsometry = getIdentity();
			getTranslationIP(isom, mp1);
			return isom;
		}
		
		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIPR(IIsometry, IPoint, Number)</code>.
		 */
		public function getTranslationIP(isom:IIsometry, mp1:IPoint):void {
			getTranslationIPR(isom, mp1, 1);
		}
		
		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIPP(IIsometry, IPoint, IPoint)</code>.
		 */
		public function getTranslationPP(mp1:IPoint, mp2:IPoint):IIsometry {
			var isom:IIsometry = getIdentity();
			getTranslationIPP(isom, mp1, mp2);
			return isom;
		}

		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIPPR(IIsometry, IPoint, IPoint, Number)</code>.
		 */
		public function getTranslationIPP(isom:IIsometry, mp1:IPoint, mp2:IPoint):void {
			getTranslationIPPR(isom, mp1, mp2, 1);
		}
		
		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIPR(IIsometry, IPoint, Number)</code>.
		 */
		public function getTranslationPR(mp:IPoint, t:Number):IIsometry {
			var isom:IIsometry = getIdentity();
			getTranslationIPR(isom, mp, t);
			return isom;
		}

		/** @inheritDoc <br>
		 * 
		 * The implementation builds the isometry using methods <code>getTranslationPR(IPoint, Number)</code>,
		 * <code>getTranslationP(IPoint)</code> and <code>Isometry#invert()</code>, i.e.
		 * it conjugates <code>getRotation(double)</code>.
		 * 
		 * Calls <code>getTranslationIPPR(IIsometry, IPoint, IPoint, Number)</code>.
		 */
		public function getTranslationPPR(mp1:IPoint, mp2:IPoint, t:Number):IIsometry {
			var isom:IIsometry = getIdentity();
			getTranslationIPPR(isom, mp1, mp2, t);
			return isom;
		}
		
		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIP(IIsometry, IPoint)</code> and 
		 * <code>getTranslationIPR(IIsometry, IPoint, Number)</code>
		 */
		public function getTranslationIPPR(isom:IIsometry, mp1:IPoint, mp2:IPoint, t:Number):void {
			t_z1.setTo(mp2);
			getTranslationIP(t_isom1, mp1);
			isom.setTo(t_isom1);
			t_isom1.invert();

			t_isom1.applyToPoint(t_z1);

			getTranslationIPR(t_isom2, t_z1, t);

			t_isom2.multiplyRight(t_isom1);
			isom.multiplyRight(t_isom2);
		}
		
		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIVR(IIsometry, IVector, Number)</code>
		 */
		public function getTranslationVR(vector:IVector, t:Number):IIsometry {
			var isom:IIsometry = getIdentity();
			getTranslationIVR(isom, vector, t);
			return isom;
		}
		
		/** @inheritDoc <br>
		 * 
		 * Calls <code>getTranslationIPP(IIsometry, IPoint, IPoint)</code>.
		 */
		public function getTranslationIVR(isom:IIsometry, vector:IVector, t:Number):void {
			getTranslationIPP(isom, vector.base, exp(vector, t));
		}
		
		/* 
		 * Obviously, one of the dist and dist2 functions has to be overwritten
		 * It's usually dist2(...)
		 */
		
		/** @inheritDoc <br>
		 */
		public function dist2(z:IPoint):Number {
			var d:Number = dist(z);
			return d * d;
		}
		
		/** @inheritDoc <br>
		 */
		public function dist(z:IPoint):Number {
			return Math.sqrt(dist2(z));
		}
		
		/** @inheritDoc <br>
		 */
		public function distP(mp1:IPoint, mp2:IPoint):Number {
			return Math.sqrt(distP2(mp1, mp2));
		}
		
		/** @inheritDoc <br>
		 */
		public function distP2(mp1:IPoint, mp2:IPoint):Number {
			var d:Number = distP(mp1, mp2);
			return d * d;
		}
		
		/** @inheritDoc <br>
		 */
		public function length2(v:IVector):Number {
			return product(v, v);
		}
		
		/** @inheritDoc <br>
		 */
		public function length(v:IVector):Number {
			return Math.sqrt(length2(v));
		}
		/**************************************************************************
		 ***        FOLLOWING METHODS MUST BE IMPLEMENTED BY SUBCLASSES         ***
		 **************************************************************************/
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
    public function getOrigin():IPoint {
			return null;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function getDefaultVector():IVector {
			return null;
		}
		 
		/** @inheritDoc <br>
		 * Sub-classes should override this to 
		 * define the respective <code>IIsometry</code>.
		 */
		public function getRotation(alpha:Number):IIsometry {
			/* NOP */
			return null;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function exp(v:IVector, length:Number):IPoint {
			return null;
		}

		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function product(v1:IVector, v2:IVector):Number{
			return 0;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function getDistance(p:IPoint,
															  z1:IPoint, z2:IPoint,
															  cutoff1:Boolean, cutoff2:Boolean):Number {
			return 0;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function getProjection(p:IPoint,
																  z1:IPoint, z2:IPoint,
																  cutoff1:Boolean, cutoff2:Boolean):IPoint {
			return null;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function getAngle(p:IPoint, z1:IPoint, z2:IPoint):Number {
			return 0;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
		public function distanceGradient(base:IPoint, z:IPoint):IVector {
			return null;
		}
		
		/** @inheritDoc <br>
		 * NOP: Subclasses must implement this method */
	  public function distanceGradientV(base:IPoint, z:IPoint, gradient:IVector):void {
		}
		
		/** @inheritDoc <br>
		 * Sub-classes should override this method to with the specific 
		 * <code>IIsometry</code> implementation.
		 */
		public function getTranslationIPR(isom:IIsometry, mp1:IPoint, r:Number):void {
			/* NOP */
		}
	}
}
