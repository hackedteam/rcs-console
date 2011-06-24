package it.ht.rcs.console.network.model
{
  import it.ht.rcs.console.network.renderers.CollectorRenderer;
	
	public class Collector extends NetworkObject
	{
		
		public var renderer:CollectorRenderer;
		
		public function Collector(ip:String)
		{
			super(ip);
			renderer = new CollectorRenderer(this);
		}
		
	}
	
}