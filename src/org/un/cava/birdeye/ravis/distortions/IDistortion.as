package org.un.cava.birdeye.ravis.distortions
{
	import flash.geom.Point;
	
	public interface IDistortion
	{
		function distort(distortionPoint:Point):void
	}
}