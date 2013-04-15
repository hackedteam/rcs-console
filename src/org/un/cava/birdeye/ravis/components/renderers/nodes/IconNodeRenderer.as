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
	import flash.filters.GlowFilter;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	
	import spark.components.BorderContainer;
	
	/**
	 * This a basic icon itemRenderer for a node. 
	 * Images are sourced by directory path and file name.
	 * Based on icons by Paul Davey aka Mattahan (http://mattahan.deviantart.com/).
	 * All rights reserved. 
	 * */
	public class IconNodeRenderer extends EffectBaseNodeRenderer  {
		
		/**
		 * Default constructor
		 * */
    

    
   private var _selected:Boolean;
   private var border:BorderContainer;
   private var _glow:GlowFilter;
   private var img:UIComponent;
   
    
		public function IconNodeRenderer() {
			super();
      this.setStyle("verticalGap", 0)
      _glow=new GlowFilter(0x00CCFF,1,10,10,2,1)
			//initZoom();
		}
	
		/**
		 * @inheritDoc
		 * */
		override protected function initComponent(e:Event):void {
			
			/* initialize the upper part of the renderer */
			initTopPart();
			
			/* add an icon as specified in the XML, this should
			 * be checked */
			img = RendererIconFactory.createIcon(this.data.data.@nodeIcon,50);
			img.toolTip = this.data.data.@name; // needs check
      

      border = new BorderContainer();
      
      border.width = 50;
      border.height = 50;
      border.visible=false;
      border.setStyle('backgroundAlpha', 0);
      border.setStyle("borderAlpha",0)
      border.setStyle("borderWeight",1)
      border.setStyle('backgroundColor', 0x00CCFF);
      border.setStyle('borderColor', 0xCCCCCC);
      border.setStyle('cornerRadius', 0);
      img.x=0;
      img.y=0;
      this.addElement(img);
      //this.addElement(border)
			/* now add the filters to the circle */
			reffects.addDSFilters(img);
			 
			/* now the link button */
			initLinkButton();

		}
    
    public function set selected(value:Boolean):void
    {
      _selected=value;
      if(selected)
      {
        //border.setStyle('backgroundAlpha', 0.2);
        //border.setStyle('borderAlpha', 1);
         img.filters=[_glow]
      }
      else
      {
        //border.setStyle('backgroundAlpha', 0);
        //border.setStyle('borderAlpha', 0);
        img.filters=null
      }
    }
    
    public function get selected():Boolean
    {
      return _selected
    }
	}
}