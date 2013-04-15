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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	import org.un.cava.birdeye.ravis.utils.StopWatch;
	import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
	/**
	 * This is a base class of an Iterative Layouting algorithm. Unlike one
	 * pass algorithms with performs animation to reach to a final drawing, 
	 * an iterative algorithm has several steps that are not pre-determined
	 * and are required to be taken until the graph 'stabilizes'.
	 * 
	 * By definition, there could be many steps involved so the goal is to:
	 * (a) report measure of stability - update the user about the developments
	 * (b) faster computation steps - less time spent before every refresh
	 * (c) responsive UI - not to freeze the interface during computation
	 * 
	 * @author Nitin Lamba
	 **/
	public class IterativeBaseLayouter extends BaseLayouter implements ILayoutAlgorithm {
		
		private static const _LOG:String = "graphLayout.layout.IterativeBaseLayouter";
		
		/*********************************************
		* CONSTANTS
		* ********************************************/
		
		private var _animationInProgress:Boolean;
		/**
		 * @internal
		 * Timing related constants.
		 * */
		private const _TIMERDELAY:Number = 10;
		private const _TIMERREPCOUNT:int = 1;
	
		/*********************************************
		* Members
		* ********************************************/
		/* the timer object */
		private var _timer:Timer = null;
		private var _stopWatch:StopWatch = new StopWatch();
		private var _timerDelay:Number = _TIMERDELAY;
		
		/* for dragging and dropping */
		protected var _dragNode:IVisualNode = null;
		
		
		/**
		 * The constructor only initialises the data structures and presets
		 * some parameters.
		 * */
		public function IterativeBaseLayouter(vg:IVisualGraph = null):void {
			super(vg);
		}

		/**
		 * Reset all layouting parameters, which may be
		 * required during a significant layout change.
		 * This is particularily important in this layouter,
		 * as it constantly updates the layout (using the timer).
		 * */
		override public function resetAll():void {
			super.resetAll();
			
			/* reset timer */
			if(_timer != null) {
				_timer.stop()
				_timer.reset();
				//_timer = null;
				//LogUtil.debug(_LOG, "Timer STOPPED");
			}
			
			/* reset parameters */
			refreshInit();
		}
		
		/**
		 * This method notifies the layouter about a drag/drop
		 * operation. This is important to exempt are currently
		 * dragged node from the layouting, to allow it to drag
		 * the whole graph with it. This method basically sets the
		 * current drag node.
		 * @param event The mouse event that is fired on the starting of the drag operation.
		 * @param vn The node which is being dragged.
		 * */
		override public function dragEvent(event:MouseEvent, vn:IVisualNode):void {
			/* we have to make sure, that what we want
			 * to drag is actually a UIComponent, i.e. 
			 * part of our nodes, if not we do nothing. */
			if(event.currentTarget is UIComponent) {
				_dragNode = vn;
			}
		}
		
		/**
		 * If we receive a drop event, we delete the drag node.
		 * @param event The mouse event that is fired on the starting of the drag operation.
		 * @param vn The node which is being dragged.
		 * */
		override public function dropEvent(event:MouseEvent, vn:IVisualNode):void {
			_dragNode = null;
		}

		/**
		 * This is the actual method that does a layout pass. In this
		 * Layouter, it is supposed to interrupt and kick-off a new
		 * layout cycle, which is different from most others, since this
		 * layouter keeps on calculating the layout through a timer.
		 * */
		override public function layoutPass():Boolean {
			
            super.layoutPass();
            
			/* if we have a current timer running, stop it
			 * to avoid mutiple unnecessary calls */
			if(_timer != null) {
				_timer.stop();
			}
			_animationInProgress = true;
			return layoutIteration();
		}
		
		/**
		 * Do a full calculation iteration of the layout. 
		 * This is a wrapper only; the actual computation at
		 * every step is done in calculateLayout()
		 * */
		protected function layoutIteration():Boolean {
			//var visVNodes:Dictionary = _vgraph.visibleVNodes;
			var vn:IVisualNode;
			
			/* return value, not really used */
			var rv:Boolean = true;
			
			/* Evaluate end condition */
			if (!isStable()) {
				_stopWatch.startTimer();
				// Step 1: Retrieve old coordinates from vNodes
				/* basically, refresh coordinates from their 'view' UI components */
				for each(vn in _vgraph.visibleVNodes) {
					if(!vn.isVisible) {
						throw Error("Received invisible node while working on visible vnodes only");
					}
					vn.refresh();
				}
				
				// Step 2: Calculate new layout
				calculateLayout();
				
				// Step 3: Commit new coordinates to all vNodes
				/* basically, set the view UI component to new values */
				for each(vn in _vgraph.visibleVNodes) {
					if(!vn.isVisible) {
						throw Error("Received invisible node while working on visible vnodes only");
					}
					vn.commit();
				}
				
				// Step 4: Update node position, redraw edges and sent update to the UI */
				_layoutChanged = true;
				_vgraph.redrawEdges();
				_vgraph.dispatchEvent(new VGraphEvent(VGraphEvent.VGRAPH_CHANGED));
				
				// Step 5: Re-start the Timer
				_timerDelay = _stopWatch.stopTimer();
				//LogUtil.debug(_LOG, "Iteration computation time = " + _timerDelay);
				restartTimer();
			} else {
				_animationInProgress = false;
				LogUtil.debug(_LOG, "Achieved steady node state, terminating iterations...");
			}
			
			/* return always true for now */
			return rv;
		}

		
		/**
		 * @internal
		 * This starts the timer, which essentially kicks off the
		 * iterative layout calculation until the layout has stabilised.
		 * */
		private function restartTimer():void {
			/* if timer is not initialized, create a new timer */
			if(_timer == null) {
				_timer = new Timer(_timerDelay, _TIMERREPCOUNT);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerFired);
				//TODO: Put preArrageFunction here
			} else {
				_timer.stop();
				_timer.reset();
			}
			
			//if (_timerDelay > _TIMERDELAY) _timer.delay = _timerDelay + 10;
			_timer.start();
		}
		
		/**
		 * @internal
		 * When the timer is fired, this calls a layout iteration
		 * */
		private function timerFired(event:TimerEvent = null):void {
			/* repeat the calculation */
			layoutIteration();
			event.updateAfterEvent();
		}
		
		/**
		 * Checks if the layout has stabilized.
		 * Sub-classes should define terminating conditions 
		 * for the layout computations.
		 * 
		 * @return true if the layout has stabilized
		 */
		protected function isStable():Boolean {
			/* NOP */
			return true;
		}
		/**
		 * Calculation step of the layout. 
		 * Sub-classes should override this method 
		 * to define actual layout computations for
		 * every step.
		 */
		protected function calculateLayout():void {
			/* NOP */
		} 
		
		override public function get animInProgress():Boolean
		{
			return _animationInProgress;
		}
	}
}
