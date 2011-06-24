package it.ht.rcs.console.network.model
{
  import it.ht.rcs.console.network.renderers.AnonymizerRenderer;
	
	public class Anonymizer extends NetworkObject
	{
	
		public var renderer:AnonymizerRenderer;
		
		public function Anonymizer(ip:String)
		{
			super(ip);
			renderer = new AnonymizerRenderer(this);
		}
		
	}
	
}