package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual
{
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;

	public interface IEnhancedVisualNode extends IVisualNode
	{
		/**
		 * Access to an associated UIComponent to
		 * display a label.
		 * */
		function get labelView():UIComponent;
		
		/**
		 * @private
		 * */
		function set labelView(lv:UIComponent):void;
	
		/**
		 * Applies the provided coordinates to edges label (if present).
		 * 
		 * @param p The Point with the target coordinates.
		 * */
		function setNodeLabelCoordinates():void;		
	}
	
}