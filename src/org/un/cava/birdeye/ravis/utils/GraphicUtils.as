/* 
 * The MIT License
 *
 * Copyright (c) 2007 The SixDegrees Project Team
 * (Jason Bellone, Juan Rodriguez, Segolene de Basquiat, Daniel Lang).
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
package org.un.cava.birdeye.ravis.utils {
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.display.Graphics;
	
	/**
	 * This is a class to provide some static functions
	 * to help with drawing and geometry.
	 * 
	 * @author Nitin Lamba
	 * */
	public class GraphicUtils {
		
		/**
		 * Function that tests if two points are equal within tolerance
		 * The current tolerance limit is (1, 1) - same as pixel resolution on screen
		 */
		public static function equal(p1:Point, p2:Point):Boolean {
			return (Math.abs(p1.x - p2.x) <= 1) && (Math.abs(p1.y - p2.y) <= 1);
		}
		
		/**
		 * Function that returns the center point of a display object
		 */
		public static function getCenter(c:DisplayObject):Point {
			return new Point(c.width / 2, c.height / 2);
		}

		/**
		 * Returns the positive angle between two lines OP and OQ at point O, where:<br>
		 * P = [x1, y1]<br>
		 * Q = [x2, y2]<br>
		 * O = [atX, atY]<br>
		 * 
		 * XXX why not use Math.atan2(y2 - y1, x2 - x1)?
		 * How can point O affect the angle between 2 lines??
		 */
		public static function getAngle(x1:Number, y1:Number,
										 x2:Number, y2:Number,
										 atX:Number, atY:Number):Number {
			var m1:Number = (y1 - atY) / (x1 - atX);
			var m2:Number = (y2 - atY) / (x2 - atX);
			var rtn:Number = Math.atan((m1 - m2) / (1 + m1 * m2));
			return Math.abs(rtn);
		}
		/** 
		 * Returns the endpoint Q of a line OP that is rotated clock-wise about point O, where:<br>
		 * O = [centerX, centerY]<br>
		 * P = [startX, startY]<br>
		 * Q = [endX, endY]<br>
		 * 
		 * XXX Why not use Point.polar here?
		 * 
		 * initAngle = Math.atan2(startY - centerY, startx - centerX);
		 * newAngle = initAngle + angleDelta
		 * length = Point.distance(P,O);
		 * resultQ = Point.polar(length,newAngle);
		 * resultQ.offset(P.x,P.y)
		 * 
		 * should do it. 
		 * 
		 */
		public static function getRotation(angleDelta:Number,
											 centerX:Number, centerY:Number,
											 startX:Number, startY:Number):Point {
			var radius:Number = Math.sqrt((centerX - startX) * (centerX - startX) + (centerY - startY) * (centerY - startY));
			var angle:Number, ax:Number, ay:Number;
			
			// Compute rotation based on location of points
			// TO-DO: Perhaps, this can be further simplified
			if (startY < centerY) { //quadrant 1 and 2
				if (startX > centerX) {
					// Quad 1:
					angle = Math.acos((startX - centerX) / radius);
					ax = centerX + Math.cos(angle + angleDelta) * radius;
					ay = centerY - Math.sin(angle + angleDelta) * radius;
				} else {
					// Quad 2:
					angle = Math.acos((centerY - startY) / radius);
					ax = centerX - Math.sin(angle + angleDelta) * radius;
					ay = centerY - Math.cos(angle + angleDelta) * radius;
				}
			} else { //quadrant 3 and 4
				if (startX < centerX) {
					// Quad 3:
					angle = Math.acos((centerX - startX) / radius);
					ax = centerX - Math.cos(angle + angleDelta) * radius;
					ay = centerY + Math.sin(angle + angleDelta) * radius;
				} else {
					// Quad 4:
					angle = Math.acos((startY - centerY) / radius);
					ax = centerX + Math.sin(angle + angleDelta) * radius;
					ay = centerY + Math.cos(angle + angleDelta) * radius;
				}
			}
			return new Point(ax,ay);
		}
		
		/** 
		 * Draws an arc starting at P and subtending an angle at 
		 * the center of the circle O, where:<br>
		 * angle = angleDelta<br>
		 * O = [centerX, centerY]<br>
		 * P = [startX, startY]<br>
		 */
		public static function drawArc(g:GraphicsWrapper, angleDelta:Number,
									  centerX:Number, centerY:Number,
									  startX:Number, startY:Number):void {
			
			if (angleDelta > Math.PI / 4) {
				// Call recursively until the angle becomes less than 45 degrees
				drawArc(g, Math.PI / 4, centerX, centerY, startX, startY);
				var pt:Point = getRotation(Math.PI / 4, centerX, centerY, startX, startY);
				
				angleDelta -= Math.PI / 4;
				startX = pt.x;
				startY = pt.y;
				drawArc(g, angleDelta, centerX, centerY, startX, startY);				
			} else {
				var radius:Number = Math.sqrt((centerX - startX) * (centerX - startX) 
				                            + (centerY - startY) * (centerY - startY));
				var ctrlDist:Number = radius/Math.cos(angleDelta/2);
				var rx:Number, ry:Number, ax:Number, ay:Number;
				//LogUtil.warn(_LOG, "Radius = " + radius);
				var angle:Number;
				
				// Compute angles, drawing points and control points
				// TO-DO: Perhaps, this can be further simplified
				if (startY < centerY) { //quadrant 1 and 2
					if (startX > centerX) {
						// Quad 1:
						angle = Math.acos((startX - centerX) / radius);
						rx = centerX + Math.cos(angle + angleDelta/2) * ctrlDist;
						ry = centerY - Math.sin(angle + angleDelta/2) * ctrlDist;
						ax = centerX + Math.cos(angle + angleDelta) * radius;
						ay = centerY - Math.sin(angle + angleDelta) * radius;
					} else {
						// Quad 2:
						angle = Math.acos((centerY - startY) / radius);
						rx = centerX - Math.sin(angle + angleDelta/2) * ctrlDist;
						ry = centerY - Math.cos(angle + angleDelta/2) * ctrlDist;
						ax = centerX - Math.sin(angle + angleDelta) * radius;
						ay = centerY - Math.cos(angle + angleDelta) * radius;
					}
				} else { //quadrant 3 and 4
					if (startX < centerX) {
						// Quad 3:
						angle = Math.acos((centerX - startX) / radius);
						rx = centerX - Math.cos(angle + angleDelta/2) * ctrlDist;
						ry = centerY + Math.sin(angle + angleDelta/2) * ctrlDist;
						ax = centerX - Math.cos(angle + angleDelta) * radius;
						ay = centerY + Math.sin(angle + angleDelta) * radius;
					} else {
						// Quad 4:
						angle = Math.acos((startY - centerY) / radius);
						rx = centerX + Math.sin(angle + angleDelta/2) * ctrlDist;
						ry = centerY + Math.cos(angle + angleDelta/2) * ctrlDist;
						ax = centerX + Math.sin(angle + angleDelta) * radius;
						ay = centerY + Math.cos(angle + angleDelta) * radius;
					}
				}
				// Draw the arc
				g.moveTo(startX, startY);
				g.curveTo(rx, ry, ax, ay);
			}
		}
  }
}
