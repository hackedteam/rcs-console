package org.un.cava.birdeye.ravis.graphLayout.visual.edgeRenderers
{
    import flash.display.Graphics;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
    import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualGraph;
    
    public class CenterWeightedCircularEdgeRenderer extends CircularEdgeRenderer
    {
        public function CenterWeightedCircularEdgeRenderer() {
            super();
        }
        
        protected override function getEdgeAnchor():Point {
            var bounds:Rectangle = vedge.vgraph.layouter.bounds;
            var anchor:Point = new Point(bounds.x + bounds.width/2, bounds.y + bounds.height/2);
            return anchor;
        }
        
        protected override function getLabelAnchor():Point {
            var bounds:Rectangle = vedge.vgraph.layouter.bounds;
            var anchor:Point = new Point(bounds.x + bounds.width/2, bounds.y + bounds.height/2);
            return anchor;
        }
    }
}