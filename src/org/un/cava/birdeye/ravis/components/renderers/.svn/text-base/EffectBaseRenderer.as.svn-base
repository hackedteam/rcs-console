/*
 * The MIT License
 *
 * Copyright (c) 2008
 * United Nations Office at Geneva
 * Center for Advanced Visual Analytics
 * http://cava.unog.ch
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
package org.un.cava.birdeye.ravis.components.renderers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.core.UIComponent;
	import mx.effects.Zoom;
	
	/**
	 * This renderer extends the very simple one by
	 * having an instance of the RendererEffects
	 * available.
	 * */
	public class EffectBaseRenderer extends BaseRenderer {
		
		/* the effect to be used, default is zoom, so we call it
		 * like that */
		protected var reffects:RendererEffects;
		
		/**
		 * Default constructor, inits the zoom effect */
		public function EffectBaseRenderer() {
			super();
			reffects = new RendererEffects();
		}
	
		/**
		 * @inheritDoc
		 * */
		override protected function initComponent(e:Event):void {
						
			super.initComponent(e);
	
			/* add the MouseEvent listeners to the circle for zooming
			   consider to add them to the whole component instead... */
			this.addEventListener(MouseEvent.ROLL_OVER,reffects.doZoom);
			this.addEventListener(MouseEvent.ROLL_OUT,reffects.doZoom);
		}
	}
}