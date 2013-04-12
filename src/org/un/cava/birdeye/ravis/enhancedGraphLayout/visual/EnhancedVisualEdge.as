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
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.IEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IEdgeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	
	/**
	 * A visual edge is just a representation of a graph edge
	 * in the VisualGraph context. However, right now the only
	 * feature a VisualEdge has is a reference to its Graph Edge
	 * and a data object to support it's drawing features.
	 * There is a small possibility that this class will be removed.
	 * */
	public class EnhancedVisualEdge extends EventDispatcher implements IVisualEdge, IControllableVisualEdge, IDataRenderer {
		
		/* internal id of the edge */
		private var _id:int;
		
		/* VEdge data object, including data for drawing of the edge */
		private var _data:Object;
		
		/* we already link a graph edge with it */
		private var _edge:IEdge;
		
		/* the associated VGraph of this VEdge */
		private var _vgraph:IVisualGraph;
		
		/* visibility */
		private var _visible:Boolean;
		
		/* the associated label view if set */
		private var _labelView:UIComponent;
		
		/* the associated from control view if set */
		private var _fromControlView:UIComponent;
		
		/* the associated to control view if set */
		private var _toControlView:UIComponent;
		
		/* the line style of the edge */
		private var _lineStyle:Object;
		
		/* instead of a left/top corner orientation
		 * we can implicitly do a centered orientation 
		 * this will be applied during the commit() method
		 * and will be reversed during refresh() */
		private var _centered:Boolean;
		
        private var _edgeView:IEdgeRenderer;
		/**
		 * The constructor initialiazes the edge and must be preset with almost
		 * all parameters. 
		 * @param vg The associated VisualGraph.
		 * @param edge The associated Graph Edge.
		 * @param id The internal id of this VisualEdge.
		 * @param data The associated data Object.
		 * @param lview The associated label view.
		 * @param lStyle The line style of the edge, must be an object as associative mapping containing Graphics.lineStyle() parameters.
		 * @see flash.display.Graphics.lineStyle()
		 * */
		public function EnhancedVisualEdge(vg:IVisualGraph, edge:IEdge, id:int, data:Object = null, lview:UIComponent = null, lStyle:Object = null,
			fromControlView:UIComponent = null, toControlView:UIComponent = null) {
			_vgraph = vg;
			_edge = edge;
			_id = id;
			_visible = undefined;
			_centered = true;
			_data = data;
			_labelView = lview;
			_lineStyle = lStyle;
			_fromControlView = fromControlView;
			_toControlView = toControlView;
		}
		
		/**
		 * Access to the associated Graph Edge.
		 * */
		public function get edge():IEdge {
			return _edge;
		}
		
		/**
		 * Access to the associated VisualGraph.
		 * */
		public function get vgraph():IVisualGraph {
			return _vgraph;
		}
		
		/**
		 * Access to the data object.
		 * */
		[Bindable]
		public function get data():Object {
			return _data;
		}
		
		/**
		 * @private
		 * */
		public function set data(o:Object):void {
			_data = o;
			/* var visible:String;
			if (data is XML)
				visible = (data as XML).attribute("visible").toString();
			else
				visible = String(data.visible);
				
			if (ReflectionUtil.isFalse(visible))
				this.isVisible = false;		 */		
		}
		
		/**
		 * Access to the id of the VEdge
		 * */
		public function get id():int {
			return _id;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get centered():Boolean {
			return _centered;
		}
		
		/**
		 * @private
		 * */
		public function set centered(c:Boolean):void {
			_centered = c;
		}

		
		/**
		 * Access to the indicator if the node is currently
		 * visible or not. If this is set to false, any
		 * associated view will be removed in order to 
		 * save resources.
		 * */
		public function get isVisible():Boolean {
			return _visible;
		}
		
		/**
		 * @private
		 * */
		public function set isVisible(v:Boolean):void {
			_visible = v;
			
			/* set the views visibility, if we currently
			 * have one */
			if(	_labelView != null) {
				_labelView.visible = v;
			}
			if(	_fromControlView != null) {
				_fromControlView.visible = v;
			}
			
			if(	_toControlView != null) {
				_toControlView.visible = v;
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get labelView():UIComponent {
			return _labelView;
		}
		
		/**
		 * @private
		 * */
		public function set labelView(lv:UIComponent):void {
			_labelView = lv;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function setEdgeLabelCoordinates(p:Point):void {
			if(_labelView != null && p != null) {
				if(_centered) {
					_labelView.x = p.x - (_labelView.width / 2.0);
					_labelView.y = p.y - (_labelView.height / 2.0);
				} else {
					_labelView.x = p.x;
					_labelView.y = p.y;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function set lineStyle(ls:Object):void {
			_lineStyle = ls;
		}
		
		/**
		 * @private
		 * */
		public function get lineStyle():Object {
			return _lineStyle;
		}
		
		public function get fromControl():UIComponent
		{
			return _fromControlView;
		}
		
		public function set fromControl(control:UIComponent):void
		{
			_fromControlView = control;	
		}
	
		public function get toControl():UIComponent
		{
			return _toControlView;		
		}
		
		public function set toControl(control:UIComponent):void
		{
			_toControlView = control;	
		}
		
		public function setEdgeFromControlCoordinates(p:Point):void
		{
			if(_fromControlView != null && p != null) {
				if(_centered) {
					_fromControlView.x = p.x - (_fromControlView.width / 2.0);
					_fromControlView.y = p.y - (_fromControlView.height / 2.0);
				} else {
					_fromControlView.x = p.x;
					_fromControlView.y = p.y;
				}
			}
		}
		
		public function setEdgeToControlCoordinates(p:Point):void
		{
			if(_toControlView != null && p != null) {
				if(_centered) {
					_toControlView.x = p.x - (_toControlView.width / 2.0);
					_toControlView.y = p.y - (_toControlView.height / 2.0);
				} else {
					_fromControlView.x = p.x;
					_fromControlView.y = p.y;
				}
			}
		}
        
        public function get edgeView():IEdgeRenderer{
            return _edgeView;
        }
        
        public function set edgeView(value:IEdgeRenderer):void {
            _edgeView = value;
        }
	}
}