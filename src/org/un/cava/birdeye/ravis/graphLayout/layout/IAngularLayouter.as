package org.un.cava.birdeye.ravis.graphLayout.layout
{
	
	/**
	 * An angular layouter uses an angle as a main
	 * parameter.
	 * */
	public interface IAngularLayouter extends ILayoutAlgorithm {
		
		/**
		 * Access to a value that controls an angle in degrees
		 * for the layouter. It is up to the
		 * layouter what to do with it, and some may ignore
		 * this value under certain circumstances (like autoFit).
		 * The interface requires the value to be between -360 and 360;
		 * @default 160
		 * @param p The value to set.
		 * */
		function set phi(p:Number):void;
		
		/**
		 * @private
		 * */
		function get phi():Number;

	}
}