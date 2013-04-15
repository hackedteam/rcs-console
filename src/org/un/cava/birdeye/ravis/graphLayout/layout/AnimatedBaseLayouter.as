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
package org.un.cava.birdeye.ravis.graphLayout.layout {

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent;
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.GraphicUtils;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This subclass to the BaseLayouter encapsulates the methods
	 * for animation, since they are typically common in layouters.
	 * */
	public class AnimatedBaseLayouter extends BaseLayouter implements ILayoutAlgorithm {

		private static const _LOG:String = "graphLayout.layout.AnimatedBaseLayouter";
		
		/**
		 *  @internal
		 * Constant to define how often to redraw the node renderers during a redraw.  It
		 * says update the node renderers everything X'th animation step. This is a performance
		 * optimization for diagrams with complicated node renderers 
		 */ 
		private const _ANIMREFRESHINTERVAL:Number = 5;
		/**
		 * constant to define the radial animation type, which
		 * interpolates node's polar coordinates.
		 * */
		public const ANIM_RADIAL:int = 1;
		
		/**
		 * constant to define the radial animation type, which
		 * interpolates node's polar coordinates.
		 * */
		public const ANIM_STRAIGHT:int = 2;
		
		/**
		 * @internal
		 * The amount of interpolation steps for the animation.
		 * 100 seems reasonable. The interpolation will be 
		 * broken into exactly that amount of steps.
		 * */
		private const _ANIMATIONSTEPS:int = 50;
		
		/**
		 * @internal
		 * The timing of the animation steps is done using the arctan()
		 * function, to achieve a slow-in-slow-out effect. The input to the
		 * arctan() function is a range of the negative of this value
		 * to the positive of this value. The larger the interval, the
		 * longer the slow-in and slow-out part of the animation.
		 * We keep it rather short.
		 * */
		private const _ANIMATIONTIMINGINTERVALSIZE:Number = 10; // -4 ; 4
		
		/**
		 * @internal
		 * This is the maximum timer delay for each animation step.
		 * The animation steps will be timed between 0 ms
		 * and this value in ms. This value will be multiplied with the
		 * result of the current steps fraction of the timing interval
		 * (see above) to trigger the next animation step
		 * */
		private const _MAXANIMTIMERDELAY:int = 100;

		/**
		 * Indicator if there is currently an animation in progress
		 * */
		protected var _animInProgress:Boolean = false;

		private var _animationType:int = ANIM_RADIAL;

		/**
		 * @internal
		 * the current step in the animation cycle */
		private var _animStep:int; 
		
		/**
		 * @internal
		 * timer object for the animation */
		private var _animTimer:Timer;
		
		/**
		 * this holds the data for a layout drawing.
		 * */
		private var _currentDrawing:BaseLayoutDrawing;
		
		/**
		 * The constructor initializes the layouter and may assign
		 * already a VisualGraph object, but this can also be set later.
		 * @param vg The VisualGraph object on which this layouter should work on.
		 * */
		public function AnimatedBaseLayouter(vg:IVisualGraph = null) {
			
			super(vg);
			_animInProgress = false;
		}

		/**
		 * @inheritDoc
		 * */
		override public function get animInProgress():Boolean {
			return _animInProgress;
		}

		/**
		 * @inheritDoc
		 * */
		override public function resetAll():void {
			super.resetAll();
			killTimer();
		}

		/**
		 * @inheritDoc
		 * */
		override protected function set currentDrawing(dr:BaseLayoutDrawing):void {
			_currentDrawing = dr;
			
			/* also set in the super class */
			super.currentDrawing = dr;
		}


		/**
		 * Access to the type of animation, currently supported
		 * type is:
		 * ANIM_RADIAL which does interpolation of polar coordinates and
		 * ANIM_STRAIGHT which interpolates cartesian coordinates.
		 * @param type ANIM RADIAL or ANIM_STRAIGHT
		 * */
		protected function set animationType(type:int):void {
			_animationType = type;
		}

		/**
		 * This method kills any currently running timers
		 * which is needed if some data is going to be
		 * reinitialised. Remaining timer events could trigger
		 * code referring to stale data and crash the program
		 * otherwise.
		 * */
		protected function killTimer():void {
			if(_animTimer != null) {
				//LogUtil.debug(_LOG, "timer killed");
				_animTimer.stop();
				_animTimer.reset();
				//_animTimer = null;
			}
		}

		/**
		 * Reset/Reinitialise animation related variables.
		 * */
		protected function resetAnimation():void {
			/* reset animation cycle */
			_animStep = 0;
		}

		/**
		 * This method starts the animation according
		 * to the preset type in the _animationType
		 * variable. Currently only valid type is
		 * "RADIAL" which animates by interpolating
		 * polar coordinates. Other types like "LINEAR"
		 * (interpolating cartesian coordinates) may be
		 * added.
		 * */
		protected function startAnimation():void {
			var cyclefinished:Boolean;
			
			if(!_disableAnimation) {

				/* indicate an animation in progress */
				_animInProgress = true;

				switch(_animationType) {
					case ANIM_RADIAL:
						cyclefinished = interpolatePolarCoords();
						break;
					case ANIM_STRAIGHT:	
						cyclefinished = interpolateCartCoords();
						break;
					default:
						LogUtil.warn(_LOG, "Illegal animation Type, default to ANIM_RADIAL");
						cyclefinished = interpolatePolarCoords();
						break;
				}
				
				/* make sure the edges are redrawn */
                _layoutChanged = true;
                if(_animStep == 0) {
                    dispatchEvent(new VisualGraphEvent(VisualGraphEvent.BEGIN_ANIMATION));   
                }    
				if(_animStep % _ANIMREFRESHINTERVAL == 0 || cyclefinished) {
				    _vgraph.refresh();
				}
				
				/* check if we ran out of anim cycles, but are not finished */
				if (cyclefinished) {
					//LogUtil.debug(_LOG, "Achieved final node positions, terminating animation...");
					_animInProgress = false;
                    dispatchEvent(new VisualGraphEvent(VisualGraphEvent.END_ANIMATION));
				} else if(_animStep >= _ANIMATIONSTEPS) {
					LogUtil.info(_LOG, "Exceeded animation steps, setting nodes to final positions...");
					applyTargetToNodes(_vgraph.visibleVNodes);
					_animInProgress = false;
				} else {
					++_animStep;
					startAnimTimer();
				}
			
			} else {
				cyclefinished = setCoords();
				if(cyclefinished == false)
				{
					//if we havent completed successfully
					//due to not being fully initialized try
					//again in 1 mili seconds
					setTimeout(startAnimation,1);
				}
				else
				{
					_animInProgress = false;
					/* make sure the edges are redrawn */
					_layoutChanged = true;
					_vgraph.refresh();
					//_vgraph.redrawNodes();
				}
			} 
		}

		/**
		 * Interpolates the target Polar coordinates with the current real coordinates
		 * achieving a smooth animation.
		 * 
		 * This method always executes only one step as part of the animation.
		 * For each node, it's current coordinates are requested (and translated
		 * into the relative polar coordinates. From the drawing object, the target
		 * coordinates are taken and divided by the remaining interpolation steps.
		 * With that the coordinates of the current interpolation step can be
		 * calculated, which are subsequently directly applied to the node.
		 * The method then checks if the animation target coordinates have been
		 * reached. If not, and there are no more animation steps left, the
		 * actual target coordinates are applied.
		 * If there are animation steps left, a timer is started to call
		 * the same function again for the next animation step.
		 * */
		protected function interpolatePolarCoords():Boolean {
			var visVNodes:Array;
			var vn:IVisualNode;
			var n:INode;
			var i:int;
			var currRadius:Number;
			var currPhi:Number;
			var currPoint:Point;
			var targetRadius:Number;
			var targetPhi:Number;
			var deltaRadius:Number;
			var deltaPhi:Number;
			var stepRadius:Number;
			var stepPhi:Number;
			var stepPoint:Point;
			var cyclefinished:Boolean;
			
			cyclefinished = true; // init to true, if any one node is not target, will be set to false
			
			/* careful for invisible nodes, the values are not
			 * calculated (obviously), so we need to make sure
			 * to exclude them */
			visVNodes = _vgraph.visibleVNodes;
			for each(vn in visVNodes) {
				
				/* should be visible otherwise somethings wrong */
				if(!vn.isVisible) {
					throw Error("received invisible vnode from list of visible vnodes");
				}
				
				n = vn.node;

				/* get relative target coordinates in polar form */
				targetRadius = _currentDrawing.getPolarR(n);
				targetPhi = _currentDrawing.getPolarPhi(n);
				
				/* when we get the current values, we have to make sure
				 * that we convert the coordinates into relative ones,
				 * i.e. we need to subtract the origin */
				n.vnode.refresh();
				currPoint = new Point(vn.x, vn.y);
				currPoint = currPoint.subtract(_currentDrawing.originOffset);
				
				if(_currentDrawing.centeredLayout) {
					currPoint = currPoint.subtract(_currentDrawing.centerOffset);
				}
				
				currRadius = Geometry.polarRadius(currPoint);
				currPhi = Geometry.polarAngleDeg(currPoint);
				
				/* not sure if this really fixes the animation end cycle ... */
				deltaRadius = (targetRadius - currRadius) * _animStep / _ANIMATIONSTEPS;

				/* New logic for interpolating polar angles
				 * Take the minimum angle to the final position */
				
				if ( Math.abs(targetPhi - currPhi) < (360 - Math.abs(targetPhi - currPhi)) ) {
					deltaPhi = (targetPhi - currPhi) * _animStep / _ANIMATIONSTEPS;
				} else { // difference b/w initial and final angles more than 180 degrees
					if (targetPhi < currPhi) {
						//crossing over from a very large angle to a very small angle
						deltaPhi = (360 + targetPhi - currPhi) * _animStep / _ANIMATIONSTEPS;
					} else { 
						//crossing over from a very small angle to a very large angle
						deltaPhi = (targetPhi - currPhi - 360) * _animStep / _ANIMATIONSTEPS;
					}
				}
				
				/* calculate the intermediate coordinates */
				stepRadius = currRadius + deltaRadius;
				stepPhi = currPhi + deltaPhi;
				
				/* check if we are already done or not */
				if(!GraphicUtils.equal(currPoint, _currentDrawing.getRelCartCoordinates(n))) {
					cyclefinished = false;
				}
				
				/* we cannot set the coordinates in the _currentDrawing,
				 * as we store our target coordinates there,
				 * we need to set them directly in the vnode */
				stepPoint = Geometry.cartFromPolarDeg(stepRadius,stepPhi);
				
				/* adjust the origin */
				stepPoint = stepPoint.add(_currentDrawing.originOffset);
				
				/* here we may need to add the center offset */
				if(_currentDrawing.centeredLayout) {
					stepPoint = stepPoint.add(_currentDrawing.centerOffset);
				}
				
				/*
				LogUtil.debug(_LOG, "interpolating node:"+n.id+" cP:"+currPoint.toString()+" cr:"+currRadius+" cp:"+currPhi+
					" tr:"+targetRadius+" tp:"+targetPhi+" sP:"+stepPoint.toString()+" sr:"+stepRadius+
					" sp:"+stepPhi); 
				*/
				
				/* set into the vnode */
				vn.x = stepPoint.x;
				vn.y = stepPoint.y;
				
				/* commit, i.e. move the node */
				vn.commit();
			}
			return cyclefinished;
		}
		
		/**
		 * Interpolates the target coordinates with the current real coordinates
		 * achieving a smooth animation.
		 * It works in the same way as interpolatePolarCoords() but
		 * uses cartesian coordinates.
		 * @see interpolatePolarCoords()
		 * */
		protected function interpolateCartCoords():Boolean {
			var visVNodes:Array;
			var vn:IVisualNode;
			var n:INode;
			var i:int;
			var currPoint:Point;
			var deltaPoint:Point;
			var targetPoint:Point;
			var cyclefinished:Boolean;
			
			cyclefinished = true; // init to true, if any one node is not target, will be set to false
			
			/* careful for invisible nodes, the values are not
			 * calculated (obviously), so we need to make sure
			 * to exclude them */
			visVNodes = _vgraph.visibleVNodes;
			for each(vn in visVNodes) {
				
				/* should be visible otherwise somethings wrong */
				if(!vn.isVisible) {
					throw Error("received invisible vnode from list of visible vnodes");
				}
				
				n = vn.node;
				/* get abs target coordinates in cartesian form */
				targetPoint = _currentDrawing.getAbsCartCoordinates(n);
				
				/* when we get the current values, we have to make sure
				 * that we convert the coordinates into relative ones,
				 * i.e. we need to subtract the origin */
				n.vnode.refresh();
				currPoint = new Point(vn.x, vn.y);
				
				/* check if we are already done or not */
				if(!GraphicUtils.equal(currPoint, targetPoint)) {
					cyclefinished = false;
				}

				deltaPoint = new Point( (targetPoint.x - currPoint.x) * _animStep / _ANIMATIONSTEPS,
					(targetPoint.y - currPoint.y) * _animStep / _ANIMATIONSTEPS);
				
				currPoint = currPoint.add(deltaPoint);
							
				/* set into the vnode */
				vn.x = currPoint.x;
				vn.y = currPoint.y;
				
				/* commit, i.e. move the node */
				vn.commit();
			}
			return cyclefinished;
		}
		
		/**
		 * Directly sets the target coordinates not animating anything.
		 * Will be used if the disableAnimation flag is set.
		 * */
		protected function setCoords():Boolean {
			var visVNodes:Array;
			var vn:IVisualNode;
			var n:INode;
			var targetPoint:Point;
						
			/* careful for invisible nodes, the values are not
			 * calculated (obviously), so we need to make sure
			 * to exclude them */
			visVNodes = _vgraph.visibleVNodes;
			for each(vn in visVNodes) {
				/* should be visible otherwise somethings wrong */
				if(!vn.isVisible) {
					throw Error("received invisible vnode from list of visible vnodes");
				}
				
				/* check if we are already done or not */
				if(vn.view.initialized == false ) {
					return false;
				}
			}
			for each(vn in visVNodes) {
				
				n = vn.node;
				/* get relative target coordinates in cartesian form */
				targetPoint = _currentDrawing.getAbsCartCoordinates(n);
							
				/* set into the vnode */
				vn.x = targetPoint.x;
				vn.y = targetPoint.y;
				
				/* commit, i.e. move the node */
				vn.commit();
			}
			return true;
		}
		
		/**
		 * @internal
		 * This calculates the timer delay for a slow-in / slow-out
		 * animation in each animation step.
		 * */
		private function startAnimTimer():void {
			var timerdelay:Number;
			var factor:Number;
			var signedAnimStep:int;
			var factorinput:Number;
				
			/* modify the current animation step to range from -/+ around 0 */
			signedAnimStep = _animStep - (_ANIMATIONSTEPS / 2); // so we should be at 0 at the middle

			/* this is the input into into the atan() function, which depends on the
			 * timing interval and the current signed animation step */
			factorinput = _ANIMATIONTIMINGINTERVALSIZE * (signedAnimStep / _ANIMATIONSTEPS);			
			
			//LogUtil.debug(_LOG, "factor input:"+factorinput);
			
			/* calculate the timing factor using the atan() function
			 * since we take the absolute value, 
			 * its range goes from PI / 2 to 0 back to PI / 2 */
			factor = Math.abs(Math.atan(factorinput));
			
			//LogUtil.debug(_LOG, "factor fraction of PI:"+(factor / Math.PI));
			
			/* now the delay for our timer is now the factors fraction
			 * of PI/2 times the maximum timer delay, i.e. the full timer
			 * delay if the factor has a value of PI / 2 */
			timerdelay = (factor / (Math.PI / 2)) * _MAXANIMTIMERDELAY;
			
			//LogUtil.debug(_LOG, "Setting timerdelay to:"+timerdelay+" milliseconds in step:"+_animStep);
			
			/* now creating the new timer with the specified delay
			 * and ask for one execution, then the event handler will be
			 * called, which does nothing except to call the interpolation
			 * method again */
			if (_animTimer == null) {
				_animTimer = new Timer(timerdelay, 1);
				_animTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animTimerFired);
			} else {
				_animTimer.stop();
				if (timerdelay > 0) _animTimer.delay = timerdelay;
				_animTimer.reset();				
			}
			_animTimer.start();
		}
		
		/**
		 * @internal
		 * Event handler when the timer fired, just calls the
		 * interpolation function again to do another animation
		 * cycle.
		 * @param event The fired timer event, will be ignored anyway.
		 * */
		private function animTimerFired(event:TimerEvent = null):void {
			//LogUtil.debug(_LOG, "Timer fired!");
			startAnimation();
			//event.updateAfterEvent();
		}
		
	}
}
