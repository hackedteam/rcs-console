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
package org.un.cava.birdeye.ravis.graphLayout.visual {
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;

	/** 
	 * Interface for a visual edge. This does not do
	 * a lot. In fact, since the avgNodeSideLength()
	 * method is only used by the ForceDirected layouter,
	 * maybe this could be eliminated in a future version.
	 * */
	public interface IVisualEdge extends IVisualItem {	
		/**
		 * Access to the associated graph Edge.
		 * */ 
		function get edge():IEdge;
		
		/**
		 * Access to an associated UIComponent to
		 * display a label.
		 * */
		function get labelView():UIComponent;
		
		/**
		 * @private
		 * */
		function set labelView(lv:UIComponent):void;
	
		/**
		 * Applies the provided coordinates to edges label (if present).
		 * 
		 * @param p The Point with the target coordinates.
		 * */
		function setEdgeLabelCoordinates(p:Point):void;
		
		/**
		 * Set the lineStyle of the edge. The parameter
		 * passed must be an object, containing a mapping.
		 * The properties (keys) in the mapping must match the
		 * lineStyle() parameters of Graphics.
		 * @see flash.display.Graphics.lineStyle()
		 * */
		function get lineStyle():Object;
		
		/**
		 * @private
		 * */
		function set lineStyle(ls:Object):void;
        
        function get edgeView():IEdgeRenderer;
        function set edgeView(value:IEdgeRenderer):void
	}
}