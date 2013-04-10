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
package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual {

	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	
	/**
	 * Interface for any Edge renderers,
	 * basically this is very simple as it just
	 * requires a draw() method.
	 * */
	public interface IControllableVisualEdge {
		
		function get fromControl():UIComponent;
		
		function set fromControl(control:UIComponent):void;
	
		function get toControl():UIComponent;
		
		function set toControl(control:UIComponent):void;
		
		function setEdgeFromControlCoordinates(p:Point):void;
		
		function setEdgeToControlCoordinates(p:Point):void;
				
	}
}