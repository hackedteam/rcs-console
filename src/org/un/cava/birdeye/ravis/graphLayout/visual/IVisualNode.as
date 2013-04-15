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
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	
	/** 
	 * The visual node interface, this includes
	 * lots of access methods for location properties,
	 * movement properties. Some of them may become
	 * obsolete and may be removed in the future.
	 * */
	public interface IVisualNode extends IVisualItem {
		
		/**
		 * Access to the target X coordinate of this
		 * VisualNode. The commit() method will actually
		 * apply these coordinates in the node's UIComponent.
		 * @see commit()
		 * */
		function get x():Number;
		
		/**
		 * @private
		 * */
		function set x(n:Number):void;
		
		/**
		 * Access to the target Y coordinate of this
		 * VisualNode. The commit() method will actually
		 * apply these coordinates in the node's UIComponent.
		 * @see commit()
		 * */
		function get y():Number;	
		
		/**
		 * @private
		 * */			
		function set y(n:Number):void;

		/**
		 * Same as 'view', only exists as a legacy function
		 * and will vanish eventually.
		 * @see view
		 * */
		function get rawview():UIComponent;
		
		/**
		 * Access to a visual node's UIComponent (or view).
		 * */
		function get view():UIComponent;
		
		/**
		 * @private
		 * */
		function set view(v:UIComponent):void;

		/**
		 * This may be useful for edge renderers and edgeLabelRenderers.
		 * 
		 * @returns the current middle of the associated view, i.e.
		 * calculates the center from the view/UIComponents 
		 * dimenstions and returns the center.
		 * */
		function get viewCenter():Point;

		/**
		 * Convenient access to the X coordinate of a node's
		 * view (or UIComponent). This method accesses the view
		 * property of this object in, thus creating the view
		 * on demand as well.
		 * @see view
		 * */
		function get viewX():Number;

		/**
		 * @private
		 * */
		function set viewX(n:Number):void;

		/**
		 * Convenient access to the Y coordinate of a node's
		 * view (or UIComponent). This method accesses the view
		 * property of this object in, thus creating the view
		 * on demand as well.
		 * @see view
		 * */
		function get viewY():Number;

		/**
		 * @private
		 * */
		function set viewY(n:Number):void;

		/**
		 * Property for access to the associated graph node
		 * of this visual node.
		 * */			
		function get node():INode;

		/**
		 * This specifies if a node is moveable. This is currently
		 * not used by any layouter and thus not effective.
		 * Useable by ForceDirectedLayouter Only!
	     * */
		function get moveable():Boolean;
		function set moveable(value:Boolean):void
		/**
		 * A layouter can optionally set an orientation angle 
		 * paramter in the node. Right now we hardcode this as
		 * one single parameter. If we need more in the future,
		 * we can replace this by a hash with multiple keys.
		 * This parameter may be accessed by the nodeRenderer for instance.
		 * The value is in degrees.
		 * */
		function get orientAngle():Number;

		/**
		 * @private
		 * */
		function set orientAngle(oa:Number):void;

		/**
		 * This method updates the internal coordinates of the
		 * visual node with the current coordinates of the visual node's
		 * view (i.e. it's current real coordinates).
		 * */
		function refresh():void;
		
		/**
		 * This method set the coordinates of the visual node's
		 * view to the internal coordinates of the visual node,
		 * thus effectively placing the view at the point where the
		 * visual coordinates point to.
		 * */
		function commit():void;
		
	}
}