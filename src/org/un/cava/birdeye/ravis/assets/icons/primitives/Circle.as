/*
 * The MIT License
 *
 * Copyright (c) 2009
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
package org.un.cava.birdeye.ravis.assets.icons.primitives
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	
	import mx.core.UIComponent;

	/**
	 * This class implements a very basic Circle object
	 * as UIComponent. It just draws a circle on the graphics
	 * object of the UIComponent with the specified color and
	 * styles...
	 * 
	 * Generally we should probably scrap this in favour of the
	 * degrafa classes, although they work differently and we
	 * first have to learn how to use them.
	 * */
	public class Circle extends UIComponent	{

		/** our current color setting. */
		private var _color:int;
		
		/* default constructor */
		
		
		/** 
		 * set the color of the circle.
		 * @param c The color of the circle as integer value 
		 * */
		public function set color(c:int): void {
			_color = c;
			invalidateDisplayList(); 
		}
		
		/**
		 * @private
		 * */
		public function get color():int {
			return _color;
		}
		
		
		/**
		 * In order to actually draw the circle, we override updateDisplayList
		 * and then add the code to draw on the graphics object.
		 * @inheritDoc		
		 * */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			/* clear the existing drawing */
			graphics.clear();
			
			/* we want a gradient filled circle */
			graphics.beginGradientFill(GradientType.RADIAL,
										[0xffffff, _color],
										[1, 1],
										[0, 127], 
										null,
										SpreadMethod.PAD,
										InterpolationMethod.RGB,
										0.75);
			/* now we draw the circle, it's radius is half the size of the height of the UIComponent,
			 * thus it will always fill a square one. However, if we resize the width the circle
			 * might be too large...? 
			 */
			graphics.drawCircle(unscaledWidth / 2, unscaledHeight / 2, unscaledHeight / 2);

			/* done */
			graphics.endFill();
		}
	}
}