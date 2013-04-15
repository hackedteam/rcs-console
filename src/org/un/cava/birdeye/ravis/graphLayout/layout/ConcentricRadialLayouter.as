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

	import flash.geom.Point;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IGTree;
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This is an implementation of the generic radial
	 * layout algorithm that uses concentric rings
	 * for the distance. In addition it will implement
	 * the animation algorithm by Yee et. al that moves
	 * nodes along their circles instead of in straight
	 * lines.
	 * */
	public class ConcentricRadialLayouter extends AnimatedBaseLayouter implements ILayoutAlgorithm {
		
		private static const _LOG:String = "graphLayout.layout.ConcentricRadialLayouter";
		
		/**
		 * The default radius increase between
		 * the concentric circles.
		 * */
		public var defaultRadius:Number = 50;
        
        /**
        * Smallest allowable radius
        */ 
		public var minRadius:Number = 0;
		/**
		 * @internal
		 * we need a previous root for the animation */
		private var _previousRoot:INode;		
		
		/**
		 * @internal
		 * the current maximum depth of the tree */
		private var _maxDepth:int = 0;
		
		/**
		 * @internal
		 * the current radius increase for each circle */
		private var _radiusInc:Number = 0;
		
		/* the two bounding angles */
		private var _theta1:Number;
		private var _theta2:Number;
		private var _setBounds:Boolean;		
		
		/* if we add views the initial size is 0,
		 * so we just keep track of the other nodes and
		 * use the largest size of a node to measure
		 */
		private var _maxviewwidth:Number = 0;
		private var _maxviewheight:Number = 0;

		/**
		 * this holds the data for a layout drawing.
		 * */
		private var _currentDrawing:ConcentricRadialLayoutDrawing;
        
        private var _zoomToFit:Boolean;
		/**
		 * The constructor initializes the layouter and may assign
		 * already a VisualGraph object, but this can also be set later.
		 * @param vg The VisualGraph object on which this layouter should work on.
		 * */
		public function ConcentricRadialLayouter(vg:IVisualGraph = null) {
		
			super(vg);
			
			/* this is inherited */
			animationType = ANIM_RADIAL;
			
			_currentDrawing = null;
			
            radiusInc = defaultRadius;
			_previousRoot = null;
			_theta1 = 0;
			_theta2 = _theta1 + 360;
			_setBounds = false;
			
			_maxviewwidth = MINIMUM_NODE_WIDTH;
			_maxviewheight = MINIMUM_NODE_HEIGHT;
			
			initDrawing();
		}
        
        private function get radiusInc():Number {
            return _radiusInc;
        }
        private function set radiusInc(value:Number):void {
            _radiusInc = Math.max(value,minRadius);
        }

		/**
		 * @inheritDoc
		 * */
		public override function resetAll():void {
			super.resetAll();
			_stree = null;
			_graph.purgeTrees();
		}
		
        public function get zoomToFit():Boolean {
            return _zoomToFit;
        }
        
        public function set zoomToFit(value:Boolean):void {
            _zoomToFit = value;
        }
		/**
		 * @inheritDoc
		 * */
		[Bindable]
		override public function set linkLength(r:Number):void {
			radiusInc = r;
		}
		
		/**
		 * @private
		 * */
		override public function get linkLength():Number {
			return radiusInc;
		}

		/**
		 * @inheritDoc
		 * @internal
		 * This method does the real layout pass, 
		 * i.e. a full calculation of the new layout and
		 * animating the nodes moving into the new position.
		 * */
		override public function layoutPass():Boolean {
		 	
            super.layoutPass();
            
            var rv:Boolean;
			var i:int;
			var n:INode;
			var nodes:Array;
			var cindex:int;
	
			//LogUtil.debug(_LOG, "layoutPass called");
			
			if(!_vgraph) {
				LogUtil.warn(_LOG, "No Vgraph set in ConcentricRadialLayouter, aborting");
				return false;
			}
			
			if(!_vgraph.currentRootVNode) {
				LogUtil.warn(_LOG, "This Layouter always requires a root node!");
				return false;
			}
			
			/* nothing to do if we have no nodes */
			if(_graph.noNodes < 1) {
				return false;
			}
			
			killTimer();
				
			/* establish the current root, if it has 
			 * changed we need to reinit the drawing */
			if(_root != _vgraph.currentRootVNode.node) {
				/* don't forget to save the root here */
				_previousRoot = _root;
				_root = _vgraph.currentRootVNode.node;
				_layoutChanged = true;
			}
			
			/* we test to always reinit the drawing */
			if(_layoutChanged) {
				initDrawing();
			}
			
			//LogUtil.debug(_LOG, "CCLayouter: current root:"+_root.id);
	
			/* set the coordinates in the drawing of root
			 * to 0,0 */
			_currentDrawing.setCartCoordinates(_root,new Point(0,0));
			
			/* establish the spanning tree, but have it restricted to
			 * visible nodes */
			_stree = _graph.getTree(_root, true, false);
			
			/* calculate the relative width and the
			 * new max Depth */
			_maxDepth = 0;
			calcAngularWidth(_root,0);
			
			/* calculate the radius increment to fit the screen */
			if(_autoFitEnabled) {
				autoFit();
			}
			
			/* we may have preset angular bounds
			 * XXX this is untested, yet */
			if(_setBounds) {
				calcAngularBounds(_root);
			}
			
			/* do a static layout pass */
			if(_maxDepth > 0) {
				calculateStaticLayout(_root,radiusInc,_theta1,_theta2);
			}
			
			/* now if we have no previous drawing we can just
			 * apply the result and display it
			 * if we do have (but maybe even if we don't have)
			 * we interpolate the polar coordinates of the nodes */
			if(_zoomToFit){
                doZoomToFit();
            }
                
			resetAnimation();
			
			/* start the animation by interpolating polar coordinates */
			startAnimation();
			
			_layoutChanged = true;
			return rv;
		}
        
        
        protected function doZoomToFit():void 
        {
            _currentDrawing.centeredLayout = false;
            var offset:Point = new Point(-bounds.x/2,-bounds.y/2);
            _currentDrawing.originOffset = offset;
            
            var wF:Number = (vgraph.width - margin)/(bounds.width);
            var hF:Number = (vgraph.height - margin)/(bounds.height);
            var sF:Number = Math.min(wF,hF);
            var newS:Number = Math.min(1, sF);
            vgraph.scale = newS;
            
            var setupsCenter:Point = new Point(bounds.width/2 , bounds.height/2);
            var ourCenter:Point = new Point(vgraph.width/newS/2, vgraph.height/newS/2);
            
            var transformPoint:Point = setupsCenter.subtract(ourCenter);
            for each(var node:INode in _graph.nodes)
            {
                var p:Point = _currentDrawing.getAbsCartCoordinates(node);
                p.x -= transformPoint.x;
                p.y -= transformPoint.y;
                _currentDrawing.setCartCoordinates(node,p);
            } 
        }
		
		/**
		 * Presets the angular bounds of the layout, if desired.
		 * This allows to restrict the layout from drawing a full circle
		 * to only draw in a segment of the circle.
		 * WARNING: XXX THIS HAS NOT BEEN TESTED YET
		 * @param theta The starting angle in radians of the bounding segment. Default is 0.
		 * @param width The angular width of the segment in radians. Default is 2*PI.
		 * */
		public function setAngularBounds(theta:Number, width:Number):void {
			_theta1 = theta;
			_theta2 = _theta1 + width;
			_setBounds = true;
		}

		/*
		 * private functions
		 * */
		 
		/**
		 * @internal
		 * create a new layout model object, which is required
		 * on any root change (and possibly during other occasions)
		 * */
		private function initDrawing():void {			
			_currentDrawing = new ConcentricRadialLayoutDrawing();
			
			/* don't forget to set the object also in the 
			 * BaseLayouter */
			super.currentDrawing = _currentDrawing;
			
			_currentDrawing.originOffset = _vgraph.origin;
			_currentDrawing.centerOffset = _vgraph.center;
			_currentDrawing.centeredLayout = true;
			//LogUtil.debug(_LOG, "New Drawing with origin:"+_currentDrawing.originOffset.toString());
		}
		
		/**
		 * @internal
		 * this autofit method sets the radius increment
		 * so that it should fit into the screen
		 * */
		protected function autoFit():void {
			var r:Number;
			r = Math.min(_vgraph.width, _vgraph.height) / 2.0;
			
			if(_maxDepth > 0) {
				radiusInc = (r - (2 *margin)) / _maxDepth;
			}
		}
		
		/**
		 * @internal
		 * This calculates the angular width of a subtree.
		 * @param n the root node of the subtree.
		 * @param d the current depth.
		 * @return The angular width of the subtree rooted in n at level d.
		 * */
		private function calcAngularWidth(n:INode, d:int):Number {
			var aw:Number = 0;
			var nw:Number;
			var nh:Number;
			var diameter:Number;
			var cn:INode; // child node
			
			if(n == null) {
				throw Error("Node to calculate Angular width is null");
			}
			if(n.vnode == null) {
				throw Error("Node has no vnode");
			}
			
			
			//LogUtil.debug(_LOG, "CalcAngWidth called with node:"+n.id+" and depth:"+d);
			
			if(!n.vnode.isVisible) {
				LogUtil.warn(_LOG, "Node:"+n.id+" not yet visible but called in angular width calc");
				return 0;
			}
			
			/* update current max Depth */
			if(d > _maxDepth) {
				_maxDepth = d;
			}
			
			/* the following two may be 0 in an early stage
			 * so we have to get around that issue 
			 * if it is 0 we assign a default size */
			nw = n.vnode.view.width;
			nh = n.vnode.view.height;
			
			/* update the max view width and height */
			_maxviewwidth = Math.max(_maxviewwidth, nw);
			_maxviewheight = Math.max(_maxviewheight, nh);
			
			if(nw == 0) {
				nw = _maxviewwidth;
			}
			if(nh == 0) {
				nh = _maxviewheight;
			}
			
			//LogUtil.debug(_LOG, "nodes width:"+nw+" height:"+nh);
			
			if(d == 0) {
				diameter = 0; // root node 
			} else {
				/* in another implementation this divided the real
				 * diameter by d not by d times the radiusINcrement
				 * which yields way too large values */
				diameter = Math.sqrt(nw*nw + nh*nh) / (d * radiusInc);
			}
			
			/* diameter is an angular width value in radians,
			 * so we convert it to degrees when used */
			diameter = Geometry.rad2deg(diameter);
			
			
			//LogUtil.debug(_LOG, "depth:"+d+" diameter:"+diameter);
			
			/* here the code checks if the node 'is expanded'
			 * which means if he has visible children
			 * we do it differently, if the node is invisible
			 * his angular width is 0, so is it for all his
			 * children in case they are not visible
			 * this may be a bit less efficient, but it fits
			 * our code */
			if(_stree.getNoChildren(n) > 0) {
				//LogUtil.debug(_LOG, "node:"+n.id+" has children...");
				for each(cn in _stree.getChildren(n)) {
					aw += calcAngularWidth(cn, d+1);
					//LogUtil.debug(_LOG, "current aw for node:"+n.id+" is:"+aw);
				}
				aw = Math.max(diameter,aw);
			} else {
				//LogUtil.debug(_LOG, "node:"+n.id+" has NO children...");
				aw = diameter;
				//LogUtil.debug(_LOG, "current aw for node:"+n.id+" is:"+aw);
			}
			
			_currentDrawing.setAngularWidth(n,aw);
			//LogUtil.warn(_LOG, "Set angular witdh of node:"+n.id+" to:"+aw);
			
			return aw;
		}
		
		/**
		 * @internal
		 * This calculates the angular bounds of the layout
		 * based on the last layout and the set bounds.
		 * @param r The current root node.
		 * */
		private function calcAngularBounds(r:INode):void {

			var ppr:INode;
			var n:INode;
			var oldtree:IGTree;
			var dt:Number;
			var rw:Number;
			var pw:Number;
			var childorder:Array;
			var cc:int;
			var i:int;
			var cindex:int;
			var rp:Point;
			var pp:Point;
			
			if(_previousRoot == null || r == _previousRoot) {
				_previousRoot = r;
				return;
			}
			
			ppr = _stree.parents[_previousRoot];
			
			/* maybe we have no parent ?*/
			if(ppr == null) {
				_previousRoot = r;
				return;
			}
			
			/* now ppr is the parent node of the previous root */
			
			childorder = calculateSortChildrenArray(r);
			cc = childorder.length;
			for(i=0; i < cc; ++i) {
				/* get the index from the sorted array, beware that
				 * the indexes should start with 0, have to make sure
				 * this is the case in the calculate sort function */
				cindex = childorder[i];
				n = _stree.getIthChildPerNode(r,cindex);
				
				/* unclear purpose, probably a root node */
				if(n == ppr) {
					break;
				}
				dt += _currentDrawing.getAngularWidth(n);
			}
			rw = _currentDrawing.getAngularWidth(r);
			pw = _currentDrawing.getAngularWidth(ppr);
			dt = -360 * (dt+ (pw/2)) / rw;
			
			rp = _currentDrawing.getRelCartCoordinates(r);
			pp = _currentDrawing.getRelCartCoordinates(ppr);
			
			/* now set the angular bounds */
			_theta1 = dt + Geometry.rad2deg(Math.atan2((pp.y - rp.y),(pp.x - rp.y)));
			_theta2 = _theta1 + 360;
			_previousRoot = r;
		}
		
		
		/**
		 * @internal
		 * Creates an array which in turn holds the indexes
		 * of the children according to the ordered defined by
		 * the current angular orientation of the nodes.
		 * @param n The node whose children should be sorted.
		 * @return An Array of indexes, which may be used in the getIthChildPerNode() method of the GTree.
		 * @see org.un.cava.birdeye.ravis.graphLayout.data.IGTree#getIthChildPerNode()
		 * */
		private function calculateSortChildrenArray(n:INode):Array {
			var base:Number;
			var cc:int;
			var angles:Array; // an array of Numbers, i.e. of the angles of the children
			var result:Array; // the resulting sort order array
			var pn:INode; //parent node
			var cn:INode; // current child
			var pp:Point; // parent point
			var np:Point; // node point
			var cp:Point; // child point
			var i:int;
			
			base = 0;
			pn = _stree.parents[n];
			
			/* we need that anyway */
			np = _currentDrawing.getRelCartCoordinates(n);
			
			if(pn != null) {
				pp = _currentDrawing.getRelCartCoordinates(pn);
				base = Geometry.rad2deg(Geometry.normaliseAngle(Math.atan2(pp.y - np.y, pp.x - np.x))); 
			}
			
			// else base remains 0
			
			cc = _stree.getNoChildren(n);
			
			/* if we have no children, the array is empty, thus null */
			if(cc == 0) {
				//LogUtil.debug(_LOG, "Node n:"+n.id+" has no children, returning null sort array");
				return null;
			}
			
			/* now the java code uses some hack to determine
			 * if a branch was newly expanded checking the isStartVisible
			 * property of a node, which is unclear what it really does
			 * we ignore this part for now */
			
			angles = new Array(cc);
		
			for(i=0; i < cc; ++i) {
				cn = _stree.getIthChildPerNode(n,i);
				cp = _currentDrawing.getRelCartCoordinates(cn);
				angles[i] = Geometry.normaliseAngleDeg(-base + Geometry.rad2deg(Math.atan2(cp.y - np.y, cp.x - np.x)));
				
				/*
				LogUtil.debug(_LOG, "childorder angle for child:"+cn.id+" of node:"+n.id+" has base:"+base+
					" and angle:"+(angles[i] / (2*Math.PI) * 360));
				*/
			}
			
			result = angles.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			/*
			LogUtil.debug(_LOG, "Built indexarray:"+result.toString()+" of array:"+angles.toString()+
				" for children:"+_stree.getChildren(n).toString());
			*/
			return result;
		}
		
		
		/**
		 * @internal
		 * calculate recursiveley the layout of the current
		 * subtree
		 * @param n The root of the current subtree.
		 * @param r The current radius (distance from center).
		 * @param theta1 The start of the current subtrees angular bounds region.
		 * @param theta2 The end of the current subtrees angular bounds region.
		 * */
		private function calculateStaticLayout(n:INode, r:Number, theta1:Number, theta2:Number):void {
			
			var dtheta:Number;
			var dtheta2:Number;
			var awidth:Number;
			var cfrac:Number;
			var nfrac:Number;
			var childorder:Array;
			var i:int;
			var cindex:int;
			var cc:int;
			var cn:INode;

			dtheta = theta2 - theta1;
			dtheta2 = dtheta / 2.0;
			nfrac = 0.0;
			cfrac = 0.0;
			awidth = _currentDrawing.getAngularWidth(n);	
			
			childorder = calculateSortChildrenArray(n);
			cc = childorder.length;
			for(i=0; i < cc; ++i) {
				
				/* get the index from the sorted array */				
				cindex = childorder[i];
				
				cn = _stree.getIthChildPerNode(n,cindex);			
				cfrac = _currentDrawing.getAngularWidth(cn) / awidth;
				
				/* do we need to recurse, 
				 * we just recurse if the node has children */
				if(_stree.getNoChildren(cn) > 0) {
					calculateStaticLayout(cn, r+radiusInc, 
						theta1 + (nfrac * dtheta),
						theta1 + ((nfrac + cfrac) * dtheta));
				}
				
				//LogUtil.debug(_LOG, "CSL: current radius:"+r);
				_currentDrawing.setPolarCoordinates(cn, r, theta1+(nfrac*dtheta)+(cfrac*dtheta2));
				
				/* set the orientation in the visual node */
				cn.vnode.orientAngle = theta1+(nfrac*dtheta)+(cfrac*dtheta2);
				
				nfrac += cfrac;	
			}
		}
	}
}
