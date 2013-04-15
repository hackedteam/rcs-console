/* 
 * The MIT License
 *
 * Copyright (c) 2008 The SixDegrees Project Team
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
	import flash.geom.Rectangle;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;


	/**
	 * This is the edge renderer for circular layout, which draws the edges
	 * as curved lines from one node to another.
	 * */
	public class CircularEdgeRenderer extends BaseEdgeRenderer {
		
		/**
		 * Constructor sets the graphics object (required).
		 * @param g The graphics object to be used.
		 * */
		public function CircularEdgeRenderer() {
			super();
		}
		
		/**
		 * The draw function, i.e. the main function to be used.
		 * Draws a curved line from one node of the edge to the other.
		 * 
		 * @inheritDoc
		 * */
		override public function draw():void {
			
			/* first get the corresponding visual object */
			var fromNode:IVisualNode = vedge.edge.node1.vnode;
			var toNode:IVisualNode = vedge.edge.node2.vnode;

            /* calculate the midpoint used as curveTo anchor point */
			var anchor:Point = getEdgeAnchor();
			
            var thickness:Number = vedge.lineStyle.thickness;
			/* apply the line style */
			applyLineStyle();
			
			/* now we actually draw */
			g.moveTo(fromNode.viewCenter.x, fromNode.viewCenter.y);			
			
			//_g.curveTo(centreX, centreY, toX, toY);
			g.curveTo(
				anchor.x ,
				anchor.y ,
				toNode.viewCenter.x ,
				toNode.viewCenter.y 
			);
			
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
			
            var thickness:Number = vedge.lineStyle.thickness;
            /* first get the corresponding visual object */
			var fromPoint:Point = new Point(vedge.edge.node1.vnode.viewCenter.x + thickness,
								vedge.edge.node1.vnode.viewCenter.y + thickness);
			var toPoint:Point = new Point(vedge.edge.node2.vnode.viewCenter.x + thickness,
								vedge.edge.node2.vnode.viewCenter.y + thickness);
			
			/* calculate the midpoint used as curveTo anchor point */
			var anchor:Point = getLabelAnchor().add(new Point(thickness,thickness));
			return Geometry.bezierPoint(fromPoint,anchor,toPoint,0.5);
		}
        
        protected function getEdgeAnchor():Point {
            /* first get the corresponding visual object */
            var fromNode:IVisualNode = vedge.edge.node1.vnode;
            var toNode:IVisualNode = vedge.edge.node2.vnode;
            
            var bounds:Rectangle = vedge.vgraph.layouter.bounds;
            /* calculate the midpoint used as curveTo anchor point */
            var anchor:Point = new Point(
                (fromNode.viewCenter.x + bounds.x + bounds.width/2) / 2.0,
                (fromNode.viewCenter.y + bounds.y + bounds.height/2) / 2.0
            );
            
            return anchor;
        }
        
        protected function getLabelAnchor():Point {
            /* first get the corresponding visual object */
            var fromPoint:Point = new Point(vedge.edge.node1.vnode.viewCenter.x,
                vedge.edge.node1.vnode.viewCenter.y);
            var toPoint:Point = new Point(vedge.edge.node2.vnode.viewCenter.x,
                vedge.edge.node2.vnode.viewCenter.y);
            var bounds:Rectangle = vedge.vgraph.layouter.bounds;
            /* calculate the midpoint used as curveTo anchor point */
            var anchor:Point = new Point(
                (fromPoint.x + bounds.x + bounds.width/2) / 2.0,
                (fromPoint.y + bounds.y + bounds.height/2) / 2.0
            );
            
            return anchor;
        }
	}
}