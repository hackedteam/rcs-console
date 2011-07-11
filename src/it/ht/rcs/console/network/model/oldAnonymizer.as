package it.ht.rcs.console.network.model
{
  import it.ht.rcs.console.network.renderers.AnonymizerRenderer;
	
	public class oldAnonymizer extends NetworkObject
	{
	
		public var renderer:AnonymizerRenderer;
		
		public function oldAnonymizer(ip:String)
		{
			super(ip);
			renderer = new AnonymizerRenderer(this);
		}
		
	}
	
}