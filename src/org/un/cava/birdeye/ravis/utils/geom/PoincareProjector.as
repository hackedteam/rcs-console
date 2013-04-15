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
import org.un.cava.birdeye.ravis.utils.GraphicUtils;
import org.un.cava.birdeye.ravis.graphLayout.layout.Hyperbolic2DLayouter;

	/**
	 * This class implements the IProjector, using Poincare model to map 
	 * points in Display Geometry (Screen) to those in Non-Euclidean Space 
	 * (Hyperbolic Geometry). Other functions that help in animation are
	 * also defined.
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
	public class PoincareProjector implements IProjector {
		
		private	var _viewMatrix:IIsometry;
		private	var _inverseViewMatrix:IIsometry;
		private var _model:PoincareModel;
		
		// TEMPORARY VARIABLES - to speed-up computations
		private var t_z:IPoint = new ComplexNumber();
		private var t_z1:ComplexNumber;
		
		private var t_p1:IPoint;
		private var t_p2:IPoint;
		private var t_i:IIsometry;
		/**
		 * Constructor of PoincareProjector
		 * @param The Poincare model
		 * */
		public function PoincareProjector(model:IModel):void {
			_model = model as PoincareModel;
			_inverseViewMatrix = _model.getIdentity();
			_viewMatrix = _model.getIdentity();
		}
		
		/**
		 * Returns the arc between two model points mp1 and mp2 
		 * as piecewise linear segments.
		 * <p><b> NOT USED ANYMORE </b></p>
		 * @deprecated
		 * @see getCenter(...)
		 */
		public function getLineSegments(mp1:IPoint, mp2:IPoint, d:DisplayObject):Array { //Point
			var lineSegments:Array; /*Point*/
			t_z1 = mp1 as ComplexNumber;
			
			_viewMatrix.applyToPoint(mp1);
			_viewMatrix.applyToPoint(mp2);
			if (t_z1.dist(mp2 as ComplexNumber) < 0.1 ) {
				lineSegments = new Array(2); //Point[2];
				lineSegments[0] = map(mp1, d);
				lineSegments[1] = map(mp2, d);
				return lineSegments;
			}

			var n:int = 10;
			if (t_z1.dist(mp2 as ComplexNumber) > 1)
				n = 30;
			lineSegments = new Array(n + 1); /* Point */
			lineSegments[0] = map(t_z1, d);
			t_i = _model.getTranslationPPR(mp1, mp2, 1 / n);
			var i:int;
			for (i = 1; i < n + 1; i++) {
				t_i.applyToPoint(t_z1);
				lineSegments[i] = map(t_z1, d);
			}
			return lineSegments;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function getCenter(x1:Number, y1:Number,
															x2:Number, y2:Number, d:DisplayObject):Point {
			var rtnX:Number, rtnY:Number;
			var c:Number = Math.min(d.width / 2, d.height / 2);
			var r1:Number = x1 * x1 + y1 * y1 - c * c;
			var r2:Number = x2 * x2 + y2 * y2 - c * c;
			var dr:Number = 2 * ( (x1 - d.width/2) * (y2 - d.height/2) - (x2 - d.width/2) * (y1 - d.height/2) );
			if (dr != 0) {
				rtnX = ( (y2 - d.height/2) * r1 - (y1 - d.height/2) * r2 ) / dr;
				rtnY = - ( (x2 - d.width/2) * r1 - (x1 - d.width/2) * r2 ) / dr;
				return new Point(rtnX, rtnY);
			} else {// a diameter
				return null;
			}
		}
		
		/**
		 * Returns a sequence of steps to move a point p (Display) to the centre of 
		 * the display object d.
		 * 
		 * @param p Point to be moved
		 * @param d The display object
		 * @param oneStep A flag to indicate if the move will be a single step
		 * or a series of steps
		 * @return An array of steps for the move
		 * */
		public function center(p:Point, d:DisplayObject, oneStep:Boolean):Array {
			return move(p, GraphicUtils.getCenter(d), d, oneStep);
		}
		
		/**
		 * Returns a sequence of steps to move an IPoint ip (Poincare) to the centre of 
		 * the display object d.
		 * 
		 * @param ip IPoint to be moved
		 * @param d The display object
		 * @param oneStep A flag to indicate if the move will be a single step
		 * or a series of steps
		 * @return An array of steps for the move
		 * */
		public function centerP(ip:IPoint, d:DisplayObject, oneStep:Boolean):Array {
			return moveP(ip, GraphicUtils.getCenter(d), d, oneStep);
		}
		
		/**
		 * Returns a sequence of steps to move an IPoint ip1 (Poincare) to a point p2.
		 * 
		 * @param ip1 IPoint to be moved
		 * @param p2 End point to move to
		 * @param d The display object
		 * @param oneStep A flag to indicate if the move will be a single step
		 * or a series of steps
		 * @return An array of steps for the move
		 * */
		public function moveP(ip1:IPoint, p2:Point, d:DisplayObject, oneStep:Boolean):Array {
			t_p1 = ip1.clone() as IPoint;
			_viewMatrix.applyToPoint(t_p1);
			t_p2 = inverseMap(p2, d, false);
			if (t_p2 == null)
				return null;
			return moveSteps(t_p1, t_p2, d, oneStep);
		}
		
		/**
		 * Returns a sequence of steps to move a Point p1 to a point p2.
		 * 
		 * @param ip1 IPoint to be moved
		 * @param p2 End point to move to
		 * @param d The display object
		 * @param oneStep A flag to indicate if the move will be a single step
		 * or a series of steps
		 * @return An array of steps for the move
		 * */
		public function move(p1:Point, p2:Point, d:DisplayObject, oneStep:Boolean):Array {
			t_p1 = inverseMap(p1, d, false);
			if (t_p1 == null)
				return null;
			t_p2 = inverseMap(p2, d, false);
			if (t_p2 == null)
				return null;
			return moveSteps(t_p1, t_p2, d, oneStep);
		}
		
		/**
		 * @internal
		 * */
		private function moveSteps(mp1:IPoint, mp2:IPoint, d:DisplayObject, oneStep:Boolean):Array {
			if (_model.distP(mp1, mp2) < 0.01)
				return null;
			var n:int, i:int;
			if (oneStep)
				n = 1;
			else
				n = Hyperbolic2DLayouter.ANIMATION_STEPS;
			var viewMatrices:Array = new Array(n); //Isometry
			for (i = 0; i < viewMatrices.length; i++) {
				viewMatrices[i] = _model.getTranslationPPR(mp1, mp2, (i + 1) / n as Number);
				(viewMatrices[i] as IIsometry).multiplyRight(getViewMatrix());
			}
			return viewMatrices;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function project(mp:IPoint, d:DisplayObject):Point {
			t_z.setTo(mp);
			_viewMatrix.applyToPoint(t_z);
			return map(t_z, d);
		}
		
		/**
		 * @inheritDoc
		 * */
		public function unProject(p:Point, d:DisplayObject, adjustBadNodes:Boolean):IPoint {
			var rtn:IPoint = inverseMap(p, d, adjustBadNodes);
			_inverseViewMatrix.applyToPoint(rtn);
			return rtn;
		}

		/**
		 * @internal
		 * */
		private function map(mp:IPoint, d:DisplayObject):Point {
			t_z1 = mp as ComplexNumber;
			return new Point(Math.floor((t_z1.real + 1) * 0.5 * d.width), 
			                 Math.floor((1 - t_z1.imag) * 0.5 * d.height));
		}
		
		/**
		 * @internal
		 * */
		private function inverseMap(p:Point, d:DisplayObject, adjustBadNodes:Boolean):IPoint {
			var z:ComplexNumber = new ComplexNumber();
			if (d.width != 0)
				z.real = p.x * 2.0 / d.width - 1;
			if (d.height != 0)
				z.imag = 1 - p.y * 2.0 / d.height;
			if (z.norm2() >= 1.0) {
				//LogUtil.warn(_LOG, "Point " + p + " out of bounds");
				if (adjustBadNodes) {// Adjusting bad node to a valid node at the same orientation
					var angle:Number = Math.atan(Math.abs(z.imag / z.real));
					z.real = 0.8 * Math.cos(angle) * z.real / Math.abs(z.real) ;
					z.imag = 0.8 * Math.sin(angle) * z.imag / Math.abs(z.imag) ;
				} else {
					return null;
				}
			}
			return z;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function getScale(mp:IPoint):Point {
			t_z.setTo(mp);
			_viewMatrix.applyToPoint(t_z);
			var scale:Number = 1 - (t_z as ComplexNumber).norm2();
			return new Point(scale, scale);
		}
		
		/**
		 * @inheritDoc
		 * */
		public function getInverseViewMatrix():IIsometry {
			return _inverseViewMatrix;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function getViewMatrix():IIsometry {
			return _viewMatrix;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function setViewMatrix(vm:IIsometry):void {
			if (vm != null) {
				_viewMatrix = vm;
				_inverseViewMatrix = _viewMatrix.getInverse();
			} else {
				_viewMatrix = _model.getIdentity();
				_inverseViewMatrix = _model.getIdentity();
			}
		}
	}
}
