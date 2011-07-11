package it.ht.rcs.console.network.model
{
  import it.ht.rcs.console.network.renderers.CollectorRenderer;
	
	public class oldCollector extends NetworkObject
	{
		
		public var renderer:CollectorRenderer;
		
		public function oldCollector(ip:String)
		{
			super(ip);
			renderer = new CollectorRenderer(this);
		}
		
	}
	
}