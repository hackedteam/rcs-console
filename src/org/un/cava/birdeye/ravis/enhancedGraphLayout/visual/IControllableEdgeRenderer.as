package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual
{
	import flash.geom.Point;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualEdge;
	
	public interface IControllableEdgeRenderer
	{
		function fromControlCoordinates():Point;
		
		function toControlCoordinates():Point;
	}
}