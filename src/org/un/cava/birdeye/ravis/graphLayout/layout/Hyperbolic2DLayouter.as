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
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.VisualNode;
	import org.un.cava.birdeye.ravis.utils.GraphicUtils;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	import org.un.cava.birdeye.ravis.utils.geom.ComplexNumber;
	import org.un.cava.birdeye.ravis.utils.geom.ComplexVector;
	import org.un.cava.birdeye.ravis.utils.geom.IIsometry;
	import org.un.cava.birdeye.ravis.utils.geom.IPoint;
	import org.un.cava.birdeye.ravis.utils.geom.IProjector;
	import org.un.cava.birdeye.ravis.utils.geom.IVector;
	import org.un.cava.birdeye.ravis.utils.geom.PoincareIsometry;
	import org.un.cava.birdeye.ravis.utils.geom.PoincareModel;
	import org.un.cava.birdeye.ravis.utils.geom.PoincareProjector;

	/**
	 * This is an implementation of the Hyperbolic 2D layouting algorithm.<br>
	 * For this iterative layout, most of default mouse behavior, namely:<br>
	 * (1) scrolling while background drag, and <br>
	 * (2) node drag-drop<br>
	 * should be turned-off in <code>VisualGraph</code>. 
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
	 * 
	 * XXX TODO: Needs to honor the '_disableAnimation' protected variable
	 * if possible XXX
	 */

	public class Hyperbolic2DLayouter extends IterativeBaseLayouter implements ILayoutAlgorithm {
		
		private static const _LOG:String = "graphLayout.layout.Hyperbolic2DLayouter";
		
	  public static const ANIMATION_STEPS:int = 10;
		
	 /*********************************************
		* INTERNAL OBJECTS
		*********************************************/
		private var _model:PoincareModel;
		private	var _projector:PoincareProjector;
		
	 /*********************************************
		* LOCAL VARIABLES
		*********************************************/
		private var _nodeIndex:Array; // of VisualNode objects
		private var _nodePositions:Array; // of ComplexNumber objects
		private var _tempPositions:Array; // of ComplexNumber objects
		private var _gradient:Array; // of ComplexVector objects
		private var _previousGradient:Array; // of ComplexVector objects
		private var _distances:Array; // 2D array of Number
		
		private var _stepWidth:Number = 1;
		
		private var _gradientNorm2:Number = 0;
		private var _previousGradientNorm2:Number = 0;
		private var _energy:Number = 0;
		private var _lastEnergy:Number = 0;
		
		private var _dragStartX:Number;
		private var _dragStartY:Number;
		
		// TEMPORARY VARIABLES - to speed-up computations
		private var t_v1:ComplexVector = new ComplexVector();
		private var t_v2:ComplexVector = new ComplexVector();
		private var t_isom1:IIsometry;
		
		// ANIMATION VARIABLES
		private var _animationIsometries:Array;
		
		/**
		 * @internal
		 * timer object for the animation */
		private var _animTimer:Timer;
		
		/**
		 * Indicator if there is currently an animation in progress
		 * */
		protected var _animInProgress:Boolean = false;
		
		/**
		 * @internal
		 * the current step in the animation cycle */
		private var _animStep:int; 
		
	 /*********************************************
		* PARAMETERS
		*********************************************/
		private var _connectedDisparity:Number;
		private var _repulsingForce:Number;
		private var _repulsingForceCutOff:Number;
		
		/*********************************************
		* Initialization - Constructors, resets
		* ********************************************/
		public function Hyperbolic2DLayouter(vg:IVisualGraph = null) {
			super(vg);
			resetAll();
			
			_model = new PoincareModel();
			_projector = new PoincareProjector(_model);
			t_isom1 = _model.getIdentity();
			
			// setup all parameter values
			_connectedDisparity = 0.2; //0.2
			_repulsingForce = 0.05; //0.05
			_repulsingForceCutOff = 5; //5
			
		}
		
		/**
		 * @inheritDoc
		 * */
		override public function resetAll():void {
			super.resetAll(); // calls refreshInit()
			
			// reset all data caches
			_nodeIndex = null;
			_nodePositions = null;
			_tempPositions = null;

			_distances = null;
			_gradient = null;
			_previousGradient = null;
		}
		
		/**
		 * @inheritDoc
		 * */
		override public function refreshInit():void {
			// reset all local variables
			_gradientNorm2 = 0;
			_previousGradientNorm2 = 0;
			_energy = 1; // random value to prevent division by zero in isStable()
			_lastEnergy = 0;
			_stepWidth = 0.05;
		}
		/*********************************************
		* Layout Methods - Computations
		* ********************************************/
		
		/* Terminating condition for the layout */
		override protected function isStable():Boolean {
			return (_stepWidth < 0.00001)
			    || (_energy < 0.01)
					|| (Math.abs((_energy - _lastEnergy) / _energy) < 0.0001 );
		}
		
		/* Calculation step of the layout */
		override protected function calculateLayout():void {
			var allVisVNodes:Array = _vgraph.visibleVNodes;
			var vn:IVisualNode;
			var totalNodes:Number = _vgraph.noVisibleVNodes;
			var k:int;
			
			// 1: Initialize global variables to avoid garbage collection.
			if (_nodeIndex == null) {
				//LogUtil.debug(_LOG, "Resetting node indexes...");
				_nodeIndex = new Array(totalNodes);
				k = 0;
      			for each(vn in allVisVNodes) {
					_nodeIndex[k] = vn;
					++k;
				}
			}
			
			if (_nodePositions == null) {// UnProject Euclidean Space to Poincare Model
				//LogUtil.debug(_LOG, "Resetting node positions...");
				_nodePositions = new Array(totalNodes); //ComplexNumber
				unProjectNodes();
			}
			
			if (_gradient == null) {
				//LogUtil.debug(_LOG, "Resetting gradients...");
				_gradient = new Array(totalNodes); //ComplexVector
				for (k = 0; k < totalNodes; k++)
					_gradient[k] = new ComplexVector(_nodePositions[k] as ComplexNumber, new ComplexNumber());
			}
			
			if (_tempPositions == null) {
				//LogUtil.debug(_LOG, "Resetting temp node positions...");
				_tempPositions = new Array(totalNodes); // ComplexNumber
				for (k = 0; k < totalNodes; k++)
					_tempPositions[k] = new ComplexNumber();
			}
			
			if (_distances == null) {
				//LogUtil.debug(_LOG, "Resetting distance matrix...");
				var j:int;
				_distances = new Array(totalNodes);
				for (k = 0; k < totalNodes; k++) {
					_distances[k] = new Array(totalNodes);
					for (j = 0; j < totalNodes; j++) {
						_distances[k][j] = 0.0;
					}
				}
			}
			
			// 2: Perform the calculations for this iteration
			// 2.1: Initialize global variables to avoid garbage collection.
			_previousGradientNorm2 = _gradientNorm2;
			_lastEnergy = _energy;

			// 2.2: Computation of distances, gradients
			computeDistances(_nodePositions);
			_gradientNorm2 = computeGradient(_nodePositions, _gradient);
			
			if (_previousGradient == null) {
				_previousGradient = new Array(totalNodes); // ComplexVector
				for (k = 0; k < totalNodes; k++)
					_previousGradient[k] = (_gradient[k] as ComplexVector).clone() as ComplexVector;
				_previousGradientNorm2 = _gradientNorm2;
			}
			// compare gradient with previous gradient to spot oscillation
			var gradientProduct:Number = 0;
			for (k = 0; k < _gradient.length; k++)
				gradientProduct += _model.product(_gradient[k] as IVector, _previousGradient[k] as IVector);
				
			// 2.3: Adjust step width
			var angle:Number = gradientProduct / Math.sqrt(_gradientNorm2 * _previousGradientNorm2);
			if (angle > 0.9)
				_stepWidth *= 1.1;
			else if (angle > 0.8)
				_stepWidth *= 1.05;
			else if (angle > 0.5)
				_stepWidth *= 1;
			else if (angle > 0.3)
				_stepWidth *= 0.7;
			else if (angle > 0.2)
				_stepWidth *= 0.4;
			else if (angle > 0.1)
				_stepWidth *= 0.2;
			else
				_stepWidth *= 0.1;
				
			// 2.4: Compute new node positions
			var step:Number;
			for (k = 0; k < totalNodes; k++) {
				step = _stepWidth * _model.length(_gradient[k] as IVector);
				if (step > 0.2)
					step = 0.2;
				(_tempPositions[k] as ComplexNumber).setTo(_nodePositions[k] as IPoint);
				_model.getTranslationIVR(t_isom1, _gradient[k] as IVector, -step);
				t_isom1.applyToPoint(_tempPositions[k] as IPoint);
				t_isom1.applyToVector(_gradient[k] as IVector); 
				/* 
				 * the gradient has to be translated along the geodesic from the old 
				 * to the new position so that we can compare it with the next gradient.
				 */
				(_previousGradient[k] as ComplexVector).setTo(_gradient[k] as IVector);
				(_nodePositions[k] as ComplexNumber).setTo(_tempPositions[k] as IPoint);
			}
			// 2.5: Compute new energy
			_energy = getEnergy();
			/*
			LogUtil.debug(_LOG, "  Energy: " + _energy 
						   + "  StepWidth: " + _stepWidth
						   + "  Gradient Norm: " + _gradientNorm2
						   + "  Angle: "  + gradientProduct/Math.sqrt(_gradientNorm2*_previousGradientNorm2));
			*/
			
			// 3: Map from Poincare Model to Euclidean Space
			projectNodes(false);
		}
		
  /************************************************
	 * Helper Functions - Layout Computations
	 ************************************************/
	  private function projectNodes(updateNodeUI:Boolean):void {
			var newNodePos:Point;
			var newNodeScale:Point;
			var k:int;
			
			/* it happens for some reasons that the _nodeIndex array 
			 * was not initialised, then this crashes, adding a safeguard
			 */
			if(_nodeIndex == null) {
				LogUtil.warn(_LOG, "_nodeIndex not initialised in Hyperbolic2DLayouter.projectNodes()");
				return;
			}
			
			for (k = 0; k < _nodeIndex.length; k++) {
 				// Use Projector to map Complex Points to 2D display
				newNodePos = _projector.project(_nodePositions[k] as IPoint, _vgraph as DisplayObject);
				// DEBUG - CHECK:
				if (isNaN(newNodePos.x)) {
					LogUtil.debug(_LOG, "HyperbolicLayout: Projected position for " + (_nodeIndex[k] as VisualNode).node.stringid + " = " + newNodePos);
                    LogUtil.debug(_LOG, "  Node Position in Model = " + (_nodePositions[k] as IPoint).toString());
				}
				(_nodeIndex[k] as VisualNode).x = newNodePos.x;
				(_nodeIndex[k] as VisualNode).y = newNodePos.y;
				
 				// Scaling of visual components at points
				newNodeScale = _projector.getScale(_nodePositions[k] as IPoint);
				
				(_nodeIndex[k] as VisualNode).view.scaleX = newNodeScale.x;
				(_nodeIndex[k] as VisualNode).view.scaleY = newNodeScale.y;
				
				// Commit the position changes if UI needs to be updated
				if (updateNodeUI) (_nodeIndex[k] as VisualNode).commit();
			}
	  }
		
	  private function unProjectNodes():void {
			var oldNodePos:Point = new Point();
			var temp:ComplexNumber;
			var k:int;
			
			for (k = 0; k < _nodeIndex.length; k++) {
				// UnProject all nodes from 2D display to Complex Points
				oldNodePos.x = (_nodeIndex[k] as IVisualNode).x;
				oldNodePos.y = (_nodeIndex[k] as IVisualNode).y;
				if ( GraphicUtils.equal(oldNodePos, GraphicUtils.getCenter(_vgraph as DisplayObject)) 
				  && ((_nodeIndex[k] as IVisualNode) != _vgraph.currentRootVNode) ) {//new point added not the root
					// Start from Random positions for newly added nodes
					temp = new ComplexNumber();
					translateRandomly(temp, 1.5, 2.5);
					_nodePositions[k] = temp;
					/*
					_LOG.debug( (_nodeIndex[k] as VisualNode).node.stringid 
					    + ": Randomly set position to " + _nodePositions[k] );
					*/
				} else {
					_nodePositions[k] = _projector.unProject(oldNodePos, _vgraph as DisplayObject, true);
				}
				// DEBUG - CHECK:
				if (isNaN((_nodePositions[k] as ComplexNumber).real)) 
					LogUtil.warn(_LOG, "HyperbolicLayout: " + (_nodeIndex[k] as VisualNode).node.stringid 
					    + ": Node position set to " + _nodePositions[k] );
			}
		}
		
	  private function getEnergy():Number {
			var energy:Number = 0;
			var i:int;
			var j:int;
			for (i=0; i < _nodeIndex.length; i++)
				for (j=i+1; j < _nodeIndex.length; j++)
					energy += getWeight((_nodeIndex[j] as IVisualNode).node,
															(_nodeIndex[i] as IVisualNode).node,
															getDistance(i, j));
			return energy;
		}
		
		private function computeDistances(position:Array):void {
			var i:int;
			var j:int;
			
 			for (i=0; i < _nodeIndex.length; i++)
				for (j=i+1; j < _nodeIndex.length; j++) {
				  _distances[i][j] = _model.distP((position[i] as IPoint), 
																					(position[j] as IPoint));
					//DEBUG - CHECK:
					if ((_distances[i][j] <= 1e-10) || isNaN(_distances[i][j]))
						LogUtil.warn(_LOG, "HyperbolicLayout: Distance for (" + i + ", " + j + ") is = " + _distances[i][j]);
				}
		}
		
		private function getDistance(i:int, j:int):Number {
			if (i > j) 
				return _distances[j][i];
			else
				return _distances[i][j];
		}
		
		private function computeGradient(position:Array, gradient:Array):Number {
			var norm2:Number = 0;
			var nodeNorm2:Number = 0;
			var w:Number;
			var i:int;
			var k:int;
			for (k = 0; k < _nodeIndex.length; k++) {
				(gradient[k] as ComplexVector).scale(0);
				for (i = 0; i < _nodeIndex.length; i++)
					if (k != i) {
						w = getWeightDerivative((_nodeIndex[k] as IVisualNode).node,
																		(_nodeIndex[i] as IVisualNode).node,
																		getDistance(k, i));
						if (Math.abs(w) > 0.001) {
							_model.distanceGradientV(position[k] as IPoint,
																			 position[i] as IPoint, t_v2);
							
							//DEBUG - CHECK:
							if (isNaN((t_v2.dir as ComplexNumber).real)) {
								LogUtil.warn(_LOG, "Hyperbolic2DLayouter: [k = " + k + "] [i = " + i + "] Gradient vector between nodes " 
									 + (_nodeIndex[k] as VisualNode).node.stringid + " & "
									 + (_nodeIndex[i] as VisualNode).node.stringid 
									 + " is: " + t_v2 );
								LogUtil.warn(_LOG, "  Positions are " 
									 + (position[k] as IPoint) + " & "
									 + (position[i] as IPoint));
							}
							(t_v2.dir as ComplexNumber).multiplyF(w);
							((gradient[k] as ComplexVector).dir as ComplexNumber).addC(t_v2.dir as ComplexNumber);
						}
				}
				nodeNorm2 = _model.length2(gradient[k] as IVector);
				norm2 += nodeNorm2;
			}
			return norm2;	
		}
		
		private function translateRandomly(pos:ComplexNumber, minR:Number, maxR:Number):void {
			var alpha:Number = 2 * Math.PI * Math.random();
			var t:Number = minR + (maxR - minR) * Math.random();
			t_v1.base = pos;
			(t_v1.dir as ComplexNumber).real = t * Math.cos(alpha);
			(t_v1.dir as ComplexNumber).imag = t * Math.sin(alpha);
			_model.getTranslationIVR(t_isom1, t_v1, t);
			t_isom1.applyToPoint(pos);
		}
		
		/*
		 * Weight Computation - 3 Cases:
		 * ----------------------------
		 * 
		 * Case 1: Nodes are directly connected
		 *    -> (d - connectedDisparity)^2
		 * Case 2: Nodes belong to same spanning tree
		 *   if closer than _repulsingForceCutOff (= d0)
		 *    -> F/d - F/d0
		 * Case 3: Nodes are completely disconnected (different spanning trees)
		 *   if closer than _cut
		 *    -> F/d - F/_cut
		 * 
		 * As of Nov/23/2007, Case 3 conditions are never satisfied (only one spanning tree)
		 * hence commented out
		 */
		private function getWeight(n1:INode, n2:INode, d:Number):Number {
			if (isConnected(n1, n2)) // Case 1: Directly connected
				return (d - _connectedDisparity) * (d - _connectedDisparity); // for classical MDS
			else if (d < _repulsingForceCutOff) // Case 2: Belong to same spanning tree
				return _repulsingForce/d - _repulsingForce/_repulsingForceCutOff;
			else
				return 0;
			/*
			if (getConnectedComponent(n1).contains(n2)) {
				if (d < _repulsingForceCutOff)
					return _repulsingForce/d - _repulsingForce/_repulsingForceCutOff;
			} else if (d < _cut)
				return _repulsingForce/d - _repulsingForce/_cut;
			return 0;
			*/
		}
		
		/*
		 * Weight Derivative Computation - 3 Cases:
		 * ---------------------------------------
		 * 
		 * Case 1: Nodes are directly connected
		 *    -> 2(d - connectedDisparity)
		 * Case 2: Nodes belong to same spanning tree
		 *   if closer than _repulsingForceCutOff (= d0)
		 *    -> -F/(d*d)
		 * Case 3: Nodes are completely disconnected (different spanning trees)
		 *   if closer than _cut
		 *    -> -F/(d*d)
		 * 
		 * As of Nov/23/2007, Case 3 conditions are never satisfied (only one spanning tree)
		 * hence commented out
		 */
		private function getWeightDerivative(n1:INode, n2:INode, d:Number):Number {
			if (isConnected(n1, n2)) // Case 1: Directly connected
				return 2 * (d - _connectedDisparity);
			else if (d < _repulsingForceCutOff) // Case 2: Belong to same spanning tree
					return -_repulsingForce / (d * d); // repulsing force for force directed layout.
			else
				return 0;
			/*
			if (getConnectedComponent(n1).contains(n2)) {
				if (d < _repulsingForceCutOff)
					return -_repulsingForce / (d * d); // repulsing force for force directed layout.
			} else if (d < _cut)
				return -_repulsingForce / (d * d); // repulsing force for force directed layout.
			return 0;
			*/
		}
		
		private function isConnected(n1:INode, n2:INode):Boolean {
			var predessors:Array = n1.predecessors;
			var successors:Array = n1.successors;
			var otherNode:INode;
			var rtn:Boolean = false;
			var i:int;
			
			// check predessors
			for (i=0; i < predessors.length; i++)
				if (n2 == (predessors[i] as INode))
				  rtn = true;
			
			// check successors
			for (i=0; i < successors.length; i++)
				if (n2 == (successors[i] as INode))
				  rtn = true;
					
			// if (rtn) _LOG.debug(n1.stringid + ", " + n2.stringid + " are directly connected");
			return rtn;
		}
		
		/*********************************************
		* Mouse Event Handling Methods
		* ********************************************/
		/**
		 * @inheritDoc
		 */
		override public function dropEvent(event:MouseEvent, vn:IVisualNode):void {
			/* Activated in three cases:
			 * 1: Node Drag/Drop: No action - disabled in VisualGraph
			 * 2: Node Clicked: Move the node at the center
			 * 3: Node Double-clicked: After changing visibility, move the node at the center
			 */
			// LogUtil.debug(_LOG, "Node: " + vn.node.stringid + " is CENTERED");
			_animationIsometries = _projector.center(new Point(vn.x, vn.y), _vgraph as DisplayObject, false);
			_animInProgress = true;
			resetAnimation();
			startAnimation();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bgDragEvent(event:MouseEvent):void {
			//LogUtil.debug(_LOG, "Canvas started DRAG");
			_dragStartX = event.localX;
			_dragStartY = event.localY;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bgDragContinue(event:MouseEvent):void {
			//LogUtil.debug(_LOG, "Canvas being DRAGGED...");
			
			var startPt:Point = new Point(_dragStartX, _dragStartY);
			// get start point of dragging but do not adjust node if it is out of bounds
			var startIPt:IPoint = _projector.unProject(startPt, _vgraph as DisplayObject, false);
			
			/* Restrict dragging to smaller steps. 
			 * Distances in Hyperbolic geometry are very high close to the edge of the unit circle
			 */
			if ( (startIPt != null) && ((startIPt as ComplexNumber).norm() < 0.9) ) {
				// get isometry for changing the viewMatrix
				var isometries:Array = _projector.moveP(startIPt, new Point(event.localX , event.localY),
																								_vgraph as DisplayObject, true);
				if(isometries != null) {
					_projector.setViewMatrix(isometries[0]);
					// Refresh Node positions - project and update
					projectNodes(true);
					_vgraph.refresh();
				}
			}
			// update dragging start point
			_dragStartX = event.localX;
			_dragStartY = event.localY;
		}
		
  /************************************************
	 * Helper Methods - Node Animation, Misc.
	 ************************************************/
		/**
		 * @inheritDoc
		 */
		public function get projector():IProjector {
			return _projector;
		}
		
		/**
		 * This method kills any currently running timers
		 * */
		private function killTimer():void {
			if(_animTimer != null) {
				_animTimer.stop();
				_animTimer.reset();
			}
		}

		/**
		 * Reset/Reinitialise animation related variables.
		 * */
		private function resetAnimation():void {
			/* reset animation cycle */
			_animStep = 0;
		}
		
		/**
		 * Performs one animation step.
		 * */
		protected function animate():void {
			// Check for end condition
			if(_animStep >= ANIMATION_STEPS) {
				//LogUtil.warn(_LOG, "Animation complete, dragged/clicked node is in its final position");
				//applyTargetToNodes(_vgraph.visibleVNodes);
				_animInProgress = false;
				_animationIsometries = null;
			} else 
			  if (_animationIsometries != null) {// Perform animation step
				_projector.setViewMatrix(_animationIsometries[_animStep]);
				// Refresh Node positions - project and update
				projectNodes(true);
				_vgraph.refresh();
				++_animStep;
				startAnimation();
			}
		}
		/**
		 * @internal
		 * This starts the animation to perform successive transformations to the view matrix
		 * Used move the selected node to the center
		 * */
		private function startAnimation():void {
			if (_animTimer == null) {
				_animTimer = new Timer(50, 1);
				_animTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animTimerFired);
			} else {
				killTimer();
			}
			_animTimer.start();
		}
		
		/**
		 * @internal
		 * Event handler when the timer fired, just calls the animate 
		 * function to do one step of view matrix translation
		 * 
		 * @param event The fired timer event, will be ignored anyway.
		 * */
		private function animTimerFired(event:TimerEvent = null):void {
			//LogUtil.warn(_LOG, "Timer fired!");
			animate();
			//event.updateAfterEvent();
		}
	}
}
