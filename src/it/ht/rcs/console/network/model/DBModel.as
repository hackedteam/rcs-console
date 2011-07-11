package it.ht.rcs.console.network.model
{
  import it.ht.rcs.console.network.renderers.DBRenderer;
	
	public class DBModel extends NetworkObject
	{
		
		public var collectors:Vector.<Collector>;
		
		public var renderer:DBRenderer;
		
		public function DBModel(ip:String)
		{
			super(ip);
			renderer = new DBRenderer(this);
		}
		
	}
	
}