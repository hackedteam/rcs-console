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
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	
	/**
	 * This class holds all the parameters needed
	 * for a drawing representation of a graph drawing
	 * with a Concentric Radial Layout and corresponding access methods
	 * It actually represents a calculated layout.
	 * */
	public class ConcentricRadialLayoutDrawing extends BaseLayoutDrawing {


		/* our addition for the concentric radial Layout is
		 * a storage for the angular widths */
		private var _nodeAngularWidths:Dictionary;

		/**
		 * The constructor just initializes the internal data structures.
		 * */
		public function ConcentricRadialLayoutDrawing() {
			super();
			_nodeAngularWidths = new Dictionary;
		}
				
		/**
		 * This methods allows the setting of the "angular width"
		 * value for each node, which is required by the corresponding
		 * layouter.
		 * @param n The node for which the width to set.
		 * @param w The angular width of the node in degrees.
		 * */
		public function setAngularWidth(n:INode, w:Number):void {
			
			//LogUtil.debug(_LOG, "Setting angular width for node:"+n.id+" to:"+degrees+" degrees");
			/*
			if(w > 360) {
				LogUtil.warn(_LOG, "Width of node:"+n.id+" larger than 360:"+w);
			}
			if(w < 0) {
				LogUtil.warn(_LOG, "Width of node:"+n.id+" smaller than 0:"+w);
			}
			*/
			_nodeAngularWidths[n] = w;
		}
		
		/**
		 * Allows retrieval of the "angular width" value of a 
		 * given node, required by the layouter.
		 * @param n The node for which the angular width is requested.
		 * @return The angular width of that node in radians.
		 * */
		public function getAngularWidth(n:INode):Number {
			return _nodeAngularWidths[n];
		}
	}
}
