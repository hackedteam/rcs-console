package org.un.cava.birdeye.ravis.distortions
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	
	public class FisheyeDistortion implements IDistortion
	{
		private var _dx:Number; // x distortion factor
		private var _dy:Number; // y distortion factor
    	private var _ds:Number;
    	
    	public var distortX:Boolean;
    	public var distortY:Boolean;
    	public var distortSize:Boolean;
    	
    	private var _bounds:Rectangle;
    	private var _graph:IVisualGraph;
    	
		public function FisheyeDistortion(graph:IVisualGraph,
			dx:Number=4, dy:Number=4, ds:Number=0) {
				
			distortX = dx > 0;
			distortY = dy > 0;
			distortSize = ds>0;
			
			_graph = graph;
			_dx = dx;
			_dy = dy;
			_ds = ds;
		}

		public function distort(distortionPoint:Point):void {
			_bounds = _graph.layouter.bounds;
			for each(var node:IVisualNode in _graph.visibleVNodes)
			{
				var p:Point = node.view.globalToLocal(distortionPoint);
				distortNode(node,distortionPoint);
			}
			_graph.redrawEdges();
			
		}
		
		public function distortNode(node:IVisualNode,distortionPoint:Point):void
		{
			node.moveable = true;
			
			if (distortX) 
			{
				node.viewX = xDistort(node.x,distortionPoint.x); 	
			}
			
			if (distortY)
			{
				node.viewY = yDistort(node.y,distortionPoint.y);	
			}
			
			if(distortSize)
			{
				var bb:Rectangle = node.view.getBounds(node.view.parent);
				if(node.data.centerVariable)
				{
					var s:Number = sizeDistort(bb,node.x,node.y,distortionPoint);
				}
			}
		}
		
		/** @inheritDoc */
		protected function xDistort(x:Number,distortionPointX:Number):Number
		{
			return fisheye(x, distortionPointX, _dx, _bounds.left, _bounds.right);
		}

		/** @inheritDoc */
		protected function yDistort(y:Number,distortionPointY:Number):Number
		{
			return fisheye(y, distortionPointY, _dy, _bounds.top, _bounds.bottom);
		}
		
		protected function sizeDistort(bb:Rectangle, x:Number, y:Number, layoutAnchor:Point):Number
		{
			if (!distortX && !distortY) return 1;

			var fx:Number=1, fy:Number=1;
			var a:Number, min:Number, max:Number, v:Number;
						
	        if (distortX) {
	            a = layoutAnchor.x;
	            min = bb.left;
	            max = bb.right;
	            v = Math.abs(min-a) > Math.abs(max-a) ? min : max;
	            if (v < _bounds.left || v > _bounds.right) v = (v==min ? max : min);
	            fx = fisheye(v, a, _dx, _bounds.left, _bounds.right);
	            fx = Math.abs(x-fx) / (max - min);
	        }

	        if (distortY) {
	        	a = layoutAnchor.y;
	        	min = bb.top;
	        	max = bb.bottom;
	        	v = Math.abs(min-a) > Math.abs(max-a) ? min : max;
	        	if (v < _bounds.top || v > _bounds.bottom) v = (v==min ? max : min);
	            fy = fisheye(v, a, _dy, _bounds.top, _bounds.bottom);
	            fy = Math.abs(y-fy) / (max - min);
	        }
	        var sf:Number = (!distortY ? fx : (!distortX ? fy : Math.min(fx,fy)));
	        return (!isFinite(sf) || isNaN(sf)) ? 1 : _ds * sf;
		}

		private function fisheye(location:Number, 
			distortionLocation:Number, distortionFactor:Number, 
			minLocation:Number, maxLocation:Number) : Number
		{
	        if (distortionFactor == 0) 
	        	return location;
	        
	        var isLeft:Boolean = location < distortionLocation;
	        var dist:Number = 0
	    
	        if(isLeft) {
	        	dist = distortionLocation-minLocation;
	        } else {
	        	dist = maxLocation-distortionLocation;
	        }

	        if ( dist == 0 ){ 
	        	dist = maxLocation-minLocation;
	        }
	        
	        var v:Number = Math.abs(location - distortionLocation) / dist;
	        v = (distortionFactor+1)/(distortionFactor+(1/v));
	        
	        var newLocation:Number;
	        if(isLeft)
	        {
	        	newLocation = -1 * dist * v + distortionLocation;
	        }
	        else
	        {
	        	newLocation = 1 * dist * v + distortionLocation;
	        }
	        return newLocation;
	    }

	}
}