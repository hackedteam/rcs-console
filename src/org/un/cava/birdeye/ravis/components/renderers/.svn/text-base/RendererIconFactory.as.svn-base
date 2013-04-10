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
	

	import mx.controls.Image;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.utils.LogUtil;
	import org.un.cava.birdeye.ravis.assets.icons.EmbeddedIcons;
	import org.un.cava.birdeye.ravis.assets.icons.primitives.Circle;
	import org.un.cava.birdeye.ravis.assets.icons.primitives.Rectangle;
	
	/**
	 * This class provides infrastructure to create an image
	 * to be used as icon in a renderer
	 * */
	public class RendererIconFactory {
	
		private static const _LOG:String = "components.renderers.RendererIconFactory";
		
		/**
		 * This method generates an icon based on the
		 * type and returns it as an UIComponent.
		 * 
		 * The type format is as follows: prefix::string
		 * The prefix can be any of
		 * <ul>
		 * 	<li>embed - The icon string is looked up a list of embedded icons</li>
		 *  <li>primitive - The icon string is searched in a list of primitive geometric icons</li>
		 *  <li>url - The icon string is interpreted as URL and directly passed to the source param of an Image object</li>
		 * </ul>
		 * @param type The type of the icon.
		 * @param size The size of the icon (as a square)
		 * @param color The color of the icon (if a primitive)
		 * @returns The icon as UIComponent
		 * */
		public static function createIcon(type:String, size:int=-1, color:int = 0):UIComponent {
			
			var icon:UIComponent;
			var pattern:RegExp;
			var result:Array;
			var prefix:String;
			var suffix:String;
		
			/* create pattern to match the prefix
			 * in the pattern we name the matching group
			 * before the :: 'prefix' and the one after 'suffix'
			 * for easy assignment. See ASDocs about RegExp
			 * for details how this works (or perl regexp, etc.)
			 */
			pattern = /^(?P<prefix>[^:]+)::(?P<suffix>.*)$/;
			
			/* now assign the results */
			result = pattern.exec(type);
			
			if(result) {
				prefix = result.prefix;
				suffix = result.suffix;
			} else {
				LogUtil.warn(_LOG, "Node type is not well formed (:: missing), assuming embed");
				prefix = "embed";
				suffix = type;
			}
			
			/* now switch depending on the prefix to how to handle
			 * the generation */
			switch(prefix) {
				case "embed":
					icon = EmbeddedIcons.generateImage(suffix,size);
					break;
				case "primitive":
					icon = getPrimitiveIcon(suffix,size,color);
					break;
				case "url":
					icon = getUrlbasedIcon(suffix);
					break;
				default:
					LogUtil.warn(_LOG, "Unknown icon prefix:"+prefix+" ,defaulting to URL based");
					icon = getUrlbasedIcon(suffix);
					break;
			}
			return icon;
		}
		
		/**
		 * This generates a UIComponent with a primitive geometric
		 * object. Right now this uses very basic code, however,
		 * the Degrafa library would also offer this kind of stuff,
		 * so we need to investigate how we could make use of that.
		 * @param name The name of the desired primitive shape.
		 * @param size The size, which is either side length of rectangle or
		 * radius of circle.
		 * @param color The color of the shape.
		 * @returns The UIComponent representing the shape.
		 * */
		public static function getPrimitiveIcon(name:String, size:int, color:int):UIComponent {
		
			var img:UIComponent;
			
			switch(name) {
		    	case "rectangle":
					img = new Rectangle();
					(img as Rectangle).color = color;
					img.setStyle("color", color);
					img.width=size;
					img.height=size;
					break;
				case "circle":
					img = new Circle();
					(img as Circle).color = color;
					img.setStyle("color", color);
					img.width=size;
					img.height=size;
					break;
				default:
			        // LogUtil.warn(_LOG, "Out of range");
			        LogUtil.warn(_LOG, "unsupported primitive shape: "+name);
			        img.setStyle("color", color);
			        break;
			}
			return img;
		}
		
		/**
		 * returns an image object with the source set
		 * to the url provided.
		 * @param url The URL string where to access the image.
		 * @param size The size, the image will be renderered as a square.
		 * @returns The Image object of the icon.
		 * */
		public static function getUrlbasedIcon(url:String):Image {
			var img:Image = new Image();
			/*img.height = size;
			img.width = size;*/
			img.source = url;
			return img;
		}
		
		/**
		 * just for the sake of the uniformity of the
		 * interface, we also provide a method to get an embedded icon,
		 * however this is directly passed to EmbeddedIcons.
		 * @param name The descriptive name of the embedded icon.
		 * @param size The size of the icon, it will render as square.
		 * @returns The image object of the embedded icon.
		 * */
		public static function getEmbeddedIcon(name:String,size:int):Image {
			return EmbeddedIcons.generateImage(name,size);
		}
	}
}

