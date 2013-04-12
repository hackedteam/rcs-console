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
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
		
	/**
	 * Renderer for data from the CIA World Factbook
	 * */
	public class WFBNodeRenderer extends EffectBaseNodeRenderer  {
		
		/**
		 * Default constructor
		 * */
		public function WFBNodeRenderer() {
			super();
		}
	
		/**
		 * @inheritDoc
		 * */
		override protected function initComponent(e:Event):void {
			
			var cc:UIComponent;
			
			/* initialize the upper part of the renderer */
			initTopPart();
			
			/* add a simple circle as in the base class */
			cc = addCircle();
			
			/* now add the filters to the circle */
			reffects.addDSFilters(cc);
			 
			/* now the link button */
			initLinkButton();
		}
	
		override protected function getDetails(e:Event):void {
			/* call base method */
			super.getDetails(e);
			
			/* now add specifics
			 * all would need checks for presence of the XML attribute */
			/* disabled for now
			if(GlobalParams.dataComponents.visualShade != null) {
				GlobalParams.dataComponents.visualShade.opened = true;
			}
			if(GlobalParams.dataComponents.visualDetailContinent != null) {
				GlobalParams.dataComponents.visualDetailContinent.text = this.data.data.@continent;
			}
			if(GlobalParams.dataComponents.visualDetailCountry != null) {
				GlobalParams.dataComponents.visualDetailCountry.text = this.data.data.@name;
			}
			if(GlobalParams.dataComponents.visualDetailCapital != null) {
				GlobalParams.dataComponents.visualDetailCapital.text = this.data.data.@capital;
			}
			if(GlobalParams.dataComponents.visualDetailGovernment != null) {
				GlobalParams.dataComponents.visualDetailGovernment.text = this.data.data.@government;
			}
			if(GlobalParams.dataComponents.visualDetailDoI != null) {
				GlobalParams.dataComponents.visualDetailDoI.text = this.data.data.@indep_date;
			}
			if(GlobalParams.dataComponents.visualDetailGDP != null) {
				GlobalParams.dataComponents.visualDetailGDP.text = this.data.data.@gdp_total;
			}
			if(GlobalParams.dataComponents.visualDetailInflation != null) {
				GlobalParams.dataComponents.visualDetailInflation.text = this.data.data.@inflation;
			}
			if(GlobalParams.dataComponents.visualDetailIM != null) {
				GlobalParams.dataComponents.visualDetailIM.text = this.data.data.@infant_mortality;
			}
			if(GlobalParams.dataComponents.visualDetailPopGrowth != null) {
				GlobalParams.dataComponents.visualDetailPopGrowth.text = this.data.data.@population_growth;
			}
			if(GlobalParams.dataComponents.visualDetailPop != null) {
				GlobalParams.dataComponents.visualDetailPop.text = this.data.data.@population;
			}
			*/
		}
	
		/**
		 * create a UIComponent with a cimple circle
		 * and add it do this object
		 * @returns the circle, may be useful for derived classes 
		 * */
		private function addCircle():UIComponent {
			
			var cc:UIComponent;
			var co:int; 
			var nodeType:String = this.data.data.@nodeType; // needs check

			switch(nodeType) {
				case "center":
					co = 0x333333;
					break;
				case "continent":
					co = 0x999999;
					break;
				case "country":
					co = 0x228b22;
					break;
				case "language":
					co = 0x9932cc;
					break;
				case "ocean":
					co = 0x4682b4;
					break;
				default:
					co = 0x333333;
					break;
			}
			
			/* add a primitive circle with the selected color */
			cc = RendererIconFactory.createIcon("primitive::circle",10,co);
			cc.toolTip = this.data.data.@name; // needs check	
			this.addChild(cc);
			return cc;
		}

	}
}