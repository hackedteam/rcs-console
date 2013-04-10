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
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;


	/**
	 * This is a directed edge renderer, which draws the edges
	 * with slim ballon like curves that indicate a source.
	 * Please note that for undirected graphs, the actual direction
	 * of the edge might be arbitrary.
	 * */
	public class DirectedBalloonEdgeRenderer extends BaseEdgeRenderer {
		
		
		/**
		 * Specifies the width or thickness of the balloons.
		 * @default 10
		 * */
		public var balloonWidth:Number = 10.0;
		
		/**
		 * Constructor sets the graphics object (required).
		 * @param g The graphics object to be used.
		 * */
		public function DirectedBalloonEdgeRenderer() {
			super();
		}
		
		/**
		 * The draw function, i.e. the main function to be used.
		 * Draws a curved line from one node of the edge to the other.
		 * The colour is determined by the "disting" parameter and
		 * a set of edge parameters, which are stored in an edge object.
		 * 
		 * @inheritDoc
		 * */
		override public function draw():void {
			
			/* first get the corresponding visual object */
			var fromNode:IVisualNode = vedge.edge.node1.vnode;
			var toNode:IVisualNode = vedge.edge.node2.vnode;
            
			var fP:Point = fromNode.viewCenter;
			var tP:Point = toNode.viewCenter;
			
			/* calculate the midpoint used as curveTo anchor point */
			var anchor:Point = Geometry.midPointOfLine(fP,tP);
			
			/* apply the line style */
			applyLineStyle();
			
			/* now we actually draw */
			g.beginFill(uint(vedge.lineStyle.color));
			g.moveTo(fP.x, fP.y);			
			
			/* bezier curve style */
			g.curveTo(fP.x - balloonWidth, fP.y - balloonWidth, anchor.x, anchor.y);
			g.endFill();
			g.beginFill(uint(vedge.lineStyle.color));
			g.moveTo(fP.x, fP.y);
			g.curveTo(fP.x + balloonWidth, fP.y + balloonWidth, anchor.x, anchor.y);
			g.endFill();
			g.beginFill(uint(vedge.lineStyle.color));
			g.moveTo(fP.x, fP.y);
			g.curveTo(fP.x - balloonWidth, fP.y + balloonWidth, anchor.x, anchor.y);
			g.endFill();
			g.beginFill(uint(vedge.lineStyle.color));
			g.moveTo(fP.x, fP.y);
			g.curveTo(fP.x + balloonWidth, fP.y - balloonWidth, anchor.x, anchor.y);
			g.endFill();
			g.beginFill(uint(vedge.lineStyle.color));
			g.moveTo(anchor.x, anchor.y);
			
			g.lineTo(toNode.viewCenter.x, toNode.viewCenter.y);
			g.endFill();
		
			/* if the vgraph currently displays edgeLabels, then
			 * we need to update their coordinates */
			if(vedge.vgraph.displayEdgeLabels) {
				vedge.setEdgeLabelCoordinates(labelCoordinates());
			}
		}
		
		/**
		 * This method places the label coordinates at the functional midpoint
		 * of the bezier curve using the same anchors as the edge renderer.
		 * 
		 * @inheritDoc
		 * */
		override public function labelCoordinates():Point {
			/* first get the corresponding visual object */
			var fromPoint:Point = new Point(vedge.edge.node1.vnode.viewCenter.x,
								vedge.edge.node1.vnode.viewCenter.y);
			var toPoint:Point = new Point(vedge.edge.node2.vnode.viewCenter.x,
								vedge.edge.node2.vnode.viewCenter.y);
			
			/* calculate the midpoint used as curveTo anchor point */
			var anchor:Point = Geometry.midPointOfLine(fromPoint,toPoint);
			
			/* we use t = 0.6 here to a bit more towards the target */
			return Geometry.bezierPoint(fromPoint,anchor,toPoint,0.6);
		}
	}
}