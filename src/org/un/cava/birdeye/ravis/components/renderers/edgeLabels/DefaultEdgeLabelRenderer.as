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
package org.un.cava.birdeye.ravis.components.renderers.edgeLabels {
	
	// Flash classes
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	import org.un.cava.birdeye.ravis.components.renderers.nodes.BaseNodeRenderer;
	
	/**
	 * This renderer displays the graph nodes as
	 * primitive icon or as embedded image or URL
	 * depending on the XML specification
	 * */
	public class DefaultEdgeLabelRenderer extends BaseNodeRenderer {
	
		/**
		 * Base Constructor
		 * */
		public function DefaultEdgeLabelRenderer() {
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
			
			/* set the tool tip */
			this.toolTip = this.data.data.@edgeLabel;
			
			/* add the image */
			img = initIcon();
			 
			/* now the link button */
			initLinkButton();
		}
		
		/**
		 * @inheritDoc
		 * */
		override protected function initLinkButton():LinkButton {
			
			/* initialise the original link button */
			super.initLinkButton();
			
			/* now override some specs */
			lb.label = this.data.data.@edgeLabel;
			lb.width = 65;
			lb.height = 15;
			lb.visible = false;

			lb.toolTip = this.data.data.@edgeDescription;
			
			return lb;
		}
		
		
		/**
		 * initialise the icon of this renderer 
		 * */
		private function initIcon():UIComponent {
			
			
			var img:UIComponent;
			/* AGAIN ALL XML VALUES SHOULD BE VERIFIED */
			
			/* this renderer does more sophisticated stuff, e.g.
			 * a primitive should be smaller than an icon (10 instead of 25)
			 */
			img = RendererIconFactory.createIcon(this.data.data.@edgeClass,25);
			
			/* primitive nodes are currently no Images, so we can use
			 * this to test for them, not ideal, but will do for now
			 * primtives have smaller size
			 */
			if(!(img is Image)) {
				img.width = 10;
				img.height = 10;
			}
			
			
			//img.setStyle("backgroundColor", "0x8b008b");
			img.setStyle("backgroundColor", "0xcccccc");
			
			img.toolTip = this.data.data.@edgeLabel;
		
			//BindingUtils.bindProperty(img,"scaleX",this.parent,"scaleX");
			//BindingUtils.bindProperty(img,"scaleY",this.parent,"scaleY");
		
			//img.scaleX = GlobalParams.scaleFactor;
			//img.scaleY = GlobalParams.scaleFactor;
			//XXXX
			img.addEventListener(MouseEvent.CLICK, toggleLabel);
			this.addChild(img);
			return img;
		}
		
		
		/**
		 * toggle the visibility of the label button
		 * */
		private function toggleLabel(e:Event):void {
			lb.visible = !lb.visible;
		}
	}
}

