/* 
* The MIT License
*
* Copyright (c) 2008 The Birdeye Project Team
* and Bjorn Abramson
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
     * Renderer for directed arrow that takes the size of the nodes
     * into consideration.
     * 
     * This is based on the RaViz DirectedArrowEdgeRenderer class.
     * 
     * @author Bjorn Abramson
     */
    public class DirectedArrowScalingEdgeRenderer extends BaseEdgeRenderer
    {
        /**
         * The size of the arrowhead in pixel. The distance of the
         * two points defining the base of the arrowhead.
         * */
        public var arrowBaseSize:Number = 10;
        
        /**
         * The distance of the arrowbase from the tip in pixel.
         * */
        public var arrowHeadLength:Number = 20;
        
        /**
         * For convenience, PI/2
         */
        private static const PI_HALF:Number = Math.PI / 2.0;
        
        /**
         * Constructor sets the graphics object (required).
         * @param g The graphics object to be used.
         * */
        public function DirectedArrowScalingEdgeRenderer() {
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
            
            var lArrowBase:Point;
            var rArrowBase:Point;
            var mArrowBase:Point;
            
            var edgeAngle:Number;
            
            /* apply the line style */
            applyLineStyle();
            
            /* calculate the base bidpoint which is on
            * the same vector defined between the two endpoints
            *
            * First Step: get the angle of the edge in radians
            */
            edgeAngle = Math.atan2(tP.y - fP.y, tP.x - fP.x);
            
            /* 
            * We want to offset the point(s) to prevent 
            * the arrow being obscured by the node. This is done
            * by moving the end point(s) to the intersection point with the node(s).
            * 
            * The idea is that we divide the node into eight sections,
            * each section becoming a right triangle, 
            * this will allow us to perform simple trig offset operations
            * for each of these sections based on the incoming edge angle. 
            * 
            * For convenience we are using a shifted edge angle [0 > 2PI).
            * 
            * Perhaps the behaviour could be configurable, i.e. an option
            * to offset the points or not...
            */
            var updatedtP:Point = tP.clone();
            var updatedfP:Point = fP.clone();
            
            var toNodeHalfWidth:Number = toNode.view.width / 2.0;
            var toNodeHalfHeight:Number = toNode.view.height / 2.0;
            
            var fromNodeHalfWidth:Number = fromNode.view.width / 2.0;
            var fromNodeHalfHeight:Number = fromNode.view.height / 2.0;			
            
            var shiftedEdgeAngle:Number = edgeAngle + Math.PI;
            
            /*
            * Apply offsets for "to" node. 
            */
            offsetPoint( updatedtP, shiftedEdgeAngle, toNodeHalfWidth, toNodeHalfHeight);
            
            /*
            * For the from node we're using the opposite angle.
            * 
            * Visually the offset at the from node doesn't matter that much, 
            * especially if the node itself is obscuring, however it is used to calculate  
            * the new midpoint when there is an edge label .
            */
            var oppositeAngle:Number = ( shiftedEdgeAngle + Math.PI ) % (Math.PI * 2.0);
            offsetPoint( updatedfP, oppositeAngle , fromNodeHalfWidth, fromNodeHalfHeight);
            
            /*
            * When nodes overlap, revert to the old center points so that the arrow
            * is pointing in the right direction towards center and not to the border.
            */
            if ( Point.distance(updatedfP, tP) < Point.distance(updatedtP, tP) )
            {
                updatedfP = fP;
                updatedtP = tP;
            }
            
            /* Second step: the midpoint of the base can easily
            * be specified in polar coords, using the same angle
            * and as distance the original distance - the base distance
            * then only the y value needs to be adjusted by the 
            * y value of the from point
            */
            
            mArrowBase = Point.polar(Point.distance(updatedtP,updatedfP) - arrowHeadLength,edgeAngle);
            mArrowBase.offset(updatedfP.x, updatedfP.y);
            
            
            /* Now find the left and right arrow base points
            * in a similar way.
            * 1. We can keep the angle but add/subtract 90 degrees.
            * 2. As distance use the half of the base size
            * 3. add the midpoint as reference 
            */
            lArrowBase = Point.polar(arrowBaseSize / 2.9,(edgeAngle - PI_HALF));
            rArrowBase = Point.polar(arrowBaseSize / 2.9,(edgeAngle + PI_HALF));
            
            lArrowBase.offset(mArrowBase.x,mArrowBase.y);                   
            rArrowBase.offset(mArrowBase.x,mArrowBase.y);
            
            /* now we actually draw */
            g.beginFill(uint(vedge.lineStyle.color));
            g.moveTo(updatedfP.x, updatedfP.y);
            g.lineTo(updatedtP.x, updatedtP.y);
            g.lineTo(lArrowBase.x, lArrowBase.y);
            g.lineTo(rArrowBase.x, rArrowBase.y);
            g.lineTo(updatedtP.x, updatedtP.y);
            g.endFill();
            
            /* if the vgraph currently displays edgeLabels, then
            * we need to update their coordinates */
            if(vedge.vgraph.displayEdgeLabels) {
                vedge.setEdgeLabelCoordinates( Geometry.midPointOfLine(updatedfP, updatedtP) );
            }
        }
        
        /**
         * Method to offset the point (p) according to the size of the node (height, width)
         * and the incoming angle (angle).
         * 
         * @param	p	Point to offset
         * @param	angle Incoming positive angle in the range of [0 > 2PI)
         * @param	halfWidth  1/2 width of the node
         * @param	halfHeight 1/2 height of the node
         */
        private function offsetPoint(p:Point, angle:Number, halfWidth:Number, halfHeight:Number):void
        {
            /* Calculate section Angle */
            var sectionAngle:Number = Math.atan2( halfHeight, halfWidth );
            
            if ( angle < sectionAngle)
            {
                p.offset( halfWidth, halfWidth * Math.tan( angle ));				
            }
            else if ( angle < PI_HALF )
            {
                p.offset( halfHeight * Math.tan( PI_HALF - angle  ) , halfHeight);
            }
            else if ( angle < (Math.PI - sectionAngle) )
            {
                p.offset( -halfHeight * Math.tan( angle - PI_HALF ) , halfHeight);
            }
            else if ( angle < (Math.PI) )
            {
                p.offset( -halfWidth , halfWidth * Math.tan( Math.PI - angle  ));
            }
            else if ( angle < (Math.PI + sectionAngle) )
            {
                p.offset( -halfWidth , -halfWidth * Math.tan( angle - Math.PI ));
            }
            else if ( angle < (Math.PI * 1.5) )
            {
                p.offset( -halfHeight * Math.tan( (Math.PI * 1.5) - angle ) , -halfHeight);
            }
            else if ( angle < (Math.PI * 2.0 - sectionAngle) )
            {
                p.offset( halfHeight * Math.tan( angle - (Math.PI * 1.5)  ) , -halfHeight);
            }
            else
            {
                p.offset( halfWidth, -halfWidth * Math.tan( 2.0 * Math.PI - angle ));	
            }
        }
        
    }
    
}