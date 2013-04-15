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
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This layouter does not use any algorithm for node placement,
	 * but relys on coordinate information (x,y-coordinates) specified
	 * in each nodes associated XML object.
	 * It also takes a relative height and width parameter (which may be
	 * calculated by autofit) to put the specified coordinates into
	 * perspective.
	 * */
	public class DirectPlacementLayouter extends BaseLayouter implements ILayoutAlgorithm {
		
		private static const _LOG:String = "graphLayout.layout.DirectPlacementLayouter";
		
		/* hold the relative height and width of the specified coordinates */
		private var _relativeHeight:Number;
		private var _relativeWidth:Number;
		
		/* a specified relative origin, defaults to (0,0); */
		private var _relativeOrigin:Point;
		
		/**
		 * defines if the vgraph's center offset should be applied.
		 * Set it to true if your coordinates assume a centered origin
		 * and you place them all around the center.
		 * @default false
		 * */
		public var centeredLayout:Boolean;
		
		
		/**
		 * The constructor only initialises some data structures.
		 * @inheritDoc
		 * */
		public function DirectPlacementLayouter(vg:IVisualGraph = null) {
			super(vg);
			
			_relativeHeight = 1000;
			_relativeWidth = 1000;
			_relativeOrigin = new Point(0,0);
			centeredLayout = false;
		}

		/**
		 * @inheritDoc
		 * */
		override public function resetAll():void {			
			
			super.resetAll();
			
			/* invalidate all trees in the graph */
			_stree = null;
			_graph.purgeTrees();
		}

		/**
		 * This main interface method computes and
		 * and executes the new layout.
		 * @return Currently the return value is not set or used.
		 * */
		override public function layoutPass():Boolean {
			
			//LogUtil.debug(_LOG, "layoutPass called");
			if(!_vgraph) {
				LogUtil.warn(_LOG, "No Vgraph set in DPLayouter, aborting");
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
			
			var notReadyRenderer:UIComponent = getFirstUninitializedNode();
			if(notReadyRenderer) {
				notReadyRenderer.callLater(layoutPass);
				return false;
			}
			else {
                super.layoutPass();
				placeNodes();
			}

			_layoutChanged = true;
			return true;
		}
		
		private function getFirstUninitializedNode():UIComponent{
			for each(var node:IVisualNode in _vgraph.visibleVNodes) {
				if(node.view.initialized == false) {
					return node.view;
				}
			}
			
			return null;
		}
	
		/**
		 * Access the relative height for the y coordinates specified.
		 * Default is 1000.
		 * */
		public function set relativeHeight(rh:Number):void {
				_relativeHeight = rh;
		}
		
		/**
		 * @private
		 * */
		public function get relativeHeight():Number {
			return _relativeHeight;
		}
		
		/**
		 * Access the relative width for the x coordinates specified.
		 * Default is 1000.
		 * */
		public function set relativeWidth(rw:Number):void {
				_relativeWidth = rw;
		}
		
		/**
		 * @private
		 * */
		public function get relativeWidth():Number {
			return _relativeWidth;
		}
		
		/**
		 * Access the relative origin, which will result in an offset for
		 * each coordinate, default is (0,0);
		 * */
		public function set relativeOrigin(ro:Point):void {
				_relativeOrigin = ro;
		}
		
		/**
		 * @private
		 * */
		public function get relativeOrigin():Point {
			return _relativeOrigin;
		}
		
		
		/**
		 * @internal
		 * Places the nodes according to the specified coordinates
		 * in the XML data of each node. Interprets the coordinates
		 * relative to the Height and Width specified (default 1000).
		 * If autoFit is enabled, it will in addition take that
		 * into account. The internal reference grid is always 1000x1000.
		 * */
		private function placeNodes():void {
			
			var visVNodes:Array;
			var vn:IVisualNode;
			var node_x:Number;
			var node_y:Number;
			var target:Point;
			
			/* those are needed for autofit */
			var smallest_x:Number = Infinity;
			var largest_x:Number = -Infinity;
			var largest_y:Number = -Infinity;
			var smallest_y:Number = Infinity;
			var max_x_dist:Number = 0;
			var max_y_dist:Number = 0;
			var max_label_width:Number = -Infinity;
			var max_label_height:Number = -Infinity;
			
			visVNodes = _vgraph.visibleVNodes;
			
			/* place visible nodes */
			for each(vn in visVNodes) {
				
				if(vn.data is XML)
				{
					/* check for x and y attributes */
					if((vn.data as XML).attribute("x").length() > 0) {
						node_x = Number(vn.data.@x);
					} else {
						LogUtil.warn(_LOG, "Node:"+vn.id+" associated XML object does not have x attribute, => 0.0");
						node_x = 0.0;
					}
					
					if((vn.data as XML).attribute("y").length() > 0) {
						node_y = Number(vn.data.@y);
					} else {
						LogUtil.warn(_LOG, "Node:"+vn.id+" associated XML object does not have y attribute, => 0.0");
						node_y = 0.0;
					}
				}
				else
				{
					if(vn.data.hasOwnProperty("x") && vn.data.x is Number) {
						node_x = vn.data.x;
					} else {
						LogUtil.warn(_LOG, "Node:"+vn.id+" associated Data object does not have x attribute as Number, => 0.0");
						node_x = 0.0;
					}
					
					if(vn.data.hasOwnProperty("y") && vn.data.y is Number) {
						node_y = vn.data.y;
					} else {
						LogUtil.warn(_LOG, "Node:"+vn.id+" associated Data object does not have y attribute, => 0.0");
						node_y = 0.0;
					}
				}
				
				//LogUtil.debug(_LOG, "using rel width:"+_relativeWidth+" rh:"+_relativeHeight);
				target = new Point(node_x * 1000 / _relativeWidth, node_y * 1000 / _relativeHeight);
				//LogUtil.debug(_LOG, "target for node:"+vn.id+" = " + target.toString());
				
				/* apply the relative origin */
				target = target.add(_relativeOrigin);
				//LogUtil.debug(_LOG, "target2 for node:"+vn.id+" = " + target.toString());

				
				/* set the coordinates in the VNode, this won't be
				 * applied until commit() is called */
				vn.x = target.x;
				vn.y = target.y;
				
				/* if autofit is enabled, we need to track
				 * the largest distances */
				if(_autoFitEnabled) {
					if(smallest_x > target.x) {
						smallest_x = target.x;
					}
					if(smallest_y > target.y) {
						smallest_y = target.y;
					}
					if(largest_x < target.x) {
						largest_x = target.x;
					}
					if(largest_y < target.y) {
						largest_y = target.y;
					}
					if(vn.view.width > max_label_width) {
						max_label_width = vn.view.width;
					}
					if(vn.view.height > max_label_height) {
						max_label_height = vn.view.height;
					}
				}
			}
			
			/* if autofitted, scale to the current canvas */
			if(_autoFitEnabled) {
				/* find greatest distance in each dimension */
				max_x_dist = largest_x - smallest_x;
				max_y_dist = largest_y - smallest_y;

				/* adjust nodes */
				for each(vn in visVNodes) {
					vn.x = vn.x * ((_vgraph.width - (2 * margin) - max_label_width) / max_x_dist);
					vn.y = vn.y * ((_vgraph.height - (2 * margin) - max_label_height) / max_y_dist);
				}
			}
			
			/* final round, to apply the vgraph origin and to call commit */
			for each(vn in visVNodes) {
				vn.x = vn.x + _vgraph.origin.x;
				vn.y = vn.y + _vgraph.origin.y;
				
				if(centeredLayout) {
					vn.x = vn.x + _vgraph.center.x;
					vn.y = vn.y + _vgraph.center.y;	
				}
				vn.commit();
			}
		}
	}
}
