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
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	/**
	 * This is an implementation of the ForceDirected/SpringGraph
	 * Layouting algorithm. The implementation took the general
	 * idea	from Mark Shepherd's SpringGraph component implementation
	 * which is itself based on TouchGraph (Java). However, apart from
	 * the general idea and some variable names, the code is a rewrite.
	 * <br>
	 * Here is the copyright information that was part of the code. I add
	 * it just in case someone might feel offended if it is not there:
	 * 
	 * <p>Copyright of the original TouchGraph LLC code:
	 * (c) 2001-2002 Alexander Shapiro. All rights reserved.
	 * Copyright of the adaption to Flex:
	 * (c) Mark Shepherd, Adobe FlexBuilder Engineering, 2006.
	 * Copyright of this reimplementation in Flex:
	 * (c) Daniel Lang, United Nations, 2007.</p>
	 * 
	 * See license infortmation at the top.
	 * */
	public class ForceDirectedLayouter extends IterativeBaseLayouter implements ILayoutAlgorithm {
		
		/*********************************************
		* CONSTANTS
		* ********************************************/
		
		private static const _LOG:String = "graphLayout.layout.ForceDirectedLayouter";
		
		/**
		 * @internal
		 * This controls the amount of adjustement passes during one
		 * layout cycle. */
		private const _RELAXPASSES:int = 5;
		
		/**
		 * @internal
		 * This is a maximum (neutral) length of a hypothetical spring.
		 * For a spring force expression Del_F = k (x - x_0), this corresponds to x_0
		 */
		private const _MAX_NODE_SEPARATION:int = 500;
		
		/**
		 * @internal
		 * This is a minimun (neutral) length of a hypothetical spring.
		 * For a spring force expression Del_F = k (x - x_0), this corresponds to x_0
		 * It also governs the minimum separation during repulsion
		 */
		private const _MIN_NODE_SEPARATION:int = 5;
		
		/**
		 * @internal
		 * The maximum scrolling step in autofit()
		 */
		private const _SCROLL_STEP:int = 2;
		
		/**
		 * @internal
		 * The rigidity constant of a spring. The actual _rigidity could be 
		 * a function and perhaps use this as a coefficient (LATER)
		 */
		private const _RIGIDITY_CONSTANT:Number = 0.0007;
		
		/**
		 * @internal
		 * The max repulsion constant of the (electrical) force field.
		 */
		private const _MAX_REPULSION:Number = 100;

		/**
		 * @internal
		 * The min repulsion constant of the (electrical) force field.
		 */
		private const _MIN_REPULSION:Number = 1;
		
		/**
		 * @internal
		 * The maximum distance in pixels, that a node is allowed
		 * to move during one layout cycle */
		private const _MOVEPIXELLIMIT:int = 100;
		
		/**
		 * @internal
		 * The ideal coverage for autofit is 90% 
		 * */
		private const _AUTOFITCOVERAGE:Number = 0.9;
		
		/**
		 * @internal
		 * There is also a tolerance of 3% to be within
		 * the ideal coverage.
		 * */
		private const _AUTOFITCOVERTOLERANCE:Number = 0.03;
		
		/*********************************************
		* Parameters
		* ********************************************/
		
		/* the damper cools down the movement
		 * it may range be from 0.0 (no movement) to
		 * 1.0 (no damping) */
		private var _damper:Number = 1.0;
		
		/* cutoff limit for max motion */
		private var _motionLimit:Number;
		
		/* a constant with a similar effect as damping
		 * low means things go slow, too high will cause oscillation */
		private var _rigidity:Number;
		private var _newRigidity:Number;
		
		/* this is a global adjustement factor for the repulsion
		 * it's access is controlled by the linkLength access
		 * methods. */
		private var _repulsionFactor:Number;

		/*********************************************
		* Variables
		* ********************************************/
		
		/* max motion keeps track of the fastest moving nodes
		 * to see if the graph stabilises */
		private var _maxMotion:Number = 0.0;
		private var _lastMaxMotion:Number = 0.0;
		
		/* this is used during motion limiting */
		private var _motionRatio:Number;
		
		/* required for this specific 
		 * autofit implementation */
		private var _coverage:Number;
		
		/*********************************************
		* Temporary Variables - For faster computation
		* ********************************************/
		
		/* for debugging */
		private var t_maxSpringMotion:Number = 0.0;
		private var t_maxRepulsiveMotion:Number = 0.0;
		
		/* for iterating/traversing caches */
		private var t_edge:IEdge;
		private var t_ve:IVisualEdge;
		private var t_vn1:IVisualNode;
		private var t_vn2:IVisualNode;
		
		/* for calculations */
		private var t_dx:Number, t_dy:Number, t_vx:Number, t_vy:Number;
		private var t_distanceMoved:Number;
		/*********************************************
		* Members - Misc
		* ********************************************/
		
		/* general setting whether to activate damping or not */
		private var _dampingActive:Boolean = true;
		
		/* current viewing bounds of the graph */
		private var _viewbounds:Rectangle;

		/* for each node we keep a 'delta' value for its
		 * coordinates. */
		private var _deltaPositions:Dictionary;
		/**
		 * The constructor only initialises the data structures and presets
		 * some parameters.
		 * */
		public function ForceDirectedLayouter(vg:IVisualGraph = null) {
			super(vg);
			resetAll();
			
			// Initialize Parameters
			_motionLimit = 0.01;
			_repulsionFactor = _MAX_REPULSION / 10;
			_rigidity = _RIGIDITY_CONSTANT;
			_newRigidity = _RIGIDITY_CONSTANT;
		}

		/**
		 * Reset all layouting parameters, which may be
		 * required during a significant layout change.
		 * This is particularily important in this layouter,
		 * as it constantly updates the layout (using the timer).
		 * */
		override public function resetAll():void {
			super.resetAll(); // calls refreshInit()
			_deltaPositions = new Dictionary;
		}

		/**
		 * In this implementation, this method resets the damper
		 * value.
		 * */
		override public function refreshInit():void {
			resetDamperValue();
			
			_maxMotion = 0.0;
			_lastMaxMotion = 0.0;
			_motionRatio = 0.0;
			
			_coverage = 0;
		}
		
		/**
		 * @inheritDoc
		 * */
		override public function set linkLength(f:Number):void {
			/*
			* Two separate intents govern the value of repulsion factor
			*  1. Auto-fit - expand/ contract the graph
			*  2. Setting linkLength to a given value
			* In force-directed layout, both should not control this simultaneously
			*/
			if (!_autoFitEnabled) {
				_repulsionFactor = Math.max(_MIN_REPULSION, Math.min(f, _MAX_REPULSION));
				refreshInit();
			}
		}
		
		/**
		 * @private
		 * */
		override public function get linkLength():Number {
			return _repulsionFactor;
		}


		/**
		 * This is a local parameter specific to this layouter, that may
		 * be accessed from outside, if required. It handles how flexible
		 * the springy edges are.
		 * @param r The new rigidity value.
		 * */
		public function set rigidity(r:Number):void {
			_newRigidity = r;
		}

		/**
		 * This is a specific method for this layouter and
		 * specifies if damping should be used or not.
		 * */
		public function set dampingActive(da:Boolean):void {
	
			/* check for a change */
			if(_dampingActive != da) {
				/* set the new value */
				_dampingActive = da;
				
				/* reset the damper value if disabled */
				if(da == false) {
					_damper = 1.0;
				}
			}
		}
		
		/**
		 * @private
		 * */
		public function get dampingActive():Boolean {
			return _dampingActive;
		}
		
		/**
		 * Reset the damper value but keep damping.
		 * @internal
		 * */
		private function resetDamperValue():void {
			_dampingActive = true;
			_damper = 1.0;
		}
		
		/*********************************************
		* Layout Methods - Computational Methods
		* ********************************************/
		
		/* Calculation step of the layout */
		override protected function calculateLayout():void {
			
			/* Calculate forces and update node positions, which
			 * calls the following four methods to work on the layout:
			 * */
			for(var i:int=0; i < _RELAXPASSES; ++i) {
			 	//1. Apply spring force, which pulls on the edges.
				applySpringForce();
			 
				//2. Apply repulsion force, which moves every node away from each other.
				applyRepulsion();
				
			  //3. Actually move the nodes respecting some constraints.
				moveNodes();
			  
				//4. Adjust node drag settings - not to be confused with UI Drag-Drop
				adjustDrag();
			}
			
			/* 5. update rigidity, it may have been set new */
			if(_rigidity != _newRigidity) {
				_rigidity = _newRigidity;
			}
			
			/* 6. update repulsion and scroll, if autoFit is enabled */
			if(_autoFitEnabled) {
				adjustRepulsion();
				scrollToFit();
			}
		}
		
		/* Terminating condition for the layout */
		override protected function isStable():Boolean {
			return (_damper <= 0.1 && _maxMotion <= _motionLimit);
		}

		/*********************************************
		* Layout Methods - Force Computations
		* ********************************************/
		/**
		 * @internal
		 * This method tenses up the edges and pulls the nodes
		 * closer. In order to optimize, it should only work on
		 * "visible" edges, i.e. edges for which both nodes
		 * are visible.
		 */
		private function applySpringForce():void {
			t_maxSpringMotion = 0.0;
			
			/* we need IEdges first */			
			for each(t_ve in _vgraph.visibleVEdges) {
				/* now work on the edge */
				t_edge = t_ve.edge;
				t_vn1 = t_edge.node1.vnode;
				t_vn2 = t_edge.node2.vnode;

				/* all nodes attached to the edge should be visible, 
				 * so we assert here that it is true */
				if(!t_vn1.isVisible || !t_vn2.isVisible) {
					throw Error("At least one node of the edge is not visible but it should be!");
				}
				
				t_vx = t_vn2.x - t_vn1.x;
				t_vy = t_vn2.y - t_vn1.y;
				
				/* calculate the actual length of the edge */
				var edgelength:Number = Math.sqrt((t_vx * t_vx)+(t_vy * t_vy));
				
				/* apply the rigidity to make the edge tighter */
				t_dx = t_vx * _rigidity * edgelength;
				t_dy = t_vy * _rigidity * edgelength;
				
				/* update the motion value */
				t_distanceMoved = Math.sqrt(t_dx*t_dx + t_dy*t_dy);
				t_maxSpringMotion = Math.max(t_distanceMoved, t_maxSpringMotion);
				
				if(_deltaPositions[t_vn1] == null) {
					_deltaPositions[t_vn1] = new Point(0,0);
				}
				if(_deltaPositions[t_vn2] == null) {
					_deltaPositions[t_vn2] = new Point(0,0);
				}
				
				/* apply the position offset, add for vnode 1 */
				(_deltaPositions[t_vn1] as Point).offset(t_dx, t_dy);
				
				/* apply the position offset, subtract for vnode 2*/
				(_deltaPositions[t_vn2] as Point).offset(-t_dx, -t_dy);
			}
		}

		/**
		 * @internal
		 * This methods (originally called avoidLabels()) applies
		 * the repulsion to the nodes in order to keep them apart
		 * (and consequently avoid their labels from overlapping).
		 * */
		private function applyRepulsion():void {
			t_maxRepulsiveMotion = 0.0;
			for each(t_vn1 in _vgraph.visibleVNodes) {
				if(!t_vn1.isVisible) {
					throw Error("Received invisible node while working on visible vnodes only");
				}
				for each(t_vn2 in _vgraph.visibleVNodes) {
					if(!t_vn2.isVisible) {
						throw Error("Received invisible node while working on visible vnodes only");
					}
					if(t_vn1 != t_vn2) {
						t_dx = 0;
						t_dy = 0;
						t_vx = t_vn1.x - t_vn2.x;
						t_vy = t_vn1.y - t_vn2.y;
						/* spread coincident nodes */
						if (t_vx == 0 && t_vy == 0) {
							t_vx = Math.random() * 10 - 5;
							t_vy = Math.random() * 10 - 5;
						}
						var lenSquare:Number = (t_vx * t_vx) + (t_vy * t_vy);
						var minSquareDistance:Number = _MIN_NODE_SEPARATION * _MIN_NODE_SEPARATION;
						
						if (lenSquare < minSquareDistance) {
							lenSquare = minSquareDistance;
						}
						/* Compute the repulsion force */
						var repforce:Number = _repulsionFactor / lenSquare;
						
						t_dx = t_vx * repforce;
						t_dy = t_vy * repforce;
						
						t_distanceMoved = Math.sqrt(t_dx * t_dx + t_dy * t_dy);
						t_maxRepulsiveMotion = Math.max(t_distanceMoved, t_maxRepulsiveMotion);
						
						/* init if not existing */
						if(_deltaPositions[t_vn1] == null) {
							_deltaPositions[t_vn1] = new Point(0,0);
						}
						if(_deltaPositions[t_vn2] == null) {
							_deltaPositions[t_vn2] = new Point(0,0);
						}
						
						/* add to vn1 */
						(_deltaPositions[t_vn1] as Point).offset(t_dx, t_dy);
						
						/* subtract from vn2 */
						(_deltaPositions[t_vn2] as Point).offset(-t_dx, -t_dy);
					}
				}
			}
		}
		
		/*********************************************
		* Layout Methods - Actual update
		* ********************************************/
		/**
		 * @internal
		 * This method scrolls the view to fit the current
		 * graph view. This should have right behavior until
		 * the view bounds are updated
		 * */
		private function scrollToFit():void {
			
            _viewbounds = _vgraph.calcNodesBoundingBox();
            
            if(isNaN(_viewbounds.left) ||
                isNaN(_viewbounds.right) ||
                isNaN(_viewbounds.top) ||
                isNaN(_viewbounds.bottom))
                return;
            
			/* the viewbounds describe the current bounding box of
			 * all nodes */
			if(_viewbounds) {
				/* check if we moved nodes out of bounds and 
				 * do some scrolling */
				if((_viewbounds.left < 0) || (_viewbounds.top < 0) ||
				   (_viewbounds.bottom > _vgraph.height) ||
				   (_viewbounds.right > _vgraph.width)) {
					
					t_dx = (_vgraph.width / 2) - (_viewbounds.x + (_viewbounds.width / 2));
					t_dy = (_vgraph.height / 2) - (_viewbounds.y + (_viewbounds.height / 2));
					
				  /* limit to _SCROLL_STEP pixels at a time */
					t_dx = Math.max(-_SCROLL_STEP, Math.min(t_dx, _SCROLL_STEP))
					t_dy = Math.max(-_SCROLL_STEP, Math.min(t_dy, _SCROLL_STEP))
					
					/* now scroll */
					if((t_dx != 0) || (t_dy != 0)) {
						_vgraph.scroll(t_dx, t_dy,false);
						_layoutChanged = true;
					}
				}
			}
		}
		
		/**
		 * @internal
		 * This method moves each node (i.e. sets the target coordinates)
		 * then it calls the damping function.
		 * There is some potential to eliminate this, particularily
		 * if the motionLimit things are not used....
		 * */
		private function moveNodes():void {
			_lastMaxMotion = _maxMotion; // save last maxMotion
			_maxMotion = 0.0;
			
			/* again work on all visible nodes */
			for each(t_vn1 in _vgraph.visibleVNodes) {
				if(!t_vn1.isVisible) {
					throw Error("Received invisible node while working on visible vnodes only");
				}
				/* work on the target coordinates of the node */
				/* this should not really happen */
				if(_deltaPositions[t_vn1] == null) {
					_deltaPositions[t_vn1] = new Point(0,0);
				}
				
				t_dx = (_deltaPositions[t_vn1] as Point).x;
				t_dy = (_deltaPositions[t_vn1] as Point).y;
				
				/* apply the damper now to slow things down and stabilise
				 * the movement. The lower the damper the lower the movement
				 * 0.0 means no movement 1.0 means no damping */
				if(_dampingActive) {
					t_dx = t_dx * _damper;
					t_dy = t_dy * _damper;
				}
					
				/* reapply the value to the node attribite and half the movement
				 * again.
				 * This slows things down more, but don't stop but keep some momentum
				 * in moving nodes, to avoid a problem if some nodes are
				 * already very slow */
				(_deltaPositions[t_vn1] as Point).x = t_dx / 2.0;
				(_deltaPositions[t_vn1] as Point).y = t_dy / 2.0;
				
				/* how far did the node move? */
				t_distanceMoved = Math.sqrt(t_dx*t_dx + t_dy*t_dy);
					
				/* move the node, but only if it is not currently dragged! */
				if(t_vn1.moveable && t_vn1 != _dragNode) {
					t_vn1.x = t_vn1.x + Math.max(-_MOVEPIXELLIMIT, Math.min(_MOVEPIXELLIMIT, t_dx));
					t_vn1.y = t_vn1.y + Math.max(-_MOVEPIXELLIMIT, Math.min(_MOVEPIXELLIMIT, t_dy));
				}
				/* update the max motion value */
				_maxMotion = Math.max(t_distanceMoved, _maxMotion);
			}
		}

		/*********************************************
		* Layout Methods - Controlling Motion
		* ********************************************/
		
		/**
		 * @internal
		 * This method calculates and adjusts the repulsion
		 * factor, in order for the graph to
		 * fit into ~ 90 % of the available space.
		 **/
		private function adjustRepulsion():void {
			
			var deltaCoverage:Number;
			
			// TO-DO: Should it be called here or with actual scrolling? How often?
			/* bounding box of nodes */
			_viewbounds = _vgraph.calcNodesBoundingBox();
			
            if(isNaN(_viewbounds.left) ||
                isNaN(_viewbounds.right) ||
                isNaN(_viewbounds.top) ||
                isNaN(_viewbounds.bottom))
                return;
            
			/* the viewbounds describe the current bounding box of
			 * all nodes */
			if(_viewbounds) {
				
				/* using the viewbounds the current percentage in coverage can be
				 * calculated */
				_coverage = Math.max((_viewbounds.bottom - _viewbounds.top) / _vgraph.height,
														 (_viewbounds.right - _viewbounds.left) / _vgraph.width );
				
				/* calculate the delta coverage */
				deltaCoverage = _AUTOFITCOVERAGE - _coverage;
				
				if(Math.abs(deltaCoverage) > _AUTOFITCOVERTOLERANCE) {//not within tolerance limit 
					/* compute target change - Similar to proportional gain controller */
					deltaCoverage *= _MAX_REPULSION * 0.1;
					
					/* change only if substantial */
					if (Math.abs(deltaCoverage) > 1.0)
						_repulsionFactor =Math.max(_MIN_REPULSION,
											Math.min(_repulsionFactor + deltaCoverage, 
												_MAX_REPULSION));
				}
			}
			//LogUtil.debug(_LOG, "FD af Coverage:" + _coverage + " repulsionFactor:" + _repulsionFactor);
		}

		/**
		 * @internal
		 * This method checks for some motion limit parameters
		 * and to adjust drag parameter.
		 * */
		private function adjustDrag():void {
			/* calculate the motionRatio, the -1 is subtracted to
			 * make positive values mean things are moving faster
			 */
			if(_maxMotion > 0) {
				_motionRatio = (_lastMaxMotion / _maxMotion) - 1;
			} else {
				_motionRatio = 0.0;
			}
			/*
			_LOG.debug(t_maxSpringMotion + "\t"
					+ t_maxRepulsiveMotion + "\t"
					+ _maxMotion + "\t"
					+ _motionRatio + "\t"
			    + _damper);
				*/
			/* adjust the value of the damper */
			if(_dampingActive) {
				
				/* Only damp if the graph starts to move faster.
				 * If things are slowing down, let them stabilise on their
				 * own, without damping */
				if(_motionRatio <= 0.005) {
					
					/* if maxMotion < 0.2 damp! OR
					 * if the damper has ticked to 0.9 and maxMotion still > 1, damp!
					 * damper must not be negative though */
					if((_maxMotion < 0.2 || (_maxMotion > 1 && _damper < 0.9)) &&
						_damper > 0.01) {
						_damper -= 0.01;
					}
					/* damp a bit less agressively now */
					else if(_maxMotion < 0.4 && _damper > 0.003) {
						_damper -= 0.003;
					}
					/* damp even less agressively */
					else if(_damper > 0.0001) {
						_damper -= 0.0001;
					}
				}
				
				/* damper 0 means no movement(!) */
				if(_maxMotion < _motionLimit) {
					_damper = 0.0;
				}
			}
		}
		
		/*********************************************
		* Mouse Event Handling Methods
		* ********************************************/
		
		/**
		 * @inheritDoc
		 */
		override public function dragContinue(event:MouseEvent, vn:IVisualNode):void{
			super.dragContinue(event, vn);
			refreshInit();
			layoutPass();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dropEvent(event:MouseEvent, vn:IVisualNode):void {
			super.dropEvent(event, vn);
			layoutPass();
		}
	}
}
