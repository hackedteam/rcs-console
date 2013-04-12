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
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.assets.icons.primitives.Circle;
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	
	/**
	 * This is a very very simple Renderer that just
	 * uses a plain small circle for the icon 
	 * */
	public class SimpleCircleNodeRenderer extends BaseNodeRenderer {
		
		/* default constructor */
		public function SimpleCircleNodeRenderer() {
			super();
		}
		
		/**
		 * @inheritDoc
		 * */
		override protected function initComponent(e:Event):void {
			
			var cc:UIComponent;
			
			/* initialize the upper part of the renderer */
			initTopPart();
			
			/* add a primitive circle
			 * as well the XML should be checked before */
			cc = RendererIconFactory.createIcon("primitive::circle",10,this.data.data.@nodeColor);
			cc.toolTip = this.data.data.@name; // needs check
			this.addChild(cc);
			 
			/* now the link button */
			initLinkButton();
		}
	}
}