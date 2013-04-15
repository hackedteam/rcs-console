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
	 * This class implements IIsometry for the Poincare hyperbolic model.
	 * The two end points A and C of this isometry are <code>ComplexNumber</code>s
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
	public class PoincareIsometry implements IIsometry {

		private var _a:ComplexNumber; // The point A
		private var _c:ComplexNumber; // The point C
		
		// TEMPORARY VARIABLES - to speed-up computations
		private	var t_z:ComplexNumber = new ComplexNumber();
		
		/**
		 * Constructs an isometry for the Poincare model
		 * 
		 * @param	ar The real part of point A
		 * @param	ai The imaginary part of point A
		 * @param	cr The real part of point C
		 * @param	ci The imaginary part of point C
		 */
		public function PoincareIsometry(ar:Number = 0, ai:Number = 0, cr:Number = 0, ci:Number = 0) {
			_a = new ComplexNumber(ar, ai);
			_c = new ComplexNumber(cr, ci);
		}
		
    /** 
		 * Sets point A (Complex Number) of the Isometry.
		 * 
     * @param a The new point A.
     */
    public function set a(a:ComplexNumber):void {
    	_a = a;
    }
		
    /** 
		 * Returns point A (Complex Number) of the Isometry.
		 * 
     * @return point A - a complex number. 
		 */
    public function get a():ComplexNumber {
		  return _a;
    }
		
    /** 
		 * Sets point C (Complex Number) of the Isometry.
		 * 
     * @param c The new point C.
     */
    public function set c(c:ComplexNumber):void {
    	_c = c;
    }
		
    /** 
		 * Returns point C (Complex Number) of the Isometry.
		 * 
     * @return point C - a complex number. 
		 */
    public function get c():ComplexNumber {
		  return _c;
    }
		
		/** @inheritDoc */
		public function setToIdentity():void {
			_a.real = 1;
			_a.imag = 0;
			_c.real = 0;
			_c.imag = 0;
		}
		
		/** @inheritDoc */
		public function multiplyRight(isometry:IIsometry):void { // this = this*isometry
			var m:PoincareIsometry = (isometry as PoincareIsometry);
		
			var ar:Number = m.a.real*_a.real - m.a.imag*_a.imag + m.c.real*_c.real + m.c.imag*_c.imag;
			var ai:Number = m.a.real*_a.imag + m.a.imag*_a.real - m.c.real*_c.imag + m.c.imag*_c.real;
			var cr:Number = m.a.real*_c.real - m.a.imag*_c.imag + m.c.real*_a.real + m.c.imag*_a.imag;
			var ci:Number = m.a.real*_c.imag + m.a.imag*_c.real - m.c.real*_a.imag + m.c.imag*_a.real;
			
			_a.real = ar;
			_a.imag = ai;
			_c.real = cr;
			_c.imag = ci;
		}
		
		/** @inheritDoc */
		public function multiplyLeft(isometry:IIsometry):void { // this = isometry * this
			var temp:PoincareIsometry = isometry.clone() as PoincareIsometry;
			temp.multiplyRight(this);
			_a = temp.a.clone() as ComplexNumber;
			_c = temp.c.clone() as ComplexNumber;
		}
		
		/** @inheritDoc */
		public function applyToPoint(mp1:IPoint):void {
			if (mp1==null)
				return;
				
			// Multiplication of the isometry with mp1, 
			// which has to be a ComplexNumber number, is given by :
			// a * mp1 + conjugate of c
			// ------------------------
			// c * mp1 + conjugate of a
			
			// Division	of a complex number z by another complex number w is given by :
			// z/w = z*conjugate of w / norm(w)^2
			
			// Re(z)*Re(w)+Im(z)*Im(w)  +  i*( -Re(z)*Im(w)+Im(z)*Re(w) )
			// ---------------------------------------------------------
			//			Re(w)*Re(w)  +  Im(w)*Im(w)
			
			var zr:Number = _a.real*(mp1 as ComplexNumber).real - _a.imag*(mp1 as ComplexNumber).imag + _c.real;
			var zi:Number = _a.real*(mp1 as ComplexNumber).imag + _a.imag*(mp1 as ComplexNumber).real - _c.imag;
			var wr:Number = _c.real*(mp1 as ComplexNumber).real - _c.imag*(mp1 as ComplexNumber).imag + _a.real;
			var wi:Number = _c.real*(mp1 as ComplexNumber).imag + _c.imag*(mp1 as ComplexNumber).real - _a.imag;
			
			var n2:Number = wr*wr + wi*wi;
			
			(mp1 as ComplexNumber).real = (zr*wr + zi*wi) / n2 ;
			(mp1 as ComplexNumber).imag = (-zr*wi + zi*wr) / n2 ;
		}
		
		/** @inheritDoc */
		public function applyToVector(vector:IVector):void {
			/*
			 * Multiplication of the isometry with mp1, 
			 * which has to be a ComplexNumber number, is given by :
			 *     a * mp1 + conjugate of c
			 *   = ------------------------
			 *     c * mp1 + conjugate of a
			 */
			
			var v:ComplexVector = (vector as ComplexVector);
			
			t_z.setTo(_c);
			t_z.multiplyC((v.base as ComplexNumber));
			_a.conjugate();
			t_z.addC(_a);
			_a.conjugate();
			
			t_z.multiplyC(t_z);
			t_z.reciprocal();
			t_z.multiplyF(_a.norm2() - _c.norm2());
			
			(v.dir as ComplexNumber).multiplyC(t_z);
			applyToPoint(v.base);
		}

		/** @inheritDoc */
		public function getInverse():IIsometry {
			return new PoincareIsometry(_a.real, -_a.imag, -_c.real, -_c.imag);
		}
		
		/** @inheritDoc */
		public function invert():void {
			_a.imag = -_a.imag;
			_c.real = -_c.real;
			_c.imag = -_c.imag;
		}

		/** @inheritDoc */
		public function setTo(isom:IIsometry):void {
			_a.real = (isom as PoincareIsometry).a.real;
			_a.imag = (isom as PoincareIsometry).a.imag;
			_c.real = (isom as PoincareIsometry).c.real;
			_c.imag = (isom as PoincareIsometry).c.imag;
		}
		
		/** @inheritDoc */
		public function equals(obj:Object):Boolean {
			return _a.equals((obj as PoincareIsometry).a) 
			    && _c.equals((obj as PoincareIsometry).c);
		}
		
		/** @inheritDoc */
		public function clone():Object {
			return new PoincareIsometry(_a.real, _a.imag, _c.real, _c.imag);
		}
		
		/** @inheritDoc */
		public function toString():String {
			return "( " + a + " ; " + c + " )";
		}
	}
}