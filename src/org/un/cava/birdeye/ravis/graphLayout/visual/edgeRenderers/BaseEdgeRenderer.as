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
 * The abovedge copyright notice and this permission notice shall be included in
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
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IEdgeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.graphLayout.visual.VisualGraph;
	import org.un.cava.birdeye.ravis.utils.Geometry;
	import org.un.cava.birdeye.ravis.utils.GraphicsWrapper;
	import org.un.cava.birdeye.ravis.utils.LogUtil;

	/**
	 * This is the default edge renderer, which draws the edges
	 * as straight lines from one node to another.
	 * */
	public class BaseEdgeRenderer extends UIComponent implements IEdgeRenderer {
		
		private static const _LOG:String = "graphLayout.visual.edgeRenderers.BaseEdgeRenderer";
        
        public var fuzzFactor:Number = 8;
        
        protected var vedge:IVisualEdge;
        
        private var _g:GraphicsWrapper;
        
		public function BaseEdgeRenderer() {

		}
        
        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            
            graphics.clear();
            if(vedge)
                draw();
        }
	    
		public function draw():void {
			
			/* first get the corresponding visual object */
			var fromNode:IVisualNode = vedge.edge.node1.vnode;
			var toNode:IVisualNode = vedge.edge.node2.vnode;
			
			/* apply the line style */
			applyLineStyle();
			
			/* now we actually draw */
			g.beginFill(uint(vedge.lineStyle.color));
			g.moveTo(fromNode.viewCenter.x, fromNode.viewCenter.y);			
			g.lineTo(toNode.viewCenter.x, toNode.viewCenter.y);
			g.endFill();
				
			/* if the vgraph currently displays edgeLabels, then
			 * we need to update their coordinates */
			if(vedge.vgraph.displayEdgeLabels) {
                vedge.setEdgeLabelCoordinates(labelCoordinates());
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 * In this simple implementation we put the label into the
		 * middle of the straight line between the two nodes.
		 * */
		public function labelCoordinates():Point {
			return Geometry.midPointOfLine(
                vedge.edge.node1.vnode.viewCenter,
                vedge.edge.node2.vnode.viewCenter
			);
		}
		
		/**
		 * Applies the linestyle stored in the passed visual Edge
		 * object to the Graphics object of the renderer.
		 * */
		protected function applyLineStyle():void {
			
			if(vedge &&
                vedge.lineStyle != null) {
				g.lineStyle(
					Number(vedge.lineStyle.thickness),
					uint(vedge.lineStyle.color),
					Number(vedge.lineStyle.alpha),
					Boolean(vedge.lineStyle.pixelHinting),
					String(vedge.lineStyle.scaleMode),
					String(vedge.lineStyle.caps),
					String(vedge.lineStyle.joints),
					Number(vedge.lineStyle.miterLimits)
				);
			}
		}
        
        protected function get g():GraphicsWrapper
        {
            if(_g == null)
                _g = new GraphicsWrapper(graphics);
            
            _g.fuzzFactor = fuzzFactor;
            return _g;
        }
        
        public function render(force:Boolean=false):void
        {
            if(force)
            {
                graphics.clear();
                if(vedge)
                    draw();   
            }
            else
            {
                invalidateDisplayList();
            }
        }
        
        public function get data():Object { return vedge; }
        public function set data(value:Object):void
        {
            vedge = value as IVisualEdge;
        }
	}
}
