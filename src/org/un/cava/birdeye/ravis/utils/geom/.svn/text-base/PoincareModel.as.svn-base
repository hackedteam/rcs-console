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
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This class implements the Poincare model, which is used for 
	 * Hyperbolic (Non-Euclidean) layout.
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
	public class PoincareModel extends BaseModel {
		
		private static const _LOG:String = "utils.geom.PoincareModel";
		
		// TEMPORARY VARIABLES - to speed-up computations
		private var t_v1:ComplexVector = new ComplexVector();
		
		/**
		 * Constructor for the Poincare Model
		 */
		public function PoincareModel():void {
			// Empty Constructor
		}

		/** @inheritDoc <br>
		 */
		override public function getOrigin():IPoint {
			return new ComplexNumber();
		}
		
		/** @inheritDoc <br>
		 */
		override public function getIdentity():IIsometry {
			return new PoincareIsometry(1);
		}
		
		/** @inheritDoc <br>
		 */
		override public function getRotation(alpha:Number):IIsometry {
			return new PoincareIsometry(Math.cos(alpha / 2), Math.sin(alpha / 2));
		}
		
		/** @inheritDoc <br>
		 */
		override public function getTranslationIPR(isom:IIsometry, mp:IPoint, t:Number):void {
			var z:ComplexNumber = (mp as ComplexNumber);
			var d:Number = 1;
			
			if ( Math.abs(t-1.0) > 0.01) {
				d = dist(z) * t;
				d = (Math.exp(d)-1) / (Math.exp(d)+1);
				d = d / z.norm();
			}
			
			((isom as PoincareIsometry).a as ComplexNumber).real = 1;
			((isom as PoincareIsometry).a as ComplexNumber).imag = 0;
			((isom as PoincareIsometry).c as ComplexNumber).real = z.real * d;
			((isom as PoincareIsometry).c as ComplexNumber).imag = -z.imag * d;
		}
		
		/** @inheritDoc <br>
		 */
		override public function getDistance(p:IPoint,
																				 z1:IPoint, z2:IPoint,
																				 cutoff1:Boolean, cutoff2:Boolean):Number {
			return distP(p, getProjection(p, z1, z2, cutoff1, cutoff2));
		}

		/** @inheritDoc <br>
		 */
		override public function getAngle(p:IPoint, z1:IPoint, z2:IPoint):Number {
			var d1:Number = distP(p, z1);
			if (d1 == 0)
				return 0;
			var d2:Number = distP(p, z2);
			if (d2 == 0)
				return 0;
			var d3:Number = distP(z1, z2);
			if (d3 == 0)
				return 0;
			var cos:Number = (Geometry.cosh(d1) * Geometry.cosh(d2) - Geometry.cosh(d3))
						/ (Geometry.sinh(d1) * Geometry.sinh(d2));
			if (cos > 1)
				cos = 1;
			if (cos < -1)
				cos = -1;
			var angle:Number = Math.acos(cos);
			return angle;
		}

		/** @inheritDoc <br>
		 */
		override public function getProjection(p:IPoint, 
																					 z1:IPoint, z2:IPoint,
																					 cutoff1:Boolean, cutoff2:Boolean):IPoint {
			var alpha:Number = getAngle(z1, p, z2);
			var z:IPoint;
			var t:Number;
			if (Math.abs(alpha) > 1e-7) {
				t = Geometry.arsinh(Geometry.sinh(distP(z1, p)) * Math.sin(alpha));
				var s:Number = Geometry.arcosh(Geometry.cosh(distP(p, z1)) / Geometry.cosh(t));
				
				var p1:IPoint = (z1.clone() as IPoint);
				getTranslationPPR(z1, z2, s / distP(z1, z2)).applyToPoint(p1);
				
				var p2:IPoint = (z1.clone() as IPoint);
				getTranslationPPR(z1, z2, -s / distP(z1, z2)).applyToPoint(p2);
				
				if (distP(p, p1) > distP(p, p2))
					z = p2;
				else
					z = p1;
			} else {
				z = p;
			}
			// if projection to whole, infinite line :
			if (!cutoff1 && !cutoff2)
				return z;
			// projection z between z1 and z2 :
			if (getAngle(z, z1, z2) > Math.PI / 2)
				return z;
			if (distP(z, z1) < distP(z, z2))
				if (cutoff1)
					return z1;
				else
					return z;
			else
				if (cutoff2)
					return z2;
				else
					return z;
		}
		
		/** @inheritDoc <br>
		 */
		override public function dist(z:IPoint):Number {
			var r:Number = (z as ComplexNumber).norm();
			return Math.log((1 + r) / (1 - r));
		}

		/** @inheritDoc <br>
		 */
		override public function distP(mp1:IPoint, mp2:IPoint):Number {
			var xr:Number = (mp1 as ComplexNumber).real;
			var xi:Number = (mp1 as ComplexNumber).imag;
			var yr:Number = (mp2 as ComplexNumber).real;
			var yi:Number = (mp2 as ComplexNumber).imag;
			var dx:Number = xr - yr;
			var dy:Number = xi - yi;
			var b1:Number = 1 - xr * yr - xi * yi;
			var b2:Number = xr * yi - xi * yr;
			var  r:Number = Math.sqrt((dx * dx + dy * dy) / (b1 * b1 + b2 * b2));
			return Math.log((1 + r) / (1 - r));
		}
		
		/** @inheritDoc <br>
		 */
		override public function length2(v:IVector):Number {
			var basePt:ComplexNumber = ((v as ComplexVector).base as ComplexNumber);
			var dirPt:ComplexNumber = ((v as ComplexVector).dir as ComplexNumber);
			
			var n2:Number = dirPt.real * dirPt.real  +  dirPt.imag * dirPt.imag;
			var baseN2:Number = basePt.real * basePt.real +  basePt.imag * basePt.imag;
			
			var scale:Number = 2 / (1 - baseN2);
			return scale * scale * n2;
		}
		
		/** @inheritDoc <br>
		 */
		override public function length(v:IVector):Number {
			return Math.sqrt(length2(v));
		}

		/** @inheritDoc <br>
		 */
		override public function product(v1:IVector, v2:IVector):Number {
			if (v1.base.equals(v2.base)) {
				var scale:Number = 2 / (1 - ((v1 as ComplexVector).base as ComplexNumber).norm2());
				var dirPt1:ComplexNumber = ((v1 as ComplexVector).dir as ComplexNumber);
				var dirPt2:ComplexNumber = ((v2 as ComplexVector).dir as ComplexNumber);
				
				return scale * scale * (dirPt1.real * dirPt2.real  +  dirPt1.imag * dirPt2.imag);
			} else {
				throw Error("PoincareModel: Product received two vectors with different base!");
				return Number.NaN;
			}
		}

		/** @inheritDoc <br>
		 */
		override public function exp(vector:IVector, length:Number):IPoint {
		// First compute exp at 0 and than use an isometry (isom) to move the result.
		// The pullback isom^*(v) has the same direction as v 
		// but a different length( as a complex number )
			var v:ComplexVector = (vector as ComplexVector) ;
			if ( (v.dir as ComplexNumber).norm2() == 0)
				return vector.base.clone() as IPoint;

			var result:ComplexNumber;
			var t:Number;
			
			t = Math.exp( length );
			t = (t-1) / (t+1);
			
			result = v.dir.clone() as ComplexNumber;
			result.multiplyF(t / (v.dir as ComplexNumber).norm());
			// at this point, result contains exp at 0
			
			getTranslationIP(t_isom1, v.base);
			t_isom1.applyToPoint(result);
			return result;	
		}
		
		/** @inheritDoc <br>
		 */
		override public function getDefaultVector():IVector {
			return new ComplexVector(new ComplexNumber(),
															 new ComplexNumber(0.5,0));
		}
		
		/** @inheritDoc <br>
		 */
		override public function distanceGradientV(base:IPoint, z:IPoint, gradient:IVector):void {
			
			(t_isom1 as PoincareIsometry).a.real = 1;
			(t_isom1 as PoincareIsometry).a.imag = 0;
			(t_isom1 as PoincareIsometry).c.real = -(base as ComplexNumber).real;
			(t_isom1 as PoincareIsometry).c.imag = (base as ComplexNumber).imag;
			
			(t_z1 as ComplexNumber).real = (z as ComplexNumber).real;
			(t_z1 as ComplexNumber).imag = (z as ComplexNumber).imag;
			
			t_isom1.applyToPoint(t_z1);
			
			var length:Number = 2 * (t_z1 as ComplexNumber).norm();
			/*
			var length:Number = 2 * Math.sqrt(
					(t_z1 as ComplexNumber).real * (t_z1 as ComplexNumber).real  
			 +  (t_z1 as ComplexNumber).imag * (t_z1 as ComplexNumber).imag );
			*/
			// DEBUG - CHECK:
			if (length == 0.0) {
				LogUtil.warn(_LOG, "distanceGradientV(): Gradient Vector not defined...");
				LogUtil.warn(_LOG, "  Positions are " + base + " & " + z);
			}
			
			(t_v1.base as ComplexNumber).real = 0;
			(t_v1.base as ComplexNumber).imag = 0;
			(t_v1.dir as ComplexNumber).real = - (t_z1 as ComplexNumber).real / length; 
			(t_v1.dir as ComplexNumber).imag = - (t_z1 as ComplexNumber).imag / length; 
			
			(t_isom2 as PoincareIsometry).a.real = 1;
			(t_isom2 as PoincareIsometry).a.imag = 0;
			(t_isom2 as PoincareIsometry).c.real = (base as ComplexNumber).real;
			(t_isom2 as PoincareIsometry).c.imag = -(base as ComplexNumber).imag;
			
			t_isom2.applyToVector(t_v1);
			gradient.setTo(t_v1);
		}
		
		/** @inheritDoc <br>
		 */
		override public function distanceGradient(base:IPoint, z:IPoint):IVector {
			var gradient:IVector = new ComplexVector();
			distanceGradientV(base, z, gradient);
			return gradient;
		}
	}
}
