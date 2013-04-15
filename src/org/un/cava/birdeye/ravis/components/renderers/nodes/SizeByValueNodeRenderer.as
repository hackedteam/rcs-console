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
	import mx.effects.Zoom;
	
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * Other version of the simple circle that changes in size
	 * */
	public class SizeByValueNodeRenderer extends EffectBaseNodeRenderer  {
		
		private static const _LOG:String = "components.renderers.nodes.SizeByValueNodeRenderer";
		
		/**
		 * Default constructor
		 * */
		public function SizeByValueNodeRenderer() {
			
			super(); // ensures that _zoom is already initialised
			
			/* we want a different zoom factor here in the
			 * renderer */
			(reffects.effect as Zoom).zoomHeightTo = 1.3;
			(reffects.effect as Zoom).zoomWidthTo = 1.3;
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
			cc = RendererIconFactory.createIcon("primitive::circle",
				this.data.data.@nodeSize,
				int(this.data.data.@nodeColor));
			cc.toolTip = this.data.data.@name; // needs check
			this.addChild(cc);
			
			//LogUtil.debug(_LOG, "COLOR of component is: "+int(this.data.data.@nodeColor));
			
			/* now add the filters to the circle */
			reffects.addDSFilters(cc);
			 
			/* now the link button */
			initLinkButton();
		}
	}
}
