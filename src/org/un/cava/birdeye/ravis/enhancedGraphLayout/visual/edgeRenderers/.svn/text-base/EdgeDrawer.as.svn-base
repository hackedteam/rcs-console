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
package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.edgeRenderers {
    
    
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import mx.core.UIComponent;
    
    import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.IControllableEdgeRenderer;
    import org.un.cava.birdeye.ravis.graphLayout.data.*;
    import org.un.cava.birdeye.ravis.graphLayout.layout.HierarchicalLayouter;
    import org.un.cava.birdeye.ravis.graphLayout.visual.*;
    import org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers.*;
    import org.un.cava.birdeye.ravis.utils.Geometry;
    import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;
    import org.un.cava.birdeye.ravis.utils.TypeUtil;
    
    /**
     * This edge renderer draws rectangular edge arrows.
     * Please note that for undirected graphs, the actual direction
     * of the arrow might be arbitrary.
     * */
    
    public class EdgeDrawer extends BaseEdgeRenderer implements IControllableEdgeRenderer {
        
        /* constructor does nothing and is therefore omitted
        */
        public var arrowLength:Number = 5;
        
        public var enableArrow:Boolean = true;
        public var fromType:String;
        public var toType:String;
        protected var _type:String;
        protected var labelView:UIComponent;
        
        protected var edgeClass:String;
        protected var arrowPosition:String;
        
        /* temporary fix */
        protected var color:Number;
        
        public static const BASE_EDGE_ABOVE:int = 1;
        public static const BASE_EDGE_RIGHT:int = 2;
        public static const BASE_EDGE_BELOW:int = 3;
        public static const BASE_EDGE_LEFT:int = 4;
        protected var baseEdgePosition:int;
        private var ptPos:Number = 0;
        public var layoutOrientation:uint = HierarchicalLayouter.ORIENT_LEFT_RIGHT;
        public var baseEdgeDis:Number = 30;
        public var isFixBaseEdge:Boolean = true;
        public var hitSize:Number = 6;
        
        public function EdgeDrawer() {
            super();
        }
        
        protected function drawLine(x1:Number, y1:Number, x2:Number, y2:Number):void
        {
            g.lineStyle(hitSize, this.color, 0.01);
            moveTo(x1, y1);
            lineTo(x2, y2);
            g.lineStyle(1, this.color, 1);
            moveTo(x1, y1);
            lineTo(x2, y2);
        }
        
        protected function lineTo(ptx:Number, pty:Number):void
        {
            var pos:Point = new Point(ptx, pty);
            pos = vedge.vgraph.localToGlobal(pos);
            pos = labelView.globalToLocal(pos);
            g.lineTo(pos.x, pos.y);
        }
        
        protected function moveTo(ptx:Number, pty:Number):void
        {
            var pos:Point = new Point(ptx, pty);
            pos = vedge.vgraph.localToGlobal(pos);
            pos = labelView.globalToLocal(pos);
            g.moveTo(pos.x, pos.y);
        }
        
        protected function positionComponent(component:DisplayObject, ptx:Number, pty:Number):void
        {
            var pos:Point = new Point(ptx, pty);
            pos = vedge.vgraph.localToGlobal(pos);
            pos = labelView.globalToLocal(pos);
            component.x = pos.x;
            component.y = pos.y;
        }
        
        /**
         * The draw function, i.e. the main function to be used.
         * Draws a straight line from one node of the edge to the other.
         * The colour is determined by the "disting" parameter and
         * a set of edge parameters, which are stored in an edge object.
         * 
         * @inheritDoc
         * */
        public override function draw():void {
            
            var edge:IEdge = vedge.edge;
            
            var edgeVO:Object = edge.data;
            
            var visible:String = String(edgeVO.visible);
            var fromVisible:String = String(edge.fromNode.data.visible);
            var toVisible:String = String(edge.toNode.data.visible);
            
            
            if (TypeUtil.isFalse(visible) || TypeUtil.isFalse(fromVisible) || TypeUtil.isFalse(toVisible))	
            {
                return;
            }
            
            calculateLayoutOrientation();
            baseEdgePosition = calculateBaseEdgePosition();
            redraw();	
        }
        
        protected function calculateBaseEdgePosition():int
        {
            var edge:IEdge = vedge.edge;
            var fromNode:INode = edge.node1;
            
            var numNodeAbove:int = 0;
            var numNodeRight:int = 0;
            var numNodeBelow:int = 0;
            var numNodeLeft:int = 0;
            
            var visualFromNode:IVisualNode = fromNode.vnode;
            if (!(visualFromNode && visualFromNode.view))
                return -1;
            
            var fromPt:Point = new Point(visualFromNode.view.x + visualFromNode.view.width/2, visualFromNode.view.y + visualFromNode.view.height/2);
            for each (var toNode:INode in fromNode.successors)
            {
                var visualToNode:IVisualNode = toNode.vnode;
                if (!(visualToNode && visualToNode.view))
                    continue;
                var toPt:Point = new Point(visualToNode.view.x + visualToNode.view.width/2, visualToNode.view.y + visualToNode.view.height/2)
                if (isFullyAbovePt(toPt, fromPt))
                    numNodeAbove++;
                
                if (isFullyRightOfPt(toPt, fromPt))
                    numNodeRight++;
                
                if (isFullyBelowPt(toPt, fromPt))
                    numNodeBelow++;
                
                if (isFullyLeftOfPt(toPt, fromPt))
                    numNodeLeft++;
            }
            
            var vg:IVisualGraph = edge.vedge.vgraph;
            
            switch(layoutOrientation)
            {
            case HierarchicalLayouter.ORIENT_LEFT_RIGHT:
            {
                if (numNodeLeft > numNodeRight)
                    return BASE_EDGE_LEFT;
                else
                    return BASE_EDGE_RIGHT;
            }
            case HierarchicalLayouter.ORIENT_RIGHT_LEFT:
            {
                if (numNodeRight > numNodeLeft)
                    return BASE_EDGE_RIGHT;
                else
                    return BASE_EDGE_LEFT;
            }
            case HierarchicalLayouter.ORIENT_TOP_DOWN:
            {
                if (numNodeAbove > numNodeBelow)
                    return BASE_EDGE_ABOVE;
                else
                    return BASE_EDGE_BELOW;
            }
            case HierarchicalLayouter.ORIENT_BOTTOM_UP:
            {
                if (numNodeBelow > numNodeAbove)
                    return BASE_EDGE_BELOW;
                else
                    return BASE_EDGE_ABOVE;
            }
            }
            
            var maxNum:int = Math.max(numNodeAbove, numNodeBelow, numNodeLeft, numNodeRight);
            if (maxNum == numNodeAbove)
                return BASE_EDGE_ABOVE;
            
            if (maxNum == numNodeBelow)
                return BASE_EDGE_BELOW;
            
            if (maxNum == numNodeLeft)
                return BASE_EDGE_LEFT;
            
            if (maxNum == numNodeRight)
                return BASE_EDGE_RIGHT;
            
            return -1;
        }
        
        protected function calculateLayoutOrientation():void
        {
            if (vedge.vgraph.layouter is HierarchicalLayouter)
            {
                layoutOrientation = HierarchicalLayouter(vedge.vgraph.layouter).orientation;
            }
        }
        
        protected function redraw():void {
            
            var edge:IEdge = vedge.edge;
            var edgeVO:Object = edge.data;
            var toPositionStrID:String;
            var fromPositionStrID:String
            arrowPosition = "type1";
            if (edgeVO is XML)
            {
                toPositionStrID = (edgeVO as XML).attribute("toPosition");
                fromPositionStrID = (edgeVO as XML).attribute("fromPosition");
                edgeClass = (edgeVO as XML).attribute("edgeClass");
                color = Number((edgeVO as XML).attribute("color").toString());
            }
            else
            {
                toPositionStrID = edgeVO.toPosition;
                fromPositionStrID = edgeVO.fromPosition;
                edgeClass = edgeVO.edgeClass;
                color = edgeVO.color;
            }
            /* first get the corresponding visual object */
            var fromNode:IVisualNode = vedge.edge.node1.vnode;
            var toNode:IVisualNode = vedge.edge.node2.vnode;
            
            fromType = fromNode.node.data.type;
            toType = toNode.node.data.type;
            
            var fromPt:Rectangle;
            var toPt:Rectangle;
            
            fromPt = new Rectangle(fromNode.view.x, 
                fromNode.view.y, 
                fromNode.view.width, fromNode.view.height);
            
            toPt = new Rectangle(toNode.view.x, 
                toNode.view.y,
                toNode.view.width, toNode.view.height);
            
            labelView = vedge.labelView;
            vedge.labelView["layoutOrientation"] = layoutOrientation;
            var castedComp:EdgeRenderer;
            var fromDistance:Number = 0;
            var toDistance:Number = 0
            if (labelView is EdgeRenderer)
            {
                castedComp = EdgeRenderer(labelView);
                fromDistance = castedComp.fromDistance;
                toDistance = castedComp.toDistance;
            }
            
            var g:GraphicsWrapper = new GraphicsWrapper(labelView.graphics);
            g.fuzzFactor = hitSize;
            g.clear();
            /* now we actually draw */
            /* apply the style to the drawing */
            
            if(vedge.lineStyle != null) {
                g.lineStyle(
                    Number(vedge.lineStyle.thickness),
                    Number(vedge.lineStyle.color),
                    Number(vedge.lineStyle.alpha),
                    Boolean(vedge.lineStyle.pixelHinting),
                    String(vedge.lineStyle.scaleMode),
                    String(vedge.lineStyle.caps),
                    String(vedge.lineStyle.joints),
                    Number(vedge.lineStyle.miterLimits)
                );
            }
            
            var midPt:Point = new Point();
            baseEdgePosition = calculateBaseEdgePosition();
            /* calculate the midpoint */
            
            var pt1:Point = new Point();
            var pt2:Point = new Point();
            var pt3:Point = new Point();
            var pt4:Point = new Point();
            var pt5:Point = new Point();
            var finalPt:Point = new Point();
            
            var pt41:Point = new Point();
            var pt42:Point = new Point();
            
            var tmpPt:Point = new Point();
            
            switch(baseEdgePosition)
            {
            case BASE_EDGE_ABOVE:
            {
                pt1.x = fromPt.x + fromPt.width/2;
                pt1.y = fromPt.y;
                pt2.x = pt1.x;
                if (isFixBaseEdge == false)
                {
                    baseEdgeDis = (Math.abs(fromPt.y - toPt.y)  - toPt.height)/2;
                    pt2.y = pt1.y - baseEdgeDis;
                }
                else
                {
                    pt2.y = pt1.y - (baseEdgeDis) + fromDistance;
                }
                
                
                if (isFullyAbovePt(new Point(toPt.x, toPt.y + toPt.height), pt2))
                {
                    pt4.y = toPt.y + toPt.height;
                    finalPt.y = pt4.y;
                }
                else if (isFullyBelowPt(new Point(toPt.x, toPt.y), pt2))
                {
                    pt4.y = toPt.y;
                    finalPt.y = pt4.y;
                }
                else
                {
                    pt3.y = pt2.y;
                    if (isFullyLeftOfPt(new Point(toPt.x + toPt.width , toPt.y), pt2))
                    {
                        pt3.x = toPt.x + toPt.width;
                        finalPt.x = pt3.x;
                        pt3.x += toDistance;
                    }
                    else if (isFullyRightOfPt(new Point(toPt.x, toPt.y), pt2))
                    {
                        pt3.x = toPt.x;
                        finalPt.x = pt3.x;
                        pt3.x += toDistance;
                    }
                    else
                    {
                        //Recalculate pt2
                        pt2.x = pt1.x;
                        pt2.y = Math.min(toPt.y + toPt.height, pt1.y);
                        
                        pt3.x = pt2.x;
                        pt3.y = pt2.y;
                    }
                    finalPt.y = pt3.y;
                    pt4.y = pt3.y;
                    pt4.x = pt3.x;
                    break;
                }
                
                pt4.x = toPt.x + toPt.width/2;
                finalPt.x = pt4.x;
                pt4.x += toDistance
                pt3.x = pt4.x;
                pt3.y = pt2.y;
                pt5.x = pt4.x ;
                pt5.y = pt4.y + 2*ptPos;
                pt41.y = pt42.y = pt4.y;
                pt41.x = pt4.x + ptPos;
                pt42.x = pt4.x - ptPos;
                break;
            }
                
            case BASE_EDGE_BELOW:
            {
                pt1.x = fromPt.x + fromPt.width/2;
                pt1.y = fromPt.y + fromPt.height;
                pt2.x = pt1.x;
                if (isFixBaseEdge == false)
                {
                    baseEdgeDis = (Math.abs(fromPt.y - toPt.y) - fromPt.height)/2;
                    pt2.y = pt1.y + baseEdgeDis;
                }
                else
                {
                    pt2.y = pt1.y + baseEdgeDis + fromDistance;
                }
                
                
                if (isFullyBelowPt(new Point(toPt.x, toPt.y), pt2))
                {
                    pt4.y = toPt.y;	
                    finalPt.y = pt4.y;
                }
                else if (isFullyAbovePt(new Point(toPt.x, toPt.y + toPt.height), pt2))
                {
                    pt4.y = toPt.y + toPt.height;
                    finalPt.y = pt4.y;
                }
                else
                {
                    pt3.y = pt2.y;
                    if (isFullyLeftOfPt(new Point(toPt.x + toPt.width , toPt.y), pt2))
                    {
                        pt3.x = toPt.x + toPt.width;
                        finalPt.x = pt3.x;
                        pt3.x += toDistance;
                    }
                    else if (isFullyRightOfPt(new Point(toPt.x, toPt.y), pt2))
                    {
                        pt3.x = toPt.x;
                        finalPt.x = pt3.x;
                        pt3.x += toDistance;
                    }
                    else
                    {
                        //Recalculate pt2
                        pt2.x = pt1.x;
                        pt2.y = Math.max(toPt.y, pt1.y);
                        
                        pt3.x = pt2.x;
                        pt3.y = pt2.y;
                    }
                    finalPt.y = pt3.y;
                    pt4.y = pt3.y;
                    pt4.x = pt3.x;
                    break;
                }
                pt4.x = toPt.x + toPt.width/2;
                finalPt.x = pt4.x;
                pt4.x += toDistance;
                pt3.x = pt4.x;
                pt3.y = pt2.y;
                pt5.x = pt4.x ;
                pt5.y = pt4.y - 2*ptPos;
                pt41.y = pt42.y = pt4.y;
                pt41.x = pt4.x + ptPos;
                pt42.x = pt4.x - ptPos;						
                break;
            }
                
            case BASE_EDGE_LEFT:
            {
                pt1.x = fromPt.x;
                pt1.y = fromPt.y + fromPt.height/2;
                pt2.y = pt1.y;
                if (isFixBaseEdge == false)
                {
                    baseEdgeDis = (Math.abs(fromPt.x - toPt.x) - toPt.width)/2;
                    pt2.x = pt1.x - baseEdgeDis;
                }
                else
                {
                    pt2.x = pt1.x - baseEdgeDis + fromDistance;
                }
                
                if (isFullyLeftOfPt(new Point(toPt.x + toPt.width, toPt.y), pt2))
                {
                    pt4.x = toPt.x + toPt.width;
                    finalPt.x = pt4.x;
                    
                }
                else if (isFullyRightOfPt(new Point(toPt.x, toPt.y), pt2))
                {
                    pt4.x = toPt.x;
                    finalPt.x = pt4.x;
                }
                else
                {
                    pt3.x = pt2.x;
                    if (isFullyAbovePt(new Point(toPt.x, toPt.y + toPt.height), pt2))
                    {
                        pt3.y = toPt.y + toPt.height;
                        finalPt.y = pt3.y;
                        pt3.y += toDistance;
                    }
                    else if (isFullyBelowPt(new Point(toPt.x, toPt.y), pt2))
                    {
                        pt3.y = pt3.y = toPt.y;
                        finalPt.y = pt3.y;
                        pt3.y += toDistance;
                    }
                    else
                    {
                        //Recalculate pt2
                        pt2.y = pt1.y;
                        pt2.x = Math.min(toPt.x + toPt.width, pt1.x);
                        
                        pt3.x = pt2.x;
                        pt3.y = pt2.y;
                    }
                    finalPt.x = pt3.x;
                    pt4.y = pt3.y;
                    pt4.x = pt3.x;
                    break;
                }
                
                pt4.y = toPt.y + toPt.height/2;
                finalPt.y = pt4.y;
                pt4.y += toDistance;
                pt3.y = pt4.y;
                pt3.x = pt2.x;
                pt5.x = pt4.x + 2*ptPos;
                pt5.y = pt4.y;
                pt41.x = pt42.x = pt4.x;
                pt41.y = pt4.y + ptPos;
                pt42.y = pt4.y - ptPos;					
                break;
            }
                
            case BASE_EDGE_RIGHT:
            {
                pt1.x = fromPt.x + fromPt.width;
                pt1.y = fromPt.y + fromPt.height/2;
                pt2.y = pt1.y;
                if (isFixBaseEdge == false)
                {
                    baseEdgeDis = (Math.abs(fromPt.x - toPt.x) - fromPt.width)/2;
                    pt2.x = pt1.x + baseEdgeDis;
                }
                else
                {
                    pt2.x = pt1.x + baseEdgeDis + fromDistance;
                }
                
                if (isFullyRightOfPt(new Point(toPt.x, toPt.y), pt2))
                {
                    pt4.x = toPt.x;
                    finalPt.x = pt4.x;
                }
                else if (isFullyLeftOfPt(new Point(toPt.x + toPt.width, toPt.y), pt2))
                {
                    pt4.x = toPt.x + toPt.width;
                    finalPt.x = pt4.x;
                }
                else
                {
                    pt3.x = pt2.x;
                    if (isFullyAbovePt(new Point(toPt.x, toPt.y + toPt.height), pt2))
                    {
                        pt3.y = toPt.y + toPt.height;
                        finalPt.y = pt3.y;
                        pt3.y += toDistance;
                    }
                    else if (isFullyBelowPt(new Point(toPt.x, toPt.y), pt2))
                    {
                        pt3.y = toPt.y;
                        finalPt.y = pt3.y;
                        pt3.y += toDistance;
                    }
                    else
                    {
                        //Recalculate pt2
                        pt2.y = pt1.y;
                        pt2.x = Math.max(toPt.x, pt1.x);
                        
                        pt3.x = pt2.x;
                        pt3.y = pt2.y;
                    }
                    finalPt.x = pt3.x;
                    pt4.y = pt3.y;
                    pt4.x = pt3.x;
                    break;
                }
                
                pt4.y = toPt.y + toPt.height/2;	
                finalPt.y = pt4.y;
                pt4.y += toDistance;
                pt3.y = pt4.y;
                pt3.x = pt2.x;
                pt5.x = pt4.x - 2*ptPos;
                pt5.y = pt4.y;	
                pt41.x = pt42.x = pt4.x;
                pt41.y = pt4.y + ptPos;
                pt42.y = pt4.y - ptPos;				
                break;
            }
            }
            
            //Caculate label position
            var dis12:Number = (pt2.x-pt1.x)*(pt2.x-pt1.x) + (pt2.y-pt1.y)*(pt2.y-pt1.y);
            var dis23:Number = (pt3.x-pt2.x)*(pt3.x-pt2.x) + (pt3.y-pt2.y)*(pt3.y-pt2.y);
            var dis34:Number = (pt4.x-pt3.x)*(pt4.x-pt3.x) + (pt4.y-pt3.y)*(pt4.y-pt3.y);
            var maxDis:Number = Math.max(dis12, dis23, dis34);
            
            if (dis12 == maxDis)
            {
                midPt.x = (pt2.x + pt1.x)/2;
                midPt.y = (pt2.y + pt1.y)/2;
            }
            else if (dis23 == maxDis)
            {
                midPt.x = (pt3.x + pt2.x)/2;
                midPt.y = (pt3.y + pt2.y)/2;
            }
            else if (dis34 == maxDis)
            {
                midPt.x = (pt3.x + pt4.x)/2;
                midPt.y = (pt3.y + pt4.y)/2;
            }
            
            drawLine(pt1.x, pt1.y, pt2.x, pt2.y);
            drawLine(pt2.x, pt2.y, pt3.x, pt3.y);
            drawLine(pt3.x, pt3.y, pt4.x, pt4.y);
            if (toDistance != 0)
            {
                drawLine(pt4.x, pt4.y, finalPt.x, finalPt.y);
            }
            
            if(arrowPosition == "type1"){
                if ((pt3.x == pt4.x) && (pt3.y == pt4.y))
                {
                    if ((pt2.x == pt3.x) && (pt2.y == pt3.y))
                    {
                        if ((pt1.x == pt2.x) && (pt1.y == pt2.y))
                        {
                            
                        }
                        else
                        {
                            drawArrow(pt1.x, pt1.y, pt2.x, pt2.y);
                        }
                    }
                    else
                    {
                        drawArrow(pt2.x, pt2.y, pt4.x, pt4.y);
                    }
                }
                else
                {
                    drawArrow(pt3.x, pt3.y, pt4.x, pt4.y);
                }				
            }
            if (arrowPosition == "type2")
            {
                tmpPt = pt4;
                pt4 = pt1;
                pt1 = tmpPt;
                
                tmpPt = pt3;
                pt3 = pt2;
                pt2 = tmpPt;
                if ((pt3.x == pt4.x) && (pt3.y == pt4.y))
                {
                    if ((pt2.x == pt3.x) && (pt2.y == pt3.y))
                    {
                        if ((pt1.x == pt2.x) && (pt1.y == pt2.y))
                        {
                            
                        }
                        else
                        {
                            drawArrow(pt1.x, pt1.y, pt2.x, pt2.y);
                        }
                    }
                    else
                        drawArrow(pt2.x, pt2.y, pt4.x, pt4.y);
                }
                else
                {
                    drawArrow(pt3.x, pt3.y, pt4.x, pt4.y);
                }				
            }
            
            
            
            if (arrowPosition == "type3")
            {
                tmpPt = pt4;
                pt4 = pt1;
                pt1 = tmpPt;
                
                tmpPt = pt3;
                pt3 = pt2;
                pt2 = tmpPt;
                if ((pt3.x == pt4.x) && (pt3.y == pt4.y))
                {
                    if ((pt2.x == pt3.x) && (pt2.y == pt3.y))
                    {
                        if ((pt1.x == pt2.x) && (pt1.y == pt2.y))
                        {
                            
                        }
                        else
                        {
                            drawArrow(pt1.x, pt1.y, pt2.x, pt2.y);
                        }
                    }
                    else
                        drawArrow(pt2.x, pt2.y, pt4.x, pt4.y);
                }
                else
                {
                    drawArrow(pt3.x, pt3.y, pt4.x, pt4.y);
                }
                
            }
            
            if(arrowPosition == "type4"){
                if ((pt3.x == pt4.x) && (pt3.y == pt4.y))
                {
                    if ((pt2.x == pt3.x) && (pt2.y == pt3.y))
                    {
                        if ((pt1.x == pt2.x) && (pt1.y == pt2.y))
                        {
                            
                        }
                        else
                        {
                            //drawArrow(pt1.x, pt1.y, pt2.x, pt2.y);
                            moveTo(pt5.x ,pt5.y);
                            lineTo(pt4.x, pt4.y);
                            moveTo(pt5.x ,pt5.y);
                            lineTo(pt41.x, pt41.y);
                            moveTo(pt5.x ,pt5.y);
                            lineTo(pt42.x, pt42.y);
                        }
                    }
                    else
                        //drawArrow(pt2.x, pt2.y, pt4.x, pt4.y);
                    {
                        moveTo(pt5.x ,pt5.y);
                        lineTo(pt4.x, pt4.y);
                        moveTo(pt5.x ,pt5.y);
                        lineTo(pt41.x, pt41.y);
                        moveTo(pt5.x ,pt5.y);
                        lineTo(pt42.x, pt42.y);							
                    }
                }
                else
                {
                    //drawArrow(pt3.x, pt3.y, pt4.x, pt4.y);
                    moveTo(pt5.x ,pt5.y);
                    lineTo(pt4.x, pt4.y);
                    moveTo(pt5.x ,pt5.y);
                    lineTo(pt41.x, pt41.y);
                    moveTo(pt5.x ,pt5.y);
                    lineTo(pt42.x, pt42.y);			
                }				
            }
            
            var midPtFrom:Point = new Point((pt2.x + pt3.x)/2, (pt2.y + pt3.y)/2);
            var midPtTo:Point = new Point((pt3.x + pt4.x)/2, (pt3.y + pt4.y)/2);
            
            if (castedComp && castedComp.label)
                positionComponent(castedComp.label , midPt.x - (castedComp.label.width/2), midPt.y - (castedComp.label.height/2));
            if (castedComp && castedComp.fromControl && (castedComp.fromControl['isDragging'] == false))
                positionComponent(castedComp.fromControl , midPtFrom.x - (castedComp.fromControl.width/2), midPtFrom.y - (castedComp.fromControl.height/2));
            if (castedComp && castedComp.toControl && (castedComp.toControl['isDragging'] == false))
                positionComponent(castedComp.toControl , midPtTo.x - (castedComp.toControl.width/2), midPtTo.y - (castedComp.toControl.height/2));
        }
        protected function calculatePoint(fromX:Number, fromY:Number, distance:Number, angle:Number):Object{
            angle = angle * 1.745329E-002;
            var _loc3:Number = fromX + distance * Math.cos(angle);
            var _loc2:Number = fromY - distance * Math.sin(angle);
            return ({x: _loc3, y: _loc2});
        }
        
        protected function drawArrow(fromX:Number, fromY:Number, toX:Number, toY:Number):void{
            
            if (enableArrow == false)
                return;
            
            var eps:Number = 0.0000000000001;
            if (fromY == toY)
                fromY += eps;
            
            if (fromX == toX)
                fromX += eps;
            
            var dXY:Number = (fromY - toY) / (fromX - toX);
            
            var arrowOS:Number;
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
            
            moveTo(toX, toY);
            g.beginFill(color,1);
            lineTo(arrowLine1.x, arrowLine1.y);            
            lineTo(arrowLine2.x, arrowLine2.y);
            lineTo(toX, toY);
            g.endFill(); 
            
        }
        
        //checks if obj1 is fully above obj2 (this includes the space for the arrow)
        protected function isFullyAbove(obj1:IVisualNode, obj2:IVisualNode):Boolean {
            return (obj1.view.y + obj1.view.height + arrowLength) < obj2.view.y;
        }
        
        protected function isFullyAbovePt(pt:Point, pt1:Point):Boolean {
            return (pt.y) < pt1.y;
        }
        
        //checks if obj1 is fully below obj2 (this includes the space for the arrow)
        protected function isFullyBelow(obj1:IVisualNode, obj2:IVisualNode):Boolean {
            return obj1.view.y > (obj2.view.y + obj2.view.height + arrowLength);
        }
        
        protected function isFullyBelowPt(pt:Point, pt1:Point):Boolean {
            return pt.y > (pt1.y);
        } 
        
        //checks if obj1 is fully to the right of obj2 (this includes the space for the arrow)
        protected function isFullyRightOf(obj1:IVisualNode, obj2:IVisualNode):Boolean {
            return obj1.view.x > (obj2.view.x + obj2.view.width + arrowLength);
        }
        protected function isFullyRightOfPt(pt:Point, pt1:Point):Boolean {
            return pt.x > (pt1.x);
        }	
        
        //checks if obj1 is fully to the left of obj2 (this includes the space for the arrow)
        private function isFullyLeftOf(obj1:IVisualNode, obj2:IVisualNode):Boolean {
            return (obj1.view.x + obj1.view.width + arrowLength) < obj2.view.x;
        }
        private function isFullyLeftOfPt(pt:Point, pt1:Point):Boolean {
            return (pt.x) < pt1.x;
        }  
        
        //from the right side of obj1 to the left side of obj2
        private function rightToLeft(obj1:IVisualNode, obj2:IVisualNode):void {
            moveTo(obj1.view.x + obj1.view.width, obj1.view.y + (obj1.view.height/2));
            if(edgeClass == 'type1') {
                if (baseEdgePosition == BASE_EDGE_LEFT)
                {
                    lineTo((obj1.view.x + obj1.view.width) + 20 - arrowLength , obj1.view.y + (obj1.view.height/2));
                    lineTo((obj1.view.x + obj1.view.width) + 20 - arrowLength , obj2.view.y + (obj2.view.height/2));
                    lineTo(obj2.view.x - arrowLength+1, obj2.view.y + (obj2.view.height/2));
                }
                else
                {
                    
                }
                drawArrow((obj1.view.x + obj1.view.width) + .5*(obj2.view.x - (obj1.view.x + obj1.view.width)) - arrowLength, obj2.view.y + (obj2.view.height/2), obj2.view.x, obj2.view.y + (obj2.view.height/2));
            }else if(edgeClass == 'type2'){
                lineTo((obj1.view.x + obj1.view.width) + .5*(obj2.view.x - (obj1.view.x + obj1.view.width)) - arrowLength, obj2.view.y + (obj2.view.height/2));
                lineTo(obj2.view.x - arrowLength+1, obj2.view.y + (obj2.view.height/2));
                drawArrow((obj1.view.x + obj1.view.width) + .5*(obj2.view.x - (obj1.view.x + obj1.view.width)) - arrowLength, obj2.view.y + (obj2.view.height/2), obj2.view.x, obj2.view.y + (obj2.view.height/2));
                
            }
            else {
                lineTo(obj2.view.x - arrowLength+1, obj2.view.y + (obj2.view.height/2));	
                drawArrow(obj1.view.x + obj1.view.width, obj1.view.y + (obj1.view.height/2), obj2.view.x, obj2.view.y + (obj2.view.height/2));
            }
        }
        
        //from the left side of obj1 to the right side of obj2
        private function leftToRight(obj1:IVisualNode, obj2:IVisualNode):void {
            moveTo(obj1.view.x , obj1.view.y + (obj1.view.height/2));
            if(edgeClass == 'type1'){
                if (baseEdgePosition == BASE_EDGE_RIGHT)
                {
                    lineTo((obj2.view.x + obj2.view.width) , obj1.view.y + (obj1.view.height/2));
                    lineTo((obj2.view.x + obj2.view.width) , obj2.view.y + (obj2.view.height/2));
                    lineTo((obj2.view.x + obj2.view.width) + arrowLength-1, obj2.view.y + obj2.view.height/2);
                }
                else
                {
                    
                }
                
                drawArrow((obj2.view.x + obj2.view.width) + .5*(obj1.view.x - (obj2.view.x + obj2.view.width)) + arrowLength, obj2.view.y + (obj2.view.height/2), (obj2.view.x + obj2.view.width), obj2.view.y + obj2.view.height/2);		
            }else if(edgeClass == 'type2'){
                lineTo((obj2.view.x + obj2.view.width) + .5*(obj1.view.x - (obj2.view.x + obj2.view.width)) + arrowLength, obj2.view.y + (obj2.view.height/2));
                lineTo((obj2.view.x + obj2.view.width) + arrowLength-1, obj2.view.y + obj2.view.height/2);
                
                drawArrow((obj2.view.x + obj2.view.width) + .5*(obj1.view.x - (obj2.view.x + obj2.view.width)) + arrowLength, obj2.view.y + (obj2.view.height/2), (obj2.view.x + obj2.view.width), obj2.view.y + obj2.view.height/2);		
            }
            else{
                lineTo((obj2.view.x + obj2.view.width) + arrowLength-1, obj2.view.y + obj2.view.height/2);
                drawArrow(obj1.view.x, obj1.view.y + (obj1.view.height/2), (obj2.view.x + obj2.view.width), obj2.view.y + obj2.view.height/2);
            }
            
        }
        
        //from the top of obj1 to the bottom of obj2
        private function topToBottom(obj1:IVisualNode, obj2:IVisualNode):void {
            moveTo(obj1.view.x + (obj1.view.width/2), obj1.view.y);
            if(edgeClass == 'type1'){
                if (baseEdgePosition == BASE_EDGE_BELOW)
                {
                    lineTo(obj1.view.x + (obj1.view.width/2), obj1.view.y - 20);
                    lineTo(obj2.view.x+(obj2.view.width/2), obj1.view.y - 20);
                    lineTo(obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height)+ arrowLength-1); 
                }
                else
                {
                    lineTo(obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height)+ arrowLength-1); 
                }
                drawArrow(obj2.view.x+(obj2.view.width/2), obj1.view.y + .5*((obj2.view.y + obj2.view.height) - obj1.view.y), obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height));			
            }else if(edgeClass == 'type2'){
                lineTo(obj2.view.x+(obj2.view.width/2), obj1.view.y + .5*((obj2.view.y + obj2.view.height) - obj1.view.y));
                lineTo(obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height)+ arrowLength-1);
                drawArrow(obj2.view.x+(obj2.view.width/2), obj1.view.y + .5*((obj2.view.y + obj2.view.height) - obj1.view.y), obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height));			
            }
            else{
                lineTo(obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height)+ arrowLength-1);
                drawArrow(obj1.view.x + (obj1.view.width/2), obj1.view.y, obj2.view.x+(obj2.view.width/2), (obj2.view.y + obj2.view.height));
            }
            
        }
        
        //from the bottom of obj1 to the top of obj2
        private function bottomToTop(obj1:IVisualNode, obj2:IVisualNode):void {
            moveTo(obj1.view.x + (obj1.view.width/2), obj1.view.y + obj1.view.height);
            if(edgeClass == 'type1') {
                if (baseEdgePosition == BASE_EDGE_ABOVE)
                {
                    lineTo(obj1.view.x + (obj1.view.width/2), (obj1.view.y + obj1.view.height) + 20);
                    lineTo(obj2.view.x + (obj2.view.width/2), (obj1.view.y + obj1.view.height) + 20);
                    lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y - arrowLength+1);
                }
                else
                {
                    lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y - arrowLength+1);
                }
                drawArrow(obj2.view.x + (obj2.view.width/2), (obj1.view.y + obj1.view.height) + .5*(obj2.view.y - (obj1.view.y + obj1.view.height)), obj2.view.x + (obj2.view.width/2), obj2.view.y);
            }
            else if(edgeClass == 'type2'){
                lineTo(obj1.view.x + (obj1.view.width/2), (obj1.view.y + obj1.view.height));
                lineTo(obj2.view.x + (obj2.view.width/2), (obj1.view.y + obj1.view.height) + .5*(obj2.view.y - (obj1.view.y + obj1.view.height)));
                lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y - arrowLength+1);
                
                drawArrow(obj2.view.x + (obj2.view.width/2), (obj1.view.y + obj1.view.height) + .5*(obj2.view.y - (obj1.view.y + obj1.view.height)), obj2.view.x + (obj2.view.width/2), obj2.view.y);
            }
            else {
                lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y - arrowLength+1);
                drawArrow(obj1.view.x + (obj1.view.width/2), obj1.view.y + obj1.view.height, obj2.view.x + (obj2.view.width/2), obj2.view.y);
            }
        }
        
        //from the center of _obj1 to the center of _obj2
        private function centerToCenter(obj1:IVisualNode, obj2:IVisualNode):void {
            moveTo(obj1.view.x + (obj1.view.width/2), obj1.view.y + (obj1.view.height/2));
            lineTo(obj2.view.x + (obj2.view.width/2), obj2.view.y + (obj2.view.height/2));
            drawArrow(obj1.view.x + (obj1.view.width/2), obj1.view.y + obj1.view.height, obj2.view.x + (obj2.view.width/2), obj2.view.y);
        }			  
        
        public function fromControlCoordinates():Point {
            return Geometry.midPointOfLine(
                vedge.edge.node1.vnode.viewCenter,
                vedge.edge.node2.vnode.viewCenter
            );
        }
        
        public function toControlCoordinates():Point {
            return Geometry.midPointOfLine(
                vedge.edge.node1.vnode.viewCenter,
                vedge.edge.node2.vnode.viewCenter
            );
        }
    }
}