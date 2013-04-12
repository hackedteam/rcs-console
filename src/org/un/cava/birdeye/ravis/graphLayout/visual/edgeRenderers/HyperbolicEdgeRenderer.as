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
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.un.cava.birdeye.ravis.graphLayout.layout.Hyperbolic2DLayouter;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.GraphicUtils;
	import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;
	import org.un.cava.birdeye.ravis.utils.geom.IProjector;


	/**
	 * This is an edge renderer for Hyperbolic2DLayout, which draws the edges
	 * as curved lines from one node to another. The radius of the curve is 
	 * dependent on the location of the two points and is computed by the 
	 * Hyperbolic (Poincare) projector.
	 * 
	 * @author Nitin Lamba
	 * 
	 */
	public class HyperbolicEdgeRenderer extends BaseEdgeRenderer {
		
		/**
		 * Constructor of the Edge Renderer that sets the projector and the
		 * graphics object to draw on.
		 * @param g The graphics object to draw on.
		 * @param projector The projector object, to be taken from the corresponding layouter.
		 */
		public function HyperbolicEdgeRenderer() {
			super();
		}
		
		/**
		 * The draw function for the HyperbolicEdgeRenderer, it draws
		 * the curve according to the model calculation.
		 * 
		 * @inheritDoc
		 * */
		override public function draw():void {

			var fromNode:IVisualNode;
			var toNode:IVisualNode;
			var mid:Point;
			
			var fromX:Number;
			var fromY:Number;
			var toX:Number;
			var toY:Number;
			
            if(projector == null)
                return;
            
			/* first get the corresponding nodes */
			fromNode = vedge.edge.node1.vnode;
			toNode = vedge.edge.node2.vnode;
			
			/* assign coordinates at the center of the node's view */
			fromX = fromNode.viewCenter.x;
			fromY = fromNode.viewCenter.y;
			toX = toNode.viewCenter.x;
			toY = toNode.viewCenter.y;
			
			
			/* apply the line style */
			applyLineStyle();
			
			
			// Method 2: Using circular arcs		
			var center:Point = projector.getCenter(fromX, fromY, toX, toY, (vedge.vgraph as DisplayObject));
			if (center == null) {// diameter - just draw a straight line
				g.moveTo(fromX, fromY);
				g.lineTo(toX, toY);
			} else {
				var angle:Number = GraphicUtils.getAngle(fromX, fromY, toX, toY, center.x, center.y);
				var testPoint1:Point = GraphicUtils.getRotation(angle, center.x, center.y, fromX, fromY);
				var testPoint2:Point = GraphicUtils.getRotation(angle, center.x, center.y, toX, toY);
				// Rotation check - the second point must be equal to the rotated point
				if (GraphicUtils.equal(testPoint1, new Point(toX,toY))) {
					GraphicUtils.drawArc(g, angle, center.x, center.y, fromX, fromY);
				} else if (GraphicUtils.equal(testPoint2, new Point(fromX, fromY))) {
					GraphicUtils.drawArc(g, angle, center.x, center.y, toX, toY);
				} else {// Rare case - arc angle greater than PI/2
					angle = Math.PI - angle;
					testPoint1 = GraphicUtils.getRotation(angle, center.x, center.y, fromX, fromY);
					testPoint2 = GraphicUtils.getRotation(angle, center.x, center.y, toX, toY);
					if (GraphicUtils.equal(testPoint1, new Point(toX,toY))) {
						GraphicUtils.drawArc(g, angle, center.x, center.y, fromX, fromY);
					} else if (GraphicUtils.equal(testPoint2, new Point(fromX, fromY))) {
						GraphicUtils.drawArc(g, angle, center.x, center.y, toX, toY);
					}
				}
			}
			
			/* if the vgraph currently displays edgeLabels, then
			 * we need to update their coordinates */
			if(vedge.vgraph.displayEdgeLabels) {
				vedge.setEdgeLabelCoordinates(labelCoordinates());
			}
		}
        
        protected function get projector():IProjector
        {
            if(vedge.vgraph.layouter is Hyperbolic2DLayouter)
                return Hyperbolic2DLayouter(vedge.vgraph.layouter).projector;
            
            return null;
        }
	}
}