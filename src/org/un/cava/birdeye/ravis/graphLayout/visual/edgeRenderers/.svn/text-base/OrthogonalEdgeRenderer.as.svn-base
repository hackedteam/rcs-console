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
package org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers {
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;


	/**
	 * This edge renderer draws rectangular edge arrows.
	 * Please note that for undirected graphs, the actual direction
	 * of the arrow might be arbitrary.
	 * */
	public class OrthogonalEdgeRenderer extends BaseEdgeRenderer {
		
		
		private var _type:String = 'orthogonal';
		private var _color:uint; // because we need to cross function boundaries
		
		/**
		 * length of the arrowhead
		 * @default 10
		 * */
		public var arrowLength:Number = 10;
		
		/**
		 * Constructor sets the graphics object (required).
		 * @param g The graphics object to be used.
		 * */
		public function OrthogonalEdgeRenderer() {
			super();
		}
		
		/**
		 * The draw function, in this renderer draws an Arrow
		 * but not straight or curved but only with angles of 90 degrees
		 * parallel to the x and y axis.
		 * 
		 * @inheritDoc
		 * */
		override public function draw():void {
			
			/* first get the corresponding visual object */
			var fromNode:IVisualNode = vedge.edge.node1.vnode;
			var toNode:IVisualNode = vedge.edge.node2.vnode;
			
			var fP:Point = fromNode.viewCenter;
				
			/* calculate the midpoint used as curveTo anchor point */
			var anchor:Point = new Point(
				(fP.x + vedge.vgraph.center.x) / 2.0,
				(fP.y + vedge.vgraph.center.y) / 2.0
				);
			
			_color = uint(vedge.lineStyle.color);
			

			/* apply the line style */
			applyLineStyle();
			
			if(isFullyLeftOf(fromNode, toNode)) {
				if(isFullyAbove(fromNode, toNode)) {
					bottomToTop(fromNode, toNode, g);					
				}
				else if(isFullyBelow(fromNode, toNode)) {
					topToBottom(fromNode, toNode, g);
				}
				else {			
					rightToLeft(fromNode, toNode, g);
				}
			}
			else if(isFullyRightOf(fromNode, toNode)) {
				if(isFullyAbove(fromNode, toNode)) {
					bottomToTop(fromNode, toNode,g);
				}
				else if(isFullyBelow(fromNode, toNode)) {						
					topToBottom(fromNode, toNode,g);
				}
				else {
					leftToRight(fromNode, toNode,g);
				}			
			}
			else if(isFullyAbove(fromNode, toNode)) {
				bottomToTop(fromNode, toNode,g);
			}
			else if(isFullyBelow(fromNode, toNode)) {
				topToBottom(fromNode, toNode,g);
			}
			else {
				centerToCenter(fromNode, toNode,g);
			}				
	
			/* if the vgraph currently displays edgeLabels, then
			 * we need to update their coordinates */
			if(vedge.vgraph.displayEdgeLabels) {
				vedge.setEdgeLabelCoordinates(labelCoordinates());
			}
			
		}
		
		/* here we could actually improve a few things.... .XXXX */
		
		private function calculatePoint(fromX:Number, fromY:Number, distance:Number, angle:Number):Object{
			
			/* XXX WHAT IS THIS VALUE? PLEASE USE/DEFINE CONSTANTS AND COMMENT */
			angle = angle * 1.745329E-002;
			var _loc3:Number = fromX + distance * Math.cos(angle);
			var _loc2:Number = fromY - distance * Math.sin(angle);
			return ({x: _loc3, y: _loc2});
		}
     
     	private function drawArrow(fromX:int, fromY:int, toX:int, toY:int, g:GraphicsWrapper):void{
     		
     		var arrowLength:Number = 10;
     		var dXY:Number = (fromY - toY) / (fromX - toX);
     		var arrowOS:Number;
     		
     		/* XXX What is arrowOS ??? */
	        if (fromX >= toX)
	        {
	            arrowOS = 155;
	        }
	        else
	        {
	            arrowOS = 25;
	        }	        
	        var arrowLine1:Object = this.calculatePoint(toX, toY, arrowLength, 180 - Math.atan(dXY) * 5.729578E+001 - arrowOS);
	        var arrowLine2:Object = this.calculatePoint(toX, toY, arrowLength, 180 - Math.atan(dXY) * 5.729578E+001 + arrowOS);   		
     		
     		g.moveTo(toX, toY);
     		g.beginFill(_color,1);
            g.lineTo(arrowLine1.x, arrowLine1.y);            
            g.lineTo(arrowLine2.x, arrowLine2.y);
            g.lineTo(toX, toY);
            g.endFill();
     	}
     			     	
		//checks if obj1 is fully above obj2 (this includes the space for the arrow)
		private function isFullyAbove(obj1:IVisualNode, obj2:IVisualNode):Boolean {
			return (obj1.view.y + obj1.view.height + arrowLength) < obj2.view.y;
		}     	
		//checks if obj1 is fully below obj2 (this includes the space for the arrow)
		private function isFullyBelow(obj1:IVisualNode, obj2:IVisualNode):Boolean {
			return obj1.view.y > (obj2.view.y + obj2.view.height + arrowLength);
		}   
		//checks if obj1 is fully to the right of obj2 (this includes the space for the arrow)
		private function isFullyRightOf(obj1:IVisualNode, obj2:IVisualNode):Boolean {
			return obj1.view.x > (obj2.view.x + obj2.view.width + arrowLength);
		}			  	
		//checks if obj1 is fully to the left of obj2 (this includes the space for the arrow)
		private function isFullyLeftOf(obj1:IVisualNode, obj2:IVisualNode):Boolean {
			return (obj1.view.x + obj1.view.width + arrowLength) < obj2.view.x;
		}  
		//from the right side of obj1 to the left side of obj2
		private function rightToLeft(obj1:IVisualNode, obj2:IVisualNode, g:GraphicsWrapper):void {
			g.moveTo(obj1.view.x + obj1.view.width, obj1.view.y + (obj1.view.height/2));
			if(_type == 'orthogonal') {
				g.lineTo((obj1.view.x + obj1.view.width) + .5*(obj2.view.x - (obj1.view.x + obj1.view.width)) - arrowLength, obj1.view.y + (obj1.view.height/2));
				g.lineTo((obj1.view.x + obj1.view.width) + .5*(obj2.view.x - (obj1.view.x + obj1.view.width)) - arrowLength, obj2.view.y + (obj2.view.height/2));
				g.lineTo(obj2.view.x - arrowLength+1, obj2.view.y + (obj2.view.height/2));
				drawArrow((obj1.view.x + obj1.view.width) + .5*(obj2.view.x - (obj1.view.x + obj1.view.width)) - arrowLength, obj2.view.y + (obj2.view.height/2), obj2.view.x, obj2.view.y + (obj2.view.height/2),g);
			}
			else {
				g.lineTo(obj2.view.x - arrowLength+1, obj2.view.y + (obj2.view.height/2));	
				drawArrow(obj1.view.x + obj1.view.width, obj1.view.y + (obj1.view.height/2), obj2.view.x, obj2.view.y + (obj2.view.height/2),g);
			}
		}
		
		//from the left side of obj1 to the right side of obj2
		private function leftToRight(obj1:IVisualNode, obj2:IVisualNode, g:GraphicsWrapper):void {
			g.moveTo(obj1.view.x, obj1.view.y + (obj1.view.height/2));
			if(_type == 'orthogonal'){
				g.lineTo((obj2.view.x + obj2.view.width) + .5*(obj1.view.x - (obj2.view.x + obj2.view.width)) + arrowLength, obj1.view.y + (obj1.view.height/2));
				g.lineTo((obj2.view.x + obj2.view.width) + .5*(obj1.view.x - (obj2.view.x + obj2.view.width)) + arrowLength, obj2.view.y + (obj2.view.height/2));
				g.lineTo((obj2.view.x + obj2.view.width) + arrowLength-1, obj2.view.y + obj2.view.height/2);
				drawArrow((obj2.view.x + obj2.view.width) + .5*(obj1.view.x - (obj2.view.x + obj2.view.width)) + arrowLength, obj2.view.y + (obj2.view.height/2), (obj2.view.x + obj2.view.width), obj2.view.y + obj2.view.height/2,g);		
			}
			else{
				g.lineTo((obj2.view.x + obj2.view.width) + arrowLength-1, obj2.view.y + obj2.view.height/2);
				drawArrow(obj1.view.x, obj1.view.y + (obj1.view.height/2), (obj2.view.x + obj2.view.width), obj2.view.y + obj2.view.height/2,g);
			}

		}
		
		//from the top of obj1 to the bottom of obj2
		private function topToBottom(obj1:IVisualNode, obj2:IVisualNode, g:GraphicsWrapper):void {
			g.moveTo(obj1.view.x + (obj1.view.width/2), obj1.view.y);
			if(_type == 'orthogonal'){
				g.lineTo(obj1.view.x + (obj1.view.width/2), obj1.view.y + .5*((obj2.view.y + obj2.view.height) - obj1.view.y));
				g.lineTo(obj2.view.x+(obj2.view.width/2), obj1.view.y + .5*((obj2.view.y + obj2.view.height) - obj1.view.y));
				g.lineTo(obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height)+ arrowLength-1);
				drawArrow(obj2.view.x+(obj2.view.width/2), obj1.view.y + .5*((obj2.view.y + obj2.view.height) - obj1.view.y), obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height),g);			
			}
			else{
				g.lineTo(obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height)+ arrowLength-1);
				drawArrow(obj1.view.x + (obj1.view.width/2), obj1.view.y, obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height),g);
			}
			
		}
		
		//from the bottom of obj1 to the top of obj2
		private function bottomToTop(obj1:IVisualNode, obj2:IVisualNode, g:GraphicsWrapper):void {
			g.moveTo(obj1.view.x + (obj1.view.width/2), obj1.view.y + obj1.view.height);
			if(_type == 'orthogonal') {
				g.lineTo(obj1.view.x + (obj1.view.width/2), (obj1.view.y + obj1.view.height) + .5*(obj2.view.y - (obj1.view.y + obj1.view.height)));
				g.lineTo(obj2.view.x + (obj2.view.width/2), (obj1.view.y + obj1.view.height) + .5*(obj2.view.y - (obj1.view.y + obj1.view.height)));
				g.lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y - arrowLength+1);
				drawArrow(obj2.view.x + (obj2.view.width/2), (obj1.view.y + obj1.view.height) + .5*(obj2.view.y - (obj1.view.y + obj1.view.height)), obj2.view.x + (obj2.view.width/2), obj2.view.y,g);
			}
			else {
				g.lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y - arrowLength+1);
				drawArrow(obj1.view.x + (obj1.view.width/2), obj1.view.y + obj1.view.height, obj2.view.x + (obj2.view.width/2), obj2.view.y,g);
			}
		}
		
		//from the center of _obj1 to the center of _obj2
		private function centerToCenter(obj1:IVisualNode, obj2:IVisualNode, g:GraphicsWrapper):void {
			g.moveTo(obj1.view.x + (obj1.view.width/2), obj1.view.y + (obj1.view.height/2));
			g.lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y + (obj2.view.height/2));
			drawArrow(obj1.view.x + (obj1.view.width/2), obj1.view.y + obj1.view.height, obj2.view.x + (obj2.view.width/2), obj2.view.y,g);
		}
        
        protected override function get g():GraphicsWrapper
        {
            var r:GraphicsWrapper = super.g;
            r.disable = true;
            return r;
        }
	}
}