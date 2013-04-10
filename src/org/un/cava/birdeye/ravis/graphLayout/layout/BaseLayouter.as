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

	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.Graph;
	import org.un.cava.birdeye.ravis.graphLayout.data.IGTree;
	import org.un.cava.birdeye.ravis.graphLayout.data.IGraph;
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.events.VisualGraphEvent;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This is an base class to various layout implementations
	 * it does not really do any layouting but implements
	 * everything required by the Interface.
	 * */
	public class BaseLayouter extends EventDispatcher implements ILayoutAlgorithm {
		
		private static const _LOG:String = "graphLayout.layout.BaseLayouter";
		
		/**
		 * The default minimum node height to be used if the exact node
		 * height cannot be determined yet.
		 * */
		public static const MINIMUM_NODE_HEIGHT:Number = 5;
		
		/**
		 * The default minimum node width to be used if the exact node
		 * height cannot be determined yet.
		 * */
		public static const MINIMUM_NODE_WIDTH:Number = 5;
		
		/**
		 * If set to true, animation is disabled and direct
		 * node location setting occurs (instantaneously).
		 * @default false
		 * */
		protected var _disableAnimation:Boolean = false;
		
		/**
		 * All layouters need access to the VisualGraph.
		 * */
		protected var _vgraph:IVisualGraph = null;
		
		/**
		 * All layouters need access to the Graph.
		 * */
		protected var _graph:IGraph = null;
		
		/**
		 * This keeps track if the layout has changed
		 * and can be accessed by any derived layouter.
		 * */
		protected var _layoutChanged:Boolean = false;

		/** 
		 * A spanning tree of the graph, since probably every layout 
		 * will work on a spanning tree, we keep this one in this
		 * base class.
		 * */
		protected var _stree:IGTree;

		/**
		 * The current root node of the layout.
		 * */
		protected var _root:INode;
		
		/**
		 * The indicator if AutoFit should currently be used or not.
		 * */
		protected var _autoFitEnabled:Boolean = false;

		/**
		 * this holds the data for a layout drawing.
		 * */
		private var _currentDrawing:BaseLayoutDrawing;
        
        /**
         * The default margin to be considered when using
         * autoFit.
         * */
         private var _margin:Number = 30; 
        
         protected var _bounds:Rectangle;
		/**
		 * The constructor initializes the layouter and may assign
		 * already a VisualGraph object, but this can also be set later.
		 * @param vg The VisualGraph object on which this layouter should work on.
		 * */
		public function BaseLayouter(vg:IVisualGraph = null) {
			
			_vgraph = vg;
			if(vg) {
				_graph = _vgraph.graph;
			} else {
				_graph = new Graph("dummyID");
			}
			
            /* this is required to smooth the animation */
            if(_vgraph)
			    _vgraph.addEventListener("forceRedrawEvent",forceRedraw);
		}
		
		public function get margin():Number {
			return _margin;
		}
		
		public function set margin(value:Number):void {
			_margin = value;
		}

		/**
		 * @inheritDoc
		 * */
		public function resetAll():void {
			_layoutChanged = true;
		}
        
        public function get vgraph():IVisualGraph { 
            return _vgraph;
        }
        
		/**
		 * @inheritDoc
		 * @throws An error if the vgraph was already set.
		 * */
		public function set vgraph(vg:IVisualGraph):void {
			if(_vgraph == null) {
				_vgraph = vg;
				_graph = _vgraph.graph;
			} else {
				LogUtil.warn(_LOG, "vgraph was already set in layouter");
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set graph(g:IGraph):void {
			_graph = g;
		}

		/**
		 * @inheritDoc
		 * */	
		public function get layoutChanged():Boolean {
			return _layoutChanged;
		}
		
		/**
		 * @private
		 * */
		public function set layoutChanged(lc:Boolean):void {
			_layoutChanged = lc;
		}
		
		/**
		 * @inheritDoc
		 * */
		[Bindable]	 
		public function get autoFitEnabled():Boolean {
			return _autoFitEnabled;	
		}
		
		/**
		 * @private
		 * */
		public function set autoFitEnabled(af:Boolean):void {
			_autoFitEnabled = af;
		}

		/**
		 * This is a NOP in the BaseLayouter class. It does not set
		 * anything and always returns 0.
		 * 
		 * @inheritDoc
		 * */
		[Bindable]
		public function set linkLength(r:Number):void {
			/* NOP */
		}
		
		/**
		 * @private
		 * */
		public function get linkLength():Number {
			/* NOP
			 * but must not return 0, since some layouter
			 * do not care about LL, but the vgraph will
			 * not draw if LL is 0
			 * so default is something else, like 1
			 */
			return 1;
		}

		/**
		 * @inheritDoc
		 * */
		public function get animInProgress():Boolean {
			/* since the base layouter is ignorant of animation
			 * it would always return false. The AnimatedBaseLayouter
			 * though needs to override this to always return the
			 * correct value. */
			return false;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set disableAnimation(d:Boolean):void {
			_disableAnimation = d;
		};
		
		/**
		 * @private
		 * */
		public function get disableAnimation():Boolean {
			return _disableAnimation;
		}
		
		/**
		 * This always returns true, dispatches the graph updated event.
		 * 
		 * @inheritDoc
		 * */
		public function layoutPass():Boolean {
            _bounds = null;
            dispatchEvent(new VisualGraphEvent(VisualGraphEvent.GRAPH_UPDATED));
		 	return true;
		}
        
        private function calculateBounds():Rectangle
        {
            var retVal:Rectangle = new Rectangle(NaN,NaN,NaN,NaN);
            for each(var node:INode in _graph.nodes)
            {
                var p:Point = _currentDrawing.getAbsCartCoordinates(node);
                if(p.x > retVal.right || isNaN(retVal.right))
                    retVal.right = p.x;
                
                if(p.y > retVal.bottom || isNaN(retVal.bottom))
                    retVal.bottom = p.y;
                
                if(p.x < retVal.left || isNaN(retVal.left))
                    retVal.left = p.x;
                
                if(p.y < retVal.top || isNaN(retVal.top))
                    retVal.top = p.y;
            }
            
            return retVal;
        }
        
        public function get bounds():Rectangle
        {
            if(_bounds)
                return _bounds;
            
            _bounds = calculateBounds();
            return _bounds;
        }
        
		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function refreshInit():void {
			/* NOP */
		}
		
		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function dragEvent(event:MouseEvent, vn:IVisualNode):void {
            _bounds = null;
		}
		
		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function dragContinue(event:MouseEvent, vn:IVisualNode):void {
			// LogUtil.debug(_LOG, "Node: " + vn.node.stringid + " being DRAGGED...");
            _bounds = null;
		}
		
		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function dropEvent(event:MouseEvent, vn:IVisualNode):void {
            _bounds = null;
		}
		
		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function bgDragEvent(event:MouseEvent):void {
            _bounds = null;
		}

		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function bgDragContinue(event:MouseEvent):void {
            _bounds = null;
		}
		
		/**
		 * This is a NOP for this layouter.
		 * @inheritDoc
		 * */
		public function bgDropEvent(event:MouseEvent):void {
            _bounds = null;
		}
		
		/**
		 * Allow to set the reference to the drawing object from
		 * derived classes. This is important because of the 
		 * type issue, the _currentDrawing variable will be declared
		 * separately in each derived layouter, but this one must
		 * have access to it anyway, to do the animation
		 * @param dr The drawing object that needs to be assigned.
		 * */
		protected function set currentDrawing(dr:BaseLayoutDrawing):void {
			_currentDrawing = dr;
		}
		
		
		/**
		 * Sets the current absolute target coordinates of a node
		 * in the node's vnode. This does not yet move the node,
		 * as for this the vnode's commit() method must be called.
		 * @param n The node to get its target coordinates updated.
		 * */ 
		protected function applyTargetCoordinates(n:INode):void {
			
			var coords:Point;
			/* add the points coordinates to its origin */		
			coords = _currentDrawing.getAbsCartCoordinates(n);
		
			n.vnode.x = coords.x;
			n.vnode.y = coords.y;
		}
		
		/**
		 * Applies the target coordinates to all nodes that
		 * are in the Dictionary object passed as argument.
		 * The items are expected to be VNodes (as typically
		 * a list of currently visible VNodes is passed).
		 * */ 
		protected function applyTargetToNodes(vns:Array):void {
			var vn:IVisualNode;
			for each(vn in vns) {			
				/* should be visible otherwise somethings wrong */
				if(!vn.isVisible) {
					throw Error("received invisible vnode from list of visible vnodes");
				}
				applyTargetCoordinates(vn.node);
				vn.commit();
			}			
		}
		
		private function forceRedraw(e:MouseEvent):void {
			//e.updateAfterEvent();
		}
	}
}
