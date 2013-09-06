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
package org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers
{

	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import it.ht.rcs.console.utils.DashedLine;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;



	/**
	 * This is a directed edge renderer, which draws the edges
	 * with arrowheads at the target point.
	 * Please note that for undirected graphs, the actual direction
	 * of the edge might be arbitrary.
	 * */
	public class BidirectedArrowEdgeRenderer extends BaseEdgeRenderer
	{

		/**
		 * The size of the arrowhead in pixel. The distance of the
		 * two points defining the base of the arrowhead.
		 * */
		public var arrowBaseSize:Number=12;

		/**
		 * The distance of the arrowbase from the tip in pixel.
		 * */
		public var arrowHeadLength:Number=20;

		/**
		 * Constructor sets the graphics object (required).
		 * @param g The graphics object to be used.
		 * */

	
    
    private var dashed:DashedLine;
    private var dotted:DashedLine;
    
    private var flowRenderer:Sprite;
    
    private var relevence0:uint=0x333333;
    private var relevence1:uint=0x999999;
    private var relevence2:uint=0x5DE35F;
    private var relevence3:uint=0xFFDC42;
    private var relevence4:uint=0xFF4034;
    private var relevanceColors:Array;
    
    private var _selected:Boolean;
    
    private var path:LinePath2D;


		public function BidirectedArrowEdgeRenderer()
		{
			super();
      relevanceColors=[relevence0, relevence1, relevence2, relevence3, relevence4]
        
      dashed=new DashedLine(3,0x000000,new Array(10,3,10,3));
      dotted=new DashedLine(3,0x000000,new Array(2,2,2,2));

      this.addChild(dashed)
      this.addChild(dotted)
        
      flowRenderer=new Sprite();
      flowRenderer.graphics.beginFill(0xFF0000);
      flowRenderer.graphics.drawCircle(0, 0, 4);
      this.addChild(flowRenderer);

      path=new LinePath2D();
      path.autoUpdatePoints=true;
      path.addFollower(flowRenderer)
		}

		/**
		 * The draw function, i.e. the main function to be used.
		 * Draws a curved line from one node of the edge to the other.
		 * The colour is determined by the "disting" parameter and
		 * a set of edge parameters, which are stored in an edge object.
		 *
		 * @inheritDoc
		 * */
		override public function draw():void
		{
      
			/* first get the corresponding visual object */
			var fromNode:IVisualNode=vedge.edge.node1.vnode;
			var toNode:IVisualNode=vedge.edge.node2.vnode;

			var fP:Point=fromNode.viewCenter; 
			var tP:Point=toNode.viewCenter;

			var lArrowBase:Point;
			var rArrowBase:Point;
			var mArrowBase:Point;

			var lArrowEnd:Point;
			var rArrowEnd:Point;
			var mArrowEnd:Point;

			var edgeAngle:Number;
			var endEdgeAngle:Number;

			/* apply the line style */
			applyLineStyle();

			/* calculate the base bidpoint which is on
			* the same vector defined between the two endpoints
			*
			* First Step: get the angle of the edge in radians
			*/
			edgeAngle=Math.atan2(tP.y - fP.y, tP.x - fP.x);
			endEdgeAngle=Math.atan2(fP.y - tP.y, fP.x - tP.x);

			/* Second step: the midpoint of the base can easily
			* be specified in polar coords, using the same angle
			* and as distance the original distance - the base distance
			* then only the y value needs to be adjusted by the
			* y value of the from point
			*/
			mArrowBase=Point.polar(Point.distance(tP, fP) - arrowHeadLength, edgeAngle);
			mArrowBase.offset(fP.x, fP.y);

			mArrowEnd=Point.polar(Point.distance(fP, tP) - arrowHeadLength, endEdgeAngle);
			mArrowEnd.offset(tP.x, tP.y);

			/* Now find the left and right arrow base points
			* in a similar way.
			* 1. We can keep the angle but add/subtract 90 degrees.
			* 2. As distance use the half of the base size
			* 3. add the midpoint as reference
			*/
			lArrowBase=Point.polar(arrowBaseSize / 2.9, (edgeAngle - (Math.PI / 2.0)));
			rArrowBase=Point.polar(arrowBaseSize / 2.9, (edgeAngle + (Math.PI / 2.0)));

			lArrowBase.offset(mArrowBase.x, mArrowBase.y);
			rArrowBase.offset(mArrowBase.x, mArrowBase.y);

			lArrowEnd=Point.polar(arrowBaseSize / 2.9, (endEdgeAngle - (Math.PI / 2.0)));
			rArrowEnd=Point.polar(arrowBaseSize / 2.9, (endEdgeAngle + (Math.PI / 2.0)));

			lArrowEnd.offset(mArrowEnd.x, mArrowEnd.y);
			rArrowEnd.offset(mArrowEnd.x, mArrowEnd.y);

			/* now we actually draw */
			var color:int;
			var a:Number=1;
			color=relevanceColors[this.data.data.@rel]
        g.clear()

			//fake bold line
			g.lineStyle(10, color, 0);
			g.moveTo(fP.x, fP.y);
			g.lineTo(tP.x, tP.y);
      
      flowRenderer.graphics.clear()
      flowRenderer.graphics.beginFill(color);
      flowRenderer.graphics.drawCircle(0, 0, 4);
      
      flowRenderer.x=fP.x;
      flowRenderer.y=fP.y;
      
      path.points=[new Point(fP.x, fP.y), new Point(tP.x, tP.y)]
     
      //TweenMax.to(path, 2, {progress:1});
      
      //dashed line
      
      if (this.data.data.@type=="identity")
      { dashed.clear()
        dashed.lineStyle(2,color, 1)
        dashed.beginFill(color, 1)
        dashed.moveTo(fP.x, fP.y);
        dashed.lineTo(tP.x, tP.y);
        
        //
        g.lineStyle(2, color, 0); //
        g.beginFill(color, 1);
        g.moveTo(fP.x, fP.y);
        g.lineTo(tP.x, tP.y);
      }
      //dotted line
      
      else if (this.data.data.@type=="know")
      { 
        dotted.clear()
        dotted.lineStyle(2,color, 1)
        dotted.beginFill(color, 1)
        dotted.moveTo(fP.x, fP.y);
        dotted.lineTo(tP.x, tP.y);
        
        //
        g.lineStyle(2, color, 0); //
        g.beginFill(color, 1);
        g.moveTo(fP.x, fP.y);
        g.lineTo(tP.x, tP.y);
      }
      //regular line
      else
      {
  			g.lineStyle(2, color, a); //
  			g.beginFill(color, a);
  			g.moveTo(fP.x, fP.y);
  			g.lineTo(tP.x, tP.y);
      }
      
      if(this.data.data.@type!="identity")
      {
  			g.lineTo(lArrowBase.x, lArrowBase.y);
  			g.lineTo(rArrowBase.x, rArrowBase.y);
  			g.lineTo(tP.x, tP.y);
      }
      
			if (this.data.data.@versus != null && this.data.data.@versus == "both" && this.data.data.@type!="identity")
			{
				g.moveTo(fP.x, fP.y);
				g.lineTo(lArrowEnd.x, lArrowEnd.y);
				g.lineTo(rArrowEnd.x, rArrowEnd.y);
			}
			g.endFill();

			if (this.data.data.@versus != null && this.data.data.@versus == "fake")
				this.visible=false;
      
      if(this.selected)
      {
        g.lineStyle(12, 0x00CCFF, 0.3);
        g.beginFill(0x00CCFF, 0.3);
        g.moveTo(fP.x, fP.y);
        g.lineTo(tP.x, tP.y);
      }

			/* if the vgraph currently displays edgeLabels, then
			* we need to update their coordinates */
      
			if (vedge.vgraph.displayEdgeLabels)
			{
				vedge.setEdgeLabelCoordinates(labelCoordinates());
			}
      
      this.toolTip=this.vedge.edge.data.@type +" - "+this.vedge.edge.data.@rel;

		}
    
    public function showFlow(count:int):void
    {
      var fromNode:IVisualNode=vedge.edge.node1.vnode;
      var toNode:IVisualNode=vedge.edge.node2.vnode;
      
      var fP:Point=fromNode.viewCenter;
      var tP:Point=toNode.viewCenter;
      TweenMax.to(path, 0, {progress:0});
      flowRenderer.x=fP.x;
      flowRenderer.y=fP.y;
      path.progress=0
      flowRenderer.visible=true;
      TweenMax.to(path, 2, {progress:1});
    }
    
  
    public function set selected(value:Boolean):void
    {
      _selected=value;
      g.clear();
      draw();
    }
    
    public function get selected():Boolean
    {
      return _selected;
    }

	}
}
