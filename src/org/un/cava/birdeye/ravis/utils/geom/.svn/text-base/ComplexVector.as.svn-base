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
	 * This is an implementation of the interface <code>IVector</code>
	 * for the complex plane, i.e. the base point is a complex number.
	 * Since the set of complex numbers is a real vector space,
	 * the direction is a complex number as well.
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
	public class ComplexVector implements IVector {
		
		/** The base point of the vector. */
		private var _base:ComplexNumber;
		
		/** The direction of the vector. */
		private var _dir:ComplexNumber;
		
		/**
		 * Constructor of ComplexVector
		 * 
		 * @param base The base of the vector
		 * @param dir The direction of the vector
		 * */
		public function ComplexVector(base:ComplexNumber = null, dir:ComplexNumber = null) {
			if (base == null)
				_base = new ComplexNumber();
			else
				_base = base;
			
			if (dir == null)
			  _dir = new ComplexNumber();
			else
			  _dir = dir;
		}

		/** @inheritDoc */
		public function set base(base:IPoint):void {
			_base = (base as ComplexNumber);
			_dir = new ComplexNumber();
		}
		
		/** @inheritDoc */
		public function get base():IPoint {
			return _base;
		}
		
		/** @inheritDoc */
		public function get dir():IPoint {
			return _dir;
		}
		
		/** @inheritDoc */
		public function scale(r:Number):void {
			_dir.real *= r;
			_dir.imag *= r;
		}
		
		/** @inheritDoc */
		public function setTo(v:IVector):void {
			_base.real = ((v as ComplexVector).base as ComplexNumber).real;
			_base.imag = ((v as ComplexVector).base as ComplexNumber).imag;
			_dir.real = ((v as ComplexVector).dir as ComplexNumber).real;
			_dir.imag = ((v as ComplexVector).dir as ComplexNumber).imag;
		}
		
		/** @inheritDoc */
		public function clone():Object {
			return new ComplexVector((_base.clone() as ComplexNumber), 
															 (_dir.clone() as ComplexNumber) );
	  }

		/** @inheritDoc */
		public function toString():String {
			return "(" + _base + "; " + _dir + ")";
		}
	}
}