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
package org.un.cava.birdeye.ravis.components.renderers.nodes {
	
	// Flash classes
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	
	/**
	 * This renderer displays the graph nodes as
	 * primitive icon or as embedded image or URL
	 * depending on the XML specification
	 * */
	public class DefaultNodeRenderer extends BaseNodeRenderer {
	
		/**
		 * Base Constructor
		 * */
		public function DefaultNodeRenderer() {
			super();
			//this.addEventListener(FlexEvent.CREATION_COMPLETE,initComponent);
		}
		
		/**
		 * Full initialisation of the renderer component, triggered
		 * after reception of the creation complete event.
		 * @param e the creation complete event (unused).
		 * */
		override protected function initComponent(e:Event):void {
			
			var img:UIComponent;
			
			/* initialize the upper part of the renderer */
			initTopPart();
			
			/* add the image */
			
			/* AGAIN ALL XML VALUES SHOULD BE VERIFIED */
			img = RendererIconFactory.createIcon(
				this.data.data.@nodeClass,
				this.data.data.@nodeSize,
				this.data.data.@nodeColor);
			img.toolTip = this.data.data.@name;
			
			//BindingUtils.bindProperty(img,"scaleX",this.parent,"scaleX");
			//BindingUtils.bindProperty(img,"scaleY",this.parent,"scaleY");
		
			//img.scaleX = GlobalParams.scaleFactor;
			//img.scaleY = GlobalParams.scaleFactor;
			this.addChild(img);
			 
			/* now the link button */
			initLinkButton();
		}
	}
}

