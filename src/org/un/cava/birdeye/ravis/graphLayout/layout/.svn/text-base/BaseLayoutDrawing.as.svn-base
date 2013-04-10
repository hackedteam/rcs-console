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
	
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.utils.Geometry;
	
	/**
	 * This is a base class to hold layout drawing information
	 * like target coordinates for all nodes, access to polar and
	 * cartesian versions of those coordinates and an origin offset.
	 * So it can already represent a drawing.
	 * */
	public class BaseLayoutDrawing	{

		/* we create a virtual origin, that is used as an offset
		 * to the (0,0) origin of the root node */
		private var _originOffset:Point;
		
		/* this is the current center offset of the 
		 * canvas, which can be applied as well */
		private var _centerOffset:Point;
		
		private var _centeredLayout:Boolean = true;
		
		/* we need the polar coordinates AND the relative
		 * origin AND the "zero degrees" ray angle of every
		 * node and of course the cartesian coordinates */
		
		/* node coordinates in polar and cartesian form, these
		 * are all "relative" coordinates. */
		private var _nodePolarRs:Dictionary;
		private var _nodePolarPhis:Dictionary;
		private var _nodeCartCoordinates:Dictionary;

		/* we need a flag to indicate if the node 
		 * in the current layout is valid or not
		 */
		private var _nodeDataValid:Dictionary;

		/**
		 * The constructor just initializes the internal data structures.
		 * */
		public function BaseLayoutDrawing() {
			
			_nodePolarRs = new Dictionary;
			_nodePolarPhis = new Dictionary;
			_nodeCartCoordinates = new Dictionary;
			_nodeDataValid = new Dictionary;
			
			_originOffset = new Point(0,0);
			_centerOffset = new Point(0,0);
			_centeredLayout = true;
		}
		
		/*
		 * getters and setters 
		 * */
		
		
		/**
		 * Access to the offset of the origin of the layout.
		 * The actual origin is the upper left corner of the
		 * canvas. But that changes if we scroll the canvas
		 * around, so we have to keep track of this offset.
		 * @param o The new origin offset.
		 * */
		[Bindable]
		public function get originOffset():Point {
			return _originOffset;
		}
		/**
		 * @private
		 * */
		public function set originOffset(o:Point):void {
			_originOffset = o;
		}
		
		/**
		 * Access to the offset of the center of the layout.
		 * The actual origin is the upper left corner of the
		 * canvas. But the calculation of this layout is done around
		 * circles around the origin. So we want to move the
		 * origin into the center of the canvas, This is what the
		 * center offset actually does.
		 * @param o The new center offset.
		 * */
		[Bindable]
		public function get centerOffset():Point {
			return _centerOffset;
		}
		/**
		 * @private
		 * */
		public function set centerOffset(o:Point):void {
			_centerOffset = o;
		}
		
		/**
		 * Specifies if the center offset should be applied 
		 * or not.
		 * @param o The new origin offset.
		 * */
		[Bindable]
		public function get centeredLayout():Boolean {
			return _centeredLayout;
		}
		/**
		 * @private
		 * */
		public function set centeredLayout(c:Boolean):void {
			_centeredLayout = c;
		}
		
		
		/**
		 * indicates if the data set for a given node is 
		 * currently valid.
		 * WARNING: may not be implemented properly and may not even be needed
		 * @param n The node for which dataset the validity should be tested.
		 * @return If the dataset for node n is valid.
		 * */
		public function nodeDataValid(n:INode):Boolean {
			return _nodeDataValid[n];
		}
		
		/**
		 * invalidate all node data sets
		 * */
		public function invalidateNodeData():void {
			_nodeDataValid = new Dictionary;
		}
		
		/**
		 * Set the target coordinates for node n according to the
		 * calculated layout in Polar form. Consider these are
		 * "relative" coordinates, which will finally be adjusted
		 * by the origin offset.
		 * 
		 * @param n The node to set its coordinates.
		 * @param polarR The radius (length) part of the polar coordinates.
		 * @param polarPhi The angle part of the polar coordinates (in degrees).
		 * @throws An error if any part of the coordinates is NaN (not a number).
		 *  */
		public function setPolarCoordinates(n:INode, polarR:Number, polarPhi:Number):void {
			
			/* we have to void NaN values */
			if(isNaN(polarR)) {
				throw Error("polarR tried to set to NaN");
			}
			if(isNaN(polarPhi)) {
				throw Error("polarPhi tried to set to NaN");
			}	
							
			_nodePolarRs[n] = polarR;
			_nodePolarPhis[n] = polarPhi;
			_nodeCartCoordinates[n] = Geometry.cartFromPolarDeg(polarR, polarPhi);
			
			//LogUtil.debug(_LOG, "SetPolarCoordinates of node:"+n.id+" polarRadius:"+polarR+" polarPhi:"+polarPhi+" and in cartesian:"+(_nodeCartCoordinates[n] as Point).toString());
			
			_nodeDataValid[n] = true;
		}
		
		/**
		 * Set the target coordinates for node n according to the
		 * calculated layout in cartesian (i.e. x and y) form. Consider these are
		 * "relative" coordinates, which will finally be adjusted
		 * by the origin offset.
		 * @param n The node to set its coordinates.
		 * @param p The point object representing the target coordinates.
		 *  */
		public function setCartCoordinates(n:INode, p:Point):void {
			
			/*
			if(isNaN(p.x) || isNaN(p.y) || !isFinite(p.x) || !isFinite(p.y)) {
				throw Error("Target Point:"+p.toString()+" of node:"+n.id+" is not valid");
			}
			*/
	
			_nodePolarRs[n] = p.length;
			_nodePolarPhis[n] = Geometry.polarAngleDeg(p);
			_nodeCartCoordinates[n] = p;
			
			/*
			LogUtil.debug(_LOG, "SetCartCoordinates of node:"+n.id+" polarRadius:"+_nodePolarRs[n]+
				" polarPhi:"+_nodePolarPhis[n]+" and in cartesian:"+
				(_nodeCartCoordinates[n] as Point).toString());
			*/
			_nodeDataValid[n] = true;
		}		
		
		/**
		 * access the polar radius part of the 
		 * target coordinates of the given node.
		 * These are relative coordinates (subject to origin offset).
		 * @param n The node which target coordinate is required.
		 * @return The radius part of n's target coordinates (in polar).
		 * */ 
		public function getPolarR(n:INode):Number {
			return _nodePolarRs[n];
		}
		
		/**
		 * access the polar angle part of the 
		 * target coordinates of the given node.
		 * These are relative coordinates (subject to origin offset).
		 * @param n The node which target coordinate is required.
		 * @return The angle part of n's target coordinates (in polar).
		 * */ 
		public function getPolarPhi(n:INode):Number {
			return _nodePolarPhis[n];
		}
		
		/**
		 * Access the cartesian coordinates of the given node.
		 * These are relative coordinates (subject to origin offset).
		 * @param n The node which target coordinates are required.
		 * @return A Point object that contains the required coordinates.
		 * */
		public function getRelCartCoordinates(n:INode):Point {
			
			/* these may not yet have been initialised
			 * in this case, we preset them to the current
			 * Relative coordinates, i.e. minus the originOffset 
			 */
			var c:Point;
			
			c = _nodeCartCoordinates[n];
			
			if(c == null) {
				n.vnode.refresh();	
				c =	new Point(n.vnode.x, n.vnode.y);
				c = c.subtract(_originOffset);
			
				if(_centeredLayout) {
					c = c.subtract(_centerOffset);
				}
				
				setCartCoordinates(n,c);
			}
			return c;
		}
		
		/**
		 * Access the absolute cartesian coordinates of the given node.
		 * These are the absolute coordinates with the origin offset
		 * already applied.
		 * @param n The node which target coordinates are required.
		 * @return A Point object that contains the required absolute coordinates.
		 * */
		public function getAbsCartCoordinates(n:INode):Point {
			var res:Point;
			
			res = getRelCartCoordinates(n).add(_originOffset);
			
			if(_centeredLayout) {
				res = res.add(_centerOffset);
			}
			
			return res;
		}
	}
}
