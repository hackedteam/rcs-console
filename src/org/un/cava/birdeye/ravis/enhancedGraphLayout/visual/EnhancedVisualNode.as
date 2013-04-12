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
package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.data.INode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
	
	/**
	 * The VisualNode to be used in the Graph.
	 * */
	public class EnhancedVisualNode extends EventDispatcher implements IEnhancedVisualNode, IDataRenderer {
		
		/* The associated VisualGraph */
		private var _vgraph:IVisualGraph;
		
		/* Internal id of the VisualNode */
		private var _id:int;
		
		/* Data object of the VisualNode */
		private var _data:Object;
		
		/* Indicates if the node shall be moveable or not
		 * current UNUSED !!! */
		private var _moveable:Boolean;
		
		/* Indicates of the node is currently visible */
		private var _visible:Boolean;
		
		/* the related Graph Node */
		private var _node:INode;
		
		/* the VisualNode's anticipated target X and Y coordinates.
		 * Will be applied using the commit() method */
		private var _x:Number;
		private var _y:Number;
		
		/* The node's view which is the UIComponent that will
		 * be displayed in Flashplayer */
		private var _view:UIComponent;
		
		/* the associated label view if set */
		private var _labelView:UIComponent;
		
		/* instead of a left/top corner orientation
		 * we can implicitly do a centered orientation 
		 * this will be applied during the commit() method
		 * and will be reversed during refresh() */
		private var _centered:Boolean;
		
		/*
		 * A layouter can optionally set an orientation angle 
		 * paramter in the node. Right now we hardcode this as
		 * one single parameter. If we need more in the future,
		 * we can replace this by a hash with multiple keys.
		 * This parameter may be accessed by the nodeRenderer for instance.
		 * The value is in degrees.
		 */
		private var _orientAngle:Number = 0;
		
		
		/**
		 * The constructor presets the VisualNode's data structures
		 * and requires most parameters already present.
		 * @param vg The VisualGraph that this VisualNode lives in.
		 * @param node The associated Graph Node.
		 * @param id The internal id of this node.
		 * @param view The view/UIComponent of this node (if already present).
		 * @param data The VisualNode's associated data object.
		 * @param mv Indicator if the node is moveable (currently ignored).
		 * */
		public function EnhancedVisualNode(vg:IVisualGraph, node:INode, id:int, view:UIComponent = null, data:Object = null, mv:Boolean = true):void {
			_vgraph = vg;
			_node = node;
			_id = id;
			_data = data;
			_moveable = mv;
			_visible = undefined;

			_centered = true;

			_x = 0;
			_y = 0;
			
			_view = view;
		}
		
		/**
		 * Access to the associated VisualGraph, that this VisualNode lives in.
		 * */
		public function get vgraph():IVisualGraph {
			return _vgraph;
		}

		/**
		 * Access to the internal id of this VisualNode.
		 * */
		public function get id():int {
			return _id;
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

			/* set the views visibility, if we currently
			 * have one */
			if(_view != null) {
				_view.visible = v;
			}
		}

		/**
		 * @inheritDoc
		 * */
		public function get node():INode {
			return _node;
		}
		
		/**
		 * @inheritDoc
		 * */
		[Bindable]
		public function get data():Object {
			return _data;
		}
		
		/**
		 * @private
		 * */
		public function set data(o:Object):void	{
			_data = o;
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
		 * @inheritDoc
		 * */
		public function get x():Number {
			return _x;
		}
		
		/**
		 * @private
		 * */
		public function set x(n:Number):void {
			if(!isNaN(n)) {
				_x = n;
			} else {
				throw Error("VNode "+_id+": set x tried to set NaN");
			}
		}


		/**
		 * @inheritDoc
		 * */		
		public function get y():Number {
			return _y;
		}
		
		/**
		 * @private
		 * */
		public function set y(n:Number):void {
			if(!isNaN(n)) {
				_y = n;
			} else {
				throw Error("VNode "+_id+": set y tried to set NaN");
			}
		}

		/**
		 * @inheritDoc
		 * */		
		public function get viewX():Number {
			return this.view.x;
		}
		
		/**
		 * @private
		 * */
		public function set viewX(n:Number):void {
			if(!isNaN(n)) {
				if((n != this.view.x) && _moveable) {
					this.view.x = n;
				}
			} else {
				throw Error("VNode "+_id+": set viewX tried to set NaN");
			}
		}
		
		
		/**
		 * @inheritDoc
		 * */
		public function get viewY():Number {
			return this.view.y;
		}
		
		/**
		 * @private
		 * */
		public function set viewY(n:Number):void {
			if(!isNaN(n)) {
				if((n != this.view.y) && _moveable) {
					this.view.y = n;
				}
			} else {
				throw Error("VNode "+_id+": set viewY tried to set NaN");
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
		public function setNodeLabelCoordinates():void {
			if(_labelView != null) {
				var p:Point = INodeRenderer(this.view).labelCoordinates(_labelView);
				_labelView.x = p.x;
				_labelView.y = p.y;
			}
		}
		
		/**
		 * @inheritDoc
		 * */
		public function get rawview():UIComponent {
			return _view;
		}

		/**
		 * @inheritDoc
		 * */
		public function get view():UIComponent {
			return _view;
		}
		
		/**
		 * @private
		 * */
		public function set view(v:UIComponent):void {
			_view = v;
		}

		/**
		 * @inheritDoc
		 * */
		public function get viewCenter():Point {
			if(_view != null) {
				if(_centered) {
					return new Point(_view.x + (_view.width / 2.0), 
									 _view.y + (_view.height / 2.0));
				} else {
					return new Point(_view.x, _view.y);
				}
			} else {
				return null;
			}
		}

		/**
		 * @inheritDoc
		 * */
		public function get moveable():Boolean {
			return _moveable;
		}
		
		public function set moveable(value:Boolean):void {
			_moveable = value;
		}
	
		/**
		 * @inheritDoc
		 * */
		public function get orientAngle():Number {
			return _orientAngle;
		}
	
		/**
		 * @private
		 * */
		public function set orientAngle(oa:Number):void {
			_orientAngle = oa;
			if(this.view is IEventDispatcher) {
				(this.view as IEventDispatcher).dispatchEvent(new VGraphEvent(VGraphEvent.VNODE_UPDATED));
			}
		}
	
		/**
		 * @inheritDoc
		 * */			
		public function commit():void {
			/* if we have the centered orientation we apply
			 * some corrections */
			if(_centered) {
				this.viewX = _x - (this.view.width / 2.0);
				this.viewY = _y - (this.view.height / 2.0);
				
			} else {
				this.viewX = _x;
				this.viewY = _y;
			}
			
			setNodeLabelCoordinates();
						
			if(this.view is IEventDispatcher) {
				(this.view as IEventDispatcher).dispatchEvent(new VGraphEvent(VGraphEvent.VNODE_UPDATED));
			}
		}
		

		/**
		 * @inheritDoc
		 * */
		public function refresh():void {
			
			/* have to recompensate for centered */
			if(_centered) {
				_x = this.viewX + (this.view.width / 2.0);
				_y = this.viewY + (this.view.height / 2.0);
			} else {
				_x = this.viewX;
				_y = this.viewY;
			}
			setNodeLabelCoordinates();
		}
	}
}