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
	
	import mx.controls.Label;
	import mx.controls.LinkButton;
		
	import org.un.cava.birdeye.ravis.components.renderers.BaseRenderer;
	import org.un.cava.birdeye.ravis.utils.events.VGraphRendererEvent;
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	
	/**
	 * This is an extension to the base renderer
	 * specific to Nodes, i.e. it populates various
	 * label fields and icons with node XML data.
	 * */
	public class BaseNodeRenderer extends BaseRenderer {
	
		private static const _LOG:String = "components.renderers.nodes.BaseNodeRenderer";
		
	/**
		 * Base Constructor
		 * */
		public function BaseNodeRenderer() {
			super();
		}
		
		/**
		 * @inheritDoc
		 * */
		override protected function getDetails(e:Event):void {
			// LogUtil.debug(_LOG, "Show Details");
			var vgre:VGraphRendererEvent = new VGraphRendererEvent(VGraphRendererEvent.VG_RENDERER_SELECTED);
			
			/* do the checks in the super class */
			super.getDetails(e);
			
			/* prepare the event */
			
			
			/* make sure we have the XML attribute */
			if(this.data.data.@name != null) {
				vgre.rname = this.data.data.@name;
			} else {
				LogUtil.warn(_LOG, "XML data object has no 'name' attribute");
			}
			
			/* now the description */
			if(this.data.data.@desc != null) {
				vgre.rdesc = this.data.data.@desc;
			} else {
				LogUtil.info(_LOG, "XML data object has no 'desc' attribute");
			}
			
			/* this is a bit obscure and should be done through a constant
			 * basically the index 2 in the current implementation means to
			 * open the detailed description pane.
			 * All this could possibly be better resolved using events
			 * ...
			 */
			/*
			if(GlobalParams.vgAccordion != null) {
				GlobalParams.vgAccordion.selectPane(VGAccordion.INDEX_DATADETAIL);
			} else {
				LogUtil.warn(_LOG, "GlobalParams.vgAccordion not initialised!");
			}
			*/
			this.dispatchEvent(vgre);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Make sure we call the init methods of THIS
		 * class and not the base class.
		 * */
		override protected function initComponent(e:Event):void {
			
			/* initialize the upper part of the renderer */
			initTopPart();
			
			/* in between could be other components added
			 * like images */
			 
			/* now the link button */
			initLinkButton();
			
			/* or the label both would be overkill */
			//initLabel();
		}

		/**
		 * @inheritDoc
		 * */
		override protected function initTopPart():void {
			
			/* create the top part using super class */
			super.initTopPart();
			
			/* set the tool tip to be the name attribute of the XML object
			 * we should also check here about the correctness of all
			 * the data objects, just as in getDetails(), even more important
			 * since this will be called earlier....
			 * maybe it is all not so critical... anyway, we don't abort,
			 * so just some diagnostic messages are printed... */
			if(this.data.data.@name != null) {
				this.toolTip = this.data.data.@name;
			} else {
				LogUtil.warn(_LOG, "XML data object has no 'name' attribute");
			}
		}

		/**
		 * @inheritDoc
		 * */
		override protected function initLinkButton():LinkButton {
			
			/* create the linkbutton using 
			 * the super class */
			super.initLinkButton();
			
			/* add node specific data;
			 * here no check, but should be done */
			lb.label = this.data.data.@name;
			
			return lb;
		}
		
		/**
		 * @inheritDoc
		 * */
		override protected function initLabel():Label {
			
			/* base init */
			super.initLabel();
			
			/* again we should do checks here */
			ll.text = this.data.data.@name;
			
			return ll;
		}
	}
}

