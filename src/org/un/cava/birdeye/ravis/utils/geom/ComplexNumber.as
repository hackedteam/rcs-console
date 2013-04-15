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
	 * Implements a complex number as a point and certain common
	 * methods for complex geometry.
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
	public class ComplexNumber implements IPoint {
		
		/** The real part of the complex number. */
		protected var _real:Number;
		/** The imaginary part of the complex number. */
		protected var _imag:Number;
		
	  /** A small number used while comparing two complex numbers */
    private const _EPSILON:Number = 1e-10;

		/**
		 * Returns <code>exp(it)</code>.
		 * 
		 * @param t The angle
		 * @return The complex number <code>exp(it)</code>
		 */
    public static function getRotation(t:Number):ComplexNumber {
		  return new ComplexNumber(Math.cos(t), Math.sin(t));
    }
		
    /** 
		 * Creates a complex number with the given real and imaginary part.
		 * 
     * @param r The real part of the complex number.
     * @param i The imaginary part of the complex number.
     */
    public function ComplexNumber(r:Number = 0, i:Number = 0) {
			_real = r;
			_imag = i;
    }

		/** @inheritDoc */
    public function setTo(p:IPoint):void {
    	if (p == null)
    		return;
			_real = (p as ComplexNumber).real;
    	_imag = (p as ComplexNumber).imag;
    }

		/** @inheritDoc */
    public function equals(z:Object):Boolean {
    	return ( (Math.abs((z as ComplexNumber).real - _real) < _EPSILON) &&
    			     (Math.abs((z as ComplexNumber).imag - _imag) < _EPSILON) );
    }

    /**
     * Returns an array of to doubles,
     * the first is the real part, the second the imaginary part.
		 * 
     * @return The complex number as array.
     */
    public function toArray():Array {
			var array:Array = [_real, _imag];
			return array;
    }
		
    /** 
		 * Sets the real part of the complex number.
		 * 
     * @param r The new real part.
     */
    public function set real(r:Number):void {
    	_real = r;
    }
		
    /** 
		 * Returns the real part of the complex number.
		 * 
     * @return The real part of the complex number. 
		 */
    public function get real():Number {
		  return _real;
    }
		
		/** 
		 * Sets the imaginary part of the complex number.
		 * 
		 * @param i The new imaginary part.
		 */
    public function set imag(i:Number):void {
    	_imag = i;
    }
		
		/** 
		 * Returns the imaginary part of the complex number.
		 * 
	   * @return The imaginary part of the complex number. 
		 */
    public function get imag():Number {
			return _imag;
    }
		
    /** 
		 * Returns the radiant of a complex number.
		 * 
     * @return The radiant of the complex number.
     */
    public function getRad():Number {
			var r:Number = Math.acos(_real / norm());
			if (_imag < 0)
					r = -r;
			return r;
    }
		
    /** 
		 * Adds a real number to the complex number.
		 * 
     * @param x The real number to be added.
     */
    public function addR(x:Number):void {
			_real += x;
    }
		
		/** 
		 * Adds a complex number to this complex number.
		 * 
		 * @param v The complex number to be added.
		 */
    public function addC(v:ComplexNumber):void {
			_real += v.real;
			_imag += v.imag;
    }
		
		/** 
		 * Subtracts a complex number from this complex number.
		 * 
		 * @param v The complex number to be subtracted.
		 */
		public function subtractC(v:ComplexNumber):void {
			_real -= v.real;
			_imag -= v.imag;
    }
		
		/** 
		 * Multiplies a real number with this complex number.
		 * 
		 * @param r The real factor.
		 */
    public function multiplyF(r:Number):void {
			_real *= r;
			_imag *= r;
    }
		
		/** 
		 * Multiplies a complex number with this complex number.
		 * 
		 * @param v The complex factor.
		 */
    public function multiplyC(v:ComplexNumber):void {
			var r:Number = _real * v.real - _imag * v.imag;
			_imag = _real * v.imag + _imag * v.real;
			_real = r;
    }
		
    /** 
		 * Sets this complex number to its reciprocal. 
		 * */
    public function reciprocal():void {
			_imag = -_imag;
			var n:Number = norm2();
			divideF(n);
    }
		
    /** 
		 * Returns the reciprocal of <code>this</code>.
		 * 
     * @return A new complex that is the reciprocal of <code>this</code>.
     */
    public function getReciprocal():ComplexNumber {
			var z:ComplexNumber = (clone() as ComplexNumber);
			z.reciprocal();
			return z;
    }
		
    /** 
		 * Divides the complex number by a real number.
		 * 
     * @param r The divisor.
     */
    public function divideF(r:Number):void {
			_real /= r;
			_imag /= r;
    }
		
		/** 
		 * Divides the complex number by another complex number.
		 * 
		 * @param z The divisor.
		 */
    public function divideC(z:ComplexNumber):void {
			z.conjugate();
			multiplyC(z);
			z.conjugate();
			divideF(z.norm2());
    }
		
    /** 
		 * Conjugates the complex number (negates the imaginary part.)
		 */
    public function conjugate():void {
			_imag = -_imag;
    }
		
    /** 
		 * Normalizes the complex number so that it's length is 1.
		 */
    public function normalize():void {
			multiplyF(1 / norm());
    }
		
    /** 
		 * Return the distance from <code>this</code> to 
		 * a complex number <code>z</code>.
		 * 
     * @param z Another complex number.
     * @return The distance from this complex number to <code>z</code>.
     */
    public function dist(z:ComplexNumber):Number {
			if (z == null) {
				throw Error("ComplexNumber: Attempted to find distance from a null point");
				return Number.NaN;
			}
			return Math.sqrt((_real - z.real) * (_real - z.real) + (_imag - z.imag) * (_imag - z.imag));
    }
		
    /** 
		 * Return the squared distance from <code>this</code> to 
		 * a complex number <code>z</code>.
		 * 
     * @param z Another complex number.
     * @return The squared distance from this complex number to <code>z</code>.
     */
    public function dist2(z:ComplexNumber):Number {
    	if (z == null) {
				throw Error("ComplexNumber: Attempted to find squared distance from a null point");
    		return Number.NaN;
			}
			return (_real - z.real) * (_real - z.real) + (_imag - z.imag) * (_imag - z.imag);
    }
		
		/** 
		 * Return the squared norm of the complex number.
		 * 
		 * @return The squared norm of the complex number.
		 */
    public function norm2():Number {
			return _real * _real + _imag * _imag;
    }
		
		/** 
		 * Return the norm of the complex number.
		 * 
		 * @return The norm of the complex number.
		 */
    public function norm():Number {
			return Math.sqrt(_real * _real + _imag * _imag);
    }
		
		/** 
		 * Return the euclidian scalar product of the complex number and another complex number.
		 * 
		 * @param z Another complex number.
		 * @return The euclidian scalar product of the two complex numbers.
		 */
    protected function scalarProduct(z:ComplexNumber):Number {
			return _real * z.real + _imag * z.imag;
    }
		
		/** @inheritDoc */
		public function clone():Object {
			return new ComplexNumber(_real, _imag);
		}
		
		/** @inheritDoc */
    public function toString():String {
			return _real + " + i*" + _imag;
    }
	}
}
